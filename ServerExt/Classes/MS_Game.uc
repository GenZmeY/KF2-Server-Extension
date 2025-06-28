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

// Minimal intermission gametype.
Class MS_Game extends GameInfo;

event Timer();

event InitGame(string Options, out string ErrorMessage)
{
	MaxPlayers = 99;
	MaxSpectators = 99;
	class'MS_TMPUI'.Static.Remove();
}

// Add or remove reference to this game for GC
static final function SetReference()
{
	class'MS_TMPUI'.Static.Apply();
}

event PlayerController Login(string Portal, string Options, const UniqueNetID UniqueID, out string ErrorMessage)
{
	local NavigationPoint StartSpot;
	local PlayerController NewPlayer;
	local rotator SpawnRotation;

	// Find a start spot.
	StartSpot = FindPlayerStart(None, 255, Portal);
	SpawnRotation.Yaw = StartSpot.Rotation.Yaw;
	NewPlayer = SpawnPlayerController(StartSpot.Location, SpawnRotation);

	NewPlayer.GotoState('PlayerWaiting');
	return newPlayer;
}

event PostLogin(PlayerController NewPlayer)
{
	GenericPlayerInitialization(NewPlayer);
}

function GenericPlayerInitialization(Controller C)
{
	local PlayerController PC;

	PC = PlayerController(C);
	if (PC != None)
		PC.ClientSetHUD(HudType);
}

defaultproperties
{
	PlayerControllerClass=class'MS_PC'
	HUDType=class'MS_HUD'
}