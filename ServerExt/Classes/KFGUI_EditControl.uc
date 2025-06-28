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

Class KFGUI_EditControl extends KFGUI_Clickable;

var export editinline KFGUI_TextLable TextLable;
var transient float TextHeight,TextScale;
var transient Font TextFont;
var Canvas.FontRenderInfo TextFontInfo;

var(Lable) float LableWidth;
var(Lable) string LableString;
var(Lable) color LableColor; // Label text color.
var(Lable) byte FontScale;
var(Lable) bool bScaleByFontSize; // Scale this component height by font height.

function InitMenu()
{
	if (LableString=="")
		TextLable = None;
	else
	{
		TextLable.SetText(LableString);
		TextLable.FontScale = FontScale;
		TextLable.XPosition = XPosition;
		TextLable.YPosition = YPosition;
		TextLable.XSize = (XSize*LableWidth*0.975);
		TextLable.YSize = YSize;
		TextLable.Owner = Owner;
		TextLable.TextColor = LableColor;
		TextLable.ParentComponent = Self;
		TextLable.InitMenu();
		XPosition+=(XSize*LableWidth);
		XSize*=(1.f-LableWidth);
	}
	Super.InitMenu();
	bClickable = !bDisabled;
}

function UpdateSizes()
{
	// Update height.
	if (bScaleByFontSize)
		YSize = ((TextHeight*1.05) + 6) / InputPos[3];
}

function PreDraw()
{
	local float XS;
	local byte i;

	Canvas.Font = Owner.CurrentStyle.PickFont(Min(FontScale+Owner.CurrentStyle.DefaultFontSize,Owner.CurrentStyle.MaxFontScale),TextScale);
	TextFont = Canvas.Font;
	Canvas.TextSize("ABC",XS,TextHeight,TextScale,TextScale);

	UpdateSizes();

	Super.PreDraw();
	if (TextLable!=None)
	{
		TextLable.YSize = YSize;
		TextLable.Canvas = Canvas;
		for (i=0; i<4; ++i)
			TextLable.InputPos[i] = InputPos[i];
		TextLable.PreDraw();
	}
}

final function DrawClippedText(string S, float TScale, float MaxX)
{
	local int i,l;
	local float X,XL,YL;

	l = Len(S);
	for (i=0; i<l; ++i)
	{
		Canvas.TextSize(Mid(S,i,1),XL,YL,TScale,TScale);
		if ((Canvas.CurX+X+XL)>MaxX)
		{
			--i;
			break;
		}
		X+=XL;
	}
	Canvas.DrawText(Left(S,i),,TScale,TScale,TextFontInfo);
}

defaultproperties
{
	LableColor=(R=255,G=255,B=255,A=255)
	FontScale=0
	LableWidth=0.5
	bScaleByFontSize=true
	TextFontInfo=(bClipText=true,bEnableShadow=true)

	Begin Object Class=KFGUI_TextLable Name=MyBoxLableText
		AlignX=0
		AlignY=1
		TextFontInfo=(bClipText=true,bEnableShadow=true)
	End Object
	TextLable=MyBoxLableText
}