// This file is part of Server Extension.
// Server Extension - a mutator for Killing Floor 2.
//
// Copyright (C) 2016-2024 The Server Extension authors and contributors
//
// Server Extension is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Server Extension is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with Server Extension. If not, see <https://www.gnu.org/licenses/>.

Class UIP_PlayerSpecs extends KFGUI_MultiComponent;

struct FPageExtraInfo
{
	var array<UniqueNetId> UserID;
};

var FPageExtraInfo ExtraInfo[3];
var KFGUI_ColumnList PlayersList,TopPlayers[3];
var KFGUI_SwitchComponent MultiPager;
var int CurrentPageIndex;
var byte CurrentPageStatus[3];
var KFGUI_Button PreviousButton;
var bool bDownloadingPage;

var KFGUI_Button TopPlaytimeButton;
var KFGUI_Button TopKillsButton;
var KFGUI_Button TopExpButton;

var localized string ShowStatsButtonText;
var localized string ShowStatsButtonToolTip;
var localized string TopPlaytimeButtonText;
var localized string TopPlaytimeButtonToolTip;
var localized string TopKillsButtonText;
var localized string TopKillsButtonToolTip;
var localized string TopExpButtonText;
var localized string TopExpButtonToolTip;
var localized string PlayerColumnText;
var localized string TotalKillsColumnText;
var localized string TotalExpColumnText;
var localized string TotalPlaytimeColumnText;

function FColumnItem NewFColumnItem(string Text, float Width)
{
	local FColumnItem NewItem;
	NewItem.Text = Text;
	NewItem.Width = Width;
	return NewItem;
}

function InitMenu()
{
	PreviousButton = KFGUI_Button(FindComponentID('Init'));
	PreviousButton.bIsHighlighted = true;
	PlayersList = KFGUI_ColumnList(FindComponentID('Players'));
	TopPlayers[0] = KFGUI_ColumnList(FindComponentID('PlayTimes'));
	TopPlayers[1] = KFGUI_ColumnList(FindComponentID('Kills'));
	TopPlayers[2] = KFGUI_ColumnList(FindComponentID('EXP'));
	MultiPager = KFGUI_SwitchComponent(FindComponentID('Pager'));

	TopPlaytimeButton=KFGUI_Button(FindComponentID('BPlaytime'));
	TopKillsButton=KFGUI_Button(FindComponentID('BKills'));
	TopExpButton=KFGUI_Button(FindComponentID('BExp'));

	PreviousButton.ButtonText=ShowStatsButtonText;
	PreviousButton.Tooltip=ShowStatsButtonToolTip;

	TopPlaytimeButton.ButtonText=TopPlaytimeButtonText;
	TopPlaytimeButton.Tooltip=TopPlaytimeButtonToolTip;

	TopKillsButton.ButtonText=TopKillsButtonText;
	TopKillsButton.Tooltip=TopKillsButtonToolTip;

	TopExpButton.ButtonText=TopExpButtonText;
	TopExpButton.Tooltip=TopExpButtonToolTip;

	PlayersList.Columns.AddItem(NewFColumnItem(PlayerColumnText,0.55));
	PlayersList.Columns.AddItem(NewFColumnItem(TotalKillsColumnText,0.15));
	PlayersList.Columns.AddItem(NewFColumnItem(TotalExpColumnText,0.15));
	PlayersList.Columns.AddItem(NewFColumnItem(TotalPlaytimeColumnText,0.15));

	TopPlayers[0].Columns.AddItem(NewFColumnItem("#",0.05));
	TopPlayers[0].Columns.AddItem(NewFColumnItem(PlayerColumnText,0.7));
	TopPlayers[0].Columns.AddItem(NewFColumnItem(TotalPlaytimeColumnText,0.25));

	TopPlayers[1].Columns.AddItem(NewFColumnItem("#",0.05));
	TopPlayers[1].Columns.AddItem(NewFColumnItem(PlayerColumnText,0.7));
	TopPlayers[1].Columns.AddItem(NewFColumnItem(TotalKillsColumnText,0.25));

	TopPlayers[2].Columns.AddItem(NewFColumnItem("#",0.05));
	TopPlayers[2].Columns.AddItem(NewFColumnItem(PlayerColumnText,0.7));
	TopPlayers[2].Columns.AddItem(NewFColumnItem(TotalExpColumnText,0.25));

	Super.InitMenu();
}

function ShowMenu()
{
	Super.ShowMenu();
	SetTimer(2,true);
	Timer();
}

function CloseMenu()
{
	Super.CloseMenu();
	SetTimer(0,false);
}

function ReceivedStat(byte ListNum, bool bFinal, string N, UniqueNetId UserID, int V)
{
	local int i;

	if (bFinal)
	{
		CurrentPageStatus[ListNum] = 1;
		bDownloadingPage = false;
	}
	else
	{
		i = ExtraInfo[ListNum].UserID.Length;
		TopPlayers[ListNum].AddLine((i+1)$"\n"$N$"\n"$(ListNum==0 ? FormatTimeSMH(V) : FormatInteger(V)),i,MakeSortStr(i)$"\n"$N$"\n"$MakeSortStr(V));
		ExtraInfo[ListNum].UserID.AddItem(UserID);
	}
}

function Timer()
{
	if (CurrentPageIndex==0)
		UpdatePlayerList(PlayersList,GetPlayer().WorldInfo.GRI);
	else if (CurrentPageStatus[CurrentPageIndex-1]==0 && !bDownloadingPage)
	{
		bDownloadingPage = true;
		ExtPlayerController(GetPlayer()).OnClientReceiveStat = ReceivedStat;
		ExtPlayerController(GetPlayer()).ServerRequestStats(CurrentPageIndex-1);
	}
}

