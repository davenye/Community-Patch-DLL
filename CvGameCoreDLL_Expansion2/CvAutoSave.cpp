#include "CvGameCoreDLLPCH.h"
#include "CvAutoSave.h"

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
/*const AutoSaveModeTypes defaultModes[NUM_AUTOSAVE_MODE];
AUTOSAVE_POINT_MANUAL,
AUTOSAVE_POINT_INITIAL,
AUTOSAVE_POINT_MAP_GEN,
AUTOSAVE_POINT_BEFORE_GAME_TURN_END,
AUTOSAVE_POINT_AFTER_GAME_TURN_START,
AUTOSAVE_POINT_AFTER_NETWORK_GAME_TURN_START,
AUTOSAVE_POINT_BEFORE_NETWORK_GAME_HUMAN_TURNS_START,*/
CvAutoSave::CvAutoSave()
{
	for (int i = 0; i < NUM_AUTOSAVE_PLAYER; i++)
	{	
		eSavePointMatrix[i][AUTOSAVE_POINT_EXTERNAL] = -1;
		eSavePointMatrix[i][AUTOSAVE_POINT_EXPLICIT] = -1;
		eSavePointMatrix[i][AUTOSAVE_POINT_MAP_GEN] = 1;
		eSavePointMatrix[i][AUTOSAVE_POINT_INITIAL] = 1;
		eSavePointMatrix[i][AUTOSAVE_POINT_LOCAL_GAME_TURN] = 1;
		eSavePointMatrix[i][AUTOSAVE_POINT_NETWORK_GAME_TURN] = 2;
		eSavePointMatrix[i][AUTOSAVE_POINT_LOCAL_GAME_TURN_POST] = 1;
		eSavePointMatrix[i][AUTOSAVE_POINT_NETWORK_GAME_TURN_POST] = 3;
	}
	
	for (int i = 0; i < NUM_AUTOSAVE_POINT; i++)
		iLastTurnSaved[i] = -1;	

	m_bSkipFirstNetworkGameHumanTurnsStartSave = false;
	m_iQueuedAutoSaveTurn = -1;
}

CvAutoSave::~CvAutoSave()
{
}

bool CvAutoSave::SavePoint(AutoSavePointTypes eSavePoint) {

	if (m_bSkipFirstNetworkGameHumanTurnsStartSave && eSavePoint == AUTOSAVE_POINT_NETWORK_GAME_TURN_POST)
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

	AutoSavePlayerTypes participant = GetBestPlayerTypeMatch();
	//NET_MESSAGE_DEBUG_OSTR_ALWAYS("GetBestPlayerTypeMatch() = " << participant);
	if (participant == NO_AUTOSAVE_PLAYER) // when, if ever?
	{
		return false;
	}

	//AutoSaveModeTypes eMode = eSavePointMatrix[participant][eSavePoint];
	int freq = eSavePointMatrix[participant][eSavePoint];
/*	NET_MESSAGE_DEBUG_OSTR_ALWAYS("eSavePoint() = " << eSavePoint);
	NET_MESSAGE_DEBUG_OSTR_ALWAYS("freq() = " << freq);
	NET_MESSAGE_DEBUG_OSTR_ALWAYS("iLastTurnSaved2[eSavePoint] = " << iLastTurnSaved[eSavePoint]);
	NET_MESSAGE_DEBUG_OSTR_ALWAYS("game turn = " << GC.getGame().getGameTurn());
	*/

	if (iLastTurnSaved[eSavePoint] + freq > GC.getGame().getGameTurn())
	{
		//NET_MESSAGE_DEBUG_OSTR_ALWAYS("too early");
		if(m_iQueuedAutoSaveTurn != GC.getGame().getGameTurn() && freq >= 0)
			return false;
		
	}

	NET_MESSAGE_DEBUG_OSTR_ALWAYS("AUTOSAVE: point " << eSavePoint << " in " << GC.getGame().getGameTurn());
	m_eSavedPoint = eSavePoint;
	switch (eSavePoint)
	{
		case AUTOSAVE_POINT_EXPLICIT:
		case AUTOSAVE_POINT_EXTERNAL:
			break;

		case AUTOSAVE_POINT_MAP_GEN:
		case AUTOSAVE_POINT_INITIAL:
			gDLL->AutoSave(true);
			break;

		case AUTOSAVE_POINT_LOCAL_GAME_TURN:
		case AUTOSAVE_POINT_NETWORK_GAME_TURN:
			gDLL->AutoSave(false);
			break;

		case AUTOSAVE_POINT_LOCAL_GAME_TURN_POST:
		case AUTOSAVE_POINT_NETWORK_GAME_TURN_POST:
			gDLL->AutoSave(false, true);
			break;
	
	}
	m_eSavedPoint = AUTOSAVE_POINT_EXTERNAL;
	m_eLastSavedPoint = eSavePoint;
	NET_MESSAGE_DEBUG_OSTR_ALWAYS("WRiting iLastTurnSaved2: " << eSavePoint << " = " << GC.getGame().getGameTurn());
	iLastTurnSaved[eSavePoint] = GC.getGame().getGameTurn();

	m_bSkipFirstNetworkGameHumanTurnsStartSave = false;
	if (m_iQueuedAutoSaveTurn >= 0 && m_iQueuedAutoSaveTurn < GC.getGame().getGameTurn()) // TODO use deque to cater for queuing while queued
		m_iQueuedAutoSaveTurn = -1;
	return true;

}
void CvAutoSave::Read(FDataStream& kStream)
{
	//m_eSavedPoint
	
	int p;
	kStream >> p;
	AutoSavePointTypes eLoadedSavePoint = (AutoSavePointTypes) p;
	NET_MESSAGE_DEBUG_OSTR_ALWAYS("LOADED SAVEPOINT: " << eLoadedSavePoint);
	if (eLoadedSavePoint == AUTOSAVE_POINT_NETWORK_GAME_TURN_POST)
		m_bSkipFirstNetworkGameHumanTurnsStartSave = true;

}

