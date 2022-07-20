#! /usr/bin/env nix-shell
#! nix-shell -i bash -p terraform-docs

print_error() {
  echo "ERROR: $1"
}

main() {
    [[ $# -eq 1 ]] || { echo "USAGE: $0 modules_directory"; exit 1; }
    [[ -d "$1" ]] || { print_error "module_directory '$2' not found"; exit 1; }

    local modules_dir="$1"


    while IFS= read -r -d '' module
    do
        terraform-docs markdown document --output-file "README.md" "$module"
    done < <(find "$modules_dir" -maxdepth 1 ! -path "$modules_dir" -type d -print0)
}

main "$@"
