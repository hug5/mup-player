#! /usr/bin/bash

# // 2024-03-16
# // 2024-03-17 Sun 01:03
# mpv-fzy search for song files and directories
# Combined the 2 functions: files and directories;
# // 2024-04-03 : Put all functions here

fd='fdfind'


VOL_LEVEL=60
AUDIO_TYPE='-e mp3 -e opus -e ogg -e flac -e ape -e mpga -e m4a'
MARG="--audio-display=no --volume=$VOL_LEVEL --loop-playlist --speed=1.0 --af=rubberband=pitch-scale=1.0:pitch=quality:smoothing=on,scaletempo"

# STYLE="--prompt=: --header=———————————————————————————————— --preview='head -n50 {}' --preview-window=right:40%"
# --border --margin=1 --prompt=: --header=———————————————————————————————— --preview='head -n50 {}' --preview-window=right:40%:noborder:wrap

  # with preview playlist;
STYLE="--border --prompt=: --header=————————————————————————————————"
  # No preview of playlist
OPTION='--preview-window=right:40%:wrap'

SHUFFLE=true    # Shuffle songs: true/false
SEARCH_TYPE="f"  # f=file; d=directory; file is default;
COUNT=0
ALL_FILES=''
PTYPE=''
FLAGS=''



function _show_help() {
cat << EOF
humm terminal mpv music player

SYNOPSIS
  Play music files with mpv in your terminal

SYNTAX
  $ humm <OPTION> [flag]
  $ humm --fuzzy [-f|-dN] [-s|-n]
  $ humm --all [-s|-n]
  $ humm --here [-s|-n]
  $ humm --playlist [-s|-n]

Kb Shortcuts
  9 / 0 : volume- / volume+
  [ / ] : speed- / speed+
  < / > : previous / next
  left/right : backward / forward
  * refer also to MPV kb shortcuts

PLAY OPTIONS
  --fuzzy           Fuzzy search; use with -d/-f flags
  --all             Play everything in current/subdirectories
  --here            Play in current folder (default)
  --playlist        Load m3u playlist(s)

FLAG OPTIONS
  -s                Shuffle song list (default)
  -n                Don't shuffle song list
  -f                Fuzzy select song files (default)
  -dN               Fuzzy select directories; N=depth
  -h | --help       Display this help

EXAMPLES
  $ humm --here          Play current folder (default).
  $ humm --here -s       Play current folder; shuffle songs.
  $ humm --fuzzy -f      Fuzzy search songs.
  $ humm --fuzzy -d1 -n  Fuzzy search directories; no shuffle.

EOF
exit 0;
}

function _check_playtype() {
    # This is a bit of a hack
    # --xxx option must be the first option;
    local STR="$*"

    case $STR in

      "--fuzzy "* | "--fuzzy")
          PTYPE="fuzzy"
          ;;

      "--all "* | "--all")
          PTYPE="all"
          ;;

      "--playlist "* | "--playlist")
          PTYPE="playlist"
          ;;

      "--here "* | "--here" | "")
          PTYPE="here"
          ;;

      # If any other, then show help
      "--"* | *)
          _show_help
          ;;

    esac

    # Remove all --xxx flags because it seems to interfere with regular single dash flags;
    FLAGS=$(echo "$FLAGS" | sed 's/--[a-z0-9 ]*//g')
    # [a-z ] : a-z or space; do this to remove --all, --here, etc;
    # But we don't want to remove the -s in, --here -s;

}

function _check_flags() {
    local OPTIND
      # Make this a local; the index of the next
      # argument index, not current;
    local LOPTION
      # LOPTION variable will be used in the while loop
      # to hold the flags found that was passed in;

    while getopts ":snd:fh" LOPTION; do  # Loop: Get the next option;

        case "$LOPTION" in
          s)
            SHUFFLE=true
            ;;
          n)
            SHUFFLE=false
            ;;
          d)
            SEARCH_TYPE="d"
            DEPTH="${OPTARG}"

            # check if > 0; or if non integer;
            # If not > 0, then set 1
            if [[ "$DEPTH" -le 0 ]]; then
                DEPTH=1
            fi
            ;;
          f)
            SEARCH_TYPE="f"
            ;;
          h)
            _show_help
            ;;
          *)                   # If unknown (any other) option:
             echo "Unknown Option."
             _show_help
            ;;
        esac
    done

}


function _humm_fzy() {

    ALL_FILES=$($fd -t f $AUDIO_TYPE | fzf -m $STYLE | sed -e 's/.*/\"&\"/')
      # AUDIO_TYPE won't work if quotes;
      # -t f : type files;

    if [[ -z "$ALL_FILES" ]]; then
        echo "Goodbye."
        exit
    fi

}

