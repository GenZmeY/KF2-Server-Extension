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

Class UIP_PerkSelection extends KFGUI_MultiComponent;

var KFGUI_List PerkList;
var KFGUI_Button B_Prestige, B_Reset, B_Unload;
var KFGUI_ComponentList StatsList;
var UIR_PerkTraitList TraitsList;
var KFGUI_TextLable PerkLabel;
var ExtPerkManager CurrentManager;
var Ext_PerkBase PendingPerk,OldUsedPerk;
var class<Ext_PerkBase> PrevPendingPerk;
var array<UIR_PerkStat> StatBuyers;
var int OldPerkPoints;

var localized string PrestigeButtonText;
var localized string PrestigeButtonToolTip;
var localized string ResetButtonText;
var localized string ResetButtonToolTip;
var localized string UnloadButtonText;
var localized string UnloadButtonToolTip;
var localized string PrestigeButtonDisabledToolTip;
var localized string Level;
var localized string Points;
var localized string NoPerkSelected;
var localized string NotAviable;
var localized string MaxStr;

function InitMenu()
{
	PerkList = KFGUI_List(FindComponentID('Perks'));
	StatsList = KFGUI_ComponentList(FindComponentID('Stats'));
	TraitsList = UIR_PerkTraitList(FindComponentID('Traits'));
	PerkLabel = KFGUI_TextLable(FindComponentID('Info'));
	PerkLabel.SetText("");
	B_Prestige = KFGUI_Button(FindComponentID('Prestige'));
	B_Reset = KFGUI_Button(FindComponentID('Reset'));
	B_Unload = KFGUI_Button(FindComponentID('Unload'));

	B_Prestige.ButtonText=PrestigeButtonText;
	B_Prestige.ToolTip="-";

	B_Unload.ButtonText=UnloadButtonText;
	B_Unload.ToolTip=UnloadButtonToolTip;

	B_Reset.ButtonText=ResetButtonText;
	B_Reset.ToolTip=ResetButtonToolTip;

	Super.InitMenu();
}

function ShowMenu()
{
	Super.ShowMenu();
	SetTimer(0.1,true);
	Timer();
}

function CloseMenu()
{
	Super.CloseMenu();
	CurrentManager = None;
	PrevPendingPerk = (PendingPerk!=None ? PendingPerk.Class : None);
	PendingPerk = None;
	OldUsedPerk = None;
	SetTimer(0,false);
}

function Timer()
{
	local int i;

	CurrentManager = ExtPlayerController(GetPlayer()).ActivePerkManager;
	if (CurrentManager!=None)
	{
		if (PrevPendingPerk!=None)
		{
			PendingPerk = CurrentManager.FindPerk(PrevPendingPerk);
			PrevPendingPerk = None;
		}
		PerkList.ChangeListSize(CurrentManager.UserPerks.Length);
		if (PendingPerk!=None && !PendingPerk.bPerkNetReady)
			return;

		// Huge code block to handle stat updating, but actually pretty well optimized.
		if (PendingPerk!=OldUsedPerk)
		{
			OldUsedPerk = PendingPerk;
			if (PendingPerk!=None)
			{
				OldPerkPoints = -1;
				if (StatsList.ItemComponents.Length!=PendingPerk.PerkStats.Length)
				{
					if (StatsList.ItemComponents.Length<PendingPerk.PerkStats.Length)
					{
						for (i=StatsList.ItemComponents.Length; i<PendingPerk.PerkStats.Length; ++i)
						{
							if (i>=StatBuyers.Length)
							{
								StatBuyers[StatBuyers.Length] = UIR_PerkStat(StatsList.AddListComponent(class'UIR_PerkStat'));
								StatBuyers[i].StatIndex = i;
								StatBuyers[i].InitMenu();
							}
							else
							{
								StatsList.ItemComponents.Length = i+1;
								StatsList.ItemComponents[i] = StatBuyers[i];
							}
						}
					}
					else if (StatsList.ItemComponents.Length>PendingPerk.PerkStats.Length)
					{
						for (i=PendingPerk.PerkStats.Length; i<StatsList.ItemComponents.Length; ++i)
							StatBuyers[i].CloseMenu();
						StatsList.ItemComponents.Length = PendingPerk.PerkStats.Length;
					}
				}
				OldPerkPoints = PendingPerk.CurrentSP;
				PerkLabel.SetText(Level$PendingPerk.GetLevelString()@PendingPerk.PerkName@"("$Points@PendingPerk.CurrentSP$")");
				for (i=0; i<StatsList.ItemComponents.Length; ++i) // Just make sure perk stays the same.
				{
					StatBuyers[i].SetActivePerk(PendingPerk);
					StatBuyers[i].CheckBuyLimit();
				}
				B_Prestige.SetDisabled(!PendingPerk.CanPrestige());
				if (PendingPerk.MinLevelForPrestige<0)
					B_Prestige.ChangeToolTip(PrestigeButtonDisabledToolTip);
				else B_Prestige.ChangeToolTip(PrestigeButtonToolTip$" "$PendingPerk.MinLevelForPrestige);
				UpdateTraits();
			}
			else // Empty out if needed.
			{
				for (i=0; i<StatsList.ItemComponents.Length; ++i)
					StatBuyers[i].CloseMenu();
				StatsList.ItemComponents.Length = 0;
				PerkLabel.SetText(NoPerkSelected);
			}
		}
		else if (PendingPerk!=None && OldPerkPoints!=PendingPerk.CurrentSP)
		{
			B_Prestige.SetDisabled(!PendingPerk.CanPrestige());

			OldPerkPoints = PendingPerk.CurrentSP;
			PerkLabel.SetText(Level$PendingPerk.GetLevelString()@PendingPerk.PerkName@"("$Points@PendingPerk.CurrentSP$")");
			for (i=0; i<StatsList.ItemComponents.Length; ++i) // Just make sure perk stays the same.
				StatBuyers[i].CheckBuyLimit();

			// Update traits list.
			UpdateTraits();
		}
	}
}

