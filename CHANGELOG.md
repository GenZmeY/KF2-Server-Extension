# Changelog

## v1.18.2 (2024-09-14)
- fixed the "Demo Professional" trait requirements: now it requires 1 prestige level (as stated in the trait description)

## v1.18.1 (2024-03-08)
- rebuild
- removed 'BountyZeds' window from HUD

## v1.18.0 (2023-09-10)
- recoil and spread are now calculated by a linear function
- added 4 traits for firebug: Inferno, Pyromaniac, GroundFire, HeatWave
- several ScriptWarning fixes on the client side
- added Simplified Chinese translation

## v1.17.1 (2022-10-13)
- update to kf2 v1135

## v1.17.0 (2022-09-16)
- completely removed custom weapons
- added compatibility with CTI / TIM
- fixed admin rank assignment

## v1.16.2 (2022-08-30)
- customXP function full refactoring
- remove unused config variable: bServerPerksMode
- added instruction in case of missing configs
- 'AdminType' is now enum
- fixed "out of bounds" error:
- fixed "Accessed None 'Killer'" error:
- fixed "Accessed None 'Pawn'" error:
- fixed "Accessed None 'OwnerController'" error:
- fixed "Accessed None 'CurrentPerk'" error:
- fixed "Accessed None 'Data'" error:
- fixed "Accessed None 'BestN'" error:

## v1.16.1 (2022-05-18)
- fixed a bug where custom zeds would not give EXP if their class name started with "KF"

## v1.16.0 (2022-01-16)
- new build system
- Spanish localization (ESN)
- xVoteAnnouncer.upk integrated into ServerExt.u
- ServerExt.u and ServerExtMut.u compressed (reduced size)

## v1.15.0 (2021-08-24)
- reduced camera shake when using weapons such as the S&W 500 Magnum when you add points to the recoil rate
- fixed a bug where spread stat didn't work for shotguns
- knockdown now always knocks back enemies
- added new stat: weapon switch speed
- changed the Gunslinger Weapon Loadout trait: now you always get two pistols when leveling this trait

## v1.14.0 (2021-06-27)
- added "bEnableAnnouncer" parameter to KFxMapVote.ini
- added versioning to KFxMapVote.ini

## v1.13.0 (2021-05-03)
- new feature: change server name when changing mode in xVoteHandler
- error fixes in Russian localization

## v1.12.2 (2021-04-13)
- fixed inaccuracies in Russian translation

## v1.12.1 (2021-03-23)
- fixed a bug where the player couldn't choose a skin for steampunk outfit
- fixed a bug when the effects of the costume were not displayed (for example, the glow of the reaper outfit)

## v1.12.0 (2021-02-21)
- japanese localization

## v1.11.1 (2021-02-09)
- fix base perk at the start of the game

## v1.11.0 (2021-02-08)
- added missing emotes
- added implementation of TAWOD mutator:
- improved compatibility with mutators that use basic perks to get information
- improved build script - now it handles unexpected termination correctly

## v1.10.0 (2021-01-18)
- fixed bug of magazine capacity when changing perk
- more text supports localization
- update the Russian localization file
- added Traditional Chinese (CHT) localization
- improved build system: ServerExt can be compiled from any folder
- the system of unlocking DLC weapons has been changed:

## v1.9.1 (2021-01-09)
- fixed "vote orgy" for no force mode

## v1.9.0 (2021-01-08)
- "MapVote orgy" can be configured or disabled (KFxMapVote.ini)
- fixed cyclic unsuccessful map change at the end of the game in single player mode

## v1.8.11 (2020-12-27)
- add bump effect to SWAT enforcer trait

## v1.8.10 (2020-12-26)
- fixed map objectives (it works now)
- fixed zed counter (no longer shows BOSS on the penultimate wave)

## v1.8.9 (2020-12-14)
- fixed work of accessories for the current patch (v1108)
- fixed a bug when characters appeared with random accessories
- fixed a bug where choosing one accessory selects another accessory

## v1.8.8 (2020-12-12)
- replaced font to UI_Canvas_Fonts.Font_Main (which supports chinese)
- replaced quotes in Russian localization

## v1.8.7 (2020-12-08)
- update to KF2 v1107
- add (free) DLC Frost Fang weapon

## v1.8.6 (2020-11-29)
- fix: XP for killing with TF2Sentry turret

