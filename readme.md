# Dotfiles

Now using [Chezmoi](https://www.chezmoi.io/docs/quick-start) to manage these dotfiles.

## Installing

Follow the above guide to install these locally or:

```sh
chezmoi init --apply https://github.com/jallier/dotfiles.git
```

If the machine you're installing on will have your gh ssh private key, then change the above to this to allow you to push more easily:

```sh
chezmoi init --apply git@github.com:jallier/dotfiles.git
```

You will probably get some errors due to missing zsh plugins or brew. Just install the things that complain and rerun until the errors go away.

## Editing

There are 2 ways to edit:

### Quick n dirty

Edit the config file you want to edit directly, then run

```sh
# To do everything at once
chezmoi re-add

# For a specific file
chezmoi add $FILE
```

### The less likely to cause conflicts way

```sh
chezmoi edit $FILE

chezmoi cd
git add .
git commit
git push
```

## More info

Read the chezmoi docs
