## COMPLETELY BROKEN. DO NOT USE.

# Beatrun | Community edition

* [Русский](./README_ru.md)\
  *(If you can read English: This isn't maintained, I don't speak Russian)*

![powered-by-source-engine-jank™](https://github.com/user-attachments/assets/0fd11ad8-3e6d-4d9e-9ef5-ee0db6f02cc9)<svg xmlns="http://www.w3.org/2000/svg" width="334.73753356933594" height="35" viewBox="0 0 334.73753356933594 35"><rect width="112.65000915527344" height="35" fill="#f3b531"/><rect x="112.65000915527344" width="222.0875244140625" height="35" fill="#d538a5"/><text x="56.32500457763672" y="21.5" font-size="12" font-family="'Roboto', sans-serif" fill="#FFFFFF" text-anchor="middle" letter-spacing="2"></text><text x="223.6937713623047" y="21.5" font-size="12" font-family="'Montserrat', sans-serif" fill="#FFFFFF" text-anchor="middle" font-weight="900" letter-spacing="2"></text></svg> ![built-on-insanity](https://github.com/user-attachments/assets/8f8d00c4-a18e-4ba5-b3cd-65d85f4d713f)<svg xmlns="http://www.w3.org/2000/svg" width="187.33751678466797" height="35" viewBox="0 0 187.33751678466797 35"><rect width="86.03750610351562" height="35" fill="#8cea23"/><rect x="86.03750610351562" width="101.30001068115234" height="35" fill="#c70a0d"/><text x="43.01875305175781" y="21.5" font-size="12" font-family="'Roboto', sans-serif" fill="#FFFFFF" text-anchor="middle" letter-spacing="2"></text><text x="136.6875114440918" y="21.5" font-size="12" font-family="'Montserrat', sans-serif" fill="#FFFFFF" text-anchor="middle" font-weight="900" letter-spacing="2"></text></svg>

Infamous parkour gamemode for Garry's Mod.\
Fully open sourced and maintained by the community (like 4 people I think).

> [!IMPORTANT]
> This repository does not contain any malicious modules whatsoever. These modules are present for more functionality however:
>
> * Discord Rich Presence
> * Steam Presence
>
> **They are optional and can be removed at any time.**\
> You can find all compiled modules **[here](lua/bin)** in the repository.\
> Check **[Credits](#credits)** section for module source code.

## Automatic Installation?

Not supported for this version, nor will it ever be. How hard is installing Beatrun anyway? It's just extracting a folder.[^2]

## Manual Installation

### *Method 1: Repository download and extract (easy)*

***Note**: `<Garry's Mod game folder>` is a placeholder for your Garry's Mod game folder.*

1. **[Download this repository](https://github.com/LostTrackpad/beatrun-forked/archive/refs/heads/dev.zip)**.
2. **Delete the `beatrun` folder in *`<Garry's Mod game folder>/garrysmod/addons`* if you have one.**
3. Extract the `beatrun-main/beatrun` folder to *`<Garry's Mod game folder>/garrysmod/addons`*.
   * If you want to have Discord and Steam Presence:
     * Extract the `beatrun-main/lua` folder to *`<Garry's Mod game folder>/garrysmod`*.
4. That's it, Beatrun is installed.

### *Method 2: Using Git and Directory Junctions* ***(Windows 10+ Only!)***
> [!WARNING]
> This method requires:<br>
> * **A working and up to date installation of Windows 10 or above.**
> * A **working and usable** installation of Git for Windows on the system
> * The drive volume you have Garry's Mod on ***must*** use a file system that supports Windows Directory Junctions (this will likely be NTFS)<br>

> [!IMPORTANT]
> ***May*** work on Windows 7/8, but those versions of Windows are **no longer supported**! You really should upgrade if you're running either of those, and I will not provide support!

If you're ready and willing to use this method, read [this](repocontent/WindowsGitInstallGuide.md) guide to continue.

## Animations

[Please refer to this file.](beatrun/README.md)

## New Features

> [!IMPORTANT]
> This version has *lots* of undocumented features and fixes. Look into the commit history if you wanna see all of them.

* Jonny_Bro (original fork creator) is hosting **[a custom course database](https://courses.jonnybro.ru)**, which is ***free***[^1] to use and also **[open source](https://git.jonnybro.ru/jonny_bro/beatrun-courses-server-express)**!
* New *Deathmatch* gamemode (it's definitely more fun than *Data Theft* trust us)
* "Proper" kick glitch just like in **[original game](https://www.youtube.com/watch?v=zK5y3NBUStc)**
  * Kick glitch behavior type toggle (yep, original kick glitch is still usable!) - `Beatrun_OldKickGlitch` to toggle
* In-game configuration menu - you can find it in the spawn menu, in the **`Beatrun`** category\
  ***Most*** Beatrun settings can now be configured there! Use `cvarlist beatrun_` to list *all* Beatrun options (and some commands), including some I didn't list
* Button hints in bottom right corner for people who don't know controls *(made by me!, not a substitute for watching a tutorial)*
* Discord and Steam Presence *(only Discord presence is new actually)*
* Localization support.\
  Now in 7 languages *(mostly, some stuff is locked in English)*!
* Dismounting from ladders with your duck key (default is `CTRL`)
* Removing ziplines created with Zipline Gun using your alternate fire bind (default is `Right Mouse Button`)
* Arrow that points to the next checkpoint
* Serverside option to enable Overdrive mode in multiplayer: `Beatrun_AllowOverdriveInMultiplayer`
* Serverside option to allow prop spawning without being an admin: `Beatrun_AllowPropSpawn`.
* Serverside toggle for health regeneration: `Beatrun_HealthRegen`
* You can change HUD colors (client only)! Use `Beatrun_HUDTextColor`, `Beatrun_HUDCornerColor`, and `Beatrun_HUDFloatingXPColor`
* Clientside to allow disabling the grapple: `Beatrun_DisableGrapple`.
* ConVar to allow QuickTurn with any weapon or only with *Runner Hands* (client) - `Beatrun_QuickturnHandsOnly`.
* Small camera punch when diving.
* Your Steam account ID/*SteamID* is no longer shown on screen
## Some Older (?) Fixes

* Some playermodels showing up as **`ERROR`**
* Leaderboard sorting in gamemodes
* Allow using the grapple in Time Trial and gamemodes
* Crash in Data Theft when touching Data Bank
* Collision issues - PvP damage not going through in gamemodes other than Data Theft
* Allowed jumping while walking *(don't ask me, Jonny did this...)*.
* Tweaked safety roll to allow rolling under stuff
* Some grapple tweaks (moves with attached entity, other players can see rope)

## TODO

* [ ] Loadouts creation menu for Data Theft and Deathmatch. (I don't do UI stuff, I can't do this).

## Known issues

* [Issues on Jonny's original fork](https://github.com/JonnyBro/beatrun/issues)\
I'm not kidding, check there first for problems. ***Do not** report issues with this fork there.*

* [Issues on this fork](https://github.com/LostTrackpad/beatrun-forked/issues)\
  Report any issues with this fork here, and any feature requests you may want.

## Related projects

* [Beatrun Reanimated Project](https://github.com/JonnyBro/beatrun-anims).

## Credits

* [All contributors](https://github.com/JonnyBro/beatrun/graphs/contributors) for making Beatrun better
* [EarthyKiller127](https://www.youtube.com/channel/UCiFqPwGo4x0J65xafIaECDQ) / datæ for making the original Beatrun gamemode *(and obfuscating it and putting it into DLL files...really?)*
* [relaxtakenotes](https://github.com/relaxtakenotes) for even making all this possible
* [MTB](https://www.youtube.com/@MTB396) for Beatrun Reanimated Project
* [Fluffy Servers](https://github.com/fluffy-servers/gmod-discord-rpc) for Discord Rich Presence module
* [YuRaNnNzZZ](https://github.com/YuRaNnNzZZ/gmcl_steamrichpresencer) for Steam Presence module

[^1]: *A Steam account with a copy of Garry's Mod is required. Ask them why if you're curious.*
[^2]: *I am also lazy, maintaining PowerShell scripts isn't something I can do, and doing this in my view doesn't add anything but open a window for more annoying issues from people who don't know what they're doing.*
