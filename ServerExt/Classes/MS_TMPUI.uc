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

Class MS_TMPUI extends UIInteraction;

var UIInteraction RealUI;
var ObjectReferencer Referencer;

static final function Apply()
{
	local GameViewportClient G;
	local MS_TMPUI T;

	G = class'Engine'.Static.GetEngine().GameViewport;
	if (MS_TMPUI(G.UIController)!=None)
		return;
	T = new(G)class'MS_TMPUI';
	T.RealUI = G.UIController;
	T.UIManager = T.RealUI.UIManager;
	G.UIController = T;
}

static final function Remove()
{
	local GameViewportClient G;
	local MS_TMPUI T;

	G = class'Engine'.Static.GetEngine().GameViewport;
	T = MS_TMPUI(G.UIController);
	if (T==None)
		return;
	G.UIController = T.RealUI;
}

defaultproperties
{
	Begin Object Class=ObjectReferencer Name=MSGameReference
		ReferencedObjects.Add(class'MS_Game')
		ReferencedObjects.Add(class'MS_PC')
	End Object
	Referencer=MSGameReference
}