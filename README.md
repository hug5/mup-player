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
[ / ] : speed- / speed+
< / > : previous / next
left / right : backward / forward
* refer also to MPV kb shortcuts
```
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
