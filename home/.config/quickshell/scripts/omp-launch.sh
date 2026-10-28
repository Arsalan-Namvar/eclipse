#!/usr/bin/env bash
# General desktop entry uses --general. Project callers omit it; all remaining
# arguments belong to OMP, not a shell command string.
set -euo pipefail
work=$HOME/Work
if [[ ${1-} == --general ]]; then
    shift
    directory=$work
elif [[ $PWD == "$HOME" ]]; then
    directory=$work
else
    directory=$PWD
fi
if [[ $directory == "$work" ]]; then
    mkdir -p -- "$directory"
fi
if ! command -v omp >/dev/null 2>&1; then
    printf 'OMP is not installed; see Eclipse README OMP integration.\n' >&2
    exit 127
fi
# Explicit package path also exposes Eclipse skills with named OMP profiles.
exec kitty --directory "$directory" --title 'OMP — Eclipse' \
    omp --extension "$HOME/.omp/agent/extensions/eclipse" "$@"
