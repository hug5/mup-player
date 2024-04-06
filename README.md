# humm.sh

## humm terminal music player

Play music files in your terminal with mpv.

-------------------------------------------------

#### REQUIREMENTS
  - mpv player
  - fzy search
  
  
#### SYNTAX
```
$ humm <OPTION> [flag]  
$ humm --fuzzy [-f|-d] [-s]  
$ humm --all [-s]  
$ humm --here [-s]  
$ humm --playlist [-s]  
```
#### Kb Shortcuts
```
9/0 : volume-/volume+
[/] : speed-/speed+
</> : previous/next
left-arrow/right-arrow : backward/forward
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
-s                Shuffle list                      
-f                Fuzzy select song files (default) 
-d                Fuzzy select directories          
-h | --help       Display this help                 
```

#### EXAMPLES
```
$ humm --here        Play current folder (default).
$ humm --here -s     Play current folder; shuffle songs.
$ humm --fuzzy -f    Fuzzy search songs.
$ humm --fuzzy -ds   Fuzzy search directories; shuffle.
```
