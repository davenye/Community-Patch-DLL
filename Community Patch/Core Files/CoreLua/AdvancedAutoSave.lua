include( "InstanceManager" );
include( "IconSupport" );
include( "SupportFunctions" );
include( "UniqueBonuses" );
include( "MapUtilities" );


print("WTF!");

AdvancedAutoSave = {};

function AdvancedAutoSave.GetStuff2()
	return 4020;
end

function GetStuff3()
	return 40201;
end
--MapModData.AAS = {};
--using MadModData all over the palce cos things are getting loaded multiple times and creating chaos.
UserData = Modding.OpenUserData("VP_AdvancedAutoSave", 4);

local function GetData()
	return MapModData.AdvancedAutoSave.Data;
end

local function deepcopy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[deepcopy(k, s)] = deepcopy(v, s) end
  return res
end
------------------------------------------------------------------

local SaveModeOptions = 
{

	{
		label = "At Intervals",
		tooltip = "turns between",
		needs_edit = true
	},
	{
		label = "On Request",
		tooltip = "ask nicely",
		needs_edit = false
	},
	{
		label = "Never",
		tooltip = "...ever",
		needs_edit = false
	}
};

local SaveModeConfigs = 
{
		{
			txt = "AI Only",
			tooltip = "AI Only",
			cat_id = 4,
			pointset = 1,			
		},
		
		{
			txt = "Local",
			tooltip = "Local",
			cat_id = 4,
			pointset = 1,
		},
		---------------
		{
			txt = "Pitboss Host",
			tooltip = "Pitboss Host",
			cat_id = 0,
			pointset = 2,
		},
		{
			txt = "MP Host",
			tooltip = "MP Host",
			cat_id = 1,
			pointset = 2,
		},
		{
			txt = "MP Guest",
			tooltip = "MP Guest",
			cat_id = 3,
			pointset = 2,
		},
		{
			txt = "MP Observer",
			tooltip = "MP Observer",
			cat_id = 2,
			pointset = 2,
		}	,
};

local PointSets =
{
	--sp
	{4,6},
	--mp
	{5,7},
};



--Data = {};



function AdvancedAutoSave.InitData()
	local idx = 0;
	local Data = GetData();
	
	Data.PostSaves = false;
	
	Data.AllowAutoSaveRequests = false;
	
	Data.AllowForceSave = false;
	Data.AllowQueueSave = false;
	Data.AllowStaleSave = false;
	
	Data.QueuedSavePopup = false;
	Data.AllowAutoSaveRequests = false;
	Data.ShowLastAutoSaveDetails = false;
	
	Data.QueuedAuto = {};
	Data.Queued = {};
	Data.LastSaves = {};
	
	local Filters = Data.Filters;
	for i,cat in ipairs(SaveModeConfigs) do
		for j,point in ipairs(PointSets[cat.pointset]) do
			idx = idx + 1;
			local default = 1;
			if(j == 2) then
				default = -1;
			end
			Filters[idx] = {cat.cat_id, point, default}; -- default to every turn
		end
	end
end


function AdvancedAutoSave.LoadData()
		print("LoadData()");
	local Data = GetData();
	Data.AllowAutoSaveRequests = UserData.GetValue("AllowAutoSaveRequests");
	Data.AllowQueueSave = UserData.GetValue("Data.AllowQueueSave");
	Data.AllowForceSave = UserData.GetValue("Data.AllowForceSave");
	Data.AllowStaleSave = UserData.GetValue("Data.AllowStaleSave");
	
	Data.QueuedSavePopup = UserData.GetValue("Data.QueuedSavePopup");
	Data.AllowAutoSaveRequests = UserData.GetValue("Data.AllowAutoSaveRequests");
	Data.ShowLastAutoSaveDetails = UserData.GetValue("Data.ShowLastAutoSaveDetails");
	
		local Filters = Data.Filters;
	for i,conf in ipairs(Filters) do
		
		local value = UserData.GetValue("conf" .. conf[1] .. "_" .. conf[2]);
		--print("looking upvaluie: " .. "conf" .. conf[1] .. "_" .. conf[2]);
		if(value ~= nil) then
			--print("Loaded valuie: " .. value);
				conf[3] = value;
		end		
	end
end