final function UpdateTraits()
{
	local array< class<Ext_TGroupBase> > CatList;
	local class<Ext_TGroupBase> N;
	local Ext_TGroupBase N_obj;
	local int i,j;
	local class<Ext_TraitBase> TC;
	local string S;

	// A bit hacky to delete and refill list again, but at least it works...
	TraitsList.EmptyList();
	TraitsList.ToolTip.Length = 0;

	CatList.AddItem(None);

	// First gather all the categories available.
	for (i=0; i<PendingPerk.PerkTraits.Length; ++i)
	{
		N = PendingPerk.PerkTraits[i].TraitType.Default.TraitGroup;
		if (N!=None && CatList.Find(N)==-1)
			CatList.AddItem(N);
	}

	for (j=0; j<CatList.Length; ++j)
	{
		N = CatList[j];
		if (j>0)
		{
			N_obj = new N;
			TraitsList.AddLine("--"$N_obj.GetUIInfo(PendingPerk),-1);
			TraitsList.ToolTip.AddItem(N_obj.GetUIDesc());
		}
		for (i=0; i<PendingPerk.PerkTraits.Length; ++i)
		{
			TC = PendingPerk.PerkTraits[i].TraitType;
			if (TC.Default.TraitGroup==N)
			{
				if (PendingPerk.PerkTraits[i].CurrentLevel>=TC.Default.NumLevels)
					S = MaxStr$"\n"$NotAviable;
				else
				{
					S = PendingPerk.PerkTraits[i].CurrentLevel$"/"$TC.Default.NumLevels$"\n";
					if (TC.Static.MeetsRequirements(PendingPerk.PerkTraits[i].CurrentLevel,PendingPerk))
						S $= string(TC.Static.GetTraitCost(PendingPerk.PerkTraits[i].CurrentLevel));
					else S $= NotAviable;
				}
				TraitsList.AddLine(TC.Default.TraitName$"\n"$S,i);
				TraitsList.ToolTip.AddItem(TC.Static.GetTooltipInfo());
			}
		}
	}
}

