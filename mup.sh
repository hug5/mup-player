#! /usr/bin/bash

# // 2024-03-16
# // 2024-03-17 Sun 01:03
# mpv-fzy search for song files and directories
# Combined the 2 functions: files and directories;
# // 2024-04-03 : Put all functions here
# // 2026-05-27 : add video type

#---------------------------------------------------------

# This script should not be sourced;
# Not sourcing runs the program in a new shell;
# Sourcing runs the program in the current shell;
#


#---------------------------------------------------------

declare fd='fdfind'

declare -i VOL_LEVEL=60
declare AUDIO_TYPE_EXT='-e mp3 -e opus -e ogg -e flac -e ape -e mpga -e m4a'
declare MARG="--audio-display=no --volume=$VOL_LEVEL --loop-playlist --speed=1.0 --af=rubberband=pitch-scale=1.0:pitch=quality:smoothing=on,scaletempo"

declare VIDEO_TYPE_EXT='-e mp4 -e avi -e mkv -e wmv -e flv -e webm -e mov -e asf -e mpg -e mpeg -e ts'

# Will be AUDIO_TYPE_EXT OR VIDEO_TYPE_EXT
declare MEDIA_TYPE_EXT="$AUDIO_TYPE_EXT"

declare MEDIA_TYPE="A"     # A (audio) or V (video)

# STYLE="--prompt=: --header=———————————————————————————————— --preview='head -n50 {}' --preview-window=right:40%"
# --border --margin=1 --prompt=: --header=———————————————————————————————— --preview='head -n50 {}' --preview-window=right:40%:noborder:wrap

  # with preview playlist;
declare STYLE="--border --prompt=: --header=————————————————————————————————"
  # No preview of playlist
declare PREV='--preview-window=right:60%:wrap'

declare SHUFFLE=false      # Shuffle songs: true/false
declare SEARCH_TYPE="f"    # f=file; d=directory; file is default;
declare -i COUNT=0
declare PTYPE=''           # Play Type: fuzzy, all, here, playlist
declare FLAGS=''
declare -i DEPTH=1
# declare -a ALL_FILES
declare ALL_FILES=''



function show_help() {
cat << EOF
mup terminal media player

SYNOPSIS
  Play music files with mpv in your terminal & video files with SMPlayer.

SYNTAX
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
  * refer also to MPV kb shortcuts

PLAY COMMANDS
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


EOF
exit 0;
}

function check_longflag_playtype() {
    # This is a bit of a hack
    # --xxx option must be the first option;
    # local STR="$*"
    # case $STR in

    # Set PTYPE variable; or play type;

    case $FLAGS in

      "--all "* | "--all")
          PTYPE="all"
          ;;

      "--playlist "* | "--playlist")
          PTYPE="playlist"
          ;;

      # "--here "* | "--here" | "")
      "--here "* | "--here")
          PTYPE="here"
          ;;

      # "--fuzzy "* | "--fuzzy")
      # If blank, then default to --here
      "--fuzzy "* | "--fuzzy" | "")
          PTYPE="fuzzy"
          ;;

      # If any other long dash, then show help
      # "--"* | *)
      "--"*)
          show_help
          ;;

    esac

    # Remove all --xxx flags because it seems to interfere with
     # regular single dash flags;
    # FLAGS=$(echo "$FLAGS" | sed 's/--[a-z0-9 ]*//g')
      # [a-z ] : a-z or space; do this to remove --all, --here, etc;
      # But we don't want to remove the -s in, --here -s;

    # Note: This isn't necessary, actually, unless you want to
     # remove multiple --xx flags; can just call "shift" command
     # to shift over to next arguments, instead; so will just do
     # that instead; multiple --xxx flags will just produce error;
}

function check_bad_longflag() {
    # If long flag used, then error if repeat same with short flag;
    if [[ -n "$PTYPE" ]]; then
        echo "Bad Option.";
        show_help;
    fi
}

