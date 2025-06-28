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
class ExtProj_SUPERGrenade extends KFProj_FragGrenade
	hidedropdown;

/** On Contact demo skill can turn our grenade into an insta boom device */
var bool bExplodeOnContact;

var class<KFProj_Grenade> ClusterNades;
var() byte NumClusters;

simulated function PostBeginPlay()
{
	local KFPerk InstigatorPerk;
	local KFPawn InstigatorPawn;

	InstigatorPawn = KFPawn(Instigator);
	if (InstigatorPawn != none)
	{
		InstigatorPerk = InstigatorPawn.GetPerk();
		if (InstigatorPerk != none)
			bExplodeOnContact = InstigatorPerk.IsOnContactActive();
	}

	Super.PostBeginPlay();
	if (Instigator!=None && ExtPlayerReplicationInfo(Instigator.PlayerReplicationInfo)!=None && ExtPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ECurrentPerk!=None)
		ClusterNades = ExtPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ECurrentPerk.Default.PerkGrenade;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if (bExplodeOnContact && Other != Instigator && !Other.bWorldGeometry && Pawn(Other)!=None && Pawn(Other).GetTeamNum() != GetTeamNum())
	{
		// For opposing team, make the grenade explode instantly
		GetExplodeEffectLocation(HitLocation, HitNormal, Other);
		TriggerExplosion(HitLocation, HitNormal, Other);
	}
	else super.ProcessTouch(Other, HitLocation, HitNormal);
}

simulated function Disintegrate(rotator inDisintegrateEffectRotation); // Nope!

simulated function TriggerExplosion(Vector HitLocation, Vector HitNormal, Actor HitActor)
{
	local byte i;
	local KFProj_Grenade P;

	if (bHasExploded)
		return;
	if (InstigatorController==None && WorldInfo.NetMode!=NM_Client) // Prevent Team-Kill.
	{
		Destroy();
		return;
	}
	Super.TriggerExplosion(HitLocation,HitNormal,HitActor);
	if (WorldInfo.NetMode!=NM_Client)
	{
		for (i=0; i<NumClusters; ++i)
		{
			P = Spawn(ClusterNades,,,Location);
			if (P!=None)
			{
				P.InstigatorController = InstigatorController;
				P.Init(VRand());
			}
		}
	}
	bHasExploded = true;
}

simulated function Destroyed()
{
	local Actor HitActor;
	local vector HitLocation, HitNormal;

	// Final Failsafe check for explosion effect
	if (!bHasExploded && WorldInfo.NetMode==NM_Client)
	{
		GetExplodeEffectLocation(HitLocation, HitNormal, HitActor);
		TriggerExplosion(HitLocation, HitNormal, HitActor);
	}
}

defaultproperties
{
	bCanDisintegrate=false
	ClusterNades=class'KFProj_FragGrenade'
	DrawScale=2
	NumClusters=6
	ProjFlightTemplate=ParticleSystem'ZED_Hans_EMIT.FX_Grenade_Explosive_01'

	Begin Object Name=ExploTemplate0
		Damage=500
		DamageRadius=1000
	End Object
}