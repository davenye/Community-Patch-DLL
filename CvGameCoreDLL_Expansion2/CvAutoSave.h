#pragma once

#ifndef CV_AUTOSAVE_H
#define CV_AUTOSAVE_H


enum AutoSavePointTypes
{
	NO_AUTOSAVE_POINT = -1,

	AUTOSAVE_POINT_EXTERNAL,

	AUTOSAVE_POINT_EXPLICIT,

	AUTOSAVE_POINT_MAP_GEN,
	AUTOSAVE_POINT_INITIAL,

	AUTOSAVE_POINT_LOCAL_GAME_TURN,
	AUTOSAVE_POINT_NETWORK_GAME_TURN,

	AUTOSAVE_POINT_LOCAL_GAME_TURN_POST,
	AUTOSAVE_POINT_NETWORK_GAME_TURN_POST,

	NUM_AUTOSAVE_POINT,
};

enum AutoSavePlayerTypes {
	NO_AUTOSAVE_PLAYER = -1,

	AUTOSAVE_PLAYER_PITBOSSHOST,
	AUTOSAVE_PLAYER_HOST,
	AUTOSAVE_PLAYER_OBSERVER,
	AUTOSAVE_PLAYER_GUEST,
	
	AUTOSAVE_PLAYER_SINGLE,

	NUM_AUTOSAVE_PLAYER,
	//ALL_AUTOSAVE_PLAYER = NUM_AUTOSAVE_PLAYER,
};

enum AutoSaveModeTypes
{
	NO_AUTOSAVE = -1,

	AUTOSAVE_MODE_NONE,
	AUTOSAVE_MODE_INITIAL,
	AUTOSAVE_MODE_NORMAL,
	AUTOSAVE_MODE_POST,


	NUM_AUTOSAVE_MODE,
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

class CvAutoSave
{
public:
	CvAutoSave();
	virtual ~CvAutoSave();

	bool SavePoint(AutoSavePointTypes eSavePoint);
	
	AutoSavePointTypes getLastAutoSavePoint() const;
	int getLastAutoSaveTurn() const;

	void queueAutoSave();

	bool ConfigureSavePoint(int freq, AutoSavePointTypes eSavePoint = NO_AUTOSAVE_POINT, AutoSavePlayerTypes ePlayerTypes = NO_AUTOSAVE_PLAYER);

	void Read(FDataStream& kStream);
	void Write(FDataStream& kStream) const;

	// Save games using this method are not guaranteed to be in a good state since they could be made at any point during processing
	// Provided for developement and debugging purposes...and for the adventurous!
	void Save(const char* filename);
protected:
	
	int eSavePointMatrix[NUM_AUTOSAVE_PLAYER][NUM_AUTOSAVE_POINT];

	int iLastTurnSaved[NUM_AUTOSAVE_POINT];

	void UpdateTurn();

	AutoSavePlayerTypes GetBestPlayerTypeMatch() const;
	
	AutoSavePointTypes m_eSavedPoint;
	AutoSavePointTypes  m_eLastSavedPoint;
	bool m_bSkipFirstNetworkGameHumanTurnsStartSave;
	int m_iQueuedAutoSaveTurn;
};

FDataStream& operator>>(FDataStream&, CvAutoSave&);
FDataStream& operator<<(FDataStream&, const CvAutoSave&);

#endif