function check_shortflags() {
    local OPTIND
      # OPTIND = index of next argument; not current!
      # Make this a local; the index of the next
      # argument index, not current;
    local LOPTION
      # LOPTION variable will be used in the while loop
      # to hold the flags found that was passed in;
    local LDEPTH
      # When --fuzzy, get directory DEPTH; default=1

    local MTYPE
      # media type: A or V

    # Set variabless:
     # DEPTH
     # SHUFFLE
     # PTYPE (if long version hasn't been yet set)
     # SEARCH_TYPE

    # Loop: Get the next option;
    # x: = takes an arguments
    # no : = does not take argument
    # : at beginning = silent error on unsupported option
    # Below, only N takes argument;
    while getopts ":dsnvfhFAHPN:" LOPTION; do

        case "$LOPTION" in

          F)
            check_bad_longflag
            PTYPE="fuzzy"
            ;;
          A)
            check_bad_longflag
            PTYPE="all"
            ;;
          H)
            check_bad_longflag
            PTYPE="here"
            ;;
          P)
            check_bad_longflag
            PTYPE="playlist"
            ;;
          s)
            SHUFFLE=true
            ;;
          # n)
          #   SHUFFLE=false
          #   # exit
          #   ;;
          n)
            # $OPTARG = switch argument
            LDEPTH="${OPTARG}"

            if [[ "$LDEPTH" -ge 2 ]]; then
                 DEPTH=$LDEPTH
            fi
            # else DEPTH is default 1
            ;;

          v)

            # make user's media_type choice, A or V, to upper
            # MTYPE=$(printf %s "${OPTARG}" | tr "[:lower:]" "[:upper:]")

            # # Check that it's either V or A
            # if [[ "$MTYPE" != "V" && "$MTYPE" != "A" ]]; then
            #     echo "Unknown media type."
            #     show_help
            # fi
            # MEDIA_TYPE="$MTYPE"

            # if [[ "$MTYPE" == "V" ]]; then
            #     MEDIA_TYPE_EXT="$VIDEO_TYPE_EXT"
            # else
            #     MEDIA_TYPE_EXT="$AUDIO_TYPE_EXT"
            # fi

            MEDIA_TYPE="V"
            MEDIA_TYPE_EXT="$VIDEO_TYPE_EXT"

            ;;
          d)
            SEARCH_TYPE="d"
            ;;
          # f)
          #   SEARCH_TYPE="f"
          #   ;;
          h)
            show_help
            ;;
          *)                   # If unknown (any other) option:
             echo "Unknown Option."
             show_help
            ;;
        esac
    done

    # echo $PTYPE
    # echo $DEPTH
    # echo $SEARCH_TYPE
    # echo $SHUFFLE
}


function mup_fzy() {

    ALL_FILES=$($fd -t f $MEDIA_TYPE_EXT | fzf -m $STYLE | sed -e 's/.*/\"&\"/')
      # MEDIA_TYPE_EXT won't work if quotes;

      # fd-find
      # -t f : type files;

      # fzf
      # -m : multiselect

    if [[ -z "$ALL_FILES" ]]; then
        echo "Goodbye."
        exit
    fi

}

function mup_fzyd() {
    local DIR_SELECTED
    # DIR_SELECTED=$($fd -t d -d $DEPTH --full-path "."| fzf -m $STYLE)
      # -t d : type directory;
      # -d $DEPTH : depth of directory;
    DIR_SELECTED=$($fd -td -d $DEPTH --full-path "." | fzf -m $STYLE "$PREV" --preview="$fd  . -tf -d99 $MEDIA_TYPE_EXT {}")
      # Added preview option; preview the files in the directory;
      # Going depth 99; the parent folder may have no music files;
      # Now if I can remove the directory and show the file name only;
      # Getting error when using $fd inside single quote

    # Check for empty string
    if [[ -z "$DIR_SELECTED" ]]; then
        echo "Goodbye."
        exit
    fi

    local NEW_FILES=''
    while IFS= read -r line; do

        # NEW_FILES=$($fd -t f $MEDIA_TYPE_EXT --full-path "$line" | sed -e 's/.*/\"&\"/')
        NEW_FILES=$($fd -t f $MEDIA_TYPE_EXT . "./$line" | sed -e 's/.*/\"&\"/')
          # MEDIA_TYPE_EXT won't work if quotes;
          # See note why I changed the syntax from --full-path to . "./$line"

        ALL_FILES+="${NEW_FILES} "
    done < <(printf '%s\n' "$DIR_SELECTED")

}


# fd-find options:
  # -t f : filter search by type
    # f, file : regular file
    # d, directory : directories
  # -d d : directory depth; limit to max-depth d
    # By default, no limit;

# sed : stream editor
 # -e : perform script operation; can use to do multiple operations
 # sed -e 's/.*/\"&\"/' : wrap string in quotes
 # & represents the matched string

function mup_all() {
    ALL_FILES=$($fd -t f $MEDIA_TYPE_EXT | sed -e 's/.*/\"&\"/')

}

function mup_here() {

    ALL_FILES=$($fd -t f -d 1 $MEDIA_TYPE_EXT | sed -e 's/.*/\"&\"/')

    # printf '%s' "$ALL_FILES" > ~/Downloads/mup_temp1.txt
    # printf '%s\n' "$ALL_FILES" > ~/Downloads/mup_temp1.txt
      # why is this not printing out the \n in the output?

}

