function zsh_test() {
  echo "PONG"
}

# Git alias to get all commits from yesterday
gitstandup() {
  if [ -z "$(git log --all --pretty=format:'* %s' --no-merges --reverse --author=Justin --since=yesterday.midnight)" ]; then
    git log --all --pretty=format:'* %s' --no-merges --reverse --author=Justin --since=last.friday.midnight;
  else
    git log --all --pretty=format:'* %s' --no-merges --reverse --author=Justin --since=yesterday.midnight;
  fi
}
