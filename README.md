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
$ mup --fuzzy [-f|-dN] [-s|-n]
$ mup --all [-s|-n]
$ mup --here [-s|-n]
$ mup --playlist [-s|-n]
```
#### Kb Shortcuts
```
9 / 0 : volume- / volume+
[ / ] : speed- / speed+
< / > : previous / next
left / right : backward / forward
* refer also to MPV kb shortcuts
```
-------------------------------------------------

#### PLAY OPTIONS
```
--fuzzy           Fuzzy search; use with -d/-f options       
--all             Play everything in current/subdirectories  
--here            Play in current folder (default)           
--playlist        Load m3u playlist(s)                       
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
$ mup --here          Play current folder (default).
$ mup --all -s        Play all; shuffle songs.
$ mup --fuzzy -f      Fuzzy search songs.
$ mup --fuzzy -d1 -n  Fuzzy search by directory; no shuffle.
```
