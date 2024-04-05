# hmp.sh

## hmp Terminal mpv Music Player

Play music files with mpv in your terminal.

-------------------------------------------------

#### REQUIREMENTS:
  - mpv player
  - fzy search  
  
-------------------------------------------------

#### SYNTAX
&nbsp;&nbsp;$ hmp \<OPTION\> [flag]  
&nbsp;&nbsp;$ hmp --fzy [-f|-d] [-s]  
&nbsp;&nbsp;$ hmp --all [-s]  
&nbsp;&nbsp;$ hmp --here [-s]  
&nbsp;&nbsp;$ hmp --playlist [-s]  

-------------------------------------------------

#### PLAY OPTIONS
| Option          | Detail                                    |
|-----------------|-------------------------------------------|  
|--fzy / --fuzzy  | Fuzzy search; use with -d/-f options      | 
|--all            | Play everything in current/subdirectories | 
|--here           | Play in current folder (default)          | 
|--playlist       | Load m3u playlist(s)                      | 

#### FLAG OPTIONS
| Option          | Detail                            |
|-----------------|-----------------------------------|
|-s               | Shuffle list                      |
|-f               | Fuzzy select song files (default) |
|-d               | Fuzzy select directories          |
|-h               | Display this help                 |

#### EXAMPLES
| Example            | Detail     |
|--------------------|------------|
| $ hmp -h           | Show help  |
| $ hmp --here       | Play current folder (default).  |
| $ hmp --here -s    | Play current folder; shuffle songs.  |
| $ hmp --all        | Play everything in/under current directory.  |
| $ hmp --fzy        | Fuzzy search songs.  |
| $ hmp --fzy -ds    | Fuzzy search directories; shuffle.  |