function mup_playlist() {

    local PLAYLIST
    local NEW_FILES=''
    # PLAYLIST=$($fd -t f -e m3u | fzf $STYLE | sed -e 's/.*/\"&\"/')
      # Can't cat a playlist when it's quoted in a script

    local ISBAT=''
    local ISBATCAT=''
    # ISBAT=$(hash bat 2>/dev/null)
    # ISBATCAT=$(hash batcat 2>/dev/null)
      # Didn't realize that this never worked!!
      # hash command doesn't work on my ubuntu
    ISBAT=$(command -v bat 2>/dev/null)
    ISBATCAT=$(command -v batcat 2>/dev/null)
      # Check if bat/batcat exists; if so, use bat; else use head for preview;
      # LSP suggestion:
      # https://www.shellcheck.net/wiki/SC2230
      # For the path of a single, unaliased, external command,
      # or to check whether this will just "run" in this shell:
      # command -v <command>
      # To check whether commands exist, without obtaining a reusable path:
      # hash <command>
      # do &>/dev/null to silence any errors;

    # // 2026-05-21
    # Added awk -F/ '{print \$NF}' to print just the song name w/o path;
    # Putting playlist in PLAYLIST variable;
    if [[ -n $ISBAT ]]; then
        # echo "here 1"
        PLAYLIST=$($fd -t f -e m3u | fzf -m $STYLE "$PREV" --preview="bat -pp --color=always --line-range=:100 {} | awk -F/ '{print \$NF}' ")
    elif [[ -n $ISBATCAT ]]; then
        # echo "here 2"
        # PLAYLIST=$($fd -t f -e m3u | fzf -m $STYLE "$PREV" --preview "head -n100 {} | awk -F/ '{print \$NF}' ")
        PLAYLIST=$($fd -t f -e m3u | fzf -m $STYLE "$PREV" --preview="batcat -pp --color=always --line-range=:100 {} | awk -F/ '{print \$NF}' ")
    else
        # echo "here 3"
        # PLAYLIST=$($fd -t f -e m3u | fzf -m $STYLE "$PREV" --preview='head -n100 {} ' )
        PLAYLIST=$($fd -t f -e m3u | fzf -m $STYLE "$PREV" --preview="head -n100 {} | awk -F/ '{print \$NF}' ")
    fi


    # If no playlist chosen;
    if [[ -z "$PLAYLIST" ]]; then
        echo "Goodbye."
        exit
    fi


    # Read the catted playlist:
    # IFS= = internal field separator; in this case, do not delimit by white space;
    # read -r : do not respect escape characters;
    while IFS= read -r line; do
        NEW_FILES=$(printf %s "$line" | sed -e 's/.*/\"&\"/')
          # wrap in quotes
        NEW_FILES+=$'\n'
          # add new line character; the $ ensures it's a real newline,
           # not just '\n' literal characters;
        ALL_FILES+="${NEW_FILES}"

    done < <(while IFS= read -r list; do
            cat "$list"
            # send cat of playlist content to above read;
        done < <(printf '%s\n' "$PLAYLIST"))
        # Name of .m3u file, not the contents;
        # %s : print as string;
        # Needs to add \n to playlist because 'read' can only
         # read if it's terminated by newline character;
        # Since we need a \n, could just use echo as well;


    # echo %s "$ALL_FILES"
    # exit

    # Remove the last blank line; either of these seem to work;
    # ALL_FILES=$(printf %s "$ALL_FILES" | grep .)
    # ALL_FILES=$(echo "$ALL_FILES" | grep .)
      # what is the issue with the last line?

    # printf '%s' $ALL_FILES > ~/Downloads/mup_temp1.txt
      # why is this not printing out the \n in the output?
}


