#!/usr/bin/env bash

# Set and push to Infinera/bitbucket
push_infinera() {
    git remote set-url origin https://pabe@atlas.transmode.se/bitbucket/scm/~pabe/bash-utilities.git
    git push -u origin --all
    git push origin --tags
}

# Set and push to github
push_github() {
    git remote set-url origin  https://github.com/karlpatrikbergman/bash-utilities.git
    git push -u origin --all
    git push origin --tags
}

# Show remote origin
show_origin() {
    git remote -v
}

push_infinera
push_github
