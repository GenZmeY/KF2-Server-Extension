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

Class KFGUI_EditBox extends KFGUI_EditControl;

var string Value;
var int TypePos,ScrollOffset;

var() int MaxTextLength;
var() color TextColor;

var bool bIsTyping,bAllSelected,bTextDirty,bHoldCtrl;

delegate OnTextChange(KFGUI_EditBox Sender);
delegate bool OnHitEnter(KFGUI_EditBox Sender); // Return true to keep focus.

function ChangeValue(string V)
{
	Value = V;
	TypePos = Len(V);
	ScrollOffset = 0;
}

function InitMenu()
{
	Super.InitMenu();
	bClickable = !bDisabled;
}

function DrawMenu()
{
	local float X,Y,XS,YS;
	local Color C;

	Owner.CurrentStyle.RenderEditBox(Self);

	if (bDisabled)
		C = TextColor*(0.5f);
	else C = TextColor;

	X = TextHeight*0.025f + 5.f;
	Y = (CompPos[3]-TextHeight)*0.5f;

	if (bIsTyping)
	{
		XS = Owner.MenuTime % 1.f;
		if (XS>0.5f)
			XS = (1.f-XS);
		Canvas.DrawColor = C*(Sin(XS*2.f*Pi)*0.45f);

		if (bAllSelected)
		{
			Canvas.TextSize(Mid(Value,ScrollOffset),XS,YS,TextScale,TextScale);
			Canvas.SetPos(X,Y);
			Canvas.DrawTile(class'WorldInfo'.Default.WhiteSquareTexture,FMin(XS,CompPos[2]-(X*2)),TextHeight,0,0,1,1,,,BLEND_Additive);
		}
		else
		{
			if (ScrollOffset>(TypePos-4))
				ScrollOffset = Max(TypePos-4,0);

Retry:
			Canvas.TextSize(Mid(Value,ScrollOffset,TypePos-ScrollOffset),XS,YS,TextScale,TextScale);
			Canvas.SetPos(X+XS,Y);

			if (Canvas.CurX<(CompPos[2]-X))
				Canvas.DrawText("|",,TextScale,TextScale,TextFontInfo);
			else
			{
				++ScrollOffset; // Keep scrolling forward until we find space.
				goto'Retry';
			}
		}
	}
	if (Value!="")
	{
		Canvas.DrawColor = C;
		Canvas.SetPos(X,Y);
		if (ScrollOffset>5)
			ScrollOffset = Min(ScrollOffset,Len(Value)-6);
		DrawClippedText(Mid(Value,ScrollOffset),TextScale,CompPos[2]);

		// FIXME: PushMaskRegion is broken in KF2?!
		//Canvas.PushMaskRegion(Canvas.OrgX,Canvas.OrgY,Canvas.ClipX-4,Canvas.ClipY);
		//Canvas.DrawText(Mid(Value,ScrollOffset),,TextScale,TextScale,TextFontInfo);
		//Canvas.PopMaskRegion();
	}
}

function bool NotifyInputKey(int ControllerId, name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
	if (Owner.CheckMouse(Key,Event))
		return true;
	if (Key=='LeftControl')
	{
		bHoldCtrl = (Event!=IE_Released);
	}
	else if (Event == IE_Released)
	{
		if (Key=='Escape' || Key=='Enter')
		{
			if (Key=='Enter' && OnHitEnter(Self))
				return true;
			ReleaseKeyFocus();
		}
	}
	else if (Event==IE_Pressed || Event==IE_Repeat)
	{
		if (Key=='backspace')
		{
			if (bAllSelected)
			{
				bTextDirty = (Value!="");
				Value = "";
				TypePos = 0;
				bAllSelected = false;
			}
			else if (TypePos>0)
			{
				bTextDirty = true;
				if (TypePos==Len(Value))
					Value = Left(Value,TypePos-1);
				else Value = Left(Value,TypePos-1)$Mid(Value,TypePos);
				--TypePos;
			}
		}
		else if (Key=='delete')
		{
			if (bAllSelected)
			{
				bTextDirty = (Value!="");
				Value = "";
				TypePos = 0;
				bAllSelected = false;
			}
			else if (TypePos<Len(Value))
			{
				bTextDirty = true;
				if (TypePos==0)
					Value = Mid(Value,1);
				else Value = Left(Value,TypePos)$Mid(Value,TypePos+1);
			}
		}
		else if (Key=='left')
		{
			if (bAllSelected)
			{
				bAllSelected = false;
				TypePos = 0;
			}
			else TypePos = Max(TypePos-1,0);
		}
		else if (Key=='right')
		{
			if (bAllSelected)
			{
				bAllSelected = false;
				TypePos = Len(Value);
			}
			else TypePos = Min(TypePos+1,Len(Value));
		}
		else if (Key=='home')
		{
			if (bAllSelected)
			{
				bAllSelected = false;
				TypePos = 0;
			}
			else TypePos = 0;
		}
		else if (Key=='end')
		{
			if (bAllSelected)
			{
				bAllSelected = false;
				TypePos = Len(Value);
			}
			else TypePos = Len(Value);
		}
		else if (Key=='C' && bHoldCtrl)
			GetPlayer().CopyToClipboard(Value);
		else if (Key=='V' && bHoldCtrl)
			PasteText();
		else if (Key=='X' && bHoldCtrl)
		{
			bTextDirty = true;
			GetPlayer().CopyToClipboard(Value);
			Value = "";
			TypePos = 0;
		}
	}
	return true;
}

final function PasteText()
{
	local string S;

	S = GetPlayer().PasteFromClipboard();
	if ((bAllSelected ? (Len(Value)+Len(S)) : Len(S))>MaxTextLength)
		return;
	bTextDirty = true;
	if (bAllSelected)
	{
		bAllSelected = false;
		Value = S;
		TypePos = 0;
	}
	else if (TypePos==Len(Value))
		Value $= S;
	else Value = Left(Value,TypePos) $ S $ Mid(Value,TypePos);
	TypePos+=Len(S);
}

function bool NotifyInputChar(int ControllerId, string Unicode)
{
	if ((!bAllSelected && Len(Value)>=MaxTextLength) || (bHoldCtrl && (Unicode~="C" || Unicode~="X" || Unicode~="V")))
		return true;
	if (Asc(Unicode)>=32) // Skip system characters.
	{
		bTextDirty = true;
		if (bAllSelected)
		{
			bAllSelected = false;
			Value = Unicode;
			TypePos = 0;
		}
		else if (TypePos==Len(Value))
			Value $= Unicode;
		else Value = Left(Value,TypePos) $ Unicode $ Mid(Value,TypePos);
		++TypePos;
	}
	return true;
}

function HandleMouseClick(bool bRight)
{
	PlayMenuSound(MN_ClickButton);
	if (bIsTyping)
	{
		if (Value!="")
			bAllSelected = !bAllSelected;
	}
	else
	{
		bIsTyping = true;
		bAllSelected = (Value!="");
		GrabKeyFocus();
	}
	TypePos = Len(Value);
}

function LostKeyFocus()
{
	if (bTextDirty)
	{
		OnTextChange(Self);
		bTextDirty = false;
	}
	bHoldCtrl = false;
	bIsTyping = false;
}

defaultproperties
{
	MaxTextLength=2147483638
	TextColor=(R=255,G=255,B=255,A=255)
}