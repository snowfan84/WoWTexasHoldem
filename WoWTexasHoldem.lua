-- WoW Texas Holdem (by Kraize@freeholdemstrategy.com)
-- Fork of WoWTexasHoldem version 1.02 (by Thornwind and Density)
-- Feedback www.freeholdemstrategy.com/forum/
-- (c)Kraize@freeholdemstrategy.com 
-- Kudos to the Peter "27" McNeill and Timothy Hancock for writing the original mod and the whole Anzac Team for helping Thornwind test.. and for reminding Thornwind about all the little details he'd have left out.  Bastards.
-- Kudos to Density (Thornwind's copilot) for his work on the hand detection stuff.
-- PLEASE DO NOT FORK/MODIFY/RELEASE your own versions of this without permission from Kraize@freeholdemstrategy.com.  

--Texas Holdem UI Mod for World Of Warcraft
--To Host a game Use: /holdem
--To Join a game Use: /holdem dealer Playername
--Feedback www.freeholdemstrategy.com/forum/
--Give thanks for the mod by adding a link to your site: <a href="http://www.freeholdemstrategy.com/wow_texas_holdem.html">WoW Texas Holdem</a>
--Dealer can rightclick player boxes to get some options up.
--Dealer can set his Chips to 0, to enable "auto dealing".

-- Issues:  * This is not secure.  The "dealer" could cheat to his hearts content by modifying this file.  The clients arnt sent any data they shouldn't have,
--	            but probably could still make a mess of things if they're assholes.  Play with people you trust, not the inevitable Ironforge Gold Farmer spam.
-- 
--			* Blinds arn't controlable, betting isn't incremented properly.  Sometimes hands might get judged wrong.
--			* People joining a table mid hand arn't sent the data to see the flop if its out, or other peoples shown cards. Annoying but superficial.
--			* Dealer disconnecting is GG.

--Notes: We don't recommend that you play for real gold.  

-- 3.1.3
-- Added afktimelimit variable, consider making this dealer configurable later

-- 3.1.4
-- Complete rewrite of determining winning hand(s) from Derrick on Thunderlord-US

-- 3.1.5
-- Auto increment blinds
-- Allows setting initial blinds
-- Allows setting blind increment (default 25%)
-- Sits players out that do not have enough chips for the blind

-- 3.1.6
-- Fix not being able to quit when dealer was wrong

-- 3.1.7
-- Added a large chunk of French translation thanks to Didier

-- 3.1.8
-- Added GUI options panel

-- 3.1.9
-- console feedback bug fix
-- BlindBig slider adjusts to max of StartChips
-- Added options button to startup popup box, right click on mini map icon also opens options

-- 3.2.0
-- Redo localization handling

-- 3.2.1
-- All frames now generated in lua

-- 3.2.2
-- Auto dealing now works minimized

-- 3.2.3
-- Blinds and Blind increment adjustable during play for dealer (with GUI)

-- 3.2.4
-- Client/Server fix for Clients not getting minimum raise size now that blinds can change

-- 3.2.5
-- German re-localization by Nachti (Many thanks!)
-- Bug fix : Only dealer was getting the Starting chips, everyone else was getting 500 still! Oops...

-- 3.2.6
-- LDB implemented, minimap icon optional

-- 3.2.7
-- Stripped out a lot of obsolete code
-- changed how comm is handle, no backwards compatibility here
-- prevent clients getting messages from someone pretending to be dealer
-- Can now query other players in guild, party or raid to see if they are a dealer or what client they have
-- Use '/holdem clients' or '/holdem dealers'

-- 3.2.8
-- Code trimming/optimizing (boy does it need a lot!)

-- 3.2.9
-- Cut out all the higher layer artwork frames ( 75 of them!), this is now handled by setting the layer on the fly

-- 3.3.0
-- Added card back display to options panel

-- 3.3.1
-- Localization additions for French and German, many thanks to Djobe, Thunderhawk2001 and Frontiii
-- Localization now pulled direct from localaztion database at curseforge... I hope ;)

-- 3.3.2
-- Code cleanups
-- Large junks of redundant localization cut out

-- 3.3.3
-- You now go all in if you don't have enough chips for the blind (Thanks Bart77 for the suggestion)
-- Fixed Ace-2-3-4-5 not being a straight
-- Bug fix

-- 3.3.4
-- Delayed auto deal fixed

-- 3.3.5
-- Prevent showing cards before end of hand

-- 3.3.6
-- Rearrange layout slightly

-- 3.3.7
-- Adding library needed by LibDataBroker

-- 3.3.8
-- Russian translation thanks to  Compeccator

-- 3.3.9
-- Further translation thanks to Zapgui(Fr)

-- 3.4.0beta
-- Minor bug fix while waiting on further information to fix reported bug.

-- 3.4.1
-- Bug fix

-- 3.4.2
-- Auto check/fold/call any (suggestion from tinytokemon)

-- 3.4.3
-- Including Spanish translation with many thanks to Arxeon, epikuros and Igb
-- Fixed tick box locations... would have sworn they were right before...

-- 3.4.4
-- Fixed text in 4.0

-- 3.4.5
-- Options panel fix

-- 3.4.6
-- Comms fix

-- 3.4.7
-- Table now moveable.
-- Fixed Minimap button

-- 3.4.8
-- Fixed player popup for dealer.

-- 4.1.0
-- Fix for 4.1 requiring use of RegisterAddonMessagePrefix

-- 4.1.1
-- Changed TOC to 50100

-- 4.1.2
-- Changed TOC to 60200

-- 4.1.3
-- Changed TOC to 70000

-- 4.1.4
-- Changed TOC to 80000
-- Changed addon comms to include C_ChatInfo.

-- c1.0.0
-- First Classic release

-- c1.0.1
-- Fixes to work with Classic

-- c1.0.2
-- Added varibales for translation required by c1.0.1 fixes

-- tbc1.0.0
-- Snowfan edit to raise from the dead

-- tbc1.0.1
-- Fix unit portraits not showing up (Whitemane Only!)
-- Add slash commands to show/hide the table
-- Change to NH-appropriate art

-- tbc1.0.2
-- Fix unit portraits for all realms
-- Move autobuttons to button bar

-- tbc1.0.3
-- Fix unit portraits for all realms - really

-- tbc1.0.4
-- Fix unit portraits (for dealer perspective)
-- Remove realm information from display
-- Hide your cards when you fold
-- Change auto- fold option to auto- check/fold
-- Turn time limit reduced to 30 seconds (from 60)

-- wrath 3.0.0
-- Bump for Wrath 

-- wrath 3.4.1
-- Fix SetBackdropColor alpha from (0-255) to (0-1)

local L = MyLocalization;

--http://wiki.github.com/tekkub/libdatabroker-1-1/api
local ldb = LibStub:GetLibrary("LibDataBroker-1.1");
local FHS_LDBObject;

local UPDATEPERIOD, elapsed = 1, 0
local FHS_ldbIcon = true;

local FHS_DEBUGING = false;
local FHS_HOLDEM_version             = "wrath3.0.0";
local FHS_COMMS_version              = "v8.1.0"; -- only changes now when comms methods change
local StuffLoaded =0;
local FHS_DraggingIcon=0;

------------Saved Variables------------------
local FHS_MapIconAngle=0;
local FHS_SetSize=0;
local minimapIcon = true;
-----------------

local lasttime=0;
local timedelta=0;
local PlayerTurnEndTime=0;
local RandomSeed=0;
local AFKTimeLimit=30;

local BigBlindStart=4; -- Starting Big Blind
local BlindIncrease=0.0; -- % increase of Big Blind per round
local StartChips=500;

local NextRefresh=0; --for player portraits

local FHS_PopupName=""; --for tracking the poped up menu
local FHS_PopupIndex=0;

local GameLevel=0;
local TheButton=1;
local WhosTurn=0;
local HighestBet=0;

local BetSize=BigBlindStart;

local Blinds=0;
local SidePot={};

local RoundCount=0;

local VodkaHoldem_options_panel;

local OriginalCardTexture = "interface\\addons\\WoWTexasHoldem\\textures\\blank"
local NeutralCardTexture = "interface\\addons\\WoWTexasHoldem\\textures\\blank_n"
local AllianceCardTexture = "interface\\addons\\WoWTexasHoldem\\textures\\blank_a"
local HordeCardTexture = "interface\\addons\\WoWTexasHoldem\\textures\\blank_h"


--Single

local CardRank=
{
	"--",
	L['Two'],
	L['Three'],
	L['Four'],
	L['Five'],
	L['Six'],
	L['Seven'],
	L['Eight'],
	L['Nine'],
	L['Ten'],
	L['Jack'],
	L['Queen'],
	L['King'],
	L['Ace'],
}

--Plural
local CardRanks=
{
	"--",
	L['Twos'],
	L['Threes'],
	L['Fours'],
	L['Fives'],
	L['Sixes'],
	L['Sevens'],
	L['Eights'],
	L['Nines'],
	L['Tens'],
	L['Jacks'],
	L['Queens'],
	L['Kings'],
	L['Aces'],
}


local Cards = 
{
	{object="FHS_Card_C0",	rank=14,	suit=1},
	{object="FHS_Card_C1",	rank=2,		suit=1},
	{object="FHS_Card_C2",	rank=3,		suit=1},
	{object="FHS_Card_C3",	rank=4,		suit=1},
	{object="FHS_Card_C4",	rank=5,		suit=1},
	{object="FHS_Card_C5",	rank=6,		suit=1},
	{object="FHS_Card_C6",	rank=7,		suit=1},
	{object="FHS_Card_C7",	rank=8,		suit=1},
	{object="FHS_Card_C8",	rank=9,		suit=1},
	{object="FHS_Card_C9",	rank=10,	suit=1},
	{object="FHS_Card_C10",	rank=11,	suit=1},
	{object="FHS_Card_C11",	rank=12,	suit=1},
	{object="FHS_Card_C12",	rank=13,	suit=1},

	{object="FHS_Card_D0",	rank=14,	suit=2},
	{object="FHS_Card_D1",	rank=2,		suit=2},
	{object="FHS_Card_D2",	rank=3,		suit=2},
	{object="FHS_Card_D3",	rank=4,		suit=2},
	{object="FHS_Card_D4",	rank=5,		suit=2},
	{object="FHS_Card_D5",	rank=6,		suit=2},
	{object="FHS_Card_D6",	rank=7,		suit=2},
	{object="FHS_Card_D7",	rank=8,		suit=2},
	{object="FHS_Card_D8",	rank=9,		suit=2},
	{object="FHS_Card_D9",	rank=10,	suit=2},
	{object="FHS_Card_D10",	rank=11,	suit=2},
	{object="FHS_Card_D11",	rank=12,	suit=2},
	{object="FHS_Card_D12",	rank=13,	suit=2},

	{object="FHS_Card_H0",	rank=14,	suit=3},
	{object="FHS_Card_H1",	rank=2,		suit=3},
	{object="FHS_Card_H2",	rank=3,		suit=3},
	{object="FHS_Card_H3",	rank=4,		suit=3},
	{object="FHS_Card_H4",	rank=5,		suit=3},
	{object="FHS_Card_H5",	rank=6,		suit=3},
	{object="FHS_Card_H6",	rank=7,		suit=3},
	{object="FHS_Card_H7",	rank=8,		suit=3},
	{object="FHS_Card_H8",	rank=9,		suit=3},
	{object="FHS_Card_H9",	rank=10,	suit=3},
	{object="FHS_Card_H10",	rank=11,	suit=3},
	{object="FHS_Card_H11",	rank=12,	suit=3},
	{object="FHS_Card_H12",	rank=13,	suit=3},

	{object="FHS_Card_S0",	rank=14,	suit=4},
	{object="FHS_Card_S1",	rank=2,		suit=4},
	{object="FHS_Card_S2",	rank=3,		suit=4},
	{object="FHS_Card_S3",	rank=4,		suit=4},
	{object="FHS_Card_S4",	rank=5,		suit=4},
	{object="FHS_Card_S5",	rank=6,		suit=4},
	{object="FHS_Card_S6",	rank=7,		suit=4},
	{object="FHS_Card_S7",	rank=8,		suit=4},
	{object="FHS_Card_S8",	rank=9,		suit=4},
	{object="FHS_Card_S9",	rank=10,	suit=4},
	{object="FHS_Card_S10",	rank=11,	suit=4},
	{object="FHS_Card_S11",	rank=12,	suit=4},
	{object="FHS_Card_S12",	rank=13,	suit=4},
	
	{object="FHS_Blank_1" },
	{object="FHS_Blank_2" },
	{object="FHS_Blank_3" },
	{object="FHS_Blank_4" },
	{object="FHS_Blank_5" },
	{object="FHS_Blank_6" },
	{object="FHS_Blank_7" },
	{object="FHS_Blank_8" },
	{object="FHS_Blank_9" },
	{object="FHS_Blank_10" },
	{object="FHS_Blank_11" },
	{object="FHS_Blank_12" },
	{object="FHS_Blank_13" },
	{object="FHS_Blank_14" },
	{object="FHS_Blank_15" },
	{object="FHS_Blank_16" },
	{object="FHS_Blank_17" },
	{object="FHS_Blank_18" },
	{object="FHS_Blank_19" },
	{object="FHS_Blank_20" },
	{object="FHS_Blank_21" },
	{object="FHS_Blank_22" },
	{object="FHS_Blank_23" },
}


--Player Seats
local Seats	= {
	{object="FHS_Seat_1",name="",	x=180, y=190,	chips=0,bet=0,status="", seated=0,hole1=0,hole2=0,dealt=0,alpha=1, inout="" },
	{object="FHS_Seat_2",name="",	x=240, y=70,	chips=0,bet=0,status="", seated=0,hole1=0,hole2=0,dealt=0,alpha=1, inout="" },
	{object="FHS_Seat_3",name="",	x=240, y=-60,	chips=0,bet=0,status="", seated=0,hole1=0,hole2=0,dealt=0,alpha=1, inout="" },
	{object="FHS_Seat_4",name="",	x=170, y=-200,	chips=0,bet=0,status="", seated=0,hole1=0,hole2=0,dealt=0,alpha=1, inout="" },
	{object="FHS_Seat_5",name="",	x=-0, y=-230,	chips=0,bet=0,status="", seated=0,hole1=0,hole2=0,dealt=0,alpha=1, inout="" },
	{object="FHS_Seat_6",name="",	x=-170, y=-200,	chips=0,bet=0,status="", seated=0,hole1=0,hole2=0,dealt=0,alpha=1, inout="" },
	{object="FHS_Seat_7",name="",	x=-240, y=-60,	chips=0,bet=0,status="", seated=0,hole1=0,hole2=0,dealt=0,alpha=1, inout="" },
	{object="FHS_Seat_8",name="",	x=-240, y=70,	chips=0,bet=0,status="", seated=0,hole1=0,hole2=0,dealt=0,alpha=1, inout="" },
	{object="FHS_Seat_9",name="",	x=-180, y=190,	chips=0,bet=0,status="", seated=0,hole1=0,hole2=0,dealt=0,alpha=1, inout="" },
}

local LocalSeat=0;
local IsDealer=0;
local DealerName="";

--Shuffle array
local Shuffle={};

--Servers Flop
local DealerFlop={};
local DealerTimer=0;
local DealerTimerDelay=10;

--Flop as known at any point
local Flop={};

local FlopBlank={}; --Record of blank flop cards

local DealerCard=0;
local CardWidth=80;

local DealerX=0;
local DealerY=250;

local DealerDelay=0.5;
local CardSpeed=3;
local CC=0;
local BlinkOn = 1;

local realm = GetRealmName()
local realmName = "-" .. realm


------------------
-- Functions --
------------------
function FHSPoker_OnLoad()

	StaticPopupDialogs["FHS_DEALER"] = 
	{
		text = L["Do you wish to start Dealing?"] .."\n".. L['To join a game use /holdem dealer <playername>'],
			button1 = L['Start Dealing'],
			button2 = L['Cancel'],
			button3 = L['Options'],
			OnAccept = function()
			FHS_DealerClick();
			end,
			OnAlt = function() InterfaceOptionsFrame_OpenToCategory(VodkaHoldem_options_panel) end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1
	};
	
	-- Link LDB
	FHS_Setup_LDB();
	
	--Setup frames
	FHS_SetupFrames();
	
    -- Events
    FHSPoker_registerEvents();
	    
	FHS_Console_Feedback("::  "..L['WoW Texas Hold\'em'] .." ".. FHS_HOLDEM_version);
	FHS_Console_Feedback("::  "..L['Use \'/holdem help\' for slash command options'])
	
	-- Initialize Seat Rings
	for j=1,5 do 
		--swap the side for a few of them
		
	local seat = "FHS_Seat_"..j		
		
		_G[seat.."_Port"]:SetPoint("CENTER", seat, "CENTER", -100, 0);
		_G[seat.."_PortWho"]:SetPoint("CENTER", seat, "CENTER", -100, 0);
		_G[seat.."_Ring"]:SetPoint("CENTER", seat, "CENTER", -82, -22);
		_G[seat.."_RingSelect"]:SetPoint("CENTER", seat, "CENTER", -82, -22);
	end

	for j=6,9 do
		Seats[j].x=Seats[j].x+12;
		PlayerTurnEndTime=GetTime()+(24*60*60*365);
	end;

	FHS_Version:SetText(L['WoW Texas Hold\'em'].." "..FHS_HOLDEM_version);
	
	-- Assign all Cards their objects
	for key, object in pairs(Cards) do 
		Cards[key].Artwork=_G[Cards[key].object];
		Cards[key].fraction=0;
		Cards[key].fadeout=0;
		Cards[key].fadetime=0;
		Cards[key].x=0;
		Cards[key].y=0;
		Cards[key].startx=0;
		Cards[key].starty=0;
		Cards[key].visible=0;
		Cards[key].high=0;	
	end

	--Turn off all the cards etc
	FHS_ClearTable();

	StuffLoaded=1;

	--FHSPokerFrame:Hide();
