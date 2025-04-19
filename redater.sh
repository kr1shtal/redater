#!/bin/bash

export_date () {
  day=${2:-$(date +"%d")}
  month=${3:-$(date +"%m")}
  year=${4:-$(date +"%Y")}
  hour=${5:-$(date +"%H")}
  minute=${6:-$(date +"%M")}
  second=${7:-$(date +"%S")}

  utc=${8:-$(date +%z)}

  if [[ ! $utc =~ ^[+-][0-9]{4}$ ]]; then
    echo "Invalid UTF offset format. Use +HHMM or -HHMM"
    exit 1
  fi

  utc_offset="${utc:0:3}:${utc:3:2}"
  timestamp="${year}-${month}-${day}T${hour}:${minute}:${second}${utc_offset}"

  export GIT_COMMITTER_DATE="$timestamp"
  export GIT_AUTHOR_DATE="$timestamp"

  echo "GIT_COMMITTER_DATE=$timestamp"
  echo "GIT_AUTHOR_DATE=$timestamp"
}

unset_date () {
  unset GIT_COMMITTER_DATE
  unset GIT_AUTHOR_DATE

  echo "unset GIT_COMMITTER_DATE"
  echo "unset GIT_AUTHOR_DATE"
}

help () {
  echo -e "Usage: ./redater [options] [DAY] [MONTH] [YEAR] [HOUR] [MINUTE] [SECOND] [UTC_OFFSET]"
  echo ""
  echo "  Options:"
  echo "  -e or --export  Export date to a specific timestamp for new commits"
  echo "  -u or --unset   Unset exported date"
  echo "  -h or --help    Show this help message"
  echo ""
  echo "  Example:"
  echo "    source ./redater -e 17 04 2024 18 53 26 +0300"
}

case "$1" in
  -e|--export) export_date "$@" ;;
  -u|--unset) unset_date ;;
  -h|--help) help ;;
  *) echo "Sorry, I don't know how to do: $1. Look for help --help" ;;
esac