function AdvancedAutoSave.StoreData()
	local Data = GetData();
	UserData.SetValue("AllowAutoSaveRequests", Data.AllowAutoSaveRequests);
	UserData.SetValue("Data.AllowQueueSave", Data.AllowQueueSave);
	UserData.SetValue("Data.AllowForceSave", Data.AllowForceSave);
	UserData.SetValue("Data.AllowStaleSave", Data.AllowStaleSave);
	
	UserData.SetValue("Data.QueuedSavePopup", Data.QueuedSavePopup);
	UserData.SetValue("Data.AllowAutoSaveRequests", Data.AllowAutoSaveRequests);
	UserData.SetValue("Data.ShowLastAutoSaveDetails", Data.ShowLastAutoSaveDetails);
	
	
	local Filters = GetData().Filters;
	for i,conf in ipairs(Filters) do
		--print("wrintg upvaluie: " .. "conf" .. conf[1] .. "_" .. conf[2], conf[3]);
		UserData.SetValue("conf" .. conf[1] .. "_" .. conf[2], conf[3]);
	end
end

function AdvancedAutoSave.UpdateData(d)
	
	MapModData.AdvancedAutoSave.Data = deepcopy(d);
	AdvancedAutoSave.ApplyData();
end


Lookup = {};
function AdvancedAutoSave.ApplyData() 
	local Filters = GetData().Filters;
	Lookup = {};
	for i,conf in ipairs(Filters) do
		--print("applying upvaluie: " .. "conf" .. conf[1] .. "_" .. conf[2], conf[3]);		
		--print("applying Lookup[" .. conf[1] .. "]");		
		--print("applying Lookup[" .. conf[1] .. "][" .. conf[2] .. "]");		
		--print("applying Lookup[" .. conf[1] .. "][" .. conf[2] .. "] = " ..  conf[3]);		
		--Game.SetAutoSavePoint(conf[1], conf[2], conf[3]);
		if(not Lookup[conf[1]]) then 
			Lookup[conf[1]] = {};
		end
		Lookup[conf[1]][conf[2]] = conf[3];
	end
end

function AdvancedAutoSave.CopyData()
	local Data = GetData();
	return deepcopy(Data);
end

function AdvancedAutoSave.GetData()
	return GetData();
end

local function GetBestPlayerTypeMatch()
	local numHumans = 0;
	local numNonHumans = 0;
	for playerID = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do
	 	local player = Players[playerID];
	 	--if player:IsEverAlive() then
	 	if player:IsAlive() then
	  	if(player:IsHuman() and not player:IsObserver()) then -- don't know if observers are human or even alive
	  		numHumans = numHumans + 1;
	  	elseif(not player:IsMajorCiv()) then
	  		numNonHumans = numHumans + 1;
			end
		end
	end
	print("numHumans=", numHumans, " numNonHumans=", numNonHumans);
	if(numHumans == 0) then -- no humans
		
		--return 5;
	elseif(numNonHumans == 0) then --humans only
		--return 6;	
	end
	--else
	if (not PreGame.IsMultiplayerGame()) then
		return 4;
	end
	if (Game.IsPitbossHost()) then
		return 0;
	elseif (Game.IsHost()) then
		return 1;
	end
	
	local eActivePlayer = GC.getGame().getActivePlayer();
	--local player = Players[Game.GetActivePlayer()];
	if (Game.GetActivePlayer() ~= -1) then
		local player = Players[Game.GetActivePlayer()];
		if (player:IsObserver()) then
			return 3;
		elseif (player:IsHuman()) then
			return 2;
		end
	end
	return -1; --Not sure when this could happen though.	
end


function AdvancedAutoSave.GetCurrentCat()
	return GetBestPlayerTypeMatch();
end


