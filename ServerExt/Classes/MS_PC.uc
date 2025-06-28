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

Class MS_PC extends KFPlayerController;

var localized string ConnectingTo;
var localized string ConnectionAborted;
var localized string UserAbortedConnection;
var localized string ConnectionError;
var localized string Disconnecting;

var MS_PendingData TravelData;
var byte ConnectionCounter;
var bool bConnectionFailed;

simulated event ReceivedPlayer();
simulated function ReceivedGameClass(class<GameInfo> GameClass);

simulated function HandleNetworkError(bool bConnectionLost)
{
	ConsoleCommand("Disconnect");
}

event PlayerTick(float DeltaTime)
{
	if (ConnectionCounter<3 && ++ConnectionCounter==3)
	{
		if (TravelData.PendingURL!="")
		{
			MS_HUD(myHUD).ShowProgressMsg(ConnectingTo@TravelData.PendingURL);
			ConsoleCommand("Open "$TravelData.PendingURL);
		}
		if (TravelData.PendingSong!=None)
			StartMusicTrack(TravelData.PendingSong);

		// Reset all cached data.
		TravelData.Reset();
	}
	PlayerInput.PlayerInput(DeltaTime);
	MS_HUD(myHUD).ActiveGame.UpdateMouse(PlayerInput.aTurn,PlayerInput.aLookUp);
}

simulated final function StartMusicTrack(SoundCue Music)
{
	local AudioComponent A;

	if (WorldInfo.MusicComp!=None)
	{
		WorldInfo.MusicComp.FadeOut(WorldInfo.CurrentMusicTrack.FadeOutTime,WorldInfo.CurrentMusicTrack.FadeOutVolumeLevel);
		WorldInfo.MusicComp = None;
	}
	Music.SoundClass = 'Music'; // Force music group for this.
	A = WorldInfo.CreateAudioComponent(Music,false,false,false,,false);
	if (A!=None)
	{
		// update the new component with the correct settings
		A.bAutoDestroy = true;
		A.bShouldRemainActiveIfDropped = true;
		A.bIsMusic = true;
		A.bAutoPlay = true;
		A.bIgnoreForFlushing = false;
		A.FadeIn(0.25, 1.f);
	}
	WorldInfo.MusicComp = A;
	WorldInfo.CurrentMusicTrack.TheSoundCue = Music;
	WorldInfo.CurrentMusicTrack.FadeInTime = 1;
	WorldInfo.CurrentMusicTrack.FadeOutTime = 1;
}

final function AbortConnection()
{
	if (bConnectionFailed)
		HandleNetworkError(false);
	else
	{
		ShowConnectionProgressPopup(PMT_ConnectionFailure,ConnectionAborted,UserAbortedConnection,true);
		ConsoleCommand("Cancel");
	}
}

reliable client event TeamMessage(PlayerReplicationInfo PRI, coerce string S, name Type, optional float MsgLifeTime );

reliable client event bool ShowConnectionProgressPopup(EProgressMessageType ProgressType, string ProgressTitle, string ProgressDescription, bool SuppressPasswordRetry = false)
{
	if (bConnectionFailed)
		return false;
	switch (ProgressType)
	{
	case PMT_ConnectionFailure:
	case PMT_PeerConnectionFailure:
		bConnectionFailed = true;
		MS_HUD(myHUD).ShowProgressMsg(ConnectionError@ProgressTitle$"|"$ProgressDescription$"|"$Disconnecting,true);
		SetTimer(4,false,'HandleNetworkError');
		return true;
	case PMT_DownloadProgress:
	case PMT_AdminMessage:
		MS_HUD(myHUD).ShowProgressMsg(ProgressTitle$"|"$ProgressDescription);
		return true;
	}
	return false;
}

exec function CustomStartFire(optional byte FireModeNum)
{
	if (!MS_HUD(myHUD).ActiveGame.bGameStarted)
		MS_HUD(myHUD).ActiveGame.StartGame();
}

exec function SelectNextWeapon()
{
	MS_HUD(myHUD).ActiveGame.AdjustSensitivity(true);
}

exec function SelectPrevWeapon()
{
	MS_HUD(myHUD).ActiveGame.AdjustSensitivity(false);
}

auto state PlayerWaiting
{
ignores SeePlayer, HearNoise, NotifyBump, TakeDamage, PhysicsVolumeChange, NextWeapon, PrevWeapon, SwitchToBestWeapon;

	reliable server function ServerChangeTeam(int N);

	reliable server function ServerRestartPlayer();

	function PlayerMove(float DeltaTime)
	{
	}
}

defaultproperties
{
	InputClass=class'MS_Input'

	Begin Object Class=MS_PendingData Name=UserPendingData
	End Object
	TravelData=UserPendingData
}