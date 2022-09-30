#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR/../logging.sh"

prompt_git_add() {
  local file
  file="$1"
  while true; do
    read -r -p "Do you wish to commit README changes (y/n)?" yn
    case $yn in
      [Yy]* ) git add "$file"; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no."; break;;
    esac
  done
}

main() {
  if command -v nix-shell &> /dev/null; then
    GIT_ROOT_DIR="$(git rev-parse --show-toplevel)"
    CMD="$GIT_ROOT_DIR/bin/generate_readme_files.sh $GIT_ROOT_DIR/modules"
    $CMD

    # Check for any updated README.md files and prompt if we should commit them
    while read -u 3 -r file; do
      git diff "$file"
      prompt_git_add "$file"
    done 3< <(git status --short | awk '/^ M modules\/.*\/README\.md/ {print $2}')

  else
      warn "Skipping $0, nix is not installed"
  fi
}

main "$@"
