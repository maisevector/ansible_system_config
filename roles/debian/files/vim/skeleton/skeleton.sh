#!/usr/bin/env bash
set -euo pipefail

usage() { echo "$0 usage:" && grep ' .) #' "$0"; exit 0; }
[ $# -eq 0 ] && usage
while getopts ":hn" arg; do
  case $arg in
    n) # Dry run
      echo "n is ${OPTARG}"
      ;;
    h | *) # Display help.
      usage
      ;;
  esac
done

