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

Class xMapVoteHistory extends Object
	config(xMapVoteHistory);

var config array<string> M;
struct FMapInfoEntry
{
	var config int U,D,S,N;
	var config string T;
};
var config array<FMapInfoEntry> N;

static final function int GetMapHistory(string MapName, string MapTitle)
{
	local int i;

	MapName = Caps(MapName);
	i = Default.M.Find(MapName);
	if (i==-1)
	{
		i = Default.M.Length;
		Default.M.Length = i+1;
		Default.M[i] = MapName;
		Default.N.Length = i+1;
	}
	if (!(MapTitle~=MapName) && MapTitle!=Class'WorldInfo'.Default.Title && MapTitle!="")
		Default.N[i].T = MapTitle;
	return i;
}

static final function GetHistory(int i, out int UpVotes, out int DownVotes, out int Seq, out int NumP, out string Title)
{
	UpVotes = Default.N[i].U;
	DownVotes = Default.N[i].D;
	Seq = Default.N[i].S;
	NumP = Default.N[i].N;
	Title = Default.N[i].T;
}

static final function UpdateMapHistory(int iWon)
{
	local int i;

	for (i=(Default.M.Length-1); i>=0; --i)
	{
		if (i==iWon)
		{
			++Default.N[i].N;
			Default.N[i].S = 0;
		}
		else ++Default.N[i].S;
	}
}

static final function AddMapKarma(int i, bool bUp)
{
	if (bUp)
		++Default.N[i].U;
	else ++Default.N[i].D;
}