function mup_play() {

    # playlist load max; for smplayer, the max seems to be
     # somewhere between 1970 and 1980 files;
    # Don't think cli mpv has a max? Never had a problem.
    local MLIMIT=1975


    if [[ -z "$ALL_FILES" || "$ALL_FILES" == ' '  ]]; then
        echo "No music files found."
        exit
    fi

    COUNT=$(echo "$ALL_FILES" | wc -l)
      # wc -l : get # of lines

    printf %s "Play $PTYPE. $COUNT media files found. "


    if (( $COUNT > $MLIMIT )); then
    # if [[ $COUNT -gr $MLIMIT ]]; # Can also do this way;
        printf %s "Limit $MLIMIT. "
    fi


    if [[ "$SHUFFLE" == true ]]; then
        ALL_FILES=$(printf %s "$ALL_FILES" | shuf -n $MLIMIT)
        echo "Shuffle On."
    else
        ALL_FILES=$(printf %s "$ALL_FILES" | head -n $MLIMIT)
        echo "Shuffle Off."
    fi

    if [[ "$MEDIA_TYPE" == "A" ]]; then
       printf %s "$ALL_FILES" | xargs mpv $MARG
    else
       printf %s "$ALL_FILES" | xargs smplayer -actions "pl_repeat true" &>/dev/null & disown
       echo "Playing..."
       # the &>/dev/null prevents showing various error message in cli
       # -add-to-playlist doesn't seem necessary;
       # AI says '%s' is a good idea; but see no difference;
       # Also can try '%s\n', but see no difference to add the final newline;
       # -action "pl_repeast true" : set playlist to repeat or cycle back if at the end;
       # -actions "pl_shuffle true pl_repeat true"
       # pl_repeat true  = repeat playlist
       # repeat true     = repeat current file / repeat mode

    fi

    ####
      # if [[ "$SHUFFLE" == true ]]; then
      #     echo "Suffle On."
      #     # smplayer -help

      #     # ALL_FILES=$(echo "$ALL_FILES" | shuf)  # shuffle; necessary?
      #     # Sometimes it seens it doesn't shuffle; or maybe some tracks are very numerous?
      #     # echo "Play $PTYPE. $COUNT songs. Shuffle On."
      #    echo "$ALL_FILES" | xargs mpv --shuffle $MARG
      #     # echo "$ALL_FILES" | shuf | xargs smplayer -actions "pl_shuffle true" &>/dev/null & disown
      #     # echo "$ALL_FILES" | shuf -n 1500 | xargs smplayer -actions "pl_shuffle true" &>/dev/null & disown

      #    # echo "$ALL_FILES" | shuf -n 1980 | xargs smplayer &>/dev/null & disown
      #     # somewhere between 1980 and 1990 seems to be the limit for the playlist;
      #     # Forward and back doesn't go to the same file; it's always something random;

      #     # mapfile -t files < <(printf '%s' "$ALL_FILES" | shuf | head -n20)
      #     # # setsid -f smplayer -actions "pl_shuffle true" "${files[@]}" >/dev/null 2>&1
      #     # smplayer -actions "pl_shuffle true" "${files[@]}" >/dev/null 2>&1
      # else
      #     echo "Suffle Off."
      #     # echo "Play $PTYPE. $COUNT songs. Shuffle Off."
      #     echo "$ALL_FILES" | xargs mpv $MARG
      #     # Errors if quote $MARG
      # fi


}

# Not sure if this will be buggy, but this seems to work;
# Want to put into a variable becuase need to edit the flags and
 # options; since I'm using --here, --fuzzy flags along with -s,
 # -d; it seems that the built-in bash interprets --playlist, for
 # instance, as an -s flag because there's an s in it; that's not
 # good! So after checking for the --flags, I delete them all from
 # the string;
FLAGS="$*"
  # "$*" : As a single string
  # "$@" : As separate distinct strings

# Check for --flags; get PTYPE or Play Type:
 # fuzzy, all, here, playlist
check_longflag_playtype "$FLAGS"

# check_shortflags $FLAGS
  # In this instance, passing $FLAGS in quotes doesn't work
  # The downside (or maybe upside) is that it will error if
  # multiple --xxx flags;
  # Needs to be unquoted to get each variable treated distinctly;
  # Remember that I set the FLAGS variable myself because I'm
  # Using both --long and -s flag types and parsing string myself;

# Only shift if long flag was used:
# If PTYPE variable was set, then shift;
# shift discards positional parameters, $1, $2, $3, etc;
# -n : Not empty
if [[ -n "$PTYPE" ]]; then
    shift
fi


# Now check short flags:
check_shortflags $*


# If PTYPE not set, then default to fuzzy
if [[ -z "$PTYPE" ]]; then
    # if PTYPE long flag not used, then set PTYPE default to fuzzy;
    PTYPE="fuzzy"
fi


if [[ $PTYPE == "all" ]]; then
    mup_all

elif [[ $PTYPE == "here" ]]; then
    mup_here

elif [[ $PTYPE == "fuzzy" ]]; then
    # If file, then run file function;
    if [[ "$SEARCH_TYPE" == "f" ]]; then
        mup_fzy
    # if -d, directory, then run directory function;
    else
        mup_fzyd
    fi

elif [[ $PTYPE == "playlist" ]]; then
    mup_playlist
fi

# After accumulating song files, play them:
mup_play
