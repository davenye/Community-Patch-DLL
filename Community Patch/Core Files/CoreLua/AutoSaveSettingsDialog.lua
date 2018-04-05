hackhackhack = 1;
include( "InstanceManager" );
include( "IconSupport" );
include( "SupportFunctions" );
include( "UniqueBonuses" );
include( "MapUtilities" );
include( "AdvancedAutoSave" );

local ModeConfigInstances = {};
local Data = {};

local CatToNum = {};
local CatToLine = {};


----------------------------------------------------------------        
-- Key Down Processing
----------------------------------------------------------------        
function InputHandler( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyDown then
        if wParam == Keys.VK_ESCAPE then
					OnBack();
				end
		end	
    return true;
end
ContextPtr:SetInputHandler( InputHandler );

------------------------------------------------------------------

function OnBack()
	-- Test if we are modal or a popup
	if (UIManager:IsModal( ContextPtr )) then
		UIManager:PopModal( ContextPtr );
	else
		UIManager:DequeuePopup( ContextPtr );
	end
	Data = AdvancedAutoSave.CopyData(); 
	ChangeAll();
end
Controls.CancelButton:RegisterCallback( Mouse.eLClick, OnBack );


------------------------------------------------------------------

function OnDefaults()
	  InitData();
		ChangeAll();
end
Controls.DefaultsButton:RegisterCallback( Mouse.eLClick, OnDefaults );


------------------------------------------------------------------

function OnAccept()
		UpdateData();
	 StoreData();
	 OnBack();
end
Controls.AcceptButton:RegisterCallback( Mouse.eLClick, OnAccept );

------------------------------------------------------------------
local hasInit = false;
function ShowHideHandler( isHide, isInit )
	--print(AutoSaveSettings.GetStuff());
	print(AdvancedAutoSave.GetStuff2());
	print("ShowHideHandler");	
	if(false and isInit) then		
		--AdvancedAutoSave.InitSystem();
		 Data = AdvancedAutoSave.CopyData();
		 --print("data11:=" .. Data[2][3]);
		CreateConfigControls();
		ChangeAll();
		hasInit = true;
		print("INITed");
		
	end
	
	if( not isHide ) then
		if(not hasInit) then		
			
			--AdvancedAutoSave.InitSystem();
			 Data = AdvancedAutoSave.CopyData();
			 
			 --print("data11:=" .. Data[2][3]);
			CreateConfigControls();
			ChangeAll();
			hasInit = true;
			--GameEvents.AutoSaved.Add(OnAutoSaved);
			print("INITed");
		end
    print("Show");
    Data = AdvancedAutoSave.CopyData();
    --InitData();
		--LoadData();
		ChangeAll();
	end
end
ContextPtr:SetShowHideHandler( ShowHideHandler);


------------------------------------------------------------------

local SaveModeOptions = 
{

	{
		label = "Turn Interval",
		tooltip = "turns between",
		needs_edit = true
	},
	{
		label = "Request Only",
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


function CreateConfigControls()
	print("CreateConfigControls"); 
	
	--for whenid = 1, 7 do
	local idx = 1;
	for i,v in ipairs(SaveModeConfigs) do
		local lineinstance = {};
		ContextPtr:BuildInstanceForControl( "SavePointConfigLine", lineinstance, Controls.ConfigLines);
		lineinstance.WhenTypeo:LocalizeAndSetText( v.txt);
		lineinstance.WhenTypeo:SetToolTipString( v.tooltip);
	--	lineinstance.WhenTypeo:SetVoid1(i);
		--lineinstance.WhenTypeo:SetToolTipCallback( TipHandler);
		
		--ModeConfigInstances[v.cat_id] = {};
		CatToLine[v.cat_id] = lineinstance;
		CatToNum[v.cat_id] = i;
		for saveid = 1, 2 do
			
			local instance = {};
			local post = saveid == 2;
			
	
		ContextPtr:BuildInstanceForControl( "SavePointConfig", instance, lineinstance.ConfigsLine);
	
				local control = instance.SaveMode;
				for m = 1, 3 do
					local controlTable = {};
					
			    control:BuildEntry("InstanceOne", controlTable);
			    --controlTable.Label:LocalizeAndSetText( "ASDAS" );
			    controlTable.Button:LocalizeAndSetText( SaveModeOptions[m].label );
			    controlTable.Button:SetToolTipString( Locale.ConvertTextKey(SaveModeOptions[m].tooltip));
			    controlTable.Button:SetVoids( m , idx);
			    --print("Added pull" .. m); 

					
			  end
			  control:RegisterSelectionCallback(OnModeSelected);
			  instance.IntervalEdit:SetVoid1(idx);
			  local dontwantclosure = idx;
			  instance.IntervalEdit:RegisterCallback( function(s) OnIntervalChanged(s, dontwantclosure) end);
			  control:CalculateInternals();
    		
			ModeConfigInstances[idx] = instance;
			idx = idx + 1;
		end
	end
end

function InitData0()
	local idx = 0; 
	for i,cat in ipairs(SaveModeConfigs) do
		for j,point in ipairs(PointSets[cat.pointset]) do
			idx = idx + 1;
			Data.Filters[idx] = {cat.cat_id, point, 1} -- default to every turn
		end
	end
end


function InitData()
	local idx = 0; 
	
	Data.AllowAutoSaveRequests = false;
	Data.AllowQueueSave = false;
	Data.AllowForceSave = false;
	Data.AllowStaleSave  = false;
	Data.AllowAutoSaveRequests = false;
	Data.ShowLastAutoSaveDetails = false;
	
	for i,cat in ipairs(SaveModeConfigs) do
		for j,point in ipairs(PointSets[cat.pointset]) do
			idx = idx + 1;
			local default = 1;
			if(j == 2) then
				default = -1;
			end
			Data.Filters[idx] = {cat.cat_id, point, default}; -- default to every turn
		end
	end
end




function ChangeAll()
		print("ChangeAll()");
	
	Controls.AllowAutoSaveRequests:SetCheck(Data.AllowAutoSaveRequests);
	Controls.AllowQueueSave:SetCheck(Data.AllowQueueSave);
	Controls.AllowForceSave:SetCheck(Data.AllowForceSave);
	Controls.AllowStaleSave:SetCheck(Data.AllowStaleSave);
	Controls.QueuedSavePopup:SetCheck(Data.QueuedSavePopup);
	Controls.AllowAutoSaveRequests:SetCheck(Data.AllowAutoSaveRequests);
	Controls.ShowLastAutoSaveDetails:SetCheck(Data.ShowLastAutoSaveDetails);

	for i,conf in ipairs(Data.Filters) do
		OnDataChange(i, conf[3]);		
	end
end

function StoreData()
	
	AdvancedAutoSave.StoreData();
end

function UpdateData()
	AdvancedAutoSave.UpdateData(Data);
end

function ApplyData() 
	for i,conf in ipairs(Data.Filters) do
		print("applying upvaluie: " .. "conf" .. conf[1] .. "_" .. conf[2], conf[3]);		
	end
end

function OnDataChange(i, v)
		print("OnDataChange(" .. i .. "," .. (v or "?") .. ")");		
	local cfg = ModeConfigInstances[i];
	
	local pd = -1;
	
	if(v ==nil) then								
		pd = 1;		
	elseif(v < 0) then		
		pd = 3;		
	elseif(v == 0) then	
			pd = 2;
	elseif(v > 0) then				
		cfg.IntervalEdit:SetText(v);		
		pd = 1;
		
	end
	
	if(pd == 1) then
		cfg.IntervalBox:SetHide(false);
		cfg.IntervalEdit:SetHide(false);
	else
		cfg.IntervalBox:SetHide(true);
		cfg.IntervalEdit:SetHide(true);
	end
		
	cfg.SaveMode:GetButton():SetText(Locale.ConvertTextKey(SaveModeOptions[pd].label));
	cfg.SaveMode:GetButton():SetToolTipString( Locale.ConvertTextKey(SaveModeOptions[pd].tooltip));
end

function ChangeData(i, v)
	print("ChangeData " .. i .. "," .. 999); 
	Data.Filters[i][3] = v;
	OnDataChange(i, v);
end


function OnModeSelected(i, g)
	print("selected instance " .. i .. " " .. g); 	
	local cfg = ModeConfigInstances[g];
	if(i == 3) then		
		ChangeData(g, -1);
	elseif(i == 2) then
		ChangeData(g, 0);
	elseif(i == 1) then		
		--ChangeData(g, nil);
		local v = tonumber(cfg.IntervalEdit:GetText());
		if (not v or v <= 0) then v = 1 end;
		ChangeData(g,  v);		
	end
	 
end


function OnIntervalChanged( s, g )
	print("OnIntervalChanged " .. s .. "@" .. g); 
		local i = tonumber(s);
		ChangeData(g, i);
end


function GetCurrentCat()
	--return math.random(1, 6);
	return AdvancedAutoSave.GetCurrentCat();
end

local lastcat = -1;
function DoUpdate() 
	local thislast = GetCurrentCat();	
	if(lastcat ~= thislast) then
		if(lastcat ~= -1) then
			CatToLine[lastcat].WhenTypeo:SetColorByName("Beige_Black");
			CatToLine[lastcat].WhenTypeo:SetToolTipString( SaveModeConfigs[CatToNum[lastcat]].tooltip);
		end
		CatToLine[thislast].WhenTypeo:SetColorByName("Green_Black");
		--print (CatToLine[thislast]);
		CatToLine[thislast].WhenTypeo:SetToolTipString(SaveModeConfigs[CatToNum[thislast]].tooltip .. "[NEWLINE][COLOR_FONT_GREEN](Current)[END_COLOR]");
		local x0 = 45;
		local x1 = 825;
		local y = 300 + (CatToNum[thislast] - 1) * 48;
		
		Controls.ActiveHighlight:SetStartVal(x0, y);
		Controls.ActiveHighlight:SetEndVal(x1, y);
		lastcat = thislast;
	end	
end

local lastlast = -2;

ContextPtr:SetUpdate( function(deltaTime)
	if(not hasInit) then
		return;
	end
	local thislast = Game.GetLastAutoSaveTurn();
	if(lastlast ~= thislast) then
			DoUpdate();
			lastlast = thislast;
	end
end);


counthax = math.random(100);
function OnAutoSaved( eSavePoint, initial, post)	 	
	--print ("GameEvents.AutoSaved=====" .. eSavePoint );
	if(not AdvancedAutoSave.IsActive()) then return end; -- needed only because my of all my order of initialization issues
	--print ("GameEvents.AutoSaved===== counthax " .. counthax);
	if(eSavePoint ~= 8) then
		
		local str = "";
		if(initial) then
			str = " (Initial)";
		elseif(post) then
			str = " (Post)";
		end
		Events.GameplayAlertMessage("--- Autosaved Turn " .. Game.GetGameTurn() .. str .. " ---"); 
	end
	--counthax = counthax + 1;

	if(AdvancedAutoSave.GetData().QueuedSavePopup and eSavePoint == 8) then
	 UIManager:QueuePopup( Controls.GAdvancedAutoSavePopup, PopupPriority.TextPopup);
	end
end

if(MapModData) then
	if(not MapModData.AdvancedAutoSaveDialog) then 
		MapModData.AdvancedAutoSaveDialog = {};
	end
	
	if(not MapModData.AdvancedAutoSaveDialog.ThisIsBS) then
		Events.SequenceGameInitComplete.Add(function() 			GameEvents.AutoSaved.Add(OnAutoSaved);				end);
		MapModData.AdvancedAutoSaveDialog.ThisIsBS = true;
	end
end


function AllowAutoSaveRequestsCheckHandler(checked) Data.AllowAutoSaveRequests = checked;	end
Controls.AllowAutoSaveRequests:RegisterCheckHandler(AllowAutoSaveRequestsCheckHandler);

function AllowQueueSaveCheckHandler(checked) Data.AllowQueueSave = checked;	end
Controls.AllowQueueSave:RegisterCheckHandler(AllowQueueSaveCheckHandler);

function AllowForceSaveCheckHandler(checked) Data.AllowForceSave = checked;	end
Controls.AllowForceSave:RegisterCheckHandler(AllowForceSaveCheckHandler);

function AllowStaleSaveCheckHandler(checked) Data.AllowStaleSave = checked;	end
Controls.AllowStaleSave:RegisterCheckHandler(AllowStaleSaveCheckHandler);

function QueuedSavePopupCheckHandler(checked) Data.QueuedSavePopup = checked;	end
Controls.QueuedSavePopup:RegisterCheckHandler(QueuedSavePopupCheckHandler);

function AllowAutoSaveRequestsCheckHandler(checked) Data.AllowAutoSaveRequests = checked;	end
Controls.AllowAutoSaveRequests:RegisterCheckHandler(AllowAutoSaveRequestsCheckHandler);

function ShowLastAutoSaveDetailsCheckHandler(checked) Data.ShowLastAutoSaveDetails = checked;	end
Controls.ShowLastAutoSaveDetails:RegisterCheckHandler(ShowLastAutoSaveDetailsCheckHandler);



