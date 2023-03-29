#!/bin/bash

#!/usr/bin/env bash
# sssh-config generates and installs an ssh identity file for a git repository.

# CAVEAT: Assumes scp-style URLs i.e. relative path w/ no port <dru 2020-04-27>
declare -A repo
repo[url]="$1"
repo[name]="${repo[url]##*/}"
repo[auth]="${repo[url]%%:*}"
repo[user]="${repo[auth]%%@*}"
repo[host]="${repo[auth]##*@}"

# CAVEAT: Use HISTCONTROL when invoking <dru 2020-04-27>
pass="$2"

# TODO: add ssh-add functionality <dru 2020-04-27>
# NOBUG: ed25519 not supported by Azure Devops <dru 2020-04-27>
ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)" -N "$pass" -f ~/".ssh/${repo[host]}_rsa"

cat <<EOF >~/.ssh/config
Host ${repo[host]}
IdentityFile ~/.ssh/%h_rsa
EOF

# IDEA: Publish public key with API? <dru 2020-04-27>
cat ~/.ssh/ssh.dev.azure.com_rsa.pub | clip.exe
