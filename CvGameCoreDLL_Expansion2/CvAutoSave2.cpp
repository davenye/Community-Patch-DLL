#include "CvGameCoreDLLPCH.h"
#include "CvAutoSave2.h"

// must be included after all other headers
#include "LintFree.h"


/*

________________________________________________
-----------------------------------------------
HOST					GUEST
PRE
|begin |					|begin |						- start of game turn
|postai|					|postai|						- after processing of ai
|all|					  	|all|								- both at start of turn and after ai (will result in "old" autosaves
|none|					  |none|							-	non pre autosaves

FREQ {i}																				- only save on turns x turns since last turn saved
NEXT (i)																				- turns till next save

[[SAVE NEXT]]																		- save at next opportunity (effectively set next to 0)

[[SAVE NOW]]																		- save now - might be dangerous!
-----------------------------------------------
Notify when saving [x]
-----------------------------------------------
POST
|first|           |first| 						- first human turn
|local|           |local| 						- local human turn
|each |           |each |  						- each human turn
|none |           |none |  						- no post autosaves

FREQ {i}
NEXT (i)

[[SAVE NEXT]]

[[SAVE NOW]]

-----------------------------------------------
Notify when saving [x]
-----------------------------------------------
[[OK]]
________________________________________________
*/
/*const AutoSaveModeTypes defaultModes[NUM_AUTOSAVE2_MODE];
AUTOSAVE2_POINT_MANUAL,
AUTOSAVE2_POINT_INITIAL,
AUTOSAVE2_POINT_MAP_GEN,
AUTOSAVE2_POINT_BEFORE_GAME_TURN_END,
AUTOSAVE2_POINT_AFTER_GAME_TURN_START,
AUTOSAVE2_POINT_AFTER_NETWORK_GAME_TURN_START,
AUTOSAVE2_POINT_BEFORE_NETWORK_GAME_HUMAN_TURNS_START,*/
CvAutoSave2::CvAutoSave2()
{
	for (int i = 0; i < NUM_AUTOSAVE2_PLAYER; i++)
	{	
		eSavePointMatrix[i][AUTOSAVE2_POINT_EXTERNAL] = -1;
		eSavePointMatrix[i][AUTOSAVE2_POINT_EXPLICIT] = -1;
		eSavePointMatrix[i][AUTOSAVE2_POINT_MAP_GEN] = 1;
		eSavePointMatrix[i][AUTOSAVE2_POINT_INITIAL] = 1;
		eSavePointMatrix[i][AUTOSAVE2_POINT_LOCAL_GAME_TURN] = 1;
		eSavePointMatrix[i][AUTOSAVE2_POINT_NETWORK_GAME_TURN] = 2;
		eSavePointMatrix[i][AUTOSAVE2_POINT_LOCAL_GAME_TURN_POST] = 1;
		eSavePointMatrix[i][AUTOSAVE2_POINT_NETWORK_GAME_TURN_POST] = 3;
	}
	
	for (int i = 0; i < NUM_AUTOSAVE2_POINT; i++)
		iLastTurnSaved[i] = -1;	

	m_bSkipFirstNetworkGameHumanTurnsStartSave = false;
	m_iQueuedAutoSaveTurn = -1;
}

CvAutoSave2::~CvAutoSave2()
{
}

