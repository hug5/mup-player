# mup.sh

### mup terminal media player

#### Play music files in your terminal with mpv.
#### Play video files from your terminal with SMPlayer.

-------------------------------------------------

REQUIREMENTS
  - mpv player (for audio)
  - SMPlayer (for video)
  - fzf search
  
  
SYNTAX:
```bash
$ mup <COMMAND> [OPTION]
$ mup --fuzzy | -F [-d] [-N<depth>] [-s]
$ mup --all |-A [-s]
$ mup --here | -H [-s]
$ mup --playlist | -P [-s]
$ mup --help | -h

Kb Shortcuts
9 / 0 : volume- / volume+
[ / ] : 10% speed- / 10% speed+
{ / } : half speed- / double speed+
Enter : Next in playlist
left/right arrows : seek backward/forward 5s
up/down arrows : seek backward/forward 1s
< / > : previous playlist / next playlist
left/right : backward / forward
F8 : show the playlist
p or space : pause
m : mute
```

Also refer to [MPV kb shortcuts.](https://mpv.io/manual/master/#keyboard-control)

-------------------------------------------------

PLAY COMMANDS:
```bash
--fuzzy | -F      Fuzzy search. (default)
--all | -A        Play everything in current + subfolders.
--here | -H       Play in current folder.
--playlist | -P   Load m3u playlist(s).

FLAG OPTIONS
-s                Shuffle media.
-v                Video media type.
-d                Select by directory.
-n D              Directory depth, D (default=1).
-h | --help       Display this help.

EXAMPLES
$ mup --fuzzy         Fuzzy search by audio files. (default)
$ mup                 Same as --fuzzy.
$ mup -d              Fuzzy search by directory.
$ mup --here          Play all audio media in current folder.
$ mup -A              Play all audio, including subfolders.
$ mup --all -s        Play all audio; shuffle.
$ mup -vsA            Play all video, including subfolder; shuffle.
$ mup -Fdn2           Fuzzy search by directory, depth=2.

```