function OnWantAutoSave(eSavePoint)
	print("OnWantAutoSave=", eSavePoint);
	if(not MapModData.AdvancedAutoSave.LastSaves) then 
		MapModData.AdvancedAutoSave.LastSaves = {};
	end
	AdvancedAutoSave.ApplyData();
	
	if(MapModData.AdvancedAutoSave.Queued[eSavePoint] and MapModData.AdvancedAutoSave.Queued[eSavePoint][1] == Game.GetGameTurn()) then
		UI.SaveGame(MapModData.AdvancedAutoSave.Queued[eSavePoint][2]);
			if(GetData().QueuedSavePopup) then
			--local popup = LookUpControl( "/InGame/Popups/TextPopup" );		
			--popup.DescriptionLabel:SetText(MapModData.AdvancedAutoSave.Queued[eSavePoint][2]);
			--UIManager:QueuePopup( ContextPtr, PopupPriority.TextPopup);		
			--UIManager:QueuePopup( Controls.GAdvancedAutoSavePopup, PopupPriority.TextPopup);		
			--popup not working for me (variou8s attempts) - blaimgin on me not settingup the the mod and just hacking away in the modpack
				Events.GameplayAlertMessage("Saved: " .. MapModData.AdvancedAutoSave.Queued[eSavePoint][2] ); 
			end
		MapModData.AdvancedAutoSave.Queued[eSavePoint] = nil;
	elseif(MapModData.AdvancedAutoSave.Queued[eSavePoint] and MapModData.AdvancedAutoSave.Queued[eSavePoint][1] < Game.GetGameTurn()) then
		MapModData.AdvancedAutoSave.Queued[eSavePoint] = nil; -- could be error here
	end;
	
	if(MapModData.AdvancedAutoSave.QueuedAuto[eSavePoint] and MapModData.AdvancedAutoSave.QueuedAuto[eSavePoint] == Game.GetGameTurn()) then
		MapModData.AdvancedAutoSave.QueuedAuto[eSavePoint] = nil;
		return true;
	elseif(MapModData.AdvancedAutoSave.QueuedAuto[eSavePoint] and MapModData.AdvancedAutoSave.QueuedAuto[eSavePoint] < Game.GetGameTurn()) then
		MapModData.AdvancedAutoSave.QueuedAuto[eSavePoint] = nil; -- could be error here
	end;
	
	local best = GetBestPlayerTypeMatch();
	 
	 print("BESTAMATCH=", best);
	 print("LookupA=", Lookup[best]);
	 print("LookupB=", Lookup[best][eSavePoint]);
	 local freq = Lookup[best][eSavePoint];
	 print("BESTAFREQ=", freq);
	 
	 
	 
	 if(freq <= 0) then
		return false;
	end
	local lastturn = MapModData.AdvancedAutoSave.LastSaves[eSavePoint] or -1;
	print("LASTASAVE=", lastturn);
	if(lastturn + freq > Game.GetGameTurn()) then
		return false;
	end
	MapModData.AdvancedAutoSave.LastSaves[eSavePoint] = Game.GetGameTurn();
	 return true;
	--return true;
end

function OnAutoSaved( eSavePoint, initial, post)	 	
	print ("**** OnAutoSaved ****" .. eSavePoint );	
end


function AdvancedAutoSave.CreateData()
	if(not MapModData.AdvancedAutoSave) then
		MapModData.AdvancedAutoSave = {};
		MapModData.AdvancedAutoSave.Data = {};
		MapModData.AdvancedAutoSave.Data.Filters = {};
		
		MapModData.AdvancedAutoSave.QueuedAuto = {};
		MapModData.AdvancedAutoSave.Queued = {};
	end
end

local hasInit = false;
function AdvancedAutoSave.InitSystem()
		print("InitSystem()");		
		AdvancedAutoSave.CreateData();
    AdvancedAutoSave.InitData();
		AdvancedAutoSave.LoadData();	
		local Data = GetData();
		--print("idata11:=" .. GetData().Filters[1][1]);	
		AdvancedAutoSave.ApplyData();
end




--AdvancedAutoSave.InitSystem();

function AdvancedAutoSave.IsActive()
	return MapModData.AdvancedAutoSave.Active;
end


function AdvancedAutoSave.QueueAutoSave(point, turn)
	MapModData.AdvancedAutoSave.QueuedAuto[point] = turn; -- bug: won't handle multiple active requests
end

function AdvancedAutoSave.QueueSave(filename, point, turn)
	MapModData.AdvancedAutoSave.Queued[point] = {turn, filename}; -- bug: won't handle multiple active requests
end

function AdvancedAutoSave.Hookup() 	
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~GameEvents.GameStart hookup");
		
		AdvancedAutoSave.InitSystem();		
		if(Game.IsNetworkMultiPlayer()) then			
		--if(true) then			
			if(not MapModData.AdvancedAutoSave.WantAutoSave) then
				GameEvents.WantAutoSave.Add(OnWantAutoSave);
				GameEvents.AutoSaved.Add(OnAutoSaved);
				MapModData.AdvancedAutoSave.WantAutoSave = true;
				print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~adding wantautosave");
			end
			MapModData.AdvancedAutoSave.Active = true;
				
		else
			MapModData.AdvancedAutoSave.Active = false;
			if(MapModData.AdvancedAutoSave.WantAutoSave) then
				print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~adding removing");
					GameEvents.WantAutoSave.Remove(OnWantAutoSave);
					MapModData.AdvancedAutoSave.WantAutoSave = false;
			end
			
		end

end

if(not hackhackhack) then
	--Events.LoadScreenClose.Add(function() print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Events.LoadScreenClose."); end);
	--GameEvents.GameStarted.Add(function() print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~GameEvents.GameStarted."); end);
end