function _humm_fzyd() {
    local DIR_SELECTED
    # DIR_SELECTED=$($fd -t d -d $DEPTH --full-path "."| fzf -m $STYLE)
      # -t d : type directory;
      # -d $DEPTH : depth of directory;
    DIR_SELECTED=$($fd -td -d $DEPTH --full-path "." | fzf -m $STYLE "$OPTION" --preview="$fd  . -tf -d99 {}")
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

        # NEW_FILES=$($fd -t f $AUDIO_TYPE --full-path "$line" | sed -e 's/.*/\"&\"/')
        NEW_FILES=$($fd -t f $AUDIO_TYPE . "./$line" | sed -e 's/.*/\"&\"/')
          # AUDIO_TYPE won't work if quotes;
          # See note why I changed the syntax from --full-path to . "./$line"

        ALL_FILES+="${NEW_FILES} "
    done < <(printf '%s\n' "$DIR_SELECTED")

}

function _humm_all() {
    ALL_FILES=$($fd -t f $AUDIO_TYPE | sed -e 's/.*/\"&\"/')

}

function _humm_here() {
    ALL_FILES=$($fd -t f -d 1 $AUDIO_TYPE | sed -e 's/.*/\"&\"/')

}

function _humm_playlist() {

    local PLAYLIST
    local NEW_FILES=''
    # PLAYLIST=$($fd -t f -e m3u | fzf $STYLE | sed -e 's/.*/\"&\"/')
      # Can't cat a playlist when it's quoted in a script

    local ISBat=''
    local ISBatCAT=''
    ISBAT=$(which bat)
    ISBATCAT=$(which batcat)
      # Check if bat/batcat exists; if so, use bat; else use head for preview;
    if [[ -n $ISBAT ]]; then
        PLAYLIST=$($fd -t f -e m3u | fzf -m $STYLE "$OPTION" --preview='bat --color=always --line-range=:100 {}')
    elif [[ -n $ISBATCAT ]]; then
        PLAYLIST=$($fd -t f -e m3u | fzf -m $STYLE "$OPTION" --preview='batcat --color=always --line-range=:100 {}')
    else
        PLAYLIST=$($fd -t f -e m3u | fzf -m $STYLE "$OPTION" --preview='head -n100 {}' )
    fi


    if [[ -z "$PLAYLIST" ]]; then
        echo "Goodbye."
        exit
    fi

    while IFS= read -r line; do
        NEW_FILES=$(echo "$line" | sed -e 's/.*/\"&\"/')
        NEW_FILES+=$'\n' # add new line character
          # Not sure why I have to add a newline in this case;
        ALL_FILES+="${NEW_FILES}"
    done < <(while IFS= read -r list; do
            cat "$list"
        done < <(printf '%s\n' "$PLAYLIST"))

    # Remove the last blank line; either of these seem to work;
    ALL_FILES=$(echo "$ALL_FILES" | grep .)

}


function _humm_play() {

    if [[ -z "$ALL_FILES" || "$ALL_FILES" == ' '  ]]; then
        echo "No music files found."
        exit
    fi

    COUNT=$(echo "$ALL_FILES" | wc -l)

    if [[ "$SHUFFLE" == true ]]; then
        echo "Play $PTYPE. $COUNT songs. Shuffle On."
        echo "$ALL_FILES" | xargs mpv --shuffle $MARG
    else
        echo "Play $PTYPE. $COUNT songs. Shuffle Off."
        echo "$ALL_FILES" | xargs mpv $MARG
        # Errors if quote $MARG
    fi


}

# Not sure if this will be buggy, but this seems to work;
# Want to put into a variable becuase need to edit the flags and options; since I'm using --here, --fuzzy flags along with -s, -d; it seems that the built-in bash interprets --playlist, for instance, as an -s flag because there's an s in it; that's not good! So after checking for the --flags, I delete them all from the string;
FLAGS="$*"

# Check for --flags
# _check_playtype "$*"

_check_playtype "$FLAGS"

_check_flags $FLAGS
  # In this instance, passing $FLAGS in quotes doesn't work
  # Needs to be unquoted to get each variable treated distinctly;
  # Remember that I set the FLAGS variable myself because I'm
  # Using both --long and -s flag types and parsing string myself;


if [[ $PTYPE == "all" ]]; then
  _humm_all

elif [[ $PTYPE == "here" ]]; then
  _humm_here

elif [[ $PTYPE == "fuzzy" ]]; then
  # If file, then run file function;
  if [[ "$SEARCH_TYPE" == "f" ]]; then
      _humm_fzy
  # if -d, directory, then run directory function;
  else
      _humm_fzyd
  fi

elif [[ $PTYPE == "playlist" ]]; then
  _humm_playlist

fi

# After accumulating song files, play them:
_humm_play
