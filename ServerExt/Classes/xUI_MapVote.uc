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

Class xUI_MapVote extends KFGUI_FloatingWindow;

var xVotingReplication RepInfo;
var KFGUI_ColumnList CurrentVotes,MapList;
var KFGUI_ComboBox GameModeCombo;
var KFGUI_RightClickMenu MapRClicker;
var KFGUI_Button CloseButton;
var int SelectedMapIndex;
var editinline export KFGUI_RightClickMenu MapRightClick;
var bool bFirstTime;

var localized string CloseButtonText;
var localized string CloseButtonToolTip;
var localized string ColumnMapName;
var localized string ColumnSequence;
var localized string ColumnPlayCount;
var localized string ColumnRating;
var localized string ColumnGame;
var localized string ColumnNumVotes;
var localized string Title;

function FColumnItem newFColumnItem(string Text, float Width)
{
	local FColumnItem newItem;
	newItem.Text=Text;
	newItem.Width=Width;
	return newItem;
}

function FRowItem newFRowItem(string Text, bool isDisabled)
{
	local FRowItem newItem;
	newItem.Text=Text;
	newItem.bDisabled=isDisabled;
	return newItem;
}

function InitMenu()
{
	Super.InitMenu();
	CurrentVotes = KFGUI_ColumnList(FindComponentID('Votes'));
	MapList = KFGUI_ColumnList(FindComponentID('Maps'));
	GameModeCombo = KFGUI_ComboBox(FindComponentID('Filter'));
	MapRClicker = KFGUI_RightClickMenu(FindComponentID('RClick'));
	CloseButton = KFGUI_Button(FindComponentID('Close'));

	// TODO: i18n this
	// I don't know why it's not working
	// MapRClicker.ItemRows.AddItem(newFRowItem("Vote this map", false));
	// MapRClicker.ItemRows.AddItem(newFRowItem("Admin force this map", true));

	// And this too:
	// GameModeCombo.LableString="Game mode:";
	// GameModeCombo.ToolTip="Select game mode to vote for.";

	CloseButton.ButtonText=CloseButtonText;
	CloseButton.ToolTip=CloseButtonToolTip;

	MapList.Columns.AddItem(newFColumnItem(ColumnMapName,0.5));
	MapList.Columns.AddItem(newFColumnItem(ColumnSequence,0.18));
	MapList.Columns.AddItem(newFColumnItem(ColumnPlayCount,0.18));
	MapList.Columns.AddItem(newFColumnItem(ColumnRating,0.14));

	CurrentVotes.Columns.AddItem(newFColumnItem(ColumnGame,0.2));
	CurrentVotes.Columns.AddItem(newFColumnItem(ColumnMapName,0.5));
	CurrentVotes.Columns.AddItem(newFColumnItem(ColumnNumVotes,0.15));
	CurrentVotes.Columns.AddItem(newFColumnItem(ColumnRating,0.15));

	WindowTitle=Title;
}

function CloseMenu()
{
	Super.CloseMenu();
	RepInfo = None;
}

function InitMapvote(xVotingReplication R)
{
	RepInfo = R;
}

function DrawMenu()
{
	Super.DrawMenu();

	if (RepInfo!=None && RepInfo.bListDirty)
	{
		RepInfo.bListDirty = false;
		UpdateList();
	}
}

final function UpdateList()
{
	local int i,g,m,Sel;
	local float V;
	local KFGUI_ListItem Item,SItem;

	if (GameModeCombo.Values.Length!=RepInfo.GameModes.Length)
	{
		GameModeCombo.Values.Length = RepInfo.GameModes.Length;
		for (i=0; i<GameModeCombo.Values.Length; ++i)
			GameModeCombo.Values[i] = RepInfo.GameModes[i].GameName;
		if (!bFirstTime)
		{
			bFirstTime = true;
			GameModeCombo.SelectedIndex = RepInfo.ClientCurrentGame;
		}
		ChangeToMaplist(GameModeCombo);
	}
	Item = CurrentVotes.GetFromIndex(CurrentVotes.SelectedRowIndex);
	Sel = (Item!=None ? Item.Value : -1);
	CurrentVotes.EmptyList();
	for (i=0; i<RepInfo.ActiveVotes.Length; ++i)
	{
		g = RepInfo.ActiveVotes[i].GameIndex;
		m = RepInfo.ActiveVotes[i].MapIndex;
		if (RepInfo.Maps[m].NumPlays==0)
			Item = CurrentVotes.AddLine(RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$RepInfo.ActiveVotes[i].NumVotes$"\n** NEW **",m,
										RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$MakeSortStr(RepInfo.ActiveVotes[i].NumVotes)$"\n"$MakeSortStr(0));
		else
		{
			V = (float(RepInfo.Maps[m].UpVotes) / float(RepInfo.Maps[m].UpVotes+RepInfo.Maps[m].DownVotes)) * 100.f;
			Item = CurrentVotes.AddLine(RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$RepInfo.ActiveVotes[i].NumVotes$"\n"$int(V)$"% ("$RepInfo.Maps[m].UpVotes$"/"$(RepInfo.Maps[m].UpVotes+RepInfo.Maps[m].DownVotes)$")",m,
										RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$MakeSortStr(RepInfo.ActiveVotes[i].NumVotes)$"\n"$MakeSortStr(int(V*100.f)));
		}
		if (Sel>=0 && Sel==m)
			SItem = Item;
	}

	// Keep same row selected if possible.
	CurrentVotes.SelectedRowIndex = (SItem!=None ? SItem.Index : -1);
}

