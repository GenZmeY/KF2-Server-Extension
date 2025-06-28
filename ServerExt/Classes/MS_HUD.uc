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

Class MS_HUD extends HUD;

var localized string PressEscToCancel;
var localized string AdjustSensetive;

var bool bShowProgress,bProgressDC;
var array<string> ProgressLines;
var MX_MiniGameBase ActiveGame;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	ActiveGame = new (PlayerController(Owner)) class'MX_PongGame';
	ActiveGame.Init();
	ActiveGame.SetFXTrack(class'MS_PC'.Default.TravelData.PendingFX);
}

event PostRender()
{
	ActiveGame.Canvas = Canvas;
	ActiveGame.Render(Canvas.ClipX*0.1,Canvas.ClipY*0.2,Canvas.ClipX*0.8,Canvas.ClipY*0.7);
	ActiveGame.Canvas = None;
	if (bShowProgress)
		RenderProgress();
}

function Tick(float Delta)
{
	ActiveGame.Tick(Delta);
}

final function ShowProgressMsg(string S, optional bool bDis)
{
	if (S=="")
	{
		bShowProgress = false;
		return;
	}
	bShowProgress = true;
	ParseStringIntoArray(S,ProgressLines,"|",false);
	bProgressDC = bDis;
	if (!bDis)
		ProgressLines.AddItem(PressEscToCancel);
}

final function RenderProgress()
{
	local float Y,XL,YL,Sc;
	local int i;

	Canvas.Font = Font(DynamicLoadObject("UI_Canvas_Fonts.Font_Main",class'Font'));
	Sc = FMin(Canvas.ClipY/1000.f,3.f);
	if (bProgressDC)
		Canvas.SetDrawColor(255,80,80,255);
	else Canvas.SetDrawColor(255,255,255,255);
	Y = Canvas.ClipY*0.05;

	for (i=0; i<ProgressLines.Length; ++i)
	{
		Canvas.TextSize(ProgressLines[i],XL,YL,Sc,Sc);
		Canvas.SetPos((Canvas.ClipX-XL)*0.5,Y);
		Canvas.DrawText(ProgressLines[i],,Sc,Sc);
		Y+=YL;
	}
	Canvas.SetPos(Canvas.ClipX*0.2,Canvas.ClipY*0.91);
	Canvas.DrawText(AdjustSensetive@(ActiveGame.Sensitivity*100.f)$"%",,Sc,Sc);
}

defaultproperties
{

}