## v1.8.5 (2020-10-13)
- fixed calculating the extra ammo for the "Ammo regeneration" trait

## v1.8.4 (2020-10-13)
- fixed reloading when adding secondary ammo by "Ammo Regeneration" skill
- fixed "Auto-Fire weapons" skill for "survivalist" perk

## v1.8.3 (2020-09-29)
- update to kf2 v1103/v1104
- add (free) minigun and mine reconstructor weapons

## v1.8.2 (2020-09-13)
- fixed "Skip trader" button

## v1.8.1 (2020-09-07)
- fixed incorrect display of player stats

## v1.8.0 (2020-09-07)
- localization support
- russian localization

## v1.7.1 (2020-08-11)
- fix xVoteAnnouncer

## v1.7.0 (2020-07-13)
- Added "Syringe Recharge Rate" by default for medic (config will update itself)
- Skill "Heal Efficiency" doesn't increasing syringe recharge anymore
- Trait "Medic Pistol" applying on purchasing now
- Added configuration for XP of custom zeds
- Rack'em Up doesn't reducing when shoot miss anymore
- Medic Pistol will be in hans on spawn like 9mm
- Optimized Rack'em Up code
- Added bolts & arrows cleanup on wave start (Too much sticky projectiles can drop FPS)

## v1.6.0 (2020-07-07)
- Medic Pistol is default weapon for Field Medic now
- Added skill "Perk Head Damage" for sharpshooter
- Removed trait "Rack'em Up" for sharpshooter (But still available to add in config)
- Fixed weight of weapon-upgrades in trader
- Fixed initial secondary ammo for weapons
- Upgraded Medic Pistol has no weight anymore
- You can see maximum value of skill in skill menu
- Trader shows damage of weapons now (but penetration and range still is null)
- Fixed secondary ammo icon in trader

## v1.5.1 (2020-07-02)
- fixed "Rack'em up": add upper limit for combos and decrease combo points over time
- added button "Skip Trader" in the game menu
- added button "Exit" in the game menu

## v1.5.0 (2020-06-24)
- DLC weapons are available for purchase from the merchant
- 9mm and medpistol can be upgraded
- removed 9mm and medpistol from PickupFactory (weapons that placed on map)
- removed dual 9mm and medpistol from trader
- restored "Armor Reparation" trait for a medic
- player inventory fixed

## v1.4.2 (2020-06-24)
- fixed gaining experience using a standard 9mm pistol
- fixed gaining experience when using a medical pistol which replaces a 9mm pistol
- standard pistol does not need reloading
- standard pistol is perked

## v1.4.1 (2020-06-24)
- update to KF2 v1096
- fixed gain XP for custom zeds

## v1.4.0 (2020-06-24)
- latest version of ForrestMarkX repository

## v1.3 (2018-02-04)
- removed desktop.ini files that were created by retarded Insync
- fixed the Demo having 0 radius damage

## v1.2 (2017-12-01)
- revert "Temp fix for Boss Camera glitching"

## v1.1 (2017-10-26)
- added a new scoreboard
- attempt to fix font scales being super huge on 1440p and higher resolutions

## v?.?.? (2018-08-06)
- fixed it to work on latest KF2 version

## v?.?.? (2017-01-31)
- ???

## v?.?.? (2016-11-21)
- fixed crash with release KF2 version

## v?.?.? (2016-08-26)
- added SWAT perk and traits for it
- fixed the mod to run in latest KF2 version
- improved support for custom player characters

## v?.?.? (2016-07-10)
- added new traits: Tactical Reload (commando+sharpshooter), Fan-Fare (for sharp), Ranger (sharp), Dire reloader (sharp)
- fixed HUD beacons show if player has grenades or supply available
- fixed some script warnings that would spam client/server logs
- fixed boss health bar to not show health for pets, and also support multiple bosses (where shield bar shows total health for all bosses)
- added option for players to select whatever to use KF2 styled kill/deathmessages
- added option to select whatever to show first person legs (by ForrestMarkX)
- added it to show last selected weapon on your backpack (by ForrestMarkX)
- fixed sharpshooter to be able to throw freeze grenades now

## v?.?.? (2016-06-14)
- fixed to work on sharpshooter KF2 update

## v?.?.? (2016-05-09)
- first version