function ChangeToMaplist(KFGUI_ComboBox Sender)
{
	local int i,g;
	local float V;

	if (RepInfo!=None)
	{
		MapList.EmptyList();
		g = Sender.SelectedIndex;
		for (i=0; i<RepInfo.Maps.Length; ++i)
		{
			if (!BelongsToPrefix(RepInfo.Maps[i].MapName,RepInfo.GameModes[g].Prefix))
				continue;
			if (RepInfo.Maps[i].NumPlays==0)
				MapList.AddLine(RepInfo.Maps[i].MapTitle$"\n"$RepInfo.Maps[i].Sequence$"\n"$RepInfo.Maps[i].NumPlays$"\n** NEW **",i,
								RepInfo.Maps[i].MapTitle$"\n"$MakeSortStr(RepInfo.Maps[i].Sequence)$"\n"$MakeSortStr(RepInfo.Maps[i].NumPlays)$"\n"$MakeSortStr(0));
			else
			{
				V = RepInfo.Maps[i].UpVotes+RepInfo.Maps[i].DownVotes;
				if (V==0)
					V = 100.f;
				else V = (float(RepInfo.Maps[i].UpVotes) / V) * 100.f;
				MapList.AddLine(RepInfo.Maps[i].MapTitle$"\n"$RepInfo.Maps[i].Sequence$"\n"$RepInfo.Maps[i].NumPlays$"\n"$int(V)$"% ("$RepInfo.Maps[i].UpVotes$"/"$(RepInfo.Maps[i].UpVotes+RepInfo.Maps[i].DownVotes)$")",i,
								RepInfo.Maps[i].MapTitle$"\n"$MakeSortStr(RepInfo.Maps[i].Sequence)$"\n"$MakeSortStr(RepInfo.Maps[i].NumPlays)$"\n"$MakeSortStr(int(V*100.f)));
			}
		}
	}
}

static final function bool BelongsToPrefix(string MN, string Prefix)
{
	return (Prefix=="" || Left(MN,Len(Prefix))~=Prefix);
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch (Sender.ID)
	{
	case 'Close':
		DoClose();
		break;
	}
}

function ClickedRow(int RowNum)
{
	if (RowNum==0) // Vote this map.
	{
		RepInfo.ServerCastVote(GameModeCombo.SelectedIndex,SelectedMapIndex,false);
	}
	else // Admin force this map.
	{
		RepInfo.ServerCastVote(GameModeCombo.SelectedIndex,SelectedMapIndex,true);
	}
}

function SelectedVoteRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if (bRight)
	{
		SelectedMapIndex = Item.Value;
		MapRightClick.ItemRows[1].bDisabled = (!GetPlayer().PlayerReplicationInfo.bAdmin);
		MapRightClick.OpenMenu(Self);
	}
	else if (bDblClick)
		RepInfo.ServerCastVote(GameModeCombo.SelectedIndex,Item.Value,false);
}

defaultproperties
{
	XPosition=0.2
	YPosition=0.1
	XSize=0.6
	YSize=0.8

	Begin Object Class=KFGUI_ColumnList Name=CurrentVotesList
		XPosition=0.015
		YPosition=0.075
		XSize=0.98
		YSize=0.25
		ID="Votes"
		OnSelectedRow=SelectedVoteRow
		bShouldSortList=true
		bLastSortedReverse=true
		LastSortedColumn=2
	End Object
	Begin Object Class=KFGUI_ColumnList Name=MapList
		XPosition=0.015
		YPosition=0.375
		XSize=0.98
		YSize=0.56
		ID="Maps"
		OnSelectedRow=SelectedVoteRow
	End Object
	Begin Object Class=KFGUI_ComboBox Name=GameModeFilter
		XPosition=0.1
		YPosition=0.325
		XSize=0.6
		YSize=0.05
		OnComboChanged=ChangeToMaplist
		ID="Filter"
		LableString="Game mode:"
		ToolTip="Select game mode to vote for."
	End Object
	Begin Object Class=KFGUI_Button Name=CloseButton
		XPosition=0.85
		YPosition=0.94
		XSize=0.1
		YSize=0.05
		ID="Close"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object

	Components.Add(CurrentVotesList)
	Components.Add(MapList)
	Components.Add(GameModeFilter)
	Components.Add(CloseButton)

	Begin Object Class=KFGUI_RightClickMenu Name=MapRClicker
		ID="RClick"
		ItemRows(0)=(Text="Vote this map")
		ItemRows(1)=(Text="Admin force this map",bDisabled=true)
		OnSelectedItem=ClickedRow
	End Object
	MapRightClick=MapRClicker
}