end;


function FHS_SetCardTextures()

	-- Pick Artwork to use and assign to CardTexture
	if FHS_ArtWork == 4 then
		CardTexture = OriginalCardTexture
	elseif FHS_ArtWork == 1 then
		CardTexture = NeutralCardTexture
	elseif FHS_ArtWork == 2 then
		CardTexture = AllianceCardTexture
	elseif FHS_ArtWork == 3 then
		CardTexture = HordeCardTexture
	else
		CardTexture = NeutralCardTexture
	end

	-- Go through all cards
	for key, object in pairs(Cards) do 
		-- if card is a blank then assign artwork from above
		if string.find(Cards[key].object, "Blank") then 
			Cards[key].Artwork:SetTexture(CardTexture)
		end
	end
	_G["FHS_Blank_Example"]:SetTexture(CardTexture)
end


function SeatSlashCommand(msg)

	--Recenter the frame
	FHSPokerFrame:ClearAllPoints();
	FHSPokerFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);

	if (msg=="") then 
		FHS_DealerClick()
		
	else
		-- Split arguments into a table and make all arguments lowercase
		args = { strsplit( " ", strlower(msg)) }
		
		-- only a valid message if we have atleast 1 argument
		if (table.getn(args)<1) then
			FHS_DealerClick()
			
		elseif ( args[1]=="options" or args[1]=="config") then
			InterfaceOptionsFrame_OpenToCategory(VodkaHoldem_options_panel);

		elseif ( args[1]=="dealer" and table.getn(args) == 2) then
			FHS_SendMessage("!seat",args[2]);
			
		elseif ( args[1]=="clients") then
			FHS_Console_Feedback(L['Looking for clients'])
			if ( UnitInRaid("player")) then
				FHS_BroadcastMessage("whoclient", "RAID")
			else
				FHS_BroadcastMessage("whoclient", "PARTY")
			end
			if ( IsInGuild() ) then
				FHS_BroadcastMessage("whoclient", "GUILD")
			end
			
		elseif ( args[1]=="dealers") then
			FHS_Console_Feedback(L['Looking for dealers'])
			if ( UnitInRaid("player")) then
				FHS_BroadcastMessage("whodealer", "RAID")
			else
				FHS_BroadcastMessage("whodealer", "PARTY")
			end
			if ( IsInGuild() ) then
				FHS_BroadcastMessage("whodealer", "GUILD")
			end
			
		elseif ( args[1]=="help") then
			-- Otherwise output usage text
			FHS_Console_Feedback("::  "..L['Use \'/holdem\' to start a table as the dealer.']);
			FHS_Console_Feedback("::  "..L['Use \'/holdem show\' to show the table']);
			FHS_Console_Feedback("::  "..L['Use \'/holdem hide\' to hide the table']);
			FHS_Console_Feedback("::  "..L['Use \'/holdem dealer <playername>\' to join someone elses table.']);
			FHS_Console_Feedback("::  "..L['Use \'/holdem dealers\' to find dealers in your guild/party/raid.']);
			FHS_Console_Feedback("::  "..L['Use \'/holdem clients\' to find clients in your guild/party/raid.']);
			FHS_Console_Feedback("::  "..L['Use \'/holdem options\' for options panel']);
			
		elseif ( args[1]=="show") then
			FHSPokerFrame:Show()
		elseif ( args[1]=="hide") then	
			FHSPokerFrame:Hide()
		else
			SeatSlashCommand("help")
				
		end
	end
end


function FHS_SizeClick()

	FHS_SetSize=FHS_SetSize+1;
	
	if (FHS_SetSize>2) then
		FHS_SetSize=0;
	end;

	if (FHS_SetSize==0) then
		FHSPokerFrame:SetScale(1);
		
	elseif (FHS_SetSize==1) then
		FHSPokerFrame:SetScale(0.75);
	
	elseif (FHS_SetSize==2) then
		FHSPokerFrame:SetScale(0.5);
			
	end;

	FHSPokerFrame:ClearAllPoints();
	FHSPokerFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
end


function FHS_DealerClick()

	if (IsDealer==1) then
		FHS_StopServer();
	end
	FHS_StartDealer();	
end;


--clear all the cards off the table
function FHS_ClearCards()

	CC=0;
	for key, object in pairs(Cards) do
		FHS_SetCard(key,DealerX,DealerY,0,0,0,0,0,0);
	end

	Flop={};
	FlopBlank={};
	BlankCard=53;
	
end


--Clear the table of everything
function FHS_InitializeSeat(j)

--Snowfan edit initialize Seats[j]
	Seats[j].name="";
	Seats[j].displayname="";
	Seats[j].HavePort=0;
	Seats[j].seated=0;
	Seats[j].dealt=0;
	Seats[j].status="";
	Seats[j].bet=0;
	Seats[j].hole1=0;
	Seats[j].hole2=0;
	Seats[j].alpha=1;
	Seats[j].inout="IN";
end;


function FHS_ClearTable()
	
	for j=1,9 do
		FHS_InitializeSeat(j)
	end;

	for j=1,9 do
		FHS_UpdateSeat(j)
	end;

	FHS_ClearCards()
	FHS_SelectPlayerRing(0)
	FHS_StatusText("")
	FHS_Pot_Text:SetText(L['WoW Texas Hold\'em'])

	FHS_HideAllButtons(true)

	FHS_Popup:Hide()
end;


function FHSPoker_registerEvents()
    
    FHSPokerFrame:RegisterEvent("ADDON_LOADED");
    FHSPokerFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	FHSPokerFrame:RegisterEvent("CHAT_MSG_ADDON");
    
	--Initialize Commands
	SLASH_FHSPOKER1 = "/holdem";
	
	SlashCmdList["FHSPOKER"] = function(msg)
		SeatSlashCommand(msg);
	end
end


function FHSPoker_OnEvent(self, event, ...)

-- prefix = arg1;
-- msg = arg2;
-- distrib = arg3;
-- sender = arg4;
	

	if (event == "PLAYER_ENTERING_WORLD") then
		FHS_Debug_Feedback("PLAYER_ENTERING_WORLD" );
		C_ChatInfo.RegisterAddonMessagePrefix("VodkaHoldem")
		
	elseif (event == "ADDON_LOADED") then
		arg1 = ...;
		if (arg1 == "WoWTexasHoldem") then
		
			FHS_Debug_Feedback("Addon loaded" .. arg1);
			if ( FHS_Artwork == nil) then
				FHS_Artwork = 1; -- default to neutral artwork
			end
			if ( FHS_StartChips) then
				StartChips = FHS_StartChips
			end
			if ( FHS_BlindIncrease) then
				FHS_SetBlindIncr(FHS_BlindIncrease);
			end
			if ( FHS_BigBlindStart) then
				BigBlindStart = FHS_BigBlindStart;
			end
			
			if ( FHS_minimapIcon) then
				minimapIcon = FHS_minimapIcon;
				FHSPoker_MapIconFrame:Show();
			else
				FHSPoker_MapIconFrame:Hide();
			end
			
			FHS_SetupOptionsPanel();
			FHS_SetCardTextures();
			FHS_SetupXMLButtons();
		end

	elseif (event == "CHAT_MSG_ADDON") then
		arg1 , arg2, arg3, arg4 = ...;
		FHS_Debug_Feedback("CHAT_MSG_ADDON "..arg1 );
		if ( arg1 == "VodkaHoldem") then
			FHS_HandleAddonComms(arg2, arg3, arg4)
		end
	end

end;


function FHSPoker_Update(arg1)
	
	--Animation is handled here
	if (StuffLoaded==1) then
--		SetPortraitTexture(FHS_Seat_Port_9, "player");
		local time=GetTime();

		timedelta=time-lasttime;
		
		if (lasttime==0) then
			timedelta=0;
		end -- initialization
		
		lasttime=time;
	
		for key, object in pairs(Cards) do 
	
			-- This is nice, just increase fraction until it hits 1			
			if (Cards[key].fraction<1) then
				Cards[key].fraction=Cards[key].fraction+(timedelta*CardSpeed);
			else
				if (Cards[key].fadeout>0) then  --Track how many ms we've been faded
					Cards[key].fadetime=Cards[key].fadetime+(timedelta*1000);
				end;
			end
		
			if (Cards[key].fraction>1) then
				Cards[key].fraction=1;
			end

			-- And update it
			FHS_DrawCard(key,0);
		end 


		if ( time>NextRefresh ) then
			NextRefresh=time+1;
			for j=1,9 do
				FHS_UpdateSeat(j);
			end
			
			if (WhosTurn>0) then
				FHS_BlinkWhosTurn();
			end;
			FHS_CheckPlayerTime();
		end;
	end
end;


function FHSPoker_MapIconUpdate()

	if (FHS_DraggingIcon==1) then

		local xpos,ypos = GetCursorPosition();
		local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom();

		xpos = xmin-xpos/Minimap:GetEffectiveScale()+70;
		ypos = ypos/Minimap:GetEffectiveScale()-ymin-70;

		FHS_MapIconAngle = math.deg(math.atan2(ypos,xpos));
		
		FHS_IconPos(FHS_MapIconAngle);
	end

	-- Flash if its our go
	FHSPoker_MapIcon:Show();
	FHSPoker_MapIcon:SetAlpha(1);
	if ((LocalSeat==WhosTurn)and(LocalSeat>0)) then
		var= (sin(GetTime() *400 )+1)/2;
		FHSPoker_MapIcon:SetAlpha(var);
	end

end


function FHS_LDB_OnUpdate()

	if ((LocalSeat==WhosTurn)and(LocalSeat>0)) then
		varR= (sin(GetTime()*400)*128);
		varG= (cos(GetTime()*400)*128);
		varB= (sin(GetTime()*400)*-128);
		
		FHS_LDBObject.text = L['Your turn'];
		FHS_LDBObject.iconB = varB;
		FHS_LDBObject.iconG = varG;
		FHS_LDBObject.iconR = varR;
	else
		FHS_LDBObject.text = L['WoW Texas Hold\'em'];
		FHS_LDBObject.iconB = 255;
		FHS_LDBObject.iconG = 255;
		FHS_LDBObject.iconR = 255;
	end
end


function FHS_Hidden_frame_OnUpdate(self, elap)

	if (StuffLoaded==1) then

		if (IsDealer==1 ) then
			if ( Seats[LocalSeat].chips==0 ) then
			-- if dealer and out of chips
				FHS_Play:SetText(L['AutoDealing'])
				if ( GetTime() > DealerTimer and DealerTimer > 0 ) then
					if ( FHS_GetSeatedPlayers() > 2 ) then
						FHS_PlayClick()
						DealerTimer = 0
					end
				end
			else
				FHS_Play:SetText(L['Play'])
			end
		end
		
		if ( minimapIcon ) then
			FHSPoker_MapIconUpdate()
		end
		
		if ( FHS_ldbIcon ) then
			FHS_LDB_OnUpdate()
		end
	end
end


function FHS_MapIconClick(arg1)
	
	FHS_LauncherClicked(arg1)
end


function FHS_LauncherClicked(button)

	if ( button == "RightButton" ) then
		InterfaceOptionsFrame_OpenToCategory(VodkaHoldem_options_panel)
	elseif ( button == "LeftButton" ) then
		if ( IsDealer==0 and LocalSeat==0) then
			StaticPopup_Show("FHS_DEALER")
			return
		end
		
		FHS_ShowTable()
	end
end


function FHS_ShowTable()
	FHSPokerFrame:Show()
end


function FHS_Dragging(param)
	FHS_DraggingIcon=param
end


function FHS_IconPos(angle)
	local xpos=cos(angle)*81
	local ypos=sin(angle)*81
	FHSPoker_MapIconFrame:SetPoint("TOPLEFT","Minimap","TOPLEFT",53-xpos,-55+ypos)
end



function FHS_CheckPlayerTime()
	if ((GetTime()>PlayerTurnEndTime)and(WhosTurn~=0)) then

		-- Snowfan edit
		if (WhosTurn==1) then
			FHS_FoldClick()
		else
			FHS_SendMessage("forceout_"..WhosTurn,Seats[WhosTurn].name)
		end

		PlayerTurnEndTime=GetTime()+(24*60*60*365) -- set the time to next year	
	end;

end;




function FHS_BlinkWhosTurn()
	
	if (BlinkOn == 0) then
		BlinkOn = 1
		if (WhosTurn>0) then
			_G["FHS_Seat_"..WhosTurn.."_RingSelect"]:Show()
			_G["FHS_Seat_"..WhosTurn.."_Ring"]:Hide()
		end
	else
		BlinkOn = 0;
		if (WhosTurn>0) then
			_G["FHS_Seat_"..WhosTurn.."_RingSelect"]:Hide()
			_G["FHS_Seat_"..WhosTurn.."_Ring"]:Show()
		end
	end

end


function FHS_StatusText(text)
	FHS_Status_Text:SetText(text)
end


function FHS_StatusTextCards()
	
	if (LocalSeat>0) then
		FHS_StatusText(FHS_handDescription(FHS_FindHandForPlayer(LocalSeat)))
	end
end


function FHS_SetCard(index,dealerx,dealery,x,y,visible,fraction,fadeout,highlayer)

	Cards[index].x=x
	Cards[index].y=y
	Cards[index].startx=dealerx
	Cards[index].starty=dealery
	Cards[index].fraction=fraction
	Cards[index].fadetime=0
	Cards[index].visible=visible
	Cards[index].fadeout=fadeout
	Cards[index].Artwork:SetAlpha(1)
	Cards[index].high=highlayer
	FHS_DrawCard(index)
end


function FHS_DrawCard(index)

	local dx
	local dy
	local card = Cards[index]
	local frac = card.fraction
	local mfrac = 1-frac
	
	
	if (frac<0) then
		card.Artwork:Hide()
		return
	else
 		dx=(card.startx*mfrac)+(card.x*frac)
		dy=(card.starty*mfrac)+(card.y*frac)
	end

	if (card.visible==1) then
		card.Artwork:SetPoint("CENTER", "FHSPokerFrame", "CENTER", dx+29, dy)

		-- Change the layer of the card to OVERLAY if high
		if (card.high==1) then
			card.Artwork:SetDrawLayer("OVERLAY")
		end
		card.Artwork:Show()
		
		if (card.fadeout>0)and(card.fadetime>0) then
			delta = card.fadeout - card.fadetime
			if (delta<0) then
				card.Artwork:Hide()
			else
				delta = (delta/card.fadeout)
				card.Artwork:SetAlpha(delta)
			end
		end
	else
		-- Otherwise hide cards
		card.Artwork:SetDrawLayer("ARTWORK")
		card.Artwork:SetPoint("CENTER", "FHSPokerFrame", "CENTER", 0, 0)
		card.Artwork:Hide()
	end
end


function FHS_UpdateSeat(j)
	
	local seat = "FHS_Seat_"..j
	
	-- If no player at position then hide/clear all data
	if (Seats[j].seated==0) then
		_G[seat.."_Name"]:SetText("")
		_G[seat.."_Chips"]:SetText("Empty")
		_G[seat.."_Status"]:SetText("")
		_G[seat.."_Port"]:Hide()
		_G[seat.."_PortWho"]:Hide()
		_G[seat]:Hide()
	else
		_G[seat]:Show()
		_G[seat]:SetAlpha(Seats[j].alpha)
		_G[seat.."_Name"]:SetText(Seats[j].displayname)
		_G[seat.."_Chips"]:SetText(L['Chips']..": "..Seats[j].chips)
		
		-- Pull Blinds data if we aren't the dealer and we receive info on a bet
		-- Setting Blinds for a client sets the Min Bet
		if ( Dealer == 0 and (Seats[j].status == "Big Blind" or Seats[j].status == "Blinds")) then
			Blinds = Seats[j].bet;
			Betsize = Seats[j].bet;
		end
		
		-- Translate status to local language. Cannot be done at source as source my not be playing in the same language!
		_G[seat.."_Status"]:SetText(L[Seats[j].status])
		_G[seat.."_PortWho"]:Hide()
		
		--Portrait
		local portraitObj = _G[seat.."_Port"]
		portraitObj:Show()
		
		if ( UnitName("player")==Seats[j].displayname) then --Visible
			SetPortraitTexture(portraitObj,"player");
			Seats[j].HavePort=1;
			
		elseif ( UnitName("target")==Seats[j].displayname) then --Visible
			SetPortraitTexture(portraitObj,"target");
			Seats[j].HavePort=1;
			
		else
			for n=1,5 do
				if ( (UnitName("party"..n))==Seats[j].displayname) then --Visible
					SetPortraitTexture(portraitObj, "party"..n);
					Seats[j].HavePort=1;
					break
				end
			end;
			
			if ( UnitInRaid("player") )then
				for n=1,40 do
					if ( UnitName("raid"..n)==Seats[j].displayname) then --Visible
						SetPortraitTexture(portraitObj, "raid"..n);
						Seats[j].HavePort=1;
						break
					end
				end
			end
		end
	
		if (Seats[j].HavePort==0) then
			portraitObj:Hide();	
			_G[seat.."_PortWho"]:Show()
		end
		
	end