void CvAutoSave::Write(FDataStream& kStream) const
{
	NET_MESSAGE_DEBUG_OSTR_ALWAYS("WRITING SAVEPOINT: " << m_eSavedPoint);
	kStream << (int) m_eSavedPoint;
}

void CvAutoSave::UpdateTurn() {

}

AutoSavePlayerTypes CvAutoSave::GetBestPlayerTypeMatch() const
{
	if (gDLL->IsPitbossHost())
	{
		return AUTOSAVE_PLAYER_PITBOSSHOST;
	}
	else if (gDLL->IsHost())
	{
		return AUTOSAVE_PLAYER_HOST;
	}
	
	PlayerTypes eActivePlayer = GC.getGame().getActivePlayer();
	
	if (eActivePlayer != NO_PLAYER)
	{
		const CvPlayerAI& kActivePlayer = GET_PLAYER(eActivePlayer);
		if (kActivePlayer.isObserver())
		{
			return AUTOSAVE_PLAYER_OBSERVER;
		}
		else if (kActivePlayer.isHuman())
		{
			return AUTOSAVE_PLAYER_GUEST;
		}
	}
	return NO_AUTOSAVE_PLAYER; // Not sure when this could happen though.	
}

AutoSavePointTypes CvAutoSave::getLastAutoSavePoint() const
{
	return m_eLastSavedPoint;
}

int CvAutoSave::getLastAutoSaveTurn() const
{
	if (m_eLastSavedPoint == NO_AUTOSAVE_POINT)
		return -1;
	return iLastTurnSaved[m_eLastSavedPoint];
}

bool CvAutoSave::ConfigureSavePoint(int freq, AutoSavePointTypes eSavePoint, AutoSavePlayerTypes ePlayerType)
{
	if (false)
		return false;

	AutoSavePointTypes eSavePointBegin, eSavePointEnd;
	AutoSavePlayerTypes ePlayerTypeBegin, ePlayerTypeEnd;

	if (eSavePoint != NO_AUTOSAVE_POINT)
	{
		eSavePointBegin = eSavePoint;
		eSavePointEnd = eSavePoint;
	}
	else
	{
		eSavePointBegin = (AutoSavePointTypes)0;
		eSavePointEnd = NUM_AUTOSAVE_POINT;
	}

	if (ePlayerType != NO_AUTOSAVE_PLAYER)
	{
		ePlayerTypeBegin = ePlayerType;
		ePlayerTypeEnd = ePlayerType;
	}
	else
	{
		ePlayerTypeBegin = (AutoSavePlayerTypes) 0;
		ePlayerTypeEnd = NUM_AUTOSAVE_PLAYER;
	}

	for(int playerType = ePlayerTypeBegin; playerType != ePlayerTypeEnd; playerType++)
		for (int savePoint = eSavePointBegin; savePoint != eSavePointEnd; savePoint++)
			eSavePointMatrix[playerType][savePoint] = freq;

	return true;
}

FDataStream& operator>>(FDataStream& kStream, CvAutoSave& kAutoSave)
{
	kAutoSave.Read(kStream);
	return kStream;
}
FDataStream& operator<<(FDataStream& kStream, const CvAutoSave& kAutoSave)
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

void CvAutoSave::Save(const char* filename)
{
	m_eSavedPoint = AUTOSAVE_POINT_EXPLICIT;
	ManualSave(filename);
	m_eSavedPoint = AUTOSAVE_POINT_EXTERNAL;
}

void CvAutoSave::queueAutoSave() {
	m_iQueuedAutoSaveTurn = GC.getGame().getGameTurn() + 1;
	ManualSave("unsafeAS");
}