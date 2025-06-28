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

class xVoteBroadcast extends BroadcastHandler;

var BroadcastHandler NextBroadcaster;
var xVotingHandler Handler;

function UpdateSentText()
{
	NextBroadcaster.UpdateSentText();
}

function Broadcast(Actor Sender, coerce string Msg, optional name Type)
{
	if ((Type=='Say' || Type=='TeamSay') && Left(Msg,1)=="!" && PlayerController(Sender)!=None)
		Handler.ParseCommand(Mid(Msg,1),PlayerController(Sender));
	NextBroadcaster.Broadcast(Sender,Msg,Type);
}

function BroadcastTeam(Controller Sender, coerce string Msg, optional name Type)
{
	if ((Type=='Say' || Type=='TeamSay') && Left(Msg,1)=="!" && PlayerController(Sender)!=None)
		Handler.ParseCommand(Mid(Msg,1),PlayerController(Sender));
	NextBroadcaster.BroadcastTeam(Sender,Msg,Type);
}

function AllowBroadcastLocalized(actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	NextBroadcaster.AllowBroadcastLocalized(Sender,Message,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}

event AllowBroadcastLocalizedTeam(int TeamIndex, actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	NextBroadcaster.AllowBroadcastLocalizedTeam(TeamIndex,Sender,Message,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}

defaultproperties
{

}