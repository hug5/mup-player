# humm.sh

## humm terminal music player

Play music files in your terminal with mpv.

-------------------------------------------------

#### REQUIREMENTS
  - mpv player
  - fzf search
  
  
#### SYNTAX
```
$ humm <OPTION> [flag]
$ humm --fuzzy [-f|-dN] [-s|-n]
$ humm --all [-s|-n]
$ humm --here [-s|-n]
$ humm --playlist [-s|-n]
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
$ humm --here          Play current folder (default).
$ humm --all -s        Play all; shuffle songs.
$ humm --fuzzy -f      Fuzzy search songs.
$ humm --fuzzy -d1 -n  Fuzzy search by directory; no shuffle.
```
