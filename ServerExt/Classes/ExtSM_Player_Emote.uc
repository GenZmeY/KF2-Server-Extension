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

class ExtSM_Player_Emote extends KFSM_Player_Emote;

static function byte PackFlagsBase(KFPawn P)
{
	return class'ExtEmoteList'.static.GetEmoteIndex(class'ExtEmoteList'.static.GetEquippedEmoteId(ExtPlayerController(P.Controller)));
}

function PlayAnimation()
{
	AnimName = class'ExtEmoteList'.static.GetEmoteFromIndex(KFPOwner.SpecialMoveFlags);

	PlaySpecialMoveAnim(AnimName, AnimStance, BlendInTime, BlendOutTime, 1.f);

	if (KFPOwner.Role == ROLE_Authority)
	{
		KFGameInfo(KFPOwner.WorldInfo.Game).DialogManager.PlayDialogEvent(KFPOwner, 31);
	}

	// Store camera mode for restoration after move ends
	LastCameraMode = 'FirstPerson';
	if (PCOwner != none && PCOwner.PlayerCamera != none)
	{
		LastCameraMode = PCOwner.PlayerCamera.CameraStyle;
	}

	// Set camera to emote third person camera
	if (PCOwner == none || !PawnOwner.IsLocallyControlled())
	{
		KFPOwner.SetWeaponAttachmentVisibility(false);
		return;
	}

	if (PCOwner.CanViewCinematics())
	{
		PCOwner.ClientSetCameraFade(true, FadeInColor, vect2d(1.f, 0.f), FadeInTime, true);
		PCOwner.PlayerCamera.CameraStyle = 'Emote';

		// Switch camera modes immediately in single player or on client
		if (PCOwner.WorldInfo.NetMode != NM_DedicatedServer)
		{
			PCOwner.ClientSetCameraMode('Emote');
		}

		KFPOwner.SetWeaponAttachmentVisibility(false);
	}
}

defaultproperties
{

}