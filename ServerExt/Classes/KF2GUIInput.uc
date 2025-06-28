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

// Input while in a menu.
class KF2GUIInput extends KFPlayerInput;

var KF2GUIController ControllerOwner;
var PlayerInput BaseInput;

function DrawHUD(HUD H)
{
	//ControllerOwner.RenderMenu(H.Canvas);
}

function PostRender(Canvas Canvas)
{
	if (ControllerOwner.bIsInMenuState)
		ControllerOwner.HandleDrawMenu();
		//ControllerOwner.RenderMenu(Canvas);
}

// Postprocess the player's input.
function PlayerInput(float DeltaTime)
{
	// Do not move.
	ControllerOwner.MenuInput(DeltaTime);

	if (!ControllerOwner.bAbsorbInput)
	{
		aMouseX = 0;
		aMouseY = 0;
		aBaseX = BaseInput.aBaseX;
		aBaseY = BaseInput.aBaseY;
		aBaseZ = BaseInput.aBaseZ;
		aForward = BaseInput.aForward;
		aTurn = BaseInput.aTurn;
		aStrafe = BaseInput.aStrafe;
		aUp = BaseInput.aUp;
		aLookUp = BaseInput.aLookUp;
		Super.PlayerInput(DeltaTime);
	}
	else
	{
		aMouseX = 0;
		aMouseY = 0;
		aBaseX = 0;
		aBaseY = 0;
		aBaseZ = 0;
		aForward = 0;
		aTurn = 0;
		aStrafe = 0;
		aUp = 0;
		aLookUp = 0;
	}
}

function PreClientTravel(string PendingURL, ETravelType TravelType, bool bIsSeamlessTravel)
{
	ControllerOwner.BackupInput.PreClientTravel(PendingURL,TravelType,bIsSeamlessTravel); // Let original mod do stuff too!
	ControllerOwner.NotifyLevelChange(); // Close menu NOW!
}

defaultproperties
{

}