bool CvAutoSave2::SavePoint(AutoSave2PointTypes eSavePoint) {

	if (!QueuedSaveRequests.empty() && eSavePoint == AUTOSAVE2_POINT_NETWORK_GAME_TURN) {
		std::vector<QueuedSaveRequest>::iterator it = QueuedSaveRequests.begin();
		while (it != QueuedSaveRequests.end() && it->turn <= GC.getGame().getGameTurn()) {
			if (it->turn == GC.getGame().getGameTurn())
			{
				NamedSave(it->filename.c_str(), AUTOSAVE2_POINT_QUEUED);
			}
			it++;
		}
		QueuedSaveRequests.erase(QueuedSaveRequests.begin(), it);
	}
	if (m_bSkipFirstNetworkGameHumanTurnsStartSave && eSavePoint == AUTOSAVE2_POINT_NETWORK_GAME_TURN_POST)
	{
		//NET_MESSAGE_DEBUG_OSTR_ALWAYS("skipping firs postautosave");
		//m_bSkipFirstNetworkGameHumanTurnsStartSave = false;
		return false;
	}
	//UpdateTurn();
	
	if (iLastTurnSaved[eSavePoint] == GC.getGame().getGameTurn())
	{
		//NET_MESSAGE_DEBUG_OSTR_ALWAYS("iLastTurnSaved2():" << eSavePoint << " = " << iLastTurnSaved[eSavePoint]);
		return false;
	}
	
	bool isInitial = false;
	bool isPost = false;
	switch (eSavePoint)
	{

		case AUTOSAVE2_POINT_MAP_GEN:
		case AUTOSAVE2_POINT_INITIAL:
			isInitial = true;	
			isPost = false;
			break;

		case AUTOSAVE2_POINT_LOCAL_GAME_TURN:
		case AUTOSAVE2_POINT_NETWORK_GAME_TURN:
			isInitial = false;
			isPost = false;
			break;

		case AUTOSAVE2_POINT_LOCAL_GAME_TURN_POST:
		case AUTOSAVE2_POINT_NETWORK_GAME_TURN_POST:
			isInitial = false;
			isPost = true;
			break;
	
	}
	bool bPostAutoSavesDefault = GC.getGame().isOption(GAMEOPTION_POST_AUTOSAVES);
	AutoSave(eSavePoint, isInitial || !isPost || bPostAutoSavesDefault, isInitial, isPost);
	

	m_bSkipFirstNetworkGameHumanTurnsStartSave = false;
	if (m_iQueuedAutoSaveTurn >= 0 && m_iQueuedAutoSaveTurn < GC.getGame().getGameTurn()) // TODO use deque to cater for queuing while queued
		m_iQueuedAutoSaveTurn = -1;
	return true;

}
void CvAutoSave2::Read(FDataStream& kStream)
{
	//m_eSavedPoint
	
	int p;
	kStream >> p;
	AutoSavePointTypes eLoadedSavePoint = (AutoSavePointTypes) p;
	NET_MESSAGE_DEBUG_OSTR_ALWAYS("LOADED SAVEPOINT: " << eLoadedSavePoint);
	if (eLoadedSavePoint == AUTOSAVE2_POINT_NETWORK_GAME_TURN_POST)
		m_bSkipFirstNetworkGameHumanTurnsStartSave = true;

}

void CvAutoSave2::Write(FDataStream& kStream) const
{
	NET_MESSAGE_DEBUG_OSTR_ALWAYS("WRITING SAVEPOINT: " << m_eSavedPoint);
	kStream << (int) m_eSavedPoint;
}

void CvAutoSave2::UpdateTurn() {

}

AutoSave2PlayerTypes CvAutoSave2::GetBestPlayerTypeMatch() const
{
	if (!GC.getGame().isNetworkMultiPlayer())
	{
		return AUTOSAVE2_PLAYER_SINGLE;
	}
	if (gDLL->IsPitbossHost())
	{
		return AUTOSAVE2_PLAYER_PITBOSSHOST;
	}
	else if (gDLL->IsHost())
	{
		return AUTOSAVE2_PLAYER_HOST;
	}
	
	PlayerTypes eActivePlayer = GC.getGame().getActivePlayer();
	
	if (eActivePlayer != NO_PLAYER)
	{
		const CvPlayerAI& kActivePlayer = GET_PLAYER(eActivePlayer);
		if (kActivePlayer.isObserver())
		{
			return AUTOSAVE2_PLAYER_OBSERVER;
		}
		else if (kActivePlayer.isHuman())
		{
			return AUTOSAVE2_PLAYER_GUEST;
		}
	}
	return NO_AUTOSAVE2_PLAYER; // Not sure when this could happen though.	
}

AutoSave2PointTypes CvAutoSave2::getLastAutoSavePoint() const
{
	return m_eLastSavedPoint;
}

int CvAutoSave2::getLastAutoSaveTurn() const
{
	if (m_eLastSavedPoint == NO_AUTOSAVE2_POINT)
		return -1;
	return iLastTurnSaved[m_eLastSavedPoint];
}

bool CvAutoSave2::ConfigureSavePoint(int freq, AutoSave2PointTypes eSavePoint, AutoSave2PlayerTypes ePlayerType)
{

	AutoSave2PointTypes eSavePointBegin, eSavePointEnd;
	AutoSave2PlayerTypes ePlayerTypeBegin, ePlayerTypeEnd;

	if (eSavePoint != NO_AUTOSAVE2_POINT)
	{
		eSavePointBegin = eSavePoint;
		eSavePointEnd = eSavePoint;
	}
	else
	{
		eSavePointBegin = (AutoSave2PointTypes)0;
		eSavePointEnd = NUM_AUTOSAVE2_POINT;
	}

	if (ePlayerType != NO_AUTOSAVE2_PLAYER)
	{
		ePlayerTypeBegin = ePlayerType;
		ePlayerTypeEnd = ePlayerType;
	}
	else
	{
		ePlayerTypeBegin = (AutoSave2PlayerTypes) 0;
		ePlayerTypeEnd = NUM_AUTOSAVE2_PLAYER;
	}

	for(int playerType = ePlayerTypeBegin; playerType <= ePlayerTypeEnd; playerType++)
		for (int savePoint = eSavePointBegin; savePoint <= eSavePointEnd; savePoint++)
			eSavePointMatrix[playerType][savePoint] = freq;

	return true;
}

