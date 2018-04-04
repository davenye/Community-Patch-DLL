#pragma once

#ifndef CV_AUTOSAVE2_H
#define CV_AUTOSAVE2_H

#include <string>

enum AutoSave2PointTypes
{
	NO_AUTOSAVE2_POINT = -1,

	AUTOSAVE2_POINT_EXTERNAL,

	AUTOSAVE2_POINT_EXPLICIT,

	AUTOSAVE2_POINT_MAP_GEN,
	AUTOSAVE2_POINT_INITIAL,

	AUTOSAVE2_POINT_LOCAL_GAME_TURN,
	AUTOSAVE2_POINT_NETWORK_GAME_TURN,

	AUTOSAVE2_POINT_LOCAL_GAME_TURN_POST,
	AUTOSAVE2_POINT_NETWORK_GAME_TURN_POST,

	AUTOSAVE2_POINT_QUEUED, //too generic? AUTOSAVE2_POINT_NETWORK_GAME_TURN_QUEUED?

	NUM_AUTOSAVE2_POINT,
};

enum AutoSave2PlayerTypes {
	NO_AUTOSAVE2_PLAYER = -1,

	AUTOSAVE2_PLAYER_PITBOSSHOST,
	AUTOSAVE2_PLAYER_HOST,
	AUTOSAVE2_PLAYER_OBSERVER,
	AUTOSAVE2_PLAYER_GUEST,
	
	AUTOSAVE2_PLAYER_SINGLE,

	NUM_AUTOSAVE2_PLAYER,
	//ALL_AUTOSAVE_PLAYER = NUM_AUTOSAVE_PLAYER,
};

enum AutoSave2ModeTypes
{
	NO_AUTOSAVE2 = -1,

	AUTOSAVE2_MODE_NONE,
	AUTOSAVE2_MODE_INITIAL,
	AUTOSAVE2_MODE_NORMAL,
	AUTOSAVE2_MODE_POST,


	NUM_AUTOSAVE2_MODE,
};

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

class CvAutoSave2
{
public:
	CvAutoSave2();
	virtual ~CvAutoSave2();

	bool SavePoint(AutoSave2PointTypes eSavePoint);
	
	AutoSave2PointTypes getLastAutoSavePoint() const;
	int getLastAutoSaveTurn() const;

	void queueAutoSave();

	bool ConfigureSavePoint(int freq, AutoSave2PointTypes eSavePoint = NO_AUTOSAVE2_POINT, AutoSave2PlayerTypes ePlayerTypes = NO_AUTOSAVE2_PLAYER);

	void Read(FDataStream& kStream);
	void Write(FDataStream& kStream) const;

	// Save games using this method are not guaranteed to be in a good state since they could be made at any point during processing
	// Provided for developement and debugging purposes...and for the adventurous!
	void Save(const char* filename);

	void QueueSave(const char* filename, int turn = -1);

protected:
	bool AutoSave(AutoSave2PointTypes eSavePoint, bool default, bool initial, bool post);
	bool FireWantAutoSaveEvent(AutoSave2PointTypes eSavePoint, bool default);
	void FireAutoSaveEvent(bool initial, bool post, AutoSave2PointTypes eSavePoint);
	int eSavePointMatrix[NUM_AUTOSAVE2_PLAYER][NUM_AUTOSAVE2_POINT];

	int iLastTurnSaved[NUM_AUTOSAVE2_POINT];
	int iTurnChecked[NUM_AUTOSAVE2_POINT];

	void UpdateTurn();

	AutoSave2PlayerTypes GetBestPlayerTypeMatch() const;
	
	void NamedSave(const char* filename, AutoSave2PointTypes type);

	AutoSave2PointTypes m_eSavedPoint;
	AutoSave2PointTypes  m_eLastSavedPoint;
	bool m_bSkipFirstNetworkGameHumanTurnsStartSave;
	int m_iQueuedAutoSaveTurn;

	struct QueuedSaveRequest {
		int turn;
		std::string filename;
	};

	std::vector<QueuedSaveRequest> QueuedSaveRequests;
};

FDataStream& operator>>(FDataStream&, CvAutoSave2&);
FDataStream& operator<<(FDataStream&, const CvAutoSave2&);

#endif