end


function FHS_StopClient()

	IsDealer=0;
	LocalSeat=0;
	WhosTurn=0;
	DealerName="";
	FHS_ClearTable();
end


function FHS_QuitClick()

	if (IsDealer==0) then
		if (DealerName ~= "" ) then
			FHS_SendMessage("q_"..LocalSeat,DealerName)
		end;
		
		FHS_StopClient()
	else
		FHS_StopServer()
	end

	--Hide the buttons cause we're done
	FHS_HideAllButtons(true)

	FHSPokerFrame:Hide()
end;


--function FHS_SitOutInClick()
--
--	FHS_SitOutIn(LocalSeat)
--end


function FHS_SitOutInClick()

	if (IsDealer==0) then
		if(Seats[LocalSeat].inout=="IN") then
			FHS_FoldClick();
			FHS_SendMessage("inout_"..LocalSeat.."_OUT",DealerName);
			Seats[LocalSeat].inout="OUT";
			FHS_SitOutIn:SetText(L['I\'m Back']);
		else			
			FHS_SendMessage("inout_"..LocalSeat.."_IN",DealerName);
			Seats[LocalSeat].inout="IN";
			FHS_SitOutIn:SetText(L['Sit Out']);
		end;
	else
		-- don't let the dealer sit out -- put up a message box to that dealer must play	
		message(L['Sorry the dealer can not sit out.  Set your chips to Zero to enable auto deal.']);	
	end
end


function FHS_HideAllButtons(fold)
	if ( fold ) then
		FHS_Fold:Hide()
	end
	FHS_Call:Hide()
	FHS_Raise:Hide()
	FHS_Raise_Higher:Hide()
	FHS_Raise_Lower:Hide()
	FHS_AllIn:Hide()
end;


function FHS_FoldClick()

	if (IsDealer==0) then
		
		if (Seats[LocalSeat].dealt==1) then
			FHS_SendMessage("fold_"..LocalSeat,DealerName)
		
			--Server wont tell us we've folded, so we do it ourselves
			Seats[LocalSeat].dealt=0
						
			FHS_ShowCard(LocalSeat,"Folded")
			FHS_Fold:SetText(L['Show Cards'])
			FHS_Fold:Hide()
			
			--Snowfan edit - this will hide our hole cards when we fold
			FHS_SetCard(Seats[LocalSeat].hole1,DealerX,DealerY, Seats[LocalSeat].x, Seats[LocalSeat].y,0,1,0,0);
			FHS_SetCard(Seats[LocalSeat].hole2,DealerX,DealerY, Seats[LocalSeat].x-12, Seats[LocalSeat].y+12,0,1,0,0);
				
		else
			FHS_SendMessage("showcards_"..LocalSeat.."_"..RoundCount,DealerName)
			FHS_Fold:Hide()
		end
	
	else
		if (Seats[LocalSeat].dealt==1) then		
			Seats[LocalSeat].status="Folded"
			FHS_FoldPlayer(LocalSeat)
			FHS_Fold:SetText(L['Show Cards'])
			FHS_Fold:Hide()
		else
			FHS_ShowCard(LocalSeat,"Showing")
			FHS_Fold:Hide()
		end
	end
	
	FHS_UpdateSeat(LocalSeat);
	
	--its no longer our turn, obviously
	FHS_HideAllButtons(false)

end


function FHS_RaiseClick()
	if (LocalSeat==0) then return; end
	
	--Raised
	delta=-1;

	delta = HighestBet-Seats[LocalSeat].bet;
	-- Make sure we have enough chips
	delta = delta + BetSize;

	--All in
	if (HighestBet+BetSize>=Seats[LocalSeat].chips) then
		delta=Seats[LocalSeat].chips;	
	end;
	
	if (IsDealer==0) then
		FHS_SendMessage("call_"..LocalSeat.."_"..delta,DealerName);
	else
		FHS_PlayerAction(LocalSeat,delta);
	end;
end;


function FHS_AllInClick()
	if (LocalSeat==0) then return; end
	
	--Raised
	delta=-1;

	delta=Seats[LocalSeat].chips;	
	if (delta==0) then return; end;

	if (IsDealer==0) then
		FHS_SendMessage("call_"..LocalSeat.."_"..delta,DealerName);
	else
		FHS_PlayerAction(LocalSeat,delta);
	end;
end;


function FHS_CallClick()
	
	if (LocalSeat==0) then return; end
		
	--Called/Checked
	
	delta=-1
	
	if (Seats[LocalSeat].bet<HighestBet) then
		--We need to make a bet here.
		delta = HighestBet-Seats[LocalSeat].bet;
			
		-- Make sure we have enough chips
		if (delta>Seats[LocalSeat].chips) then
			delta=-1;			
		end; 
	end;
	if (Seats[LocalSeat].bet==HighestBet) then
		--Checked!
		delta=0;
	end;

	if (delta>-1) then
		if (IsDealer==0) then
			FHS_SendMessage("call_"..LocalSeat.."_"..delta,DealerName);
		else
			FHS_PlayerAction(LocalSeat,delta);
		end;
	end;
end;


function FHS_StartClient()

	FHS_Console_Feedback(string.format(L['%s has seated you in Seat %d'],DealerName, LocalSeat));
	FHS_ClearTable();
	
	if (IsDealer==1) then
		FHS_StopServer();
	end
	
	IsDealer=0;
	FHS_ShowTable();
	FHS_Play:Hide();	
	
end


-- Enable or disable the buttons based on whats going on
function FHS_UpdateWhosTurn()
	
	if (LocalSeat==0) then
		return;
	end;

	FHS_UpdateButtons();

	--Fold Button, available while we still have cards
	if (Seats[LocalSeat].dealt==1) then
		FHS_Fold:SetText(L['Fold']);
		FHS_Fold:Show();
	end;

	FHS_SelectPlayerRing(WhosTurn);

	if (WhosTurn==LocalSeat) then
		--Its our turn!
		
		FHS_Call:Show();
		FHS_AllIn:Show();
		FHS_Raise:Show();
		FHS_Raise_Higher:Show();
		FHS_Raise_Lower:Show();
		
		Call=1;
		
		--Set the text based on the action required
		delta = HighestBet-Seats[LocalSeat].bet;
		FHS_Debug_Feedback("Delta:"..delta)
		FHS_Call:SetText("Call "..delta)

		if (Seats[LocalSeat].bet==HighestBet) then
			FHS_Call:SetText(L['Check']);
			delta=0;
			Call=0;
		end
		
-- ******************
-- Need to change the raise ammount to be ateast the last raise instead of the blind
-- ******************
		-- Make sure we have enough chips
		if (Call==1) then
			FHS_Raise:SetText(L['Call'].." "..delta..", "..L['Raise'].." "..BetSize);
		else
			FHS_Raise:SetText(L['Raise'].." "..BetSize);
		end;


		--if (HighestBet+BetSize>=Seats[LocalSeat].chips) then
		--if (BetSize>(Seats[LocalSeat].chips-delta)) then
		if ( Seats[LocalSeat].chips <= delta ) then
			delta=-1;			
			if (Call==1) then
				FHS_Raise:SetText(L['Call'].." "..L['All In']);
				FHS_Call:Hide();
			else
				FHS_Raise:SetText(L['All In']);
			end;		
		end; 
		
		--Check for automatic play
		if ( FHS_AutoBetCheck:GetChecked() ) then
			if ( not FHS_AutoStickyCheck:GetChecked() ) then
				FHS_AutoBetCheck:SetChecked(false);
			end;
			FHS_CallClick();
		end;
		
		if ( FHS_AutoCheckCheck:GetChecked() and Call==0 ) then
			if ( not FHS_AutoStickyCheck:GetChecked() ) then
				FHS_AutoCheckCheck:SetChecked(false);
			end;
			FHS_CallClick();
		end;
		
		if ( FHS_AutoFoldCheck:GetChecked() ) then
			if ( not FHS_AutoStickyCheck:GetChecked() ) then
				FHS_AutoFoldCheck:SetChecked(false);
			end;
			
			--Snowfan edit - auto button should be check/fold instead
			if (Seats[LocalSeat].bet==HighestBet) then
				delta=0;
				Call=0;
				FHS_CallClick();
			else
				FHS_FoldClick();
			end
			
			
		end;

	else
		--Its not our turn!
		FHS_HideAllButtons(false)
	end;
end;


function FHS_RaiseChange(dir)

	local CallAmount = 0;
	
	CallAmount = HighestBet-Seats[LocalSeat].bet;
	
	BetSize=BetSize+(dir*20);
	if (BetSize<Blinds) then BetSize=Blinds; end
	--if (HighestBet+BetSize>=Seats[LocalSeat].chips) then 
	if (BetSize>(Seats[LocalSeat].chips-CallAmount)) then
		BetSize=Seats[LocalSeat].chips-CallAmount; 
	end;
	FHS_UpdateWhosTurn();
end;


function FHS_SelectPlayerRing(j)

	--Hide everyones selection
	for r=1,9 do
		_G["FHS_Seat_"..r.."_RingSelect"]:Hide()
		_G["FHS_Seat_"..r.."_Ring"]:Show()
	end

	if (j>0) then
		_G["FHS_Seat_"..j.."_RingSelect"]:Show()
		_G["FHS_Seat_"..j.."_RingSelect"]:SetAlpha(1)
		_G["FHS_Seat_"..j.."_Ring"]:Hide()

	end
end


function FHS_SelectPlayerButton(j)

	--Hide everyones button
	for r=1,9 do
		_G["FHS_Seat_"..r.."_Button"]:Hide()
	end

	if (j>0) then
		_G["FHS_Seat_"..j.."_Button"]:Show()
	end
end


function FHS_UpdateButtons()

	if (LocalSeat==0) then
		return;
	end;

end;


function FHS_HandleAddonComms(msg, channel, sender)

	FHS_Debug_Feedback("FHS_HandleAddonComms");
	FHS_Debug_Feedback(sender..":"..msg)
	FHS_Debug_Feedback("RoundCount:"..RoundCount)

	-- split arg1 into separate tabs separated by _
	local tab = { strsplit( "_", msg) }
	
	-- only a valid message if we have atleast 3 tabs
	if (table.getn(tab)<3) then
		return
	end
	
	--check version
	if ( tab[1]~="FHS" or tab[2]~=FHS_COMMS_version ) then
		FHS_Debug_Feedback("Message format incorrect")
		return
	end
	
	-- tab 3 holds the nature of the message so we check this to find out what to do
	
	-- First check server only messages
	if ( IsDealer == 1 ) then
	-- server only messages
		if (tab[3]=="pong!") then
			FHS_Debug_Feedback("pong!")
			FHS_SeatPlayer(sender)
			
			
		-- Player telling server he folded
		elseif (tab[3]=="fold") then
			FHS_Debug_Feedback("fold")
			local j=tonumber(tab[4])
			if (IsPlaying(sender)==1 and Seats[j].dealt==1) then
				FHS_FoldPlayer(j)
			end

		-- Player telling server he actioned ( call, check, raise, all in)
		elseif (tab[3]=="call") then
			FHS_Debug_Feedback("call")
			local j=tonumber(tab[4])
			if (IsPlaying(sender)==1 and Seats[j].dealt==1) then
				FHS_PlayerAction(j,tonumber(tab[5]))	
			end

		-- Player telling server he wants to flash his cards
		elseif (tab[3]=="showcards" and GameLevel == 5) then
			FHS_Debug_Feedback("showcards")
			local j=tonumber(tab[4])
			FHS_Debug_Feedback("4:"..j.." 5:"..tab[5].." sender:"..sender.." RoundCount:"..RoundCount)
			if (IsPlaying(sender)==1 and tonumber(tab[5]) == RoundCount) then
			--Temporal bug... showcards were hitting on the next round
				FHS_ShowCard(j,"Showing")
			end
		end
	
	-- Then check client only messages
	elseif ( IsDealer == 0) then
	-- client only messages
		if (tab[3]=="ping!") then
			DealerName=sender
			FHS_SendMessage("pong!",sender)
			DealerName=""
			
		elseif (tab[3]=="NoSeats") then
		--Noseats	
			FHS_Console_Feedback(string.format(L['%s has no seat available for you'], sender))
			
		-- Only process if the message came from the dealer!
		elseif ( DealerName==sender ) then
		
			--Player Sits
			if (tab[3]=="s") then
				FHS_Client_Sit(tonumber(tab[4]), tab[5], tonumber(tab[6]), tonumber(tab[7]))
				
			--Player Status
			elseif (tab[3]=="st") then
				FHS_Client_Status_Update(tonumber(tab[4]), tab[5], tab[6], tab[7], tab[8])
				
			--Dealer Button
			elseif (tab[3]=="b") then
				--tab[4] contains the player with the button
				FHS_SelectPlayerButton(tonumber(tab[4]))
				
			-- Player is forced to sit out (timer)
			elseif (tab[3]=="forceout") then
				FHS_Console_Feedback(L['You did not act in time. Press I\'m Back to continue playing.'])
				FHS_SitOutInClick()

			--- Host has quit the game
			elseif (tab[3]=="hostquit") then
				FHS_Console_Feedback(DealerName.." "..L['has quit. GG.'])
				FHS_StopClient()
				
			-- Hole Cards
			elseif (tab[3]=="round0") then  --PRE FLOP
				FHS_Client_Round0( tonumber(tab[4]) )
			
			-- Your hole cards
			elseif (tab[3]=="hole") then
				FHS_Client_Hole( tonumber(tab[4]), tonumber(tab[5]) )
		
			--Other peoples hole cards
			elseif (tab[3]=="deal") then
				FHS_Client_Deal( tonumber(tab[4]))

			-- The Tables Flop (blanks)
			-- Note we record what blank cards we used, so we can clean them up when the flop is shown
			elseif (tab[3]=="flop0") then
				FHS_Client_Flop0()

			-- The Tables Flop (Real Cards)
			elseif (tab[3]=="flop1") then
				FHS_Client_Flop1(tonumber(tab[4]), tonumber(tab[5]), tonumber(tab[6]))
		
			-- Turn card
			elseif (tab[3]=="turn") then
				
				Flop[4]=tonumber(tab[4]);
				FHS_SetCard(Flop[4],DealerX,DealerY, CardWidth*1,30,1,0,0,0)
				FHS_StatusTextCards()

			-- River card
			elseif (tab[3]=="river") then
			
				Flop[5]=tonumber(tab[4]);
				FHS_SetCard(Flop[5],DealerX,DealerY, CardWidth*2,30,1,0,0,0)
				FHS_StatusTextCards()
				
			-- Show cards
			elseif (tab[3]=="show") then
				FHS_Client_Show(tonumber(tab[4]), tonumber(tab[5]), tonumber(tab[6]), tab[7])
				
			--Server saying whos turn it is
			elseif (tab[3]=="go") then
				local j=tonumber(tab[4])
				HighestBet=tonumber(tab[5])
				WhosTurn=j
				FHS_UpdateWhosTurn()
		
			elseif (tab[3]=="betsize") then
				Blinds=tonumber(tab[4])
				BetSize=Blinds
			
			end
		end
	end

	-- Finally check message for either server or client
	if (tab[3]=="!seat") then
		--player tried to seat themselves.. assume they want to be a dealer
		if (sender==UnitName("player")) then
			FHS_Console_Feedback(L['Use just /holdem instead'])
		elseif (IsDealer==1) then
			FHS_SendMessage("ping!",sender)
		end

	elseif (tab[3]=="seat") then
		--We've Been Seated.. Clear our stats and await further messages
		LocalSeat=tonumber(tab[4])
		DealerName=sender
		FHS_StartClient()

	--Player sits in or out
	elseif (tab[3]=="inout") then
		FHS_Receive_InOut( tonumber(tab[4]), tab[5], sender)

	-- Player has Quit the game
	elseif (tab[3]=="q") then
		FHS_Receive_Quit( sender, tonumber(tab[4]))
		
	--Normal Showdown.. 1 or more winners cards will be visible
	elseif (tab[3]=="showdown" and sender==DealerName) then
		FHS_Receive_Showdown( tonumber(tab[4]), tab[5])
	
	-- outside table broadcast
	elseif ( tab[3]=="broadcast") then
		FHS_HandleOutsideBroadcast(tab, sender, channel)

	-- outside table whsiper
	elseif ( tab[3]=="outside") then
		FHS_HandleOutsideWhisper(tab, sender)

	end
	
