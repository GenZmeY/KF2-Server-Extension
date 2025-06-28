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

Class Ext_T_MonsterPRI extends PlayerReplicationInfo;

var repnotify class<Pawn> MonsterType;
var repnotify PlayerReplicationInfo OwnerPRI;
var Controller OwnerController;
var string MonsterName;
var int HealthStatus,HealthMax;
var Pawn PawnOwner;
var KFExtendedHUD OwnerHUD;

replication
{
	// Things the server should send to the client.
	if (bNetDirty)
		OwnerPRI,MonsterType,HealthStatus,HealthMax;
}

// Make no efforts with this one.
simulated event PostBeginPlay()
{
	if (WorldInfo.NetMode!=NM_Client)
		SetTimer(1,true);
}

simulated event Destroyed()
{
	if (OwnerHUD!=None)
	{
		OwnerHUD.MyCurrentPet.RemoveItem(Self);
		OwnerHUD = None;
	}
	if (WorldInfo.GRI != None)
		WorldInfo.GRI.RemovePRI(self);
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName=='OwnerPRI' && OwnerPRI!=None)
		NotifyOwner();
	else if (VarName=='MonsterType' && MonsterType!=None)
		MonsterName = Class'KFExtendedHUD'.Static.GetNameOf(MonsterType);
}

simulated function Timer()
{
	if (PawnOwner==None || PawnOwner.Health<=0)
		Destroy();
	else if (HealthStatus!=PawnOwner.Health)
		HealthStatus = PawnOwner.Health;
}

simulated final function NotifyOwner()
{
	local PlayerController PC;

	PC = GetALocalPlayerController();
	if (PC==None || PC.PlayerReplicationInfo!=OwnerPRI || KFExtendedHUD(PC.MyHUD)==None)
		return;
	OwnerHUD = KFExtendedHUD(PC.MyHUD);
	OwnerHUD.MyCurrentPet.AddItem(Self);
}

defaultproperties
{
	bBot=true
}