# hmp.sh

## hmp terminal music player

Play music files in your terminal with mpv.

-------------------------------------------------

#### REQUIREMENTS:
  - mpv player
  - fzy search  
  

#### SYNTAX
```
$ hmp <OPTION> [flag]  
$ hmp --fzy [-f|-d] [-s]  
$ hmp --all [-s]  
$ hmp --here [-s]  
$ hmp --playlist [-s]  
````

-------------------------------------------------

#### PLAY OPTIONS
```
--fzy / --fuzzy    Fuzzy search; use with -d/-f options       
--all              Play everything in current/subdirectories  
--here             Play in current folder (default)           
--playlist         Load m3u playlist(s)                       
```

#### FLAG OPTIONS
```
-s                 Shuffle list                      
-f                 Fuzzy select song files (default) 
-d                 Fuzzy select directories          
-h                 Display this help                 
```

#### EXAMPLES
```
$ hmp -h            Show help
$ hmp --here        Play current folder (default).
$ hmp --here -s     Play current folder; shuffle songs.
$ hmp --all         Play everything in/under current directory.
$ hmp --fzy         Fuzzy search songs.
$ hmp --fzy -ds     Fuzzy search directories; shuffle.
```
