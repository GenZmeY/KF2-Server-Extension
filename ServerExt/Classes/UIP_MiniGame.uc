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

Class UIP_MiniGame extends KFGUI_MultiComponent;

var MX_MiniGameBase ActiveGame;
var transient float LastUpdateTime;
var WorldInfo Level;

function ShowMenu()
{
	Super.ShowMenu();

	Level = GetPlayer().WorldInfo;
	LastUpdateTime = Level.RealTimeSeconds;
	if (ActiveGame==None)
	{
		ActiveGame = new (GetPlayer()) class'MX_PongGame';
		ActiveGame.Init();
		ActiveGame.SetFXTrack(ExtPlayerController(GetPlayer()).BonusFX);
		ActiveGame.StartGame();
	}
}

function DrawMenu()
{
	// Update input.
	ActiveGame.SetMouse(Owner.MousePosition.X-CompPos[0],Owner.MousePosition.Y-CompPos[1]);

	// Handle tick.
	ActiveGame.Tick(FMin(Level.RealTimeSeconds-LastUpdateTime,0.05));
	LastUpdateTime = Level.RealTimeSeconds;

	// Draw background.
	Canvas.SetPos(0,0);
	Canvas.SetDrawColor(0,0,0,255);
	Canvas.DrawTile(Canvas.DefaultTexture,CompPos[2],CompPos[3],0,0,1,1);

	// Draw minigame
	ActiveGame.Canvas = Canvas;
	ActiveGame.Render(0,0,CompPos[2],CompPos[3]);
	ActiveGame.Canvas = None;
}

defaultproperties
{
}