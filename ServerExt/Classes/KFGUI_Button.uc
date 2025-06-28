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

Class KFGUI_Button extends KFGUI_Clickable;

var() Canvas.CanvasIcon OverlayTexture;
var() string ButtonText;
var() color TextColor;
var() Canvas.FontRenderInfo TextFontInfo;
var() byte FontScale,ExtravDir;
var bool bIsHighlighted;

function DrawMenu()
{
	Owner.CurrentStyle.RenderButton(Self);
}

function HandleMouseClick(bool bRight)
{
	PlayMenuSound(MN_ClickButton);
	if (bRight)
		OnClickRight(Self);
	else OnClickLeft(Self);
}

Delegate OnClickLeft(KFGUI_Button Sender);
Delegate OnClickRight(KFGUI_Button Sender);

defaultproperties
{
	ButtonText="Button!"
	TextColor=(R=255,G=255,B=255,A=255)
	TextFontInfo=(bClipText=true,bEnableShadow=true)
	FontScale=1
}