#!/bin/bash - 
#===============================================================================
#
#          FILE: createHotfixPR.sh
# 
#         USAGE: ./createHotfixPR.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 09/04/2021 12:33
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# This uses EDITOR as editor, or vim if EDITOR is null or unset
EDITOR=${EDITOR:-vim}

die() {
    (($#)) && printf >&2 '%s\n' "$@"
    exit 1
}

temp=$(mktemp $TMPDIR.XXXXXXXXXXXX.$(uuidgen).md) || die "Can't create temp file"
echo "https://app.asana.com/0/1199559628644847/$1" > "$temp"
echo '' >> "$temp"
echo '## Changelog' >> "$temp"
echo '' >> "$temp"
if "$EDITOR" -- "$temp" && [[ -s $temp ]]; then
    # slurp file content in variable content, preserving trailing blank lines
    IFS= read -r -d '' content < "$temp"
fi
rm -f -- "$temp"

title="hotfix/$1 - $2"

hfaddress=$(gh pr create --title "$title" --body="$content" --base='master' --reviewer="bradley-arizto,david-arizto")
echo "Created $hfaddress"

praddress=$(gh pr create --title "$1 - $2 (Develop)" --body="$hfaddress" --base='develop' --reviewer="bradley-arizto,david-arizto")
echo "Created $praddress"
