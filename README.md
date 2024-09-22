# mup.sh

## mup terminal music player

Play music files in your terminal with mpv.

-------------------------------------------------

#### REQUIREMENTS
  - mpv player
  - fzf search
  
  
#### SYNTAX
```
$ mup <OPTION> [flag]
$ mup --fuzzy | -F [-f|-dN] [-s|-n]
$ mup --all | -A [-s|-n]
$ mup --here | -H [-s|-n]
$ mup --playlist | -P [-s|-n]
```
#### Kb Shortcuts
```
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
```
###### Also refer to [MPV kb shortcuts.](https://mpv.io/manual/master/#keyboard-control)
-------------------------------------------------

#### PLAY COMMANDS
```
--fuzzy | F       Fuzzy search; use with -d/-f options (default)        
--all | A         Play everything in current/subdirectories  
--here | H        Play in current folder         
--playlist | P    Load m3u playlist(s)                       
```

#### FLAG OPTIONS
```
-s                Shuffle song list (default)
-n                Don't shuffle song list
-f                Fuzzy select song files (default)
-dN               Fuzzy select directories; N=depth
-h | --help       Display this help              
```

#### EXAMPLES
```
$ mup --fuzzy -f      Fuzzy search songs. (default)
$ mup                 Same as --fuzzy -f 
$ mup --here          Play current folder.
$ mup --all -s        Play all; shuffle songs.
$ mup -An             Play all; no shuffle songs.
$ mup -FdN2           Fuzzy search by directory; depth=2.

```
