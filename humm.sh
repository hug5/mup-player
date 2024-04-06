#! /usr/bin/bash

# // 2024-03-16
# // 2024-03-17 Sun 01:03
# mpv-fzy search for song files and directories
# Combined the 2 functions: files and directories;
# // 2024-04-03 : Put all functions here


VOL_LEVEL=60
AUDIO_TYPE='-e mp3 -e opus -e ogg -e flac -e ape -e mpga -e m4a'
MARG="--audio-display=no --volume=$VOL_LEVEL --loop-playlist --speed=1.0 --af=rubberband=pitch-scale=1.0:pitch=quality:smoothing=on,scaletempo"
# FARG=''
# FARG="--prompt=: --header=———————————————————————————————— --preview='head -n50 {}' --preview-window=right:40%"
FARG="--prompt=: --header=————————————————————————————————"

SHUFFLE=false    # Shuffle songs: true/false
SEARCH_TYPE="f"  # f=file; d=directory; file is default;
COUNT=0
ALL_FILES=''
OPTION=''
FLAGS=''


function _show_help() {
cat << EOF
humm terminal mpv music player

SYNOPSIS
  Play music files with mpv in your terminal

SYNTAX
  $ humm <OPTION> [flag]
  $ humm --fuzzy [-f|-d] [-s]
  $ humm --all [-s]
  $ humm --here [-s]
  $ humm --playlist [-s]

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
  -s                Shuffle song list
  -f                Fuzzy select song files (default)
  -d                Fuzzy select directories
  -h | --help       Display this help

EXAMPLES
  $ humm --here        Play current folder (default).
  $ humm --here -s     Play current folder; shuffle songs.
  $ humm --fuzzy -f    Fuzzy search songs.
  $ humm --fuzzy -ds   Fuzzy search directories; shuffle.

EOF
exit 0;
}

function _check_options() {
    # This is a bit of a hack
    # --xxx option must be the first option;
    local STR="$*"

    case $STR in

      "--fuzzy "* | "--fuzzy")
          OPTION="fuzzy"
          ;;

      "--all "* | "--all")
          OPTION="all"
          ;;

      "--playlist "* | "--playlist")
          OPTION="playlist"
          ;;

      "--here "* | "--here" | "")
          OPTION="here"
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
    local OPTIND                          # Make this a local; the index of the next argument index, not current;

    while getopts ":dsfh" OPTIONS; do       # Loop: Get the next option;

        case "$OPTIONS" in
          s)
            SHUFFLE=true
            ;;
          d)
            SEARCH_TYPE="d"
            ;;
          f)
            SEARCH_TYPE="f"
            ;;
          h)
            _show_help
            ;;

          *)                   # If unknown (any other) option:
             _show_help
            ;;
        esac
    done

}

function _humm_fzy() {

    ALL_FILES=$(fdfind -t f $AUDIO_TYPE | fzf -m $FARG | sed -e 's/.*/\"&\"/')
      # AUDIO_TYPE won't work if quotes;
      # -t f : type files;

    if [[ -z "$ALL_FILES" ]]; then
        echo "Goodbye."
        exit
    fi

}

function _humm_fzyd() {
    local DIR_SELECTED
    DIR_SELECTED=$(fdfind -t d -d 1 --full-path "."| fzf -m $FARG)
      # -t d : type directory;
      # -d 1 : depth of 1 directory; don't go recursive into subfolders;

    # Check for empty string
    if [[ -z "$DIR_SELECTED" ]]; then
        echo "Goodbye."
        exit
    fi

    local NEW_FILES=''
    while IFS= read -r line; do

        # NEW_FILES=$(fdfind -t f $AUDIO_TYPE --full-path "$line" | sed -e 's/.*/\"&\"/')
        NEW_FILES=$(fdfind -t f $AUDIO_TYPE . "./$line" | sed -e 's/.*/\"&\"/')
          # AUDIO_TYPE won't work if quotes;
          # See note why I changed the syntax from --full-path to . "./$line"

        ALL_FILES+="${NEW_FILES} "
    done < <(printf '%s\n' "$DIR_SELECTED")

}

function _humm_all() {
    ALL_FILES=$(fdfind -t f $AUDIO_TYPE | sed -e 's/.*/\"&\"/')

}

function _humm_here() {
    ALL_FILES=$(fdfind -t f -d 1 $AUDIO_TYPE | sed -e 's/.*/\"&\"/')

}

function _humm_playlist() {

    local PLAYLIST
    local NEW_FILES=''
    # PLAYLIST=$(fdfind -t f -e m3u | fzf $FARG | sed -e 's/.*/\"&\"/')
      # Can't cat a playlist when it's quoted in a script

    PLAYLIST=$(fdfind -t f -e m3u | fzf -m $FARG)

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
        echo "Play $OPTION. $COUNT songs. Shuffle On."
        echo "$ALL_FILES" | xargs mpv --shuffle $MARG
    else
        echo "Play $OPTION. $COUNT songs. Shuffle Off."
        echo "$ALL_FILES" | xargs mpv $MARG
        # Errors if quote $MARG
    fi


}

# Not sure if this will be buggy, but this seems to work;
# Want to put into a variable becuase need to edit the flags and options; since I'm using --here, --fuzzy flags along with -s, -d; it seems that the built-in bash interprets --playlist, for instance, as an -s flag because there's an s in it; that's not good! So after checking for the --flags, I delete them all from the string;
FLAGS="$*"

# Check for --flags
# _check_options "$*"
_check_options "$FLAGS"

# echo $OPTION; exit

# Check flags: check for -d and -s
# _check_flags "$@"
_check_flags "$FLAGS"


if [[ $OPTION == "all" ]]; then
  _humm_all

elif [[ $OPTION == "here" ]]; then
  _humm_here

elif [[ $OPTION == "fuzzy" ]]; then
  # If file, then run file function;
  if [[ "$SEARCH_TYPE" == "f" ]]; then
      _humm_fzy
  # if -d, directory, then run directory function;
  else
      _humm_fzyd
  fi

elif [[ $OPTION == "playlist" ]]; then
  _humm_playlist

fi

# After accumulating song files, play them:
_humm_play