FDataStream& operator>>(FDataStream& kStream, CvAutoSave2& kAutoSave)
{
	kAutoSave.Read(kStream);
	return kStream;
}
FDataStream& operator<<(FDataStream& kStream, const CvAutoSave2& kAutoSave)
{
	kAutoSave.Write(kStream);
	return kStream;
}


struct ManualSaveArgs
{
	ICvEngineScriptSystem1* pkScriptSystem;
	const char* filename;
	bool bSuccess;
};

namespace {
	int UnsafeUISave(lua_State* L) {

		ManualSaveArgs* pArgs = (ManualSaveArgs*)lua_touserdata(L, 1);

		pArgs->bSuccess = false;
		lua_getglobal(L, "UI");
		lua_getfield(L, -1, "SaveGame");
		lua_pushstring(L, pArgs->filename);
		lua_pcall(L, 1, 0, 0);

		pArgs->bSuccess = true;

		return 0;
	}


	bool ManualSave(const char* filename)
	{
		ICvEngineScriptSystem1* pkScriptSystem = gDLL->GetScriptSystem();
		lua_State* l = pkScriptSystem->CreateLuaThread("Manual Save"); // don't know if I want a thread...not sure what a thread is in this context..dont think I *need* one

		ManualSaveArgs args;
		args.pkScriptSystem = pkScriptSystem;
		args.filename = filename;
		args.bSuccess = false;

		pkScriptSystem->CallCFunction(l, UnsafeUISave, &args);

		pkScriptSystem->FreeLuaThread(l);
		NET_MESSAGE_DEBUG_OSTR_ALWAYS("ManualSave success? " << args.bSuccess);
		return args.bSuccess;
	}
}
void CvAutoSave2::Save(const char* filename)
{
	NamedSave(filename, AUTOSAVE2_POINT_EXPLICIT);	
}


void CvAutoSave2::queueAutoSave() {
	m_iQueuedAutoSaveTurn = GC.getGame().getGameTurn() + 1;
	ManualSave("unsafeAS");
}

bool CvAutoSave2::AutoSave(AutoSave2PointTypes eSavePoint, bool default, bool initial, bool post)
{
	bool save = eSavePoint == AUTOSAVE2_POINT_INITIAL;
	if(!save)
		save = FireWantAutoSaveEvent(eSavePoint, default);
	if (save) {
		m_eSavedPoint = eSavePoint;					
		gDLL->AutoSave(initial, post);
		m_eSavedPoint = AUTOSAVE2_POINT_EXTERNAL;
		m_eLastSavedPoint = eSavePoint;

		iLastTurnSaved[eSavePoint] = GC.getGame().getGameTurn();

		FireAutoSaveEvent(initial, post, eSavePoint);
	}
	return save;
}

bool CvAutoSave2::FireWantAutoSaveEvent(AutoSave2PointTypes eSavePoint, bool default)
{
	int result =  GAMEEVENTINVOKE_TESTANY(GAMEEVENT_WantAutoSave, eSavePoint);
	bool save = false;
	
	if (result == GAMEEVENTRETURN_TRUE) save = true;
	else if (result == GAMEEVENTRETURN_FALSE) save = false;
	else save = default;

	return save;
}

void CvAutoSave2::FireAutoSaveEvent(bool initial, bool post, AutoSave2PointTypes eSavePoint)
{
	GAMEEVENTINVOKE_HOOK(GAMEEVENT_AutoSaved, eSavePoint, initial, post);
}

void CvAutoSave2::QueueSave(const char* filename, int turn)
{
	if (turn < 0)
		turn = GC.getGame().getGameTurn();
	QueuedSaveRequest qsr = { turn, filename };
	//QueuedSaveRequests.push_back(qsr);
	std::vector<QueuedSaveRequest>::iterator it = QueuedSaveRequests.begin();
	while (it != QueuedSaveRequests.end()) {
		if (it->turn > qsr.turn)
			break;
		it++;
	}
	QueuedSaveRequests.insert(it, qsr);
}

void CvAutoSave2::NamedSave(const char* filename, AutoSave2PointTypes type) {
	m_eSavedPoint = type;
	ManualSave(filename);
	m_eSavedPoint = AUTOSAVE2_POINT_EXTERNAL;
	FireAutoSaveEvent(false, false, type);

}