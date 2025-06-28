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

// Written by Marco.
class ExtProj_SUPERMolotov extends KFProj_MolotovGrenade;

defaultproperties
{
	Speed=2500
	TerminalVelocity=3500
	TossZ=450

	bCanDisintegrate=false
	DrawScale=2.5

	NumResidualFlames=10
	ResidualFlameProjClass=class'ExtProj_SUPERMolotovS'

	// explosion
	Begin Object Name=ExploTemplate0
		Damage=750
		DamageRadius=500
	End Object
}