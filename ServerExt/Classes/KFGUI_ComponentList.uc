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

// List box with components as items.
Class KFGUI_ComponentList extends KFGUI_List;

var int VisRange[2];
var() int NumColumns;
var array<KFGUI_Base> ItemComponents;

// REMEMBER to call InitMenu() on the newly created component after values are init!!!
final function KFGUI_Base AddListComponent(class<KFGUI_Base> CompClass, optional float XS=1.f, optional float YS=1.f)
{
	local KFGUI_Base G;

	G = new(Self)CompClass;
	if (G==None)
		return None;
	G.XPosition = (1.f - XS) * 0.5f;
	G.YPosition = (1.f - YS) * 0.5f;
	G.XSize = XS;
	G.YSize = YS;
	G.Owner = Owner;
	G.ParentComponent = Self;
	ItemComponents[ItemComponents.Length] = G;
	return G;
}

function EmptyList()
{
	ItemComponents.Length = 0;
}

function InitMenu()
{
	Super.InitMenu();
	ListCount = 0;
	NumColumns = Max(NumColumns,1);
}

function DrawMenu()
{
	Canvas.DrawColor = BackgroundColor;
	Canvas.SetPos(0.f,0.f);
	Owner.CurrentStyle.DrawWhiteBox(CompPos[2],CompPos[3]);
}

function PreDraw()
{
	local int i,XNum,r;
	local byte j;
	local float XS,YS;

	ComputeCoords();

	// Update list size
	i = ItemComponents.Length / NumColumns;
	if (i!=NumColumns)
	{
		ListCount = i;
		UpdateListVis();
	}

	// First draw scrollbar to allow it to resize itself.
	for (j=0; j<4; ++j)
		ScrollBar.InputPos[j] = CompPos[j];
	if (OldXSize!=InputPos[2])
	{
		OldXSize = InputPos[2];
		ScrollBar.XPosition = 1.f - ScrollBar.GetWidth();
	}
	ScrollBar.Canvas = Canvas;
	ScrollBar.PreDraw();

	// Then downscale our selves to give room for scrollbar.
	CompPos[2] -= ScrollBar.CompPos[2];
	Canvas.SetOrigin(CompPos[0],CompPos[1]);
	Canvas.SetClip(CompPos[0]+CompPos[2],CompPos[1]+CompPos[3]);
	DrawMenu();

	// Then draw rest of components.
	XNum = 0;
	r = 0;
	XS = CompPos[2] / NumColumns;
	YS = CompPos[3] / ListItemsPerPage;
	VisRange[0] = (ScrollBar.CurrentScroll*NumColumns);
	VisRange[1] = ItemComponents.Length;
	for (i=VisRange[0]; i<VisRange[1]; ++i)
	{
		ItemComponents[i].Canvas = Canvas;
		ItemComponents[i].InputPos[0] = CompPos[0]+XS*XNum;
		ItemComponents[i].InputPos[1] = CompPos[1]+YS*r;
		ItemComponents[i].InputPos[2] = XS;
		ItemComponents[i].InputPos[3] = YS;
		ItemComponents[i].PreDraw();

		if (++XNum==NumColumns)
		{
			XNum = 0;
			if (++r==ListItemsPerPage)
			{
				VisRange[1] = i+1;
				break;
			}
		}
	}
	CompPos[2] += ScrollBar.CompPos[2];
}

function ChangeListSize(int NewSize);

function MouseClick(bool bRight);
function MouseRelease(bool bRight);
function MouseLeave()
{
	Super(KFGUI_Base).MouseLeave();
}

function MouseEnter()
{
	Super(KFGUI_Base).MouseEnter();
}

function bool CaptureMouse()
{
	local int i;

	for (i=VisRange[0]; i<VisRange[1] && i<ItemComponents.Length; ++i)
		if (ItemComponents[i].CaptureMouse())
		{
			MouseArea = ItemComponents[i];
			return true;
		}
	return Super.CaptureMouse();
}

function CloseMenu()
{
	local int i;

	for (i=0; i<ItemComponents.Length; ++i)
		ItemComponents[i].CloseMenu();
	Super.CloseMenu();
}

function NotifyLevelChange()
{
	local int i;

	for (i=0; i<ItemComponents.Length; ++i)
		ItemComponents[i].NotifyLevelChange();
	Super.NotifyLevelChange();
}

function MenuTick(float DeltaTime)
{
	local int i;

	Super.MenuTick(DeltaTime);
	for (i=0; i<ItemComponents.Length; ++i)
		ItemComponents[i].MenuTick(DeltaTime);
}

defaultproperties
{
	ListCount=0
	NumColumns=1
	bClickable=true
}