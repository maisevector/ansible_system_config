#!/usr/bin/env bash

while getopts "nh" opt; do
    case "${opt}" in
        n) # Dry run
            DRY_RUN=1
            ;;
        h | *) #Display help
            echo "-n is dry run, others do not exist"
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

length_in_seconds() {
    ffprobe "$1" 2>&1 | awk '/Duration/ { print $2 }' | awk -F':' '{print $1 * 3600 + $2 * 60 + $3}' | sed 's/\..*//g'
}

diff_abs () {
    res=$(( $1 - $2 ))
    echo "${res#-}"
}

find . -type f -name "*.mp3" | while read file; do
    if [ -f "$file" ] && [ -f "${file/%mp3/ogg}" ]; then
        # echo "Both files exist: ${file}"
        dur_mp3="$(length_in_seconds "$file")"
        dur_ogg="$(length_in_seconds "${file/%mp3/ogg}")"
        time_diff="$(diff_abs "$dur_mp3" "$dur_ogg")"
        if [ "${time_diff}" -gt 1 ]; then
            echo "Diff high for ${file}, is ${time_diff}s."
        else
            if [ -n "${DRY_RUN}" ]; then
                echo "rm ${file}"
            else
                rm "${file}"
            fi
        fi
    fi
done