static final function UpdatePlayerList(KFGUI_ColumnList PL, GameReplicationInfo GRI)
{
	local int i;
	local ExtPlayerReplicationInfo PRI;
	local string S;

	PL.EmptyList();
	if (GRI==None)
		return;
	for (i=0; i<GRI.PRIArray.Length; ++i)
	{
		PRI = ExtPlayerReplicationInfo(GRI.PRIArray[i]);
		if (PRI==None || PRI.bHiddenUser)
			continue;
		S = PRI.PlayerName;
		if (PRI.ShowAdminName())
			S $= " ("$PRI.GetAdminName()$")";
		PL.AddLine(S$"\n"$FormatInteger(PRI.RepKills)$"\n"$FormatInteger(PRI.RepEXP)$"\n"$FormatTimeSMH(PRI.RepPlayTime),PRI.PlayerID,S$"\n"$MakeSortStr(PRI.RepKills)$"\n"$MakeSortStr(PRI.RepEXP)$"\n"$MakeSortStr(PRI.RepPlayTime));
	}
}

static final function string FormatTimeSMH(float Sec)
{
	local int Seconds,Minutes,Hours,Days;
	local string S;

	Sec = Abs(Sec);
	Seconds = int(Sec);

	Minutes = Seconds/60;
	Seconds-=(Minutes*60);

	Hours = Minutes/60;
	Minutes-=(Hours*60);

	Days = Hours/24;
	Hours-=(Days*24);

	S = Hours$":"$(Minutes<10 ? "0"$Minutes : string(Minutes))$":"$(Seconds<10 ? "0"$Seconds : string(Seconds));
	if (Days>0)
		S = Days$"d "$S;
	return S;
}

static final function string FormatInteger(int Val)
{
	local string S,O;

	S = string(Val);
	Val = Len(S);
	if (Val<=3)
		return S;
	while (Val>3)
	{
		if (O=="")
			O = Right(S,3);
		else O = Right(S,3)$","$O;
		S = Left(S,Val-3);
		Val-=3;
	}
	if (Val>0)
		O = S$","$O;
	return O;
}

function ButtonClicked(KFGUI_Button Sender)
{
	if (CurrentPageIndex==Sender.IDValue)
		return;

	if (PreviousButton!=None)
		PreviousButton.bIsHighlighted = false;
	Sender.bIsHighlighted = true;
	PreviousButton = Sender;
	CurrentPageIndex = Sender.IDValue;
	MultiPager.SelectPageIndex(CurrentPageIndex);
	Timer();
}

function SelectedRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	local UniqueNetId Res;
	local PlayerReplicationInfo PRI;

	if (bRight || bDblClick)
	{
		if (CurrentPageIndex==0)
		{
			foreach GetPlayer().WorldInfo.GRI.PRIArray(PRI)
				if (PRI.PlayerID==Item.Value)
					break;
			if (PRI==None || PRI.PlayerID!=Item.Value || PRI.bBot)
				return;
			Res = PRI.UniqueId;
		}
		else Res = ExtraInfo[CurrentPageIndex-1].UserID[Item.Value];

		OnlineSubsystemSteamworks(class'GameEngine'.static.GetOnlineSubsystem()).ShowProfileUI(0,,Res);
	}
}

defaultproperties
{
	Begin Object Class=KFGUI_Button Name=B_ShowStats
		XPosition=0.05
		YPosition=0.05
		XSize=0.1
		YSize=0.045
		IDValue=0
		ID="Init"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object
	Begin Object Class=KFGUI_Button Name=B_ShowTopTime
		ID="BPlaytime"
		XPosition=0.35
		YPosition=0.05
		XSize=0.1
		YSize=0.045
		IDValue=1
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object
	Begin Object Class=KFGUI_Button Name=B_ShowTopKills
		ID="BKills"
		XPosition=0.6
		YPosition=0.05
		XSize=0.1
		YSize=0.045
		IDValue=2
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object
	Begin Object Class=KFGUI_Button Name=B_ShowTopEXP
		ID="BExp"
		XPosition=0.85
		YPosition=0.05
		XSize=0.1
		YSize=0.045
		IDValue=3
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object
	Components.Add(B_ShowStats)
	Components.Add(B_ShowTopTime)
	Components.Add(B_ShowTopKills)
	Components.Add(B_ShowTopEXP)

	Begin Object Class=KFGUI_SwitchComponent Name=MultiPager
		XPosition=0.05
		YPosition=0.12
		XSize=0.9
		YSize=0.85
		ID="Pager"
		Begin Object Class=KFGUI_ColumnList Name=PlayerList
			ID="Players"
			OnSelectedRow=SelectedRow
		End Object
		Begin Object Class=KFGUI_ColumnList Name=TopPlaytimes
			ID="PlayTimes"
			OnSelectedRow=SelectedRow
		End Object
		Begin Object Class=KFGUI_ColumnList Name=TopKills
			ID="Kills"
			OnSelectedRow=SelectedRow
		End Object
		Begin Object Class=KFGUI_ColumnList Name=TopExp
			ID="EXP"
			OnSelectedRow=SelectedRow
		End Object
		Components.Add(PlayerList)
		Components.Add(TopPlaytimes)
		Components.Add(TopKills)
		Components.Add(TopExp)
	End Object
	Components.Add(MultiPager)
}