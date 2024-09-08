# PS Classics fPKG Builder
- Easily create PS1, PS2 & PSP game fake packages for the PS4 / PS5 on macOS & Windows
- Supports .BIN files (PS1) & .ISO files (PS2 & PSP)
- Detects PS1 game protection and can apply the required patch
- Automatic PS1 game TOC generation for games using CDDA music
- Customize the icon & background
- Configurate the used emulator
- Select up to 4 discs on PS1 & up to 5 discs on PS2

## Notes for macOS users
- Runs on macOS 12.0 or newer
  - Intel or Apple ARM
- Wine runs under the hood to get the publishing tools working on macOS, this is why the archive size is way bigger for macOS.
  - This is experimental but works.
- This is a portable app, if you want to move it into the 'Applications' folder then you have to move the entire extracted directory including its 'Tools' folder in 'Applications'.
- You will need to add an exception when opening the app for the first time (CMD+Open) :
  - https://support.apple.com/en-gb/guide/mac-help/mh40616/mac

PS Classics fPKG Builder uses the following tools from other developers:

| Tool | Created by | Repository |
| --- | --- | --- |
| `crc` | asahui | [https://gist.github.com/asahui/a6af64606a9476a40442274335f5feaf](https://gist.github.com/asahui/a6af64606a9476a40442274335f5feaf)
| `Cue2toc` | Goatman13 | [https://github.com/Goatman13/Cue2toc](https://github.com/Goatman13/Cue2toc)
| `pspdecrypt` | John-K & More | [https://github.com/John-K/pspdecrypt](https://github.com/John-K/pspdecrypt)
| `sfo` | hippie68 | [https://github.com/hippie68/sfo](https://github.com/hippie68/sfo)
| `unar` | The Unarchiver | [https://theunarchiver.com/command-line](https://theunarchiver.com/command-line)
| `wine` | WineHQ | [https://www.winehq.org/](https://www.winehq.org/)
