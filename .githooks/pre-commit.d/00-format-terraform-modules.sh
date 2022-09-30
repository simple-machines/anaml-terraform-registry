#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR/../logging.sh"

# Find any *.tf files staged for commit and run `terraform fmt` on them,
# then stage the changes
while read -r file ; do
  info "Formatting $file"
  terraform fmt "$file" && git add "$file"
done < <(git status --short | awk '/^M.*\.tf$/ { print $2 }')

