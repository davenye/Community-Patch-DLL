#include "CvGameCoreDLLPCH.h"
#include "CvAutoSave2.h"

// must be included after all other headers
#include "LintFree.h"


CvAutoSave2::CvAutoSave2()
{
	for (int i = 0; i < NUM_AUTOSAVE2_POINT; i++)
	{
		iLastTurnSaved[i] = -1;
		iTurnChecked[i] = -1;
	}

	m_bSkipFirstNetworkGameHumanTurnsStartSave = false;
	m_eSavedPoint = AUTOSAVE2_POINT_EXTERNAL;
	m_eLastSavedPoint = NO_AUTOSAVE2_POINT;

}

CvAutoSave2::~CvAutoSave2()
{
}

bool CvAutoSave2::SavePoint(AutoSave2PointTypes eSavePoint) {
	if (iTurnChecked[eSavePoint] == GC.getGame().getGameTurn())	{
		return false;
	}
	else {
		iTurnChecked[eSavePoint] = GC.getGame().getGameTurn();
	}
	
	if (m_bSkipFirstNetworkGameHumanTurnsStartSave && eSavePoint == AUTOSAVE2_POINT_NETWORK_GAME_TURN_POST)
	{
		m_bSkipFirstNetworkGameHumanTurnsStartSave = false;
		return false;
	}
	
	if (iLastTurnSaved[eSavePoint] == GC.getGame().getGameTurn())
	{
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
	
	return true;

}
void CvAutoSave2::Read(FDataStream& kStream)
{
	int p;
	kStream >> p;
	AutoSave2PointTypes eLoadedSavePoint = (AutoSave2PointTypes) p;
	NET_MESSAGE_DEBUG_OSTR_ALWAYS("LOADED SAVEPOINT: " << eLoadedSavePoint);
	if (eLoadedSavePoint == AUTOSAVE2_POINT_NETWORK_GAME_TURN_POST)
		m_bSkipFirstNetworkGameHumanTurnsStartSave = true;

}

void CvAutoSave2::Write(FDataStream& kStream) const
{
	NET_MESSAGE_DEBUG_OSTR_ALWAYS("WRITING SAVEPOINT: " << m_eSavedPoint);
	kStream << (int) m_eSavedPoint;
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

void CvAutoSave2::NamedSave(const char* filename, AutoSave2PointTypes type) {
	m_eSavedPoint = type;
	ManualSave(filename);
	m_eSavedPoint = AUTOSAVE2_POINT_EXTERNAL;
	FireAutoSaveEvent(false, false, type);

}