end


function FHS_Receive_InOut( j, inout, sender)

	Seats[j].inout=inout

	if (IsDealer==1) then
		-- dealer tells everyone else about the change
		FHS_BroadCastToTable("inout_"..j.."_"..inout,LocalSeat)

	elseif ( IsDealer==0 and sender==DealerName and inout=="OUT") then
		-- everyone who gets the message dims the player
		Seats[j].alpha=0.5
		Seats[j].status="Sitting Out"
		FHS_UpdateSeat(j)
	end
end


function FHS_Receive_Showdown( j, status)
	--local view
	FHS_HideAllButtons(false)

	----- Locally, we might have already folded and still want to flash our cards
	----- Logically, the FHS_Fold button will already be hidden if we've shown already
	FHS_Fold:SetText("Show Cards");
	Seats[LocalSeat].dealt=0;
	---

	FHS_StatusText(status);

	if (LocalSeat == j) then
		-- you won by default, you are allowed to flash your cards
		Seats[LocalSeat].dealt=0;
		
		FHS_Fold:SetText(L['Show Cards']);
		FHS_Fold:Show();
	end
end


function FHS_Receive_Quit( sender, j)
	--Update about a player

	if (IsDealer==0 and sender==DealerName) then
		Seats[j].seated=0;
		Seats[j].HavePort=0;
		if (IsPlaying(sender)==1) then								
			FHS_UpdateSeat(j);
			FHS_Console_Feedback(Seats[j].displayname.." "..L['has left the table.']);
		end;

		if (j==LocalSeat) then
			
			FHS_Console_Feedback(L['The dealer booted you.']);
			FHS_StopClient();
		end

	else
		if (IsPlaying(sender)==1) then								
										
			--Tell the other seats about the change
			FHS_BroadCastToTable("q_"..j,j);
			FHS_Console_Feedback(Seats[j].displayname.." "..L['has left the table.']);
			Seats[j].seated=0;
			Seats[j].HavePort=0;
			FHS_UpdateSeat(j);
			if (WhosTurn==j) then
				FHS_GoNextPlayersTurn();
			end
		end
	end
end


function FHS_Client_Sit(j, name, chips, bet)
	--Update about player
	Seats[j].seated=1
	Seats[j].name=name
	Seats[j].chips=chips
	Seats[j].bet=bet
	Seats[j].displayname=string.gsub(name, realmName, "");
	
	FHS_UpdateSeat(j)
	FHS_Console_Feedback(string.format(L['%s sits %s in Seat %d'],DealerName, Seats[j].displayname, j))
end


function FHS_Client_Status_Update(j, chips, bet, status, alpha)
	--Update about a player
	Seats[j].chips=tonumber(chips)
	Seats[j].bet=tonumber(bet)
	Seats[j].status=status
	Seats[j].alpha=alpha

	FHS_UpdateSeat(j)
	FHS_TotalPot()
end


function FHS_Client_Show(hole1, hole2, j, status)
	Seats[j].hole1=hole1
	Seats[j].hole2=hole2
	
	Seats[j].status=status
	
	Seats[j].dealt=0

	FHS_SetCard(hole1,DealerX,DealerY, Seats[j].x, Seats[j].y,1,1,0,1)
	FHS_SetCard(hole2,DealerX,DealerY, Seats[j].x-12, Seats[j].y+12,1,1,0,0)

	FHS_UpdateSeat(j)
end

				
function FHS_Client_Flop1(flop1, flop2, flop3)
				
	Flop={}
	Flop[1]=flop1
	Flop[2]=flop2
	Flop[3]=flop3
	
	for i=1,3 do
		FHS_SetCard(Flop[i],DealerX,DealerY, -CardWidth*(3-i),30,1,1,0,0)
		
		--Its possible to get here if they come in late
		if (getn(FlopBlank)>0) then
			FHS_SetCard(FlopBlank[i],0,0,0,0,0,0,0,0)
		end
	end

	FlopBlank={}
	FHS_StatusTextCards()
end


function FHS_Client_Flop0()
	
	for i=1,3 do
		FlopBlank[i]=BlankCard
		FHS_SetCard(BlankCard,DealerX,DealerY, -CardWidth*(3-i),30,1,CC*DealerDelay,0,0)
		BlankCard=BlankCard+1
		CC=CC-1
	end
	
end


function FHS_Client_Deal(j)

	FHS_SetCard(BlankCard,DealerX,DealerY, Seats[j].x-12 , Seats[j].y+12,1,CC*DealerDelay,500,0)
	BlankCard=BlankCard+1
	CC=CC-1
	
	FHS_SetCard(BlankCard,DealerX,DealerY, Seats[j].x , Seats[j].y,1,CC*DealerDelay,500,1)
	BlankCard=BlankCard+1
	CC=CC-1

	Seats[j].dealt=1
	Seats[j].status="Playing"
	Seats[j].alpha=1
	FHS_UpdateSeat(j)
end


function FHS_Client_Hole( hole1, hole2 )

	local ThisSeat = Seats[LocalSeat]
	ThisSeat.hole1=hole1
	ThisSeat.hole2=hole2
	
	FHS_SetCard(hole2,DealerX,DealerY, ThisSeat.x-12, ThisSeat.y+12,1,CC*DealerDelay,0,0)
	CC=CC-1

	FHS_SetCard(hole1,DealerX,DealerY, ThisSeat.x, ThisSeat.y,1,CC*DealerDelay,0,1)
	CC=CC-1

	ThisSeat.status="Playing"
	ThisSeat.dealt=1
	ThisSeat.alpha=1
	FHS_UpdateSeat(LocalSeat)
	
	--Fold Button
	FHS_Fold:SetText("Fold")
	FHS_Fold:Show()

	FHS_StatusTextCards()
end


function FHS_Client_Round0(thisRoundCount)
	FHS_HideAllButtons(true)
	FHS_ClearCards()
	
	RoundCount = thisRoundCount

	--Clear status text
	for j=1,9 do
		Seats[j].bet=0
		if(Seats[j].inout=="OUT") then
			Seats[j].status="Sitting Out"
			Seats[j].alpha=0.5
		else
			Seats[j].status=""
			Seats[j].alpha=0
		end;
		FHS_UpdateSeat(j)
	end;

	BetSize=Blinds
	FHS_TotalPot()
	FHS_StatusText("")
end


function FHS_HandleOutsideBroadcast(tab, sender, channel)

	FHS_Debug_Feedback("Broadcast received");
	-- Ignore own broadcasts
	if (sender == GetUnitName("player")) then
		FHS_Debug_Feedback("Own broadcast: "..tab[4]);
		return
	end
	
	-- Ignore messages from guild members while in a raid or party with them (duplicates)
	if ( channel == "GUILD" and ( UnitInParty(sender) or UnitInRaid(sender))) then
		return
	end

	if ( tab[4] == "whodealer" and IsDealer == 1) then
		FHS_SendMessage("outside_dealer_"..(9-FHS_GetSeatedPlayers()),sender)
	
	elseif( tab[4] == "whoclient") then
		FHS_SendMessage("outside_client_"..FHS_HOLDEM_version,sender)
	end
end


function FHS_HandleOutsideWhisper(tab, sender)

	if ( tab[4] == "dealer" ) then
		FHS_Console_Feedback(string.format(L['%s is a dealer and has %s seats available'], sender, tab[5]))
	
	elseif ( tab[4] == "client" ) then
		FHS_Console_Feedback(string.format(L['%s has client version %s'], sender, tab[5]))
	end
end


function IsPlaying(name)

	for j=1,9 do
		if (Seats[j].seated==1 and Seats[j].name==name) then
			return 1
		end
	end
	return 0
end


function FHS_SendMessage(msg,username)
	FHS_Debug_Feedback("addon whisper "..msg.." to "..username);
	C_ChatInfo.SendAddonMessage("VodkaHoldem", "FHS_".. FHS_COMMS_version.."_"..msg, "WHISPER", username);
end;


function FHS_BroadcastMessage(msg, channel)
--"PARTY", "RAID", "GUILD", "BATTLEGROUND".
	FHS_Debug_Feedback("broadcast "..msg.." on "..channel);
	C_ChatInfo.SendAddonMessage("VodkaHoldem", "FHS_".. FHS_COMMS_version.."_broadcast_"..msg, channel);
end;


function FHS_BroadCastToTable(message,skip)
	if (IsDealer==0) then
		return;
	end

	for j=1,9 do
		if ((j==LocalSeat) or(j==skip) or (Seats[j].seated==0))  then 
			--no good
		else
			FHS_SendMessage(message,Seats[j].name);
		end
	end
end