function DrawPerkInfo(Canvas C, int Index, float YOffset, float Height, float Width, bool bFocus)
{
	local Ext_PerkBase P;
	local float Sc;

	if (CurrentManager==None || Index>=CurrentManager.UserPerks.Length)
		return;
	P = CurrentManager.UserPerks[Index];
	if (P.Class==ExtPlayerReplicationInfo(GetPlayer().PlayerReplicationInfo).ECurrentPerk)
	{
		if (PendingPerk==None)
			PendingPerk = P;
		C.SetDrawColor(164,164,32);
	}
	else if (P==PendingPerk)
		C.SetDrawColor(164,86,32);
	else C.SetDrawColor(32,32,128);

	if (bFocus)
	{
		C.DrawColor.R+=15;
		C.DrawColor.G+=15;
		C.DrawColor.B+=15;
	}
	C.SetPos(0,YOffset);
	Owner.CurrentStyle.DrawWhiteBox(Width,Height);

	C.SetDrawColor(240,240,240);
	C.SetPos(2,YOffset);
	C.DrawRect(Height,Height,P.PerkIcon);

	C.SetPos(6+Height,YOffset);
	C.Font = Owner.CurrentStyle.PickFont(Max(Owner.CurrentStyle.DefaultFontSize-1,0),Sc);
	C.DrawText(P.PerkName,,Sc,Sc);

	C.SetPos(6+Height,YOffset+Height*0.5);
	C.DrawText("Lv "$P.GetLevelString()$" ("$P.CurrentEXP$"/"$P.NextLevelEXP$" XP)",,Sc,Sc); // TODO: Localization
}

function SwitchedPerk(int Index, bool bRight, int MouseX, int MouseY)
{
	if (CurrentManager==None || Index>=CurrentManager.UserPerks.Length)
		return;

	PendingPerk = CurrentManager.UserPerks[Index];
	ExtPlayerController(GetPlayer()).SwitchToPerk(PendingPerk.Class);
}

function ShowTraitInfo(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	local UIR_TraitInfoPopup T;
	if ((bRight || bDblClick) && Item.Value>=0)
	{
		T = UIR_TraitInfoPopup(Owner.OpenMenu(class'UIR_TraitInfoPopup'));
		T.ShowTraitInfo(Item.Value,PendingPerk);
	}
}

function ButtonClicked(KFGUI_Button Sender)
{
	local KFGUI_Page T;

	switch (Sender.ID)
	{
	case 'Reset':
		if (PendingPerk!=None)
		{
			T = Owner.OpenMenu(class'UI_ResetWarning');
			UI_ResetWarning(T).SetupTo(PendingPerk);
		}
		break;
	case 'Unload':
		if (PendingPerk!=None)
		{
			T = Owner.OpenMenu(class'UI_UnloadInfo');
			UI_UnloadInfo(T).SetupTo(PendingPerk.Class);
		}
		break;
	case 'Prestige':
		if (PendingPerk!=None)
		{
			T = Owner.OpenMenu(class'UI_PrestigeNote');
			UI_PrestigeNote(T).SetupTo(PendingPerk);
		}
		break;
	}
}

defaultproperties
{
	Begin Object Class=KFGUI_List Name=PerksList
		ID="Perks"
		XPosition=0
		YPosition=0
		XSize=0.25
		YSize=1
		ListItemsPerPage=12
		bClickable=true
		OnDrawItem=DrawPerkInfo
		OnClickedItem=SwitchedPerk
	End Object

	Begin Object Class=KFGUI_ComponentList Name=PerkStats
		ID="Stats"
		XPosition=0.25
		YPosition=0.12
		XSize=0.375
		YSize=0.88
		ListItemsPerPage=16
	End Object

	Begin Object Class=UIR_PerkTraitList Name=PerkTraits
		ID="Traits"
		XPosition=0.625
		YPosition=0.12
		XSize=0.375
		YSize=0.88
		OnSelectedRow=ShowTraitInfo
	End Object

	Begin Object Class=KFGUI_TextLable Name=CurPerkLabel
		ID="Info"
		XPosition=0.4
		YPosition=0
		XSize=0.58
		YSize=0.12
		AlignX=1
		AlignY=1
		TextFontInfo=(bClipText=true)
	End Object

	Begin Object Class=KFGUI_Button Name=ResetPerkButton
		ID="Reset"
		XPosition=0.25
		YPosition=0.025
		XSize=0.074
		YSize=0.045
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		ExtravDir=1
	End Object
	Begin Object Class=KFGUI_Button Name=UnloadPerkButton
		ID="Unload"
		XPosition=0.325
		YPosition=0.025
		XSize=0.074
		YSize=0.045
		ExtravDir=1
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
	End Object
	Begin Object Class=KFGUI_Button Name=PrestigePerkButton
		ID="Prestige"
		XPosition=0.4
		YPosition=0.025
		XSize=0.074
		YSize=0.045
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		bDisabled=true
	End Object

	Components.Add(PerksList)
	Components.Add(PerkStats)
	Components.Add(PerkTraits)
	Components.Add(CurPerkLabel)
	Components.Add(ResetPerkButton)
	Components.Add(UnloadPerkButton)
	Components.Add(PrestigePerkButton)
}