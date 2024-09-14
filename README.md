# Server Extension

[![Banner](PublicationContent/mutbanner.png)](https://steamcommunity.com/sharedfiles/filedetails/?id=2085786712)

[![Steam Workshop](https://img.shields.io/static/v1?message=workshop&logo=steam&labelColor=gray&color=blue&logoColor=white&label=steam%20)](https://steamcommunity.com/sharedfiles/filedetails/?id=2085786712)
[![Steam Downloads](https://img.shields.io/steam/downloads/2085786712)](https://steamcommunity.com/sharedfiles/filedetails/?id=2085786712)
[![Steam Favorites](https://img.shields.io/steam/favorites/2085786712)](https://steamcommunity.com/sharedfiles/filedetails/?id=2085786712)
[![MegaLinter](https://github.com/GenZmeY/KF2-Server-Extension/actions/workflows/mega-linter.yml/badge.svg?branch=master)](https://github.com/GenZmeY/KF2-Server-Extension/actions/workflows/mega-linter.yml)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/GenZmeY/KF2-Server-Extension)](https://github.com/GenZmeY/KF2-Server-Extension/tags)
[![GitHub top language](https://img.shields.io/github/languages/top/GenZmeY/KF2-Server-Extension)](https://docs.unrealengine.com/udk/Three/WebHome.html)
[![GitHub](https://img.shields.io/github/license/GenZmeY/KF2-Server-Extension)](LICENSE)

***

*This mod replaces current perk system in [Killing Floor 2](https://en.wikipedia.org/wiki/Killing_Floor_2) with a serverside perk progression with RPG elements, which let you buy individual stats and traits.*

*This is a further development of the ServerExt mutator from [Marco](https://forums.tripwireinteractive.com/index.php?threads/mutator-server-extension-mod.109463) and [Forrest Mark X](https://github.com/ForrestMarkX/KF2-Server-Extension).*

## Features
- RPG elements (traits and stats);
- New menu system;
- Scoreboard that supports unlimited playercount on server;
- Supports custom characters and weapons;
- Enhanced HUD feedback (kill/damage messages);
- First person legs and backpack weapon;
- **Customizable experience for killing custom zeds;**
- **DLC weapons are available for purchase from the trader;**
- **Localization support.**

The full changelog is available on [steam workshop](https://steamcommunity.com/sharedfiles/filedetails/changelog/2085786712).

***

**Note:** If you want to build/test/brew/publish a mutator without git-bash and/or scripts, follow [these instructions](https://tripwireinteractive.atlassian.net/wiki/spaces/KF2SW/pages/26247172/KF2+Code+Modding+How-to) instead of what is described here.

## Build
1. Install [Killing Floor 2](https://store.steampowered.com/app/232090/Killing_Floor_2/), Killing Floor 2 - SDK and [git for windows](https://git-scm.com/download/win);
2. open git-bash and go to any folder where you want to store ServerExt sources:  
`cd <ANY_FOLDER_YOU_WANT>`  
3. Clone this repository and go to the source folder:  
`git clone https://github.com/GenZmeY/KF2-Server-Extension && cd KF2-Server-Extension`
4. Download ServerExt dependencies:  
`git submodule init && git submodule update`  
5. Compile ServerExt:  
`./tools/builder -c`  
5. The compiled files will be here:  
`C:\Users\<USERNAME>\Documents\My Games\KillingFloor2\KFGame\Unpublished\BrewedPC\Script\`

## Using and configuring ServerExt
A detailed manual is available on the [mod page](https://steamcommunity.com/sharedfiles/filedetails/?id=2085786712) in the steam workshop.

## Contributing
**Participation is welcome!**

### Bug reports
If you find a bug, go to the [issue page](https://github.com/GenZmeY/KF2-Server-Extension/issues) and check if there is a description of your bug. If not, create a new issue.  
Describe what the bug looks like and how we can reproduce it.  
Attach screenshots if you think it might help.

If it's a crash issue, be sure to include the `Launch.log` file. You can find them here:  
`C:\Users\<USERNAME>\Documents\My Games\KillingFloor2\KFGame\Logs\`  
Please note that these files are overwritten every time you start the game/server. Therefore, you must take these files immediately after the game crashes in order not to lose information.

### Localization
The mutator supports localization and you can help translate it into other languages.  
It does not require any special knowledge or programming skills, so you just need to know the language into which you will translate.  
Here's a quick guide on how to do it: [localization guide](https://steamcommunity.com/workshop/filedetails/discussion/2085786712/2942494909176752884)

### Contribute code
You can help improve ServerExt by fixing bugs and adding new features.  
Before making a pull request, make sure that:  
1. Your code is working correctly.  
2. Your code does not break existing features.  

In the description of the pull request, describe the changes you made.


## Contributors
[![ServerExt Contributors](https://contrib.rocks/image?repo=GenZmeY/KF2-Server-Extension)](https://github.com/GenZmeY/KF2-Server-Extension/graphs/contributors)

[Marco](https://steamcommunity.com/profiles/76561197975509070)  
[ForrestMarkX](https://steamcommunity.com/profiles/76561197997881512)  
[inklesspen](https://steamcommunity.com/profiles/76561198143883210)  
[GenZmeY](https://steamcommunity.com/profiles/76561198001617867)  
[secret](https://steamcommunity.com/profiles/76561198042219365)  
[Scaredkid93](https://steamcommunity.com/profiles/76561198004271210)  
[小曦曦](https://steamcommunity.com/profiles/76561198200630473)  

**Translators:**  
[GenZmeY](https://steamcommunity.com/profiles/76561198001617867) - Russian [RUS];  
[MilkTeaFox](https://steamcommunity.com/profiles/76561197967822972) - Traditional Chinese [CHT];  
[あさぴっぴ1020](https://steamcommunity.com/profiles/76561198930643117) - Japanese [JPN];  
[Jason Voorehes ](https://steamcommunity.com/profiles/76561198080866131) - Spanish [ESN];  
[小曦曦](https://steamcommunity.com/profiles/76561198200630473) - Simplified Chinese [CHN].  

## License
[![license](https://www.gnu.org/graphics/gplv3-with-text-136x68.png)](LICENSE)

***

**Note about the banner:**  
The cat in the picture is [meowbin](https://twitter.com/meawbinneko). And [Cotton Valent](https://twitter.com/horrormove) is the artist who designed and painted this magnificent cat.