function FHS_Console_Feedback(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end


function FHS_Debug_Feedback(msg)
	if ( FHS_DEBUGING) then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end


function FHS_PlayClick()

--	FHSPokerFrame:SetScale(0.75);
	if (IsDealer==0) then
		return
	end

	if (GameLevel==5) then
		GameLevel=0
	end
	if (GameLevel==0) then
		FHS_NextLevel()
	end
end;


function FHS_NextLevel()
	
	GameLevel=GameLevel+1
	
	if (GameLevel==1) then  --Pre Flop
		FHS_DealHoleCards()
		
	elseif (GameLevel==2) then
		FHS_ShowFlopCards()
		
	elseif (GameLevel==3) then
		FHS_DealTurn()
		
	elseif (GameLevel==4) then
		FHS_DealRiver()
		
	elseif (GameLevel==5) then
		FHS_ShowDown()
		
	end
end


-------------   SERVER NETWORKING ---------------------------------
function FHS_StartDealer()
	
	FHS_Console_Feedback(L['You are now a dealer.'])
	LocalSeat=1
	IsDealer=1
	TheButton=LocalSeat
	DealerName=""

	FHS_ClearTable()
	
	Seats[LocalSeat].name=UnitName("player")
	Seats[LocalSeat].seated=1
	Seats[LocalSeat].chips=StartChips
	Seats[LocalSeat].displayname=UnitName("player")
	FHS_UpdateSeat(LocalSeat)
	GameLevel=0
	
	FHS_ShowTable()
	
	FHS_Play:Show()
	FHS_DealerButtons:Show()
	
	--Set the initial Blinds
	FHS_Set_CurrentBlind(BigBlindStart / (1+BlindIncrease))
	-- Dividing by BlindIncrease here saves worrying about checking on new round if it is the first round.
end


function FHS_StopServer()

	--bump everyone off
	FHS_BroadCastToTable("hostquit",-1)

	IsDealer=0
	LocalSeat=0
	WhosTurn=0
	
	FHS_ClearTable()
	FHS_DealerButtons:Hide()
end


function FHS_FoldPlayer(j)

	if (IsDealer==0 or Seats[j].seated==0 or Seats[j].dealt==0) then
		return
	end

	FHS_BroadCastToTable("st_"..j.."_"..Seats[j].chips.."_"..Seats[j].bet.."_Folded_0.5",0)
	
	Seats[j].dealt=0
	Seats[j].forcedbet=0 --player has had their bet
	Seats[j].alpha=0.5
	Seats[j].status="Folded"
	
	--Snowfan edit - this will hide hole cards when we fold
	--- Local Graphics
	FHS_SetCard(Seats[j].hole1,Seats[j].x, Seats[j].y,DealerX,DealerY, 0,1,0,1);
	FHS_SetCard(Seats[j].hole2,Seats[j].x, Seats[j].y,DealerX,DealerY+12,0,1,0,0);
	
	FHS_UpdateSeat(j)

	--if it was their turn when they folded, next turn.
	if (WhosTurn==j) then
		FHS_GoNextPlayersTurn()
	else
		--It Wasn't their turn.. but them folding may have ended the game anyway
		if (FHS_GetPlayingPlayers()==1) then
			--Notify the player their turn go canceled
			
			FHS_GoNextPlayersTurn()
		end
	end
end


function FHS_TotalPot()

	local total=0
	
	for j=1,9 do
		if (Seats[j].seated==1) then
			total=total+Seats[j].bet
		end
	end
	
	if (total==0) then
		FHS_Pot_Text:SetText(L['WoW Texas Hold\'em'])
	else
		FHS_Pot_Text:SetText(L['Total Pot']..": "..total)
	end

	return total
end


--Loop through all seats, add up everyone who has bet less then this
function FHS_SidePot(bet)

	local total=0
	local r
	
	for j=1,9 do
		if (Seats[j].seated==1) then
		
			r=Seats[j].bet
			if ( r > bet ) then
				r=bet
			end
			total=total+r
		end
	end

	return total
end


function FHS_DealHoleCards()
	
	if (IsDealer==0) then
		return
	end
	
	--Initialize the shuffle array
	for j=1, 52 do
		Shuffle[j]=j
	end

	seed=GetTime()*1000
	seed=FHS_round(seed,0)
	
	FHS_Shuffle(seed, false) -- set truth value to fake shuffle

	-- Set the dealers card to 1
	DealerCard=1
	BlankCard=53

	-- Increament Blinds
	FHS_Set_CurrentBlind(FHS_IncrementBlind(Blinds))
	FHS_BroadCastToTable("betsize_"..Blinds)
	
	BetSize=Blinds
	-- Transmit betsize to other players
	SidePot={}
	
	-- Clear the dealers visuals
	FHS_ClearCards()

	--Tell everyone Round 0 is beginning
	RoundCount=RoundCount+1
	FHS_BroadCastToTable("round0_"..RoundCount,-1)

	FHS_StatusText("")

	--Deal out the hole cards
	for index=1,9 do
		
		local j=TheButton+index+1  -- Player after the button gets dealt first
		if (j>9) then j=j-9; end
		if (j>9) then j=j-9; end
		
		local ThisSeat = Seats[j]
		
		--Set up a blank hand
		ThisSeat.bet=0
		ThisSeat.hole1=0
		ThisSeat.hole2=0
		ThisSeat.forcedbet=0
		if(ThisSeat.inout=="IN") then
			ThisSeat.status=""
		else
			ThisSeat.status="Sitting Out"
		end;

		--Deal them in
		if ( ThisSeat.seated==1 and ThisSeat.chips>0 and ThisSeat.inout=="IN" ) then
		
			--If dealing to a player..
			ThisSeat.hole1=Shuffle[DealerCard]
			DealerCard=DealerCard+1
			ThisSeat.hole2=Shuffle[DealerCard]
			DealerCard=DealerCard+1
			ThisSeat.dealt=1
			ThisSeat.bet=0
			ThisSeat.alpha=0.5
			ThisSeat.forcedbet=1
			ThisSeat.status="Playing"

			FHS_UpdateSeat(j) -- local view
			
			if (j==LocalSeat) then
				-- Local Graphics ------------------------------------------
				FHS_SetCard(ThisSeat.hole2,DealerX,DealerY, ThisSeat.x-12, ThisSeat.y+12,1,CC*DealerDelay,0,0)
				CC=CC-1
				
				FHS_SetCard(ThisSeat.hole1,DealerX,DealerY, ThisSeat.x, ThisSeat.y,1,CC*DealerDelay,0,1)
				CC=CC-1

				--enable the fold button
				ThisSeat.alpha=1
				FHS_Fold:SetText(L['Fold'])
				FHS_Fold:Show()
				FHS_StatusTextCards()
				------------------------------------------------------------

				FHS_BroadCastToTable("deal_"..j,j)

			else

				-- Local Graphics ------------------------------------------
				FHS_SetCard(BlankCard,DealerX,DealerY, Seats[j].x-12 , Seats[j].y+12,1,CC*DealerDelay,500,0)
				BlankCard=BlankCard+1
				CC=CC-1

				FHS_SetCard(BlankCard,DealerX,DealerY, Seats[j].x , Seats[j].y,1,CC*DealerDelay,500,1)
				BlankCard=BlankCard+1
				CC=CC-1
				
				Seats[j].alpha=1
				------------------------------------------------------------
				
				FHS_SendMessage("hole_"..Seats[j].hole1 .."_"..Seats[j].hole2,Seats[j].name)
				FHS_BroadCastToTable("deal_"..j,j)
			end
				
		else
			if ( ThisSeat.chips < 1 ) then
				--they're sitting out due to lack of chips
				ThisSeat.hole1=0
				ThisSeat.hole2=0
				ThisSeat.dealt=0
				ThisSeat.bet=0
				ThisSeat.forcedbet=0
				ThisSeat.status="Sitting Out"
				FHS_UpdateSeat(j) -- local view
			end
			if ( ThisSeat.inout=="OUT" ) then
				--they're sitting out because they want to 
				ThisSeat.hole1=0
				ThisSeat.hole2=0
				ThisSeat.dealt=0
				ThisSeat.bet=0
				ThisSeat.forcedbet=0
				ThisSeat.alpha=0.5
				ThisSeat.status="Sitting Out"
				FHS_UpdateSeat(j) -- local view
			end
		end
	end
	
	--Deal out the flop
	DealerFlop={}
	for i= 1,5 do
		DealerFlop[i]=Shuffle[DealerCard]
		DealerCard=DealerCard+1
	end
	
	FHS_BroadCastToTable("flop0",-1)
	Flop={}
		
	-- Local Graphics ------------------------------------------
	for i=1,3 do
		FlopBlank[i]=BlankCard	
		FHS_SetCard(BlankCard,DealerX,DealerY, -CardWidth*(3-i),30,1,CC*DealerDelay,0,0)
		BlankCard=BlankCard+1
		CC=CC-1
	end
	
	------------------------------------------------------------
	-- set the button
	TheButton=FHS_WhosButtonAfter(TheButton)
	
	FHS_BroadCastToTable("b_"..TheButton,-1)
	FHS_SelectPlayerButton(TheButton)
	
	FHS_SetupBets()
	FHS_PostBlinds()

end


--let everyone playing have at least 1 turn
function FHS_SetupBets()
	for j=1,9 do
		if ((Seats[j].seated==1) and (Seats[j].dealt==1) and (Seats[j].inout=="IN")) then
			Seats[j].forcedbet=1
		end
	end
end


function FHS_ShowFlopCards()
	if (IsDealer==0) then
		return
	end

	Flop={}

	
	for i=1,3 do
		Flop[i]=DealerFlop[i]
		FHS_SetCard(FlopBlank[i],0,0,0,0,0,0,0,0)
		FHS_SetCard(Flop[i],DealerX,DealerY, -CardWidth*(3-i),30,1,1,0,0)
	end

	FHS_BroadCastToTable("flop1_"..Flop[1].."_"..Flop[2].."_"..Flop[3],-1)

	FHS_StatusTextCards()

	FHS_SetupBets()
	WhosTurn=TheButton
	FHS_GoNextPlayersTurn()
end


function FHS_DealTurn()
	if (IsDealer==0) then
		return;
	end;

	Flop[4]=DealerFlop[4];

	FHS_BroadCastToTable("turn_"..Flop[4],-1);

	--Local View --------------
	FHS_SetCard(Flop[4],DealerX,DealerY, CardWidth*1,30,1,0,0,0);
	CC=CC-1;
	FHS_StatusTextCards();							
	---------------------------

	FHS_SetupBets();
	WhosTurn=TheButton;
	FHS_GoNextPlayersTurn();
end


function FHS_DealRiver()

	if (IsDealer==0) then
		return;
	end;

	Flop[5]=DealerFlop[5];

	FHS_BroadCastToTable("river_"..Flop[5],-1);

	--Local View --------------
	FHS_SetCard(Flop[5],DealerX,DealerY, CardWidth*2,30,1,0,0,0);
	CC=CC-1;
	FHS_StatusTextCards();							
	---------------------------

	FHS_SetupBets();
	WhosTurn=TheButton;
	FHS_GoNextPlayersTurn();
	


end


function FHS_ShowDown()

	-- Only Dealer runs this function
	if (IsDealer==0) then
		return
	end
	
	--Start Timer til next hand
	DealerTimer=GetTime()+DealerTimerDelay

	--local view
	FHS_HideAllButtons()

	--Determine everyones hand
	pot=FHS_TotalPot()
	Winners={};

	--Ok, well, we work out our sidepots
	--Correct our sidepots with the last info
	if (getn(SidePot)==0) then
		SidePot[1]={bet=FHS_HighestBet(),pot=FHS_TotalPot()}
	end

	local found=0
	
	for j=1,getn(SidePot) do
		if (SidePot[j].bet==FHS_HighestBet()) then
			found=1
		end
	end
	
	if (found==0) then
		SidePot[getn(SidePot)+1]={bet=FHS_HighestBet(),pot=FHS_TotalPot()}
	end
	
    sort(SidePot, function (a,b) return (a.pot < b.pot)  end)

	--fix the pots
	local temp={}
	temp[1]=SidePot[1].pot
	
	for j=2,getn(SidePot) do
		temp[j]=SidePot[j].pot - SidePot[j-1].pot
	end
	for j=1,getn(SidePot) do
		SidePot[j].pot = temp[j]
	end    

	if (FHS_GetPlayingPlayers()==1) then
		--Hand fizzled, everyone but one person folded..
		--so we don't tell anyone what he had and do the winner stuff that way.
		
		for j=1,9 do
			--give the winner the chips
			if ((Seats[j].seated==1)and(Seats[j].dealt==1)) then
				Winners[1]=j
			end
		end
			
		--------------------------------------------------------------
		for r=1,getn(SidePot) do
			
			winnercount=0
			for j=1,getn(Winners) do
				if (Seats[Winners[j]].bet>=SidePot[r].bet) then
					winnercount=winnercount+1
				end;
			end;
								
			if (winnercount>0) then
				pot=FHS_round((SidePot[r].pot) / winnercount,0)
				
			for j=1,getn(Winners) do
					if (Seats[Winners[j]].bet>=SidePot[r].bet) then
						Seats[Winners[j]].chips=Seats[Winners[j]].chips+pot
						Seats[Winners[j]].dealt=0
					end
				end						
			else
				-- There were no winners of this pot, split it and give it back
				winnercount=0
				for j=1,9 do
					if ((Seats[j].bet>=SidePot[r].bet)and(Seats[j].seated==1)) then
						winnercount=winnercount+1
					end
				end

				for j=1,9 do
					
					pot=FHS_round((SidePot[r].pot) / winnercount,0)
					--Player bet into that 
					if ((Seats[j].seated==1)and(Seats[j].bet>=SidePot[r].bet)) then
						
						Seats[j].chips=Seats[j].chips+pot
						FHS_BroadCastToTable("st_"..j.."_"..Seats[j].chips.."_"..Seats[j].bet.."_"..Seats[j].status.."_0.5")
					
						FHS_ShowCard(j,pot.." returned")
						Seats[j].dealt=0

						--Local View
						FHS_UpdateSeat(j)
					end
				end
			end
			
		end
		--------------------------------------------------------------

		local j=Winners[1]
		local ThisSeat=Seats[j]
		ThisSeat.status="Default"
		FHS_BroadCastToTable("st_"..j.."_"..ThisSeat.chips.."_"..ThisSeat.bet.."_"..ThisSeat.status.."_1")
		text = ThisSeat.displayname.." "..L['wins'].."."
		FHS_BroadCastToTable("showdown_"..j.."_"..text)

		if (j==LocalSeat) then  --dealer won
			ThisSeat.dealt=0
			ThisSeat.alpha=1
			
			FHS_Fold:SetText(L['Show Cards'])
			FHS_Fold:Show()
		end;

		FHS_StatusText(text)
		
	else
		-- Otherwise more than one player left in hand
		for j=1,9 do
			local ThisSeat=Seats[j]
			ThisSeat.OutText=""
			ThisSeat.HandRank=""

			if (ThisSeat.seated==0) then
				ThisSeat.dealt=0
			end;

			if ((ThisSeat.dealt==1)and(ThisSeat.seated==1)) then
				ThisSeat.HandRank=FHS_FindHandForPlayer(j)
				ThisSeat.OutText=FHS_handDescription(ThisSeat.HandRank)
			end
		end

		--Work out the "winners"

		-- Best hand is?
		local Best="0"
		local index=0
		
		for j=1,9 do
			if (Seats[j].dealt==1) then
				if (Seats[j].HandRank>Best) then 
					Best=Seats[j].HandRank
					index=j
				end
			end
		end

		--Winners, index who is a contender.  Look at their hand again and determine the winner.

		for j=1,9 do
			if (Seats[j].dealt==1) then
				if (Seats[j].HandRank==Best) then
					Winners[getn(Winners)+1]=j
				end
			end
		end

		if (getn(Winners)>0) then
			--DEFAULT_CHAT_FRAME:AddMessage("newcode");
			--Go through the side pots.
				-- Find out who won a piece of it.
					-- Hand it out

			--Go to next side pot.. subtract the what? exactly?

			if (getn(Winners)==1) then
				text=Seats[ Winners[1] ].displayname.." "..L['wins']..". "..Seats[Winners[1]].OutText
			else
				text=L['Split']..". "..Seats[Winners[1]].OutText
			end

			for r=1,getn(SidePot) do
				
				winnercount=0
				
				for j=1,getn(Winners) do
					if (Seats[Winners[j]].bet>=SidePot[r].bet) then
						winnercount=winnercount+1
					end
				end
								
				if (winnercount>0) then
					pot=FHS_round((SidePot[r].pot) / winnercount,0)

					for j=1,getn(Winners) do
						local ThisSeat = Seats[Winners[j]]
						
						if (ThisSeat.bet>=SidePot[r].bet) then

							ThisSeat.chips=ThisSeat.chips+pot
							FHS_BroadCastToTable("st_"..Winners[j].."_"..ThisSeat.chips.."_"..ThisSeat.bet.."_"..ThisSeat.status.."_1")
							FHS_ShowCard(Winners[j],"Winner!")
							ThisSeat.dealt=0

							--Local View
							FHS_UpdateSeat(Winners[j])
						end
					end						
					
				else
					-- There were no winners of this pot, split it and give it back
					--DEFAULT_CHAT_FRAME:AddMessage("No winners of: "..SidePot[r].pot);
				
					winnercount=0
					for j=1,9 do
						if ((Seats[j].bet>=SidePot[r].bet)and(Seats[j].seated==1)) then
							winnercount=winnercount+1
						end
					end

		
					--DEFAULT_CHAT_FRAME:AddMessage("people who bet that much:"..winnercount);
					
					for j=1,9 do
						local ThisSeat = Seats[j]
						
						pot=FHS_round((SidePot[r].pot) / winnercount,0)
						--Player bet into that 
						if ((ThisSeat.seated==1)and(ThisSeat.bet>=SidePot[r].bet)) then
							
							ThisSeat.chips=ThisSeat.chips+pot
							--DEFAULT_CHAT_FRAME:AddMessage(j..":"..pot)
							FHS_BroadCastToTable("st_"..j.."_"..ThisSeat.chips.."_"..ThisSeat.bet.."_"..ThisSeat.status.."_0.5")
						
							FHS_ShowCard(j,pot.." returned")
							ThisSeat.dealt=0

							--Local View
							FHS_UpdateSeat(j)
						end
					end

				end
			end

		else
			text=L['No Winners. Game Seed = ']..RandomSeed

			--Return their cash
			for j=1,9 do
				if ((Seats[j].seated==1)and(Seats[j].bet>0)) then
					Seats[j].chips=Seats[j].chips+Seats[j].bet
					FHS_UpdateSeat(j)
					Seats[j].status=""
					FHS_BroadCastToTable("st_"..j.."_"..Seats[j].chips.."_"..Seats[j].bet.."_"..Seats[j].status.."_1")
				end
			end
		end

		FHS_BroadCastToTable("showdown_0_"..text)
		FHS_StatusText(text)
		
		for j=1,9 do
			-- If you're still in at this point, you have to show your hand
			if (Seats[j].dealt==1) then
				FHS_ShowCard(j,"Showdown")
			end
		end

		--We may still want to flash our cards, even if we've folded
		FHS_Fold:SetText("Show Cards")
		FHS_Fold:Show()
		Seats[LocalSeat].dealt=0;
		-------------------------------------------------
	end

end


function FHS_round( num, idp )
	return tonumber( string.format("%."..idp.."f", num ) )
end


function FHS_ShowCard(j,status)

	if ((Seats[j].seated==1)) then
		
		Seats[j].status=status;
		
		if ((Seats[j].hole1==0)or(Seats[j].hole2==0)) then 
		
			FHS_Console_Feedback(L['Error case']);
			return; 
		end;
		
		
		if (IsDealer==1) then
			FHS_BroadCastToTable("show_"..Seats[j].hole1 .."_"..Seats[j].hole2.."_"..j.."_"..status,j);
		end;

		--- Local Graphics
		--Snowfan edit
		FHS_SetCard(Seats[j].hole2,DealerX,DealerY, Seats[j].x-12, Seats[j].y+12,0,1,0,0);
		FHS_SetCard(Seats[j].hole1,DealerX,DealerY, Seats[j].x, Seats[j].y,0,1,0,1);
		
		FHS_SetCard(Seats[j].hole2,DealerX,DealerY, Seats[j].x-12, Seats[j].y+12,1,1,0,0);
		FHS_SetCard(Seats[j].hole1,DealerX,DealerY, Seats[j].x, Seats[j].y,1,1,0,1);

		FHS_UpdateSeat(j);
	end
end



function FHS_Shuffle(seed, fake)

	RandomSeed=seed
	--randomseed(seed);

	--Initialize the shuffle array
	for j=1, 52 do
		Shuffle[j]=j
	end;

	--Shuffle each card once
	for j=1, 52 do
		newspot=random(52)

		temp=Shuffle[j]
		Shuffle[j]=Shuffle[newspot]
		Shuffle[newspot]=temp
	end;

	--debug shuffle
	if (0==1) then
		for j=1, 52 do
			FHS_Console_Feedback(Shuffle[j])
		end
	end
	
	if ( fake ) then
		RandomSeed=1
		local Clubs=0
		local Diamonds=13
		local Hearts=13+13
		local Spades=13+13+13
		
		Shuffle[1]=1+Diamonds  --p1
		Shuffle[2]=2+Diamonds 
		Shuffle[3]=9+Hearts -- p2/flop
		Shuffle[4]=8+Hearts
		Shuffle[5]=3+Clubs -- p3/flop
		Shuffle[6]=4+Spades
		Shuffle[7]=5+Diamonds
		Shuffle[8]=9+Spades
		Shuffle[9]=11+Clubs
	
	end
end


function FHS_SeatPlayer(name)
	
	found=-1;
	foldplayer=0;
	
	--Try and find the player
	for j=1,9 do
		if (Seats[j].seated==1) and (Seats[j].name==name) then
			found=-2; --player is already seated
			break;
		end
		if (Seats[j].seated==0) then
			found=j;
		end
	end

	if (found==-1) then
		FHS_SendMessage("NoSeats",name);
		return;
	elseif (found==-2) then
	
		for j=1,9 do
			if (Seats[j].seated==1) and (Seats[j].name==name) then
				found=j; --player is already seated
				break;
			end
		end
	
		if (Seats[found].dealt==1) then 	
			foldplayer=found;
		end;
	else
		Seats[found].seated=1;
		Seats[found].name=name;
		Seats[found].dealt=0;
		Seats[found].chips=StartChips; --Sit with 500 chips  - eventually will be a dealer option - Is now :D
		Seats[found].displayname=string.gsub(name, realmName, "");
	end;
	
	FHS_UpdateSeat(found);

	--seat them
	FHS_SendMessage("seat_"..found,name);

	--Tell them about Everyone
	for j=1,9 do
		if (Seats[j].seated==1) then
			FHS_SendMessage("s_"..j.."_"..Seats[j].name.."_"..Seats[j].chips.."_"..Seats[j].bet,name)
		end
	end

	--Tell the other seats about the change
	FHS_BroadCastToTable("s_"..found.."_"..Seats[found].name.."_"..Seats[found].chips.."_"..Seats[found].bet,found);


	if (foldplayer>0) then 
		FHS_FoldPlayer(foldplayer);
	end;

	--  Todo: if we're not on GameLevel==1, we have other things to tell them about
	--		  like blank/flop cards, showdowns, etc
end;


--Returns the next player to take a turn after j.
--It will return j if theres nobody 
function FHS_WhosTurnAfter(j)
	
	local index
	for r=1,9 do
		index=j+r;
		if (index>9) then index=index-9; end;
		if (index>9) then index=index-9; end;

		if ((Seats[index].seated==1)and(Seats[index].dealt==1)and(Seats[index].chips>0)and(Seats[index].inout=="IN")) then
			return index;
		end;
	end;

	return j;		
end;


--Returns the next player to take the button
--It will return j if theres nobody 
function FHS_WhosButtonAfter(j)
	
	local index
	for r=1,9 do
		index=j+r;
		if (index>9) then index=index-9; end;
		if (index>9) then index=index-9; end;

		if ((Seats[index].seated==1)and(Seats[index].chips>0)and(Seats[index].inout=="IN")) then
			return index;
		end;
	end;

	return j;		
end;


--Returns the next player who needs to bet after j. 
-- You need to bet if you were forced to post blinds, or if you are below the current highest
--It will return 0 if theres nobody 
function FHS_WhosBetAfter(j)
	
	local maxbet=FHS_HighestBet();
	
	for r=1,9 do
		index=j+r;
		if (index>9) then index=index-9; end;
		if (index>9) then index=index-9; end;

		if ((Seats[index].seated==1)and(Seats[index].dealt==1)and(Seats[index].chips>0)) then
		
			if ((Seats[index].bet<maxbet) or (Seats[index].forcedbet==1)) then
				return index;
			end;
		end;
	end;

	return 0;		
end;


function FHS_HighestBet()

	local maxbet=0;
	--Find out what the highest bet on the table 
	for r=1,9 do
		if ((Seats[r].seated==1)and(Seats[r].dealt==1)) then
			if (Seats[r].bet>maxbet) then
				maxbet=Seats[r].bet;
			end;
		end
	end;
	return maxbet;
end;


function FHS_GetPlayingPlayers()
	
	local j=0;
	for r=1,9 do
		if ((Seats[r].seated==1)and(Seats[r].dealt==1)) then
			j=j+1;
		end;
	end;

	return j;		
end;


function FHS_GetSeatedPlayers()
	
	local j=0;
	for r=1,9 do
		if ((Seats[r].seated==1)) then
			j=j+1;
		end;
	end;

	return j;		
end;


function FHS_IncrementBlind(Blind)

	-- Increase blind by BlindIncrease % to the nearest 5 chips (round up at 2.5).
	local newBlind = Blind * (1 + BlindIncrease)
	
	if ( newBlind % 5 >= 2.5 ) then
		newBlind = math.ceil(newBlind/5)*5
	else
		newBlind = math.floor(newBlind/5)*5
	end
	
	return newBlind;

end;


function FHS_PostBlinds()
	
	if (IsDealer==0) then 
		return; 
	end;
	
	local pc=FHS_GetPlayingPlayers();
	
	NextPlayer=TheButton;
	
	local SmallBlind = math.floor(Blinds/10)*5

	if (pc==1) then --If theres just one player, post a blind
		FHS_PlayerBet(TheButton,Blinds,"Blinds");
		
		NextPlayer=TheButton; --This person goes first
		
	elseif (pc==2) then

		j=FHS_WhosTurnAfter(TheButton);
		FHS_PlayerBet(j,Blinds,"Blinds");

		NextPlayer=TheButton; --person after this goes first
		
		FHS_PlayerBet(TheButton, SmallBlind, "Blinds");
		NextPlayer=FHS_WhosTurnAfter(TheButton);
		
	elseif (pc>1) then -- We have 3 players or more, so big and little blinds

		j=FHS_WhosTurnAfter(TheButton);
		
		FHS_PlayerBet(j, SmallBlind, "Small Blind");

		j=FHS_WhosTurnAfter(j);
		FHS_PlayerBet(j,Blinds,"Big Blind" );

		NextPlayer=j; --person after this goes first
	end;

	WhosTurn=NextPlayer;
	FHS_GoNextPlayersTurn();
end;


function FHS_PlayerBet(j,size,status)

	if (IsDealer==0) then 
		return; 
	end;
	
	FHS_Debug_Feedback("FHS_PlayerBet: j:"..j.." size:"..size.." status:"..status)

	--Todo: validity Checks... Gendi says perhaps we should check they have the chips to play with ;)
	-- In theory this should never be reached....
	--if ( Seats[j].chips < size ) then
		-- Player doesn't have the money to play, if during the deal they need to fold and be sat out
		-- FHS_FoldPlayer(j);
		-- Seats[j].chips = 0;
		-- FHS_SendMessage("forceoutmoney_"..j,Seats[j].name);
		-- FHS_UpdateSeat(j);
		-- return;
	-- end
	
	if ( Seats[j].chips < size ) then
	    -- reduce bet to remaining chips
		size = Seats[j].chips
		status = "All In"
	end
	
	Seats[j].chips=Seats[j].chips-size;
	Seats[j].bet=Seats[j].bet+size;
	Seats[j].status=status..": "..Seats[j].bet;	

	
	FHS_BroadCastToTable("st_"..j.."_"..Seats[j].chips.."_"..Seats[j].bet.."_"..Seats[j].status.."_1");

	--local view
	FHS_UpdateSeat(j);
	FHS_TotalPot();
	
	--Pots
	if (Seats[j].chips==0) then
		--Mark the curent pot as a side pot.
		found=0;
		bets=FHS_SidePot(Seats[j].bet);
		for r=1,getn(SidePot) do
			if (SidePot[r].bet==Seats[j].bet) then found=1; end;
		end;
		if (found==0) then 
			SidePot[getn(SidePot)+1]={bet=Seats[j].bet,pot=bets}; 
		end;
	end;

	--Check the existing sidepots, if our bet is < a sidepot, that sidepot needs to be rebuilt
	for j=1,getn(SidePot) do
	--if (Seats[j].bet<=SidePot[j].bet) then
			SidePot[j].pot=FHS_SidePot(SidePot[j].bet);
	--	end;
	end;

