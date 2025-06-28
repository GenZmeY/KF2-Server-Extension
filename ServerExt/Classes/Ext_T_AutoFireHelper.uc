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

Class Ext_T_AutoFireHelper extends Info
	transient;

var class<KFPerk> AssociatedPerkClass;
var Pawn PawnOwner;
var PlayerController LocalPC;
var bool bNetworkOwner;

replication
{
	if (bNetOwner)
		PawnOwner,AssociatedPerkClass;
}

function PostBeginPlay()
{
	PawnOwner = Pawn(Owner);
	if (PawnOwner==None)
		Destroy();
	else SetTimer(0.5+FRand()*0.4,true);
}

function Timer()
{
	if (PawnOwner==None || PawnOwner.Health<=0 || PawnOwner.InvManager==None)
		Destroy();
}

simulated function Tick(float Delta)
{
	if (WorldInfo.NetMode==NM_DedicatedServer
	|| PawnOwner==None
	|| PawnOwner.InvManager==None
	|| KFWeapon(PawnOwner.Weapon)==None
	|| (KFWeapon(PawnOwner.Weapon).GetWeaponPerkClass(AssociatedPerkClass) != AssociatedPerkClass && AssociatedPerkClass != class'KFPerk_Survivalist'))
		return;

	// Find local playercontroller.
	if (LocalPC==None)
	{
		LocalPC = PlayerController(PawnOwner.Controller);
		if (LocalPC==None)
			return;
		bNetworkOwner = (LocalPlayer(LocalPC.Player)!=None);
	}
	if (!bNetworkOwner)
		return;

	// Force always to pending fire.
	if (LocalPC.bFire!=0 && !PawnOwner.InvManager.IsPendingFire(None,0))
		PawnOwner.Weapon.StartFire(0);
	else if (LocalPC.bAltFire!=0 && !PawnOwner.InvManager.IsPendingFire(None,1))
		PawnOwner.Weapon.StartFire(1);
}

defaultproperties
{
	Components.Empty()
	RemoteRole=ROLE_SimulatedProxy
	bOnlyRelevantToOwner=true
}