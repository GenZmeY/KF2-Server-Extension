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

Class ExtGUI_PerkSelectionPage extends UI_MidGameMenu;

function InitMenu()
{
	local byte i;
	local KFGUI_Button B;

	PageSwitcher = KFGUI_SwitchMenuBar(FindComponentID('Pager'));
	Super(KFGUI_Page).InitMenu();

	for (i=0; i<Pages.Length; ++i)
	{
		PageSwitcher.AddPage(Pages[i],B).InitMenu();
	}
}

function ShowMenu()
{
	Super(KFGUI_FloatingWindow).ShowMenu();
}

function PreDraw()
{
	local GameViewportClient Viewport;
	local ExtMoviePlayer_Manager MovieManager;

	Super.PreDraw();

	Viewport = LocalPlayer(GetPlayer().Player).ViewportClient;
	MovieManager = ExtMoviePlayer_Manager(KFPlayerController(GetPlayer()).MyGFxManager);
	if (CaptureMouse())
	{
		Viewport.bDisplayHardwareMouseCursor = true;
		Viewport.ForceUpdateMouseCursor(true);

		MovieManager.SetMovieCanReceiveInput(false);
	}
	else if (Viewport.bDisplayHardwareMouseCursor)
	{
		Viewport.bDisplayHardwareMouseCursor = false;
		Viewport.ForceUpdateMouseCursor(true);

		MovieManager.SetMovieCanReceiveInput(true);
	}
}

function UserPressedEsc();

defaultproperties
{
	WindowTitle=""
	XPosition=0.01
	XSize=0.73
	YSize=0.73

	Pages.Empty
	Pages.Add(Class'UIP_PerkSelectionLobby')
}