end;


function FHS_GoNextPlayersTurn()

	if (IsDealer==0) then 
		return; 
	end;
	
	WhosTurn=FHS_WhosBetAfter(WhosTurn);


	if (WhosTurn==0) then 
		FHS_NextLevel(); --All betting is satisfied
		return;
	end;

	--Check the number of dealt players left.
	--If theres only one player, clearly he's the winner
	--so end the round
	if (FHS_GetPlayingPlayers()==1) then
		
		if (FHS_GetSeatedPlayers()>1) then  -- If its only the dealer, let him keep playing
		
			FHS_NextLevel();
		
			return;
		end;
	end;

	HighestBet=FHS_HighestBet();
	FHS_BroadCastToTable("go_"..WhosTurn.."_"..HighestBet);

	FHS_UpdateWhosTurn(); --buttons and whatnot

	
	--Start Timer for whos turn it is
	PlayerTurnEndTime=GetTime()+AFKTimeLimit;
end


function FHS_PlayerAction(j,delta)

	if (IsDealer==0) then 
		return; 
	end;

	--Todo: make sure its actually their turn
	-- This could occur only when the last player folds right as they make their move
	HighestBet=FHS_HighestBet();
	
	-- if this is the forced blind bet...
	if ( Seats[j].forcedbet == 1) then
		if ( delta > Seats[j].chips ) then
			-- Change forced bet to all in bet
			delta = Seats[j].chips
			
			
			--Mark the curent pot as a side pot.
			local found=0
			local bets=FHS_SidePot(delta)
			for r=1,getn(SidePot) do
				if (SidePot[r].bet==delta) then found=1; end
			end
			if (found==0) then 
				SidePot[getn(SidePot)+1]={bet=delta,pot=bets}
			end

			--Check the existing sidepots, if our bet is < a sidepot, that sidepot needs to be rebuilt
			for j=1,getn(SidePot) do
				SidePot[j].pot=FHS_SidePot(SidePot[j].bet)
			end
			
		end
	end
	
	-- Update the players bet, move the turn
	if (delta==0) then
		if (Seats[j].bet==HighestBet) then
			FHS_PlayerBet(j,0,"Checked");
		else
			--Shouldnt ever occur, the player sent a "check" 
			-- when they were not equal to the highest bet
			FHS_Console_Feedback(L['Player Invalid Action'].." "..j..":"..delta);
		end;
	end

	if (delta>0) then
		if (Seats[j].bet+delta==HighestBet) then
			FHS_PlayerBet(j,delta,"Called");
			
		else
			if (Seats[j].bet+delta>=Seats[j].chips) then
				delta=Seats[j].chips;
				FHS_PlayerBet(j,delta,"All In");

			else
				FHS_PlayerBet(j,delta,"Raised");
			end;
		end;
	end;
	
	--Player has had their forced bet.
	Seats[j].forcedbet=0;

	--Next turn
	FHS_GoNextPlayersTurn();
end;


function FHS_PopupMenu(name)
	
	if (IsDealer==0) then 
		return; 
	end;

	FHS_Popup:SetPoint("CENTER", name, "CENTER", 20, -70);
	FHS_Popup:Show();

	FHS_PopupName=name;
	for j=1,9 do
		if (Seats[j].object==FHS_PopupName) then
			FHS_PopupIndex=j;
			return;
		end;
	end;
end


function FHS_Popup_GiveChipsClick()

	local j=FHS_PopupIndex;

	Seats[j].chips=Seats[j].chips+100;
	FHS_BroadCastToTable("st_"..j.."_"..Seats[j].chips.."_"..Seats[j].bet.."_"..Seats[j].status.."_1",0);
	FHS_UpdateSeat(j);
end


function FHS_Popup_BootPlayerClick()

	local j=FHS_PopupIndex;

	if (j==LocalSeat) then
		FHS_Console_Feedback(L['Cannot boot the dealer.']);	
	else
		--Tell the other seats about the change
		FHS_BroadCastToTable("q_"..j,0);
		FHS_Console_Feedback(Seats[j].displayname.." "..L['has left the table.']);
		Seats[j].seated=0;
		Seats[j].HavePort=0;
		FHS_UpdateSeat(j);

		FHS_Popup:Hide();

		if (WhosTurn==j) then
			FHS_GoNextPlayersTurn();
		end;

	end;

end;


function FHS_Popup_ClearChipsClick()
	local j=FHS_PopupIndex;

	Seats[j].chips=0;
	FHS_BroadCastToTable("st_"..j.."_"..Seats[j].chips.."_"..Seats[j].bet.."_"..Seats[j].status.."_0.5",0);
	FHS_UpdateSeat(j);
end


------------------------------------------------------------------------
--Takes cards[1..N]  (1 based array)
--Returns   rank string, description
function FHS_FindHandForPlayer(j)
	local rank="";
	local desc="";

	if (Seats[j].dealt==1) then

		InCards={};	
		InCards[1]=Seats[j].hole1;
		InCards[2]=Seats[j].hole2;

		for r=1,getn(Flop) do
			InCards[r+2]=Flop[r];
		end 
	
		rank=FHS_bestRank(InCards);
		desc=FHS_handDescription(rank);
	end
	
	return rank,desc;
end;


