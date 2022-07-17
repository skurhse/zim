# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# NOTE: For a list of targets, run `make help`. <skr 2022-07>

define prompt
	read -p $(1): $(subst .,_,$(1))
endef

define git-config
  git config --local $(1) $$$(subst .,_,$(2))
endef

.PHONY: user.name 
user.name:
	$(Q)$(call prompt,$@); \
	$(call git-config,$@)

.PHONY: user.email
user.email:

setup : set-user set-email

USERNAME ?= 'Skurhse Rage 🌆🌃🌌'

GIT_USER_NAME ?= $(call get-git-user-name)

GIT_EMAIL_ADDRESS ?= $(call get-git-email-address)

CONTAINER ?= nervous_mclean

CYAN=\033[1;36m
NC=\033[0m

DEBUG ?= no

ifeq (DEBUG,yes)
  Q =
else
  Q = @
endif

.PHONY: help
help:
	$(Q)printf '\n'
	$(Q)printf 'Install targets:\n'
	$(Q)printf '\n'
	$(Q)printf '  $(CYAN)ansible$(NC) - installs ansible with pip.\n'
	$(Q)printf '  $(CYAN)docker$(NC)  - installs docker with brew.\n'
	$(Q)printf '\n'
	$(Q)printf 'Utility targets:\n'
	$(Q)printf '\n'
	$(Q)printf '  $(CYAN)shell$(NC)   - shells into a docker dev env\n'
	$(Q)printf '\n'


.PHONY: ansible
ansible: pip
	sudo pip3 install --system $@

.PHONY: pip python3-pip
pip: python3-pip
python3-pip: apt-update
	sudo apt-get install $@ --assume-yes

.PHONY: apt-update
apt-update:
	sudo apt-get update

.PHONY: container
container:
	docker container exec -it -- $(CONTAINER) /usr/bin/env bash -c ' \
	  export REMOTE_CONTAINERS_IPC=$$( \
	    find /tmp -name '\''vscode-remote-containers-ipc*'\'' -type s \
	      -printf "%T@ %p\n" | sort -n | cut -d " " -f 2- | tail -n 1);$$SHELL -l'

.PHONY: git-config
git-config:
	git config --local user.name 'Skurhse Eris Rage 🌆🌃🌌'
	git config --local user.email 'skurhse.eris@rage.codes'

.PHONY: gh-setup
gh-setup:
	gh auth status || gh auth login --git-protocol https --web
	gh auth setup-git
