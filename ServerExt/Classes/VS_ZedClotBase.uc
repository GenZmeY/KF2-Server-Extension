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

class VS_ZedClotBase extends VSZombie
	abstract;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	Super.PostInitAnimTree(SkelComp);

	if (bCanHeadTrack)
	{
		IK_Look_Head		= SkelControlLookAt(Mesh.FindSkelControl('HeadLook'));
		//IK_Look_Spine	   = SkelControlLookAt(Mesh.FindSkelControl('SpineLook'));
	}
}

simulated function float StartAttackAnim(byte Num) // Return animation duration.
{
	if (FPHandModel!=None)
		FPHandModel.PlayHandsAnim('Atk_Combo1_V1');
	return PlayBodyAnim('Atk_Combo1_V1',EAS_UpperBody);
}

defaultproperties
{
	MonsterArchPath="ZED_ARCH.ZED_Clot_UnDev_Archetype"
	CharacterMonsterArch=KFCharacterInfo_Monster'ZED_ARCH.ZED_Clot_UnDev_Archetype'
	DoshValue=12
	HitsPerAttack=2
	KnockedDownBySonicWaveOdds=0.230000
	Mass=50.000000
	GroundSpeed=190.000000
	RotationRate=(Pitch=50000,Yaw=30000,Roll=50000)
}