-- iterator function over set of cards, returns next subset of 5
function FHS_nextHand(cards, listCards)
	if (listCards==nil) then
		local initial={}
		local hand={}
		for i=1,math.min(5,#cards) do
			initial[i]=i
			hand[i]=cards[i]
		end
		return initial, hand
	end

	if (#cards<=5) then return nil end
	for i=5,1,-1 do
		if (listCards[i]+5-i<#cards) then
			listCards[i]=listCards[i]+1
			for j=i+1,5 do
				listCards[j]=listCards[j-1]+1
			end
			local hand={};
			for j=1,#listCards do hand[j]=cards[listCards[j]] end
			return listCards, hand
		end
	end
	return nil
end


-- iterator wrapper for finding possible 5-card sets in cards
function FHS_possibleHands(cards)
	return FHS_nextHand,cards,initial
end


-- return best ranked hand rank with cards
function FHS_bestRank(cards)
	local rank="000000"
	local newRank
	for i,hand in FHS_possibleHands(cards) do
		newRank=FHS_rank(hand)
		if (newRank>rank) then rank=newRank end
	end
	return rank
end


-- return rank of a hand of 5 or fewer cards
-- return value is a string "raabbcc..."
-- where r=0 (high card) to 9 (five of a kind)
-- and aa, bb, cc,... are card values in order of ranking relevance 02 (deuce) - 14 (ace)
-- e.g. 807 (straight flush to the 7) 70611 (four sixes, jack kicker) 60208 (twos full of eights)
function FHS_rank(cards)

	-- create table of ranks by count of each
	local rankCount={}

	for i,card in pairs(cards) do
		if (rankCount[Cards[card].rank]==nil) then
			rankCount[Cards[card].rank]=1
		else
			rankCount[Cards[card].rank]=rankCount[Cards[card].rank]+1
		end
	end
	
	-- find best groups by number and rank
	local sortedGroups={"","","","",""}
	table.foreach(rankCount, function(k,v) sortedGroups[#sortedGroups+1]=v..string.sub(100+k,2) end)
	table.sort(sortedGroups, function(a,b) return a>b end)
	
	-- find flush
	local flush = #cards==5 
		and Cards[cards[1]].suit==Cards[cards[2]].suit
		and Cards[cards[1]].suit==Cards[cards[3]].suit
		and Cards[cards[1]].suit==Cards[cards[4]].suit
		and Cards[cards[1]].suit==Cards[cards[5]].suit

	-- find ranks
	local straight=false
	local ranks={"","","","",""}
	for i = 1,math.min(5,#cards) do
		ranks[i] = string.sub(100+Cards[cards[i]].rank,2)
	end
	table.sort(ranks, function(a,b) return a>b end)
	
	if (sortedGroups[1]<"200" and #cards==5) then -- no pairs in a straight
		if (ranks[1]=="14" and ranks[2]=="05" and ranks[5]=="02") then -- special case ace to five
			ranks={"05","04","03","02","14"}
			straight=true
		else
			straight=tonumber(ranks[1])==tonumber(ranks[5])+4
		end
	end

	-- now find best hand
	-- 5 of a kind
	if (sortedGroups[1]>"500") then return "9"..string.sub(sortedGroups[1],2) end
	-- straight flush
	if (straight and flush) then return "8"..string.sub(sortedGroups[1],2) end
	-- 4 of a kind
	if (sortedGroups[1]>"400") then return "7"..string.sub(sortedGroups[1],2)..string.sub(sortedGroups[2],2) end
	-- full house
	if (sortedGroups[1]>"300" and sortedGroups[2]>"200") then return "6"..string.sub(sortedGroups[1],2)..string.sub(sortedGroups[2],2) end
	-- flush
	if (flush) then return "5"..table.concat(ranks) end
	-- straight
	if (straight) then return "4"..ranks[1] end --string.sub(sortedGroups[1],2) end
	-- 3 of a kind
	if (sortedGroups[1]>"300") then return "3"..string.sub(sortedGroups[1],2)..string.sub(sortedGroups[2],2)..string.sub(sortedGroups[3],2) end
	-- full house
	if (sortedGroups[1]>"200" and sortedGroups[2]>"200") then return "2"..string.sub(sortedGroups[1],2)..string.sub(sortedGroups[2],2)..string.sub(sortedGroups[3],2) end
	-- 2 of a kind
	if (sortedGroups[1]>"200") then return "1"..string.sub(sortedGroups[1],2)..string.sub(sortedGroups[2],2)..string.sub(sortedGroups[3],2)..string.sub(sortedGroups[4],2) end
	return "0"..table.concat(ranks)
	 
end
	
	
-- takes a rank string and returns a text descriptor of it
function FHS_handDescription(rank)

	if (rank==nil or rank=="") then
		return ""
	end
	
	local handType=tonumber(string.sub(rank,1,1))
	local card1=tonumber(string.sub(rank,2,3))
	local card2=tonumber(string.sub(rank,4,5))
	
	if ( card1 == nil ) then
		card1 = 2
	end
	if ( card2 == nil ) then
		card2 = 2
	end

	local descriptions = {}
	descriptions[0] = L['High Card']..": "..CardRank[card1]
	descriptions[1] = L['2 of a Kind']..": "..CardRanks[card1]
	descriptions[2] = string.format(L['%s over %s'], CardRanks[card1], CardRanks[card2])
	descriptions[3] = L['3 of a Kind']..": "..CardRanks[card1]
	descriptions[4] = string.format(L['Straight to the %s'], CardRank[card1])
	descriptions[5] = string.format(L['Flush: %s high'],CardRank[card1])
	descriptions[6] = string.format(L['%s full of %s'], CardRanks[card1], CardRanks[card2])
	descriptions[7] = L['4 of a Kind']..": "..CardRanks[card1]
	descriptions[8] = string.format(L['Straight Flush to the %s'], CardRank[card1])
	descriptions[9] = L['Royal Flush']
		
	if (handType==8 and card1==14) then -- Royal Flush
		handType = 9
	end
	
	return descriptions[handType]
	
end

--------------
-- GUI
--------------
function FHS_Set_BigBlindStart(value)
	if ( StartChips < value ) then
		value = StartChips
	end
	BigBlindStart = value;
	FHS_BigBlindStart = value
	
end


function FHS_Set_CurrentBlind(value)
	if ( value % 1 >= .9 ) then
		Blinds = math.ceil(value)
	elseif ( value % 1 <= .1 ) then
		Blinds = math.floor(value)
	end
	FHS_bigBlindText:SetText(L['Next Round\'s Big Blind']..": "..('%.0f'):format(FHS_IncrementBlind(Blinds)));
end


function FHS_ChangeBigBlind(whichway)
	if ( whichway == -1 and Blinds>20) then
		FHS_Set_CurrentBlind(Blinds-20);
	elseif ( whichway == 1 ) then
		FHS_Set_CurrentBlind(Blinds+20);
	end
end


function FHS_ChangeIncrement(whichway)
	if ( whichway == -1 and BlindIncrease>0.04) then
		FHS_SetBlindIncr(BlindIncrease-0.05);
	elseif ( whichway == 1 and BlindIncrease<0.96) then
		FHS_SetBlindIncr(BlindIncrease+0.05);
	end

end


function FHS_SetBlindIncr(value)
	
	value = tonumber(('%g'):format(value));
	BlindIncrease = value;
	FHS_BlindIncrease = value;
	FHS_bigBlindIncText:SetText(L['Current Blind Increment per round']..": "..('%.0f'):format(BlindIncrease*100).."\%");
	FHS_bigBlindText:SetText(L['Next Round\'s Big Blind']..": "..('%.0f'):format(FHS_IncrementBlind(Blinds)));
	
end


function FHS_Set_StartChips(value)
	StartChips = value;
	FHS_StartChips = value;
	if ( StartChips < BigBlindStart ) then
		FHS_Set_BigBlindStart(value)
	end
	
end


function FHS_SetupOptionsPanel()

	FHS_Debug_Feedback("Do options panel");
	VodkaHoldem_options_panel = LibStub("LibSimpleOptions-1.0").AddOptionsPanel(L['WoW Texas Hold\'em'],function()  end)

	
	local VodkaHoldem_Options_Minimap_toggle = VodkaHoldem_options_panel:MakeToggle(
	    'name', L['Minimap Icon'],
	    'description', L['Turn minimap icon on/off'],
	    'default', false,
	    'getFunc', function() return FHS_minimapIcon end,
	    'setFunc', function(value) FHS_Toggle_MiniMap(value) end
	)

	
	local VodkaHoldem_Options_Blind_slider = VodkaHoldem_options_panel:MakeSlider(
	    'name', L['Starting Blind'],
	    'description', L['Set the starting Blind'],
	    'minText', '2',
	    'maxText', ('%.0f'):format(StartChips),
	    'minValue', 2,
	    'maxValue', StartChips,
	    'step', 2,
	    'default', 10,
	    'current', BigBlindStart,
	    'setFunc', function(value) FHS_Set_BigBlindStart(value) end,
	    'currentTextFunc', function(value) return ("%.0f"):format(value) end
	)
	
	local VodkaHoldem_Options_Increment_slider = VodkaHoldem_options_panel:MakeSlider(
	    'name', L['Blind increase percent per round'],
	    'description', L['Set the by what percent the Blind increases each round'],
	    'minText', '0%',
	    'maxText', '100%',
	    'minValue', 0,
	    'maxValue', 1,
	    'step', 0.05,
	    'default', 0.25,
	    'current', BlindIncrease,
	    'setFunc', function(value) FHS_SetBlindIncr(value) end,
	    'currentTextFunc', function(value) return ("%.0f%%"):format(value*100) end
	)
	
	local VodkaHoldem_Options_Chips_slider = VodkaHoldem_options_panel:MakeSlider(
	    'name', L['Starting Chips'],
	    'description', L['Set the starting Chips'],
	    'minText', '100',
	    'maxText', '5000',
	    'minValue', 100,
	    'maxValue', 5000,
	    'step', 100,
	    'default', 500,
	    'current', StartChips,
	    'setFunc', function(value)
				FHS_Set_StartChips(value);
				VodkaHoldem_Options_Blind_slider:SetMinMaxValues(10, StartChips);
				_G[VodkaHoldem_Options_Blind_slider:GetName() .. "High"]:SetText(('%.0f'):format(StartChips))
				VodkaHoldem_options_panel:Refresh();
			end,
	    'currentTextFunc', function(value) return ("%.0f"):format(value) end
	)
	
	-- 4 = Original, 1 = Neutral, 2 = Alliance, 3 = Horde
	local VodkaHoldem_Options_Artwork_Button1 = VodkaHoldem_options_panel:MakeButton(
	    'name', L['Neutral artwork'],
	    'description', L['Use neutral card back artwork'],
	    'func', function() FHS_ArtWork = 1; FHS_SetCardTextures() end
	)
	local VodkaHoldem_Options_Artwork_Button2 = VodkaHoldem_options_panel:MakeButton(
	    'name', L['Alliance artwork'],
	    'description', L['Use Alliance card back artwork'],
	    'func', function() FHS_ArtWork = 2; FHS_SetCardTextures() end
	)
	local VodkaHoldem_Options_Artwork_Button3 = VodkaHoldem_options_panel:MakeButton(
	    'name', L['Horde artwork'],
	    'description', L['Use Horde card back artwork'],
	    'func', function() FHS_ArtWork = 3; FHS_SetCardTextures() end
	)
	local VodkaHoldem_Options_Artwork_Button4 = VodkaHoldem_options_panel:MakeButton(
	    'name', L['Original artwork'],
	    'description', L['Use original card back artwork'],
	    'func', function() FHS_ArtWork = 4; FHS_SetCardTextures() end
	)
	--[[local VodkaHoldem_Options_Artwork_Drop = VodkaHoldem_options_panel:MakeDropDown(
	    'name', L['Artwork'],
	    'description', L['Select card back artwork'],
	    'values', {
	        1, L['Neutral'],
	        2, L['Alliance'],
	        3, L['Horde'],
			4, L['Original']
	     },
	    'default', 1,
	    'getFunc', function() return FHS_ArtWork; end,
	    'setFunc', function(value) FHS_ArtWork = value; FHS_SetCardTextures() end
	)
	]]

	local title, subText = VodkaHoldem_options_panel:MakeTitleTextAndSubText(
		L['WoW Texas Hold\'em Options'], 
		L['These options are saved between sessions']
	)
	
	local VodkaHoldem_Options_CardArtwork = VodkaHoldem_options_panel:CreateTexture("FHS_Blank_Example","ARTWORK")
	VodkaHoldem_Options_CardArtwork:SetHeight(128);VodkaHoldem_options_panel:SetWidth(128)
	
	VodkaHoldem_Options_Chips_slider:SetPoint("TOPLEFT",50, -100)
	VodkaHoldem_Options_Blind_slider:SetPoint("TOPLEFT",50, -175)
	VodkaHoldem_Options_Increment_slider:SetPoint("TOPLEFT",50, -250)
	--VodkaHoldem_Options_Artwork_Drop:SetPoint("TOPLEFT",50, -325)
	VodkaHoldem_Options_Artwork_Button1:SetPoint("TOPLEFT",50, -300)
	VodkaHoldem_Options_Artwork_Button2:SetPoint("TOPLEFT",50, -325)
	VodkaHoldem_Options_Artwork_Button3:SetPoint("TOPLEFT",50, -350)
	VodkaHoldem_Options_Artwork_Button4:SetPoint("TOPLEFT",50, -375)
	VodkaHoldem_Options_Minimap_toggle:SetPoint("TOPLEFT",250, -100)
	VodkaHoldem_Options_CardArtwork:SetPoint("TOPLEFT",200,-300)
	
end


function FHS_SetupXMLButtons()

--	_G["FHS_Strategy"]:SetText(L['Learn How to Play Texas Holdem']);
	_G["FHS_Quit"]:SetText(L['Quit']);
	_G["FHS_SitOutIn"]:SetText(L['Sit Out']);
	_G["FHS_Play"]:SetText(L['Play']);
	_G["FHS_Fold"]:SetText(L['Fold']);
	_G["FHS_Call"]:SetText(L['Call']);
	_G["FHS_AllIn"]:SetText(L['All In']);
	_G["FHS_Raise"]:SetText(L['Raise']);
	_G["FHS_ClearChips"]:SetText(L['Clear Chips']);
	_G["FHS_GiveChips"]:SetText(L['+100 Chips']);
	_G["FHS_BootPlayer"]:SetText(L['Boot']);
	_G["FHS_PopOk"]:SetText(L['Ok']);
--	_G["FHS_Feedback"]:SetText("www.FreeHoldemStrategy.com");
	_G["FHS_Pot_Text"]:SetText(L['WoW Texas Hold\'em']);
end
		

function FHS_Setup_LDB()
	if ( FHS_ldbIcon ) then
		FHS_LDBObject = ldb:NewDataObject(
			"WoWTexasHoldem",
			{
				type = "data source",
				text = L['WoW Texas Hold\'em'],
				label = "WoWTexasHoldem",
				icon = "interface\\addons\\WoWTexasHoldem\\textures\\mapicon",
				OnClick  = function(clickedframe, button) FHS_LauncherClicked(button) end,
				iconCoords = {0.25,.75,0.25,.75},
			})
	end
	
	local f = CreateFrame("frame");
	
	f:SetScript("OnUpdate", function(self, elap) FHS_Hidden_frame_OnUpdate(self, elap) end)

end

			
function FHS_SetupFrames()
	FHS_SetupTableFrame();
	FHS_SetupTopButtons();
	FHS_SetupButtonButtons();
	FHS_SetupButtonsFrame();
	FHS_SetupPopUpFrame();
	FHS_SetupStatusFrame();
	FHS_SetupPotFrame();
	FHS_SetupSeatFrames();
	FHS_SetupCardFrames();
	FHS_SetupMiniMapButton();
	FHS_SetupDealerButtonsFrame();
end


function FHS_SetupTableFrame()
	local tablebackdropInfo =
	{ 
		bgFile = "interface\\addons\\WoWTexasHoldem\\textures\\felt", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	};
	local tableFrame = CreateFrame("Frame", "FHSPokerFrame", PARENT_FRAME, BackdropTemplateMixin and "BackdropTemplate");
	tableFrame:SetBackdrop(tablebackdropInfo)
	tableFrame:Hide();
	tableFrame:SetMovable(true);
	tableFrame:EnableMouse();
	tableFrame:RegisterForDrag("LeftButton");
	tableFrame:SetScript("OnDragStart", tableFrame.StartMoving);
	tableFrame:SetScript("OnDragStop", tableFrame.StopMovingOrSizing);
	tableFrame:SetFrameStrata("TOOLTIP");
	
	tableFrame:SetScript("OnEvent",FHSPoker_OnEvent);

	tableFrame:SetScript("OnUpdate",function() FHSPoker_Update(arg1);  end);
	tableFrame:SetScript("OnMouseDown",
		function()
			if ( arg1 == "LeftButton" ) then
				this:StartMoving();
				FHS_Popup:Hide();
			end
		end);
	tableFrame:SetScript("OnMouseUp",
		function()
			if ( arg1 == "LeftButton" ) then
				this:StopMovingOrSizing();
			end
		end);
		
	tableFrame:SetWidth(860);tableFrame:SetHeight(560);
	tableFrame:SetPoint("CENTER",UIParent,"CENTER",0,0);
	

	local circleTexture = tableFrame:CreateTexture("FHS_CCirc","OVERLAY");
	circleTexture:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\circle");
	circleTexture:SetTexCoord(0,1,0,1);
	circleTexture:SetWidth(512);tableFrame:SetHeight(512);
	circleTexture:SetPoint("CENTER",tableFrame,"CENTER",0,-50)
	
	local versionString = tableFrame:CreateFontString("FHS_Version","BACKGROUND","GameTooltipText");
	versionString:SetPoint("BOTTOMLEFT",tableFrame,"BOTTOMLEFT",10,10);
	
	local feedbackString = tableFrame:CreateFontString("FHS_Feedback","BACKGROUND","GameTooltipText");
	feedbackString:SetPoint("BOTTOMLEFT",tableFrame,"BOTTOMLEFT",10,34);
	
	local strategyString = tableFrame:CreateFontString("FHS_Strategy","BACKGROUND","GameTooltipText");
	strategyString:SetPoint("BOTTOMLEFT",tableFrame,"BOTTOMLEFT",10,22);
	
end


function FHS_Toggle_MiniMap(toggle)

	if ( toggle ) then
		minimapIcon = true;
		FHS_minimapIcon = true;
		FHSPoker_MapIconFrame:Show();
	else
		minimapIcon = false;
		FHS_minimapIcon = false;
		FHSPoker_MapIconFrame:Hide();
	end

end
		
		
function FHS_SetupMiniMapButton()
	local miniMapButton = CreateFrame("Button", "FHSPoker_MapIconFrame", Minimap)
	
	miniMapButton:SetFrameStrata("MEDIUM");
	miniMapButton:SetMovable(true);
	miniMapButton:EnableMouse(true);
	miniMapButton:SetWidth(32);miniMapButton:SetHeight(32);
	miniMapButton:SetPoint("TOPLEFT",Minimap,"TOPLEFT",-25,-80);
	
	local miniMapButtonTexture = miniMapButton:CreateTexture("FHSPoker_MapIcon", "BACKGROUND")
	
	miniMapButtonTexture:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\mapicon");
	miniMapButtonTexture:SetWidth(32);miniMapButtonTexture:SetHeight(32);
	miniMapButtonTexture:SetPoint("CENTER",miniMapButton,"CENTER",0,0);
	
	miniMapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight","ADD");
	
	miniMapButton:SetScript("OnLoad",function() this:RegisterForClicks("LeftButtonUp","RightButtonUp"); this:RegisterForDrag("RightButton");  end);
	miniMapButton:SetScript("OnMouseDown",function(self, button) if (button=="RightButton") then FHS_Dragging(1); self:StartMoving() end end);
	miniMapButton:SetScript("OnMouseUp",function(self, button) if (button=="RightButton") then FHS_Dragging(0); self:StopMovingOrSizing() end end);
	miniMapButton:SetScript("OnClick",function(self, button, down) FHS_MapIconClick(button);  end);
	--miniMapButton:SetScript("OnClick",function(self, button, down) print("OnClick: "..button..down);  end);
    --miniMapButton:SetScript("OnMouseUp",function(self, button) print("OnMouseUp: "..button); end);
    --miniMapButton:SetScript("OnMouseDown",function(self, button) print("OnMouseDown: "..button); end);

	if ( not minimapIcon ) then
		FHSPoker_MapIconFrame:Hide();
	end

end


function FHS_SetupButtonButtons()

	local quitButton = CreateFrame("Button", "FHS_Quit", FHSPokerFrame, "OptionsButtonTemplate");
	quitButton:SetText(L['Quit']);
	quitButton:SetHeight(20);quitButton:SetWidth(100);
	quitButton:SetPoint("BOTTOM",FHSPokerFrame,"BOTTOM",370,10)
	quitButton:SetScript("OnClick",function() FHS_Popup:Hide(); FHS_QuitClick(); end);
	
	local sitInOutButton = CreateFrame("Button", "FHS_SitOutIn", FHSPokerFrame, "OptionsButtonTemplate");
	sitInOutButton:SetText(L['Sit Out']);
	sitInOutButton:SetHeight(20);sitInOutButton:SetWidth(100);
	sitInOutButton:SetPoint("BOTTOM",FHSPokerFrame,"BOTTOM",370,35)
	sitInOutButton:SetScript("OnClick",function() FHS_SitOutInClick(); end);
	
	local playButton = CreateFrame("Button", "FHS_Play", FHSPokerFrame, "OptionsButtonTemplate");
	playButton:SetText(L['Play']);
	playButton:SetHeight(20);playButton:SetWidth(90);
	playButton:SetPoint("BOTTOM",FHSPokerFrame,"BOTTOM",270,10)
	playButton:SetScript("OnClick",function() FHS_Popup:Hide(); FHS_Popup:Hide(); FHS_PlayClick(); end);

end


function FHS_SetupTopButtons()

	local setSizeButton = CreateFrame("Button", "FHSPoker_SetSizeButton", FHSPokerFrame);
	setSizeButton:SetHeight(32);setSizeButton:SetWidth(32);
	setSizeButton:SetPoint("TOPRIGHT",FHSPokerFrame,"TOPRIGHT",-40,-10);
	
	local setSizeIconButton = setSizeButton:CreateTexture("FHSPoker_MinimizeMapIcon", "BACKGROUND")
	setSizeIconButton:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\mapicon_g");
	setSizeIconButton:SetHeight(32);setSizeIconButton:SetWidth(32);
	setSizeIconButton:SetPoint("CENTER",setSizeButton,"CENTER",0,0);
	
	setSizeButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight","ADD");
	
	setSizeButton:SetScript("OnClick",function() FHS_SizeClick(); end);
	
	
	local minimizeButton = CreateFrame("Button", "FHSPoker_Minimize", FHSPokerFrame);
	minimizeButton:SetHeight(32);minimizeButton:SetWidth(32);
	minimizeButton:SetPoint("TOPRIGHT",FHSPokerFrame,"TOPRIGHT",-10,-10);
	
	local minimizeIconButton = minimizeButton:CreateTexture("FHSPoker_MinimizeMapIcon", "BACKGROUND")
	minimizeIconButton:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\mapicon");
	minimizeIconButton:SetHeight(32);minimizeIconButton:SetWidth(32);
	minimizeIconButton:SetPoint("CENTER",minimizeButton,"CENTER",0,0);	
	minimizeButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight","ADD");	
	minimizeButton:SetScript("OnClick",function() FHSPokerFrame:Hide(); end);
	
end


function FHS_SetupButtonsFrame()
	local FHSbackdropInfo =
	{ 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	};
	local buttonsFrame = CreateFrame("Frame", "FHS_Buttons", FHSPokerFrame, BackdropTemplateMixin and "BackdropTemplate");
	buttonsFrame:SetBackdrop(FHSbackdropInfo);
	buttonsFrame:SetHeight(60);buttonsFrame:SetWidth(380);
	buttonsFrame:SetPoint("CENTER",FHSPokerFrame,"CENTER",0,-57);
	buttonsFrame:SetBackdropColor(0,0,0,0.5);
	
	local foldButton = CreateFrame("Button", "FHS_Fold", buttonsFrame, "OptionsButtonTemplate");
	foldButton:Hide();
	foldButton:SetHeight(20);foldButton:SetWidth(100);
	foldButton:SetPoint("CENTER",buttonsFrame,"CENTER",-130,12)
	foldButton:SetScript("OnClick",function()FHS_FoldClick();end);

	--Snowfan edit autobutton help
--	local AutoText = buttonsFrame:CreateFontString("FHS_AutoText","BACKGROUND","GameTooltipText");
--	AutoText:SetText(L['Tick to act automatically']);
--	AutoText:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",50,21);	
	
	local AutoFoldText = buttonsFrame:CreateFontString("FHS_AutoFoldText","BACKGROUND","GameTooltipText");
	AutoFoldText:SetText(L['Check/\nFold']);
	AutoFoldText:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",14,8);
	local AutoFoldCheck = CreateFrame("CheckButton", "FHS_AutoFoldCheck", buttonsFrame, "UICheckButtonTemplate");
	AutoFoldCheck:SetHeight(15);AutoFoldCheck:SetWidth(15);
	AutoFoldCheck:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",40,6)
	AutoFoldCheck:SetScript("OnClick",function() if ( FHS_AutoFoldCheck:GetChecked() )then FHS_AutoBetCheck:SetChecked(false); FHS_AutoCheckCheck:SetChecked(false); end; end);	
		
	local AutoCheckText = buttonsFrame:CreateFontString("FHS_AutoCheckText","BACKGROUND","GameTooltipText");
	AutoCheckText:SetText(L['Check']);
	AutoCheckText:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",59,8);
	local AutoCheckCheck = CreateFrame("CheckButton", "FHS_AutoCheckCheck", buttonsFrame, "UICheckButtonTemplate");
	AutoCheckCheck:SetHeight(15);AutoCheckCheck:SetWidth(15);
	AutoCheckCheck:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",96,6)
	AutoCheckCheck:SetScript("OnClick",function() if ( FHS_AutoCheckCheck:GetChecked() )then FHS_AutoFoldCheck:SetChecked(false); FHS_AutoBetCheck:SetChecked(false); end; end);	
	
	local AutoBetText = buttonsFrame:CreateFontString("FHS_AutoBetText","BACKGROUND","GameTooltipText");
	AutoBetText:SetText(L['Call any']);
	AutoBetText:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",117,8);
	local AutoBetCheck = CreateFrame("CheckButton", "FHS_AutoBetCheck", buttonsFrame, "UICheckButtonTemplate");
	AutoBetCheck:SetHeight(15);AutoBetCheck:SetWidth(15);
	AutoBetCheck:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",166,6)
	AutoBetCheck:SetScript("OnClick",function() if ( FHS_AutoBetCheck:GetChecked() )then FHS_AutoFoldCheck:SetChecked(false); FHS_AutoCheckCheck:SetChecked(false); end; end);
	
	local AutoStickyText = buttonsFrame:CreateFontString("FHS_AutoStickyText","BACKGROUND","GameTooltipText");
	AutoStickyText:SetText(L['Sticky']);
	AutoStickyText:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",185,8);
	local AutoStickyCheck = CreateFrame("CheckButton", "FHS_AutoStickyCheck", buttonsFrame, "UICheckButtonTemplate");
	AutoStickyCheck:SetHeight(15);AutoStickyCheck:SetWidth(15);
	AutoStickyCheck:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",220,6)
	
	local callButton = CreateFrame("Button", "FHS_Call", buttonsFrame, "OptionsButtonTemplate");
	callButton:Hide();
	callButton:SetHeight(20);callButton:SetWidth(100);
	callButton:SetPoint("CENTER",buttonsFrame,"CENTER",-26,12)
	callButton:SetScript("OnClick",function()FHS_CallClick();end);
	
	local allInButton = CreateFrame("Button", "FHS_AllIn", buttonsFrame, "OptionsButtonTemplate");
	allInButton:Hide();
	allInButton:SetText(L['All In']);
	allInButton:SetHeight(20);allInButton:SetWidth(120);
	allInButton:SetPoint("CENTER",buttonsFrame,"CENTER",110,-12)
	allInButton:SetScript("OnClick",function()FHS_AllInClick();end);
	
	local raiseButton = CreateFrame("Button", "FHS_Raise", buttonsFrame, "OptionsButtonTemplate");
	raiseButton:Hide();
	raiseButton:SetHeight(20);raiseButton:SetWidth(120);
	raiseButton:SetPoint("CENTER",buttonsFrame,"CENTER",86,12)
	raiseButton:SetScript("OnClick",function()FHS_RaiseClick();end);
	
	local lowerButton = CreateFrame("Button", "FHS_Raise_Lower", buttonsFrame, "OptionsButtonTemplate");
	lowerButton:Hide();
	lowerButton:SetText("-");
	lowerButton:SetHeight(20);lowerButton:SetWidth(20);
	lowerButton:SetPoint("CENTER",buttonsFrame,"CENTER",153,12)
	lowerButton:SetScript("OnClick",function()FHS_RaiseChange(-1);end);
	
	local higherButton = CreateFrame("Button", "FHS_Raise_Higher", buttonsFrame, "OptionsButtonTemplate");
	higherButton:Hide();
	higherButton:SetText("+");
	higherButton:SetHeight(20);higherButton:SetWidth(20);
	higherButton:SetPoint("CENTER",buttonsFrame,"CENTER",173,12)
	higherButton:SetScript("OnClick",function()FHS_RaiseChange(1);end);

end


function FHS_SetupDealerButtonsFrame()
	local dealerbuttonsbackdropInfo =
	{ 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	};
	local buttonsFrame = CreateFrame("Frame", "FHS_DealerButtons", FHSPokerFrame, BackdropTemplateMixin and "BackdropTemplate");
	buttonsFrame:SetBackdrop(dealerbuttonsbackdropInfo)
	buttonsFrame:Hide();
	buttonsFrame:SetHeight(40);buttonsFrame:SetWidth(300);
	buttonsFrame:SetPoint("CENTER",FHSPokerFrame,"CENTER",0,-225);
	buttonsFrame:SetBackdropColor(0,0,0,0.5);
	
	local bigBlindText = buttonsFrame:CreateFontString("FHS_bigBlindText","BACKGROUND","GameTooltipText");
	bigBlindText:SetText(L['Next Round\'s Big Blind']..": "..('%.0f'):format(FHS_IncrementBlind(Blinds)));
	bigBlindText:SetPoint("TOPLEFT",buttonsFrame,"TOPLEFT",40,-6);
	
	local lowerButtonBlind = CreateFrame("Button", "FHS_Blind_Lower", buttonsFrame, "OptionsButtonTemplate");
	lowerButtonBlind:SetText("-");
	lowerButtonBlind:SetHeight(15);lowerButtonBlind:SetWidth(15);
	lowerButtonBlind:SetPoint("TOPLEFT",buttonsFrame,"TOPLEFT",5,-4)
	lowerButtonBlind:SetScript("OnClick",function()FHS_ChangeBigBlind(-1);end);
	
	local higherButtonBlind = CreateFrame("Button", "FHS_Blind_Higher", buttonsFrame, "OptionsButtonTemplate");
	higherButtonBlind:SetText("+");
	higherButtonBlind:SetHeight(15);higherButtonBlind:SetWidth(15);
	higherButtonBlind:SetPoint("TOPLEFT",buttonsFrame,"TOPLEFT",22,-4)
	higherButtonBlind:SetScript("OnClick",function() FHS_ChangeBigBlind(1);end);
	
	local bigBlindIncText = buttonsFrame:CreateFontString("FHS_bigBlindIncText","BACKGROUND","GameTooltipText");
	bigBlindIncText:SetText(L['Current Blind Increment per round']..": "..(BlindIncrease*100).."\%");
	bigBlindIncText:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",40,6);
	
	local lowerButton = CreateFrame("Button", "FHS_Incr_Lower", buttonsFrame, "OptionsButtonTemplate");
	lowerButton:SetText("-");
	lowerButton:SetHeight(15);lowerButton:SetWidth(15);
	lowerButton:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",5,4)
	lowerButton:SetScript("OnClick",function()FHS_ChangeIncrement(-1);end);
	
	local higherButton = CreateFrame("Button", "FHS_Incr_Higher", buttonsFrame, "OptionsButtonTemplate");
	higherButton:SetText("+");
	higherButton:SetHeight(15);higherButton:SetWidth(15);
	higherButton:SetPoint("BOTTOMLEFT",buttonsFrame,"BOTTOMLEFT",22,4)
	higherButton:SetScript("OnClick",function()FHS_ChangeIncrement(1);end);

end


function FHS_SetupPopUpFrame()
	local popupbackdropInfo =
	{ 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	};
	local popUpFrame = CreateFrame("Frame", "FHS_Popup", FHSPokerFrame, BackdropTemplateMixin and "BackdropTemplate");
	popUpFrame:SetBackdrop(popupbackdropInfo);
	popUpFrame:Hide();
	popUpFrame:SetHeight(100);
	popUpFrame:SetWidth(130);
	popUpFrame:SetPoint("CENTER",FHSPokerFrame,"CENTER",0,0);
	popUpFrame:SetBackdropColor(0,0,0,0.5);
	
	local clearChipsbutton = CreateFrame("Button", "FHS_ClearChips", popUpFrame, "OptionsButtonTemplate");
	clearChipsbutton:SetPoint("CENTER",popUpFrame,"CENTER",0,30)
	clearChipsbutton:SetScript("OnClick",function()FHS_Popup_ClearChipsClick()end);
	
	local giveChipsbutton = CreateFrame("Button", "FHS_GiveChips", popUpFrame, "OptionsButtonTemplate");
	giveChipsbutton:SetPoint("CENTER",popUpFrame,"CENTER",0,10)
	giveChipsbutton:SetScript("OnClick",function()FHS_Popup_GiveChipsClick()end);
	
	local bootPlayerbutton = CreateFrame("Button", "FHS_BootPlayer", popUpFrame, "OptionsButtonTemplate");
	bootPlayerbutton:SetPoint("CENTER",popUpFrame,"CENTER",0,-10)
	bootPlayerbutton:SetScript("OnClick",function()FHS_Popup_BootPlayerClick()end);
	
	local popOkbutton = CreateFrame("Button", "FHS_PopOk", popUpFrame, "OptionsButtonTemplate");
	popOkbutton:SetPoint("CENTER",popUpFrame,"CENTER",0,-30)
	popOkbutton:SetScript("OnClick",function()FHS_Popup:Hide()end);

end
			
			
function FHS_SetupPotFrame()
	local potbackdropInfo =
	{ 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16, 
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	};
	local potFrame = CreateFrame("Frame", "FHS_Pot", FHSPokerFrame, BackdropTemplateMixin and "BackdropTemplate");
	potFrame:SetBackdrop(potbackdropInfo)
	potFrame:SetHeight(30);
	potFrame:SetWidth(360);
	potFrame:SetPoint("CENTER",FHSPokerFrame,"CENTER",0,140);
	potFrame:SetBackdropColor(0,0,0,0.5);
	local potFrameString = potFrame:CreateFontString("FHS_Pot_Text","BACKGROUND","GameTooltipText");
	potFrameString:SetPoint("CENTER",potFrame,"CENTER",0,2);

end


function FHS_SetupStatusFrame()
	local statusbackdropInfo =
	{ 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	};
	local statusFrame = CreateFrame("Frame", "FHS_Status", FHSPokerFrame, BackdropTemplateMixin and "BackdropTemplate");
	statusFrame:SetBackdrop(statusbackdropInfo)
	statusFrame:SetHeight(30);
	statusFrame:SetWidth(264);
	statusFrame:SetPoint("CENTER",FHSPokerFrame,"CENTER",0,175);
	statusFrame:SetBackdropColor(0,0,0,0.5);
	local statusFrameString = statusFrame:CreateFontString("FHS_Status_Text","BACKGROUND","GameTooltipText");
	statusFrameString:SetPoint("CENTER",statusFrame,"CENTER",0,2);

end
	

function FHS_SetupSeatFrames()

	local seatFrame;
	local seatlocations =
	{
		{x=300, y=220},
		{x=360, y=90},
		{x=360, y=-40},
		{x=288, y=-165},
		{x=100, y=-236},
		{x=-288, y=-165},
		{x=-360, y=-40},
		{x=-360, y=90},
		{x=-300, y=220}
	}	
	
	for seat=1,9 do
		local seatbackdropInfo =
		{ 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
		};
		local seatFrame = CreateFrame("Frame", "FHS_Seat_"..seat, FHSPokerFrame, BackdropTemplateMixin and "BackdropTemplate");
		seatFrame:SetBackdrop(seatbackdropInfo)	
		seatFrame:EnableMouse();
		seatFrame:SetHeight(50);
		seatFrame:SetWidth(120);
		seatFrame:SetPoint("CENTER",FHSPokerFrame,"CENTER",seatlocations[seat].x,seatlocations[seat].y);
		seatFrame:SetBackdrop( { 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	});
		seatFrame:SetBackdropColor(0,0,0,0.5);
		
		local seatFrameName = seatFrame:CreateFontString(seatFrame:GetName().."_Name","BACKGROUND","GameTooltipTextSmall");
		seatFrameName:SetPoint("CENTER",seatFrame,"CENTER",0,13);
		
		local seatFrameChips = seatFrame:CreateFontString(seatFrame:GetName().."_Chips","BACKGROUND","GameTooltipTextSmall");
		seatFrameChips:SetPoint("CENTER",seatFrame,"CENTER",0,1);
		
		local seatFrameStatus = seatFrame:CreateFontString(seatFrame:GetName().."_Status","BACKGROUND","GameTooltipTextSmall");
		seatFrameStatus:SetPoint("CENTER",seatFrame,"CENTER",0,-11);
		
		local seatFramePort = seatFrame:CreateTexture(seatFrame:GetName().."_Port","BACKGROUND");
		seatFramePort:SetWidth(60);seatFramePort:SetHeight(60);
		seatFramePort:SetTexCoord(0,1,0,1);
		seatFramePort:SetPoint("CENTER",seatFrame,"CENTER",100,0);
		
		local seatFramePortWho = seatFrame:CreateTexture(seatFrame:GetName().."_PortWho","BACKGROUND");
		seatFramePortWho:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\unknown");
		seatFramePortWho:SetWidth(60);seatFramePortWho:SetHeight(60);
		seatFramePortWho:SetTexCoord(0,1,0,1);
		seatFramePortWho:SetPoint("CENTER",seatFrame,"CENTER",100,0);
		
		local seatFrameRing = seatFrame:CreateTexture(seatFrame:GetName().."_Ring","BORDER");
		seatFrameRing:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\ring");
		seatFrameRing:SetWidth(128);seatFrameRing:SetHeight(128);
		seatFrameRing:SetTexCoord(0,1,0,1);
		seatFrameRing:SetPoint("CENTER",seatFrame,"CENTER",116,-22);
		
		local seatFrameRingSelect = seatFrame:CreateTexture(seatFrame:GetName().."_RingSelect","BORDER");
		seatFrameRingSelect:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\ring_select");
		seatFrameRingSelect:Hide();
		seatFrameRingSelect:SetWidth(128);seatFrameRingSelect:SetHeight(128);
		seatFrameRingSelect:SetTexCoord(0,1,0,1);
		seatFrameRingSelect:SetPoint("CENTER",seatFrame,"CENTER",116,-22);
		
		local seatFrameButton = seatFrame:CreateTexture(seatFrame:GetName().."_Button","BACKGROUND");
		seatFrameButton:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\button");
		seatFrameButton:Hide();
		seatFrameButton:SetWidth(16);seatFrameButton:SetHeight(16);
		seatFrameButton:SetTexCoord(0,1,0,1);
		seatFrameButton:SetPoint("CENTER",seatFrame,"CENTER",-46,11);
		
		seatFrame:SetScript("OnMouseDown",
			function(self, button)
				if ( button == "RightButton" ) then
					FHS_PopupMenu(self:GetName());
				end
			end);
			
	end
end		



function FHS_SetupCardFrames()

	local cardFrame
	local thiscard
	
	cardFrame = CreateFrame("Frame", nil, FHSPokerFrame, BackdropTemplateMixin and "BackdropTemplate");
	cardFrame:SetHeight(560);cardFrame:SetWidth(860);
	cardFrame:SetPoint("CENTER",nil,nil,-330,220);

	for card=0,12 do
		-- clubs
		thiscard = cardFrame:CreateTexture("FHS_Card_C"..card,"ARTWORK");
		thiscard:SetHeight(128);cardFrame:SetWidth(128);
		thiscard:SetPoint("CENTER",nil,nil);
		thiscard:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\c"..card);
		
		-- diamonds
		thiscard = cardFrame:CreateTexture("FHS_Card_D"..card,"ARTWORK");
		thiscard:SetHeight(128);cardFrame:SetWidth(128);
		thiscard:SetPoint("CENTER",nil,nil);
		thiscard:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\d"..card);
		
		-- hearts
		thiscard = cardFrame:CreateTexture("FHS_Card_H"..card,"ARTWORK");
		thiscard:SetHeight(128);cardFrame:SetWidth(128);
		thiscard:SetPoint("CENTER",nil,nil);
		thiscard:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\h"..card);
		
		-- spades
		thiscard = cardFrame:CreateTexture("FHS_Card_S"..card,"ARTWORK");
		thiscard:SetHeight(128);cardFrame:SetWidth(128);
		thiscard:SetPoint("CENTER",nil,nil);
		thiscard:SetTexture("interface\\addons\\WoWTexasHoldem\\textures\\s"..card);
		
	end
	
	-- card backs
	for card=1,23 do
		thiscard = cardFrame:CreateTexture("FHS_Blank_"..card,"ARTWORK");
		thiscard:SetHeight(128);cardFrame:SetWidth(128);
		thiscard:SetPoint("CENTER",nil,nil);
	end
	
end

-----------------------
-- Start OnLoad --
-----------------------
FHSPoker_OnLoad();
