#!/bin/bash
# Run gh auth login and capture output to a file
gh auth login --web --git-protocol https --scopes repo,workflow,read:org > /tmp/gh-code.txt 2>&1
