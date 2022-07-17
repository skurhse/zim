# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# NOTE: For a list of, run `make help`. <skr>

BD := $(shell tput bold)
BL := $(shell tput setaf 4)
MG := $(shell tput setaf 5)
CY := $(shell tput setaf 6) 
RS := $(shell tput sgr0)

.PHONY: help
help:
	$(Q)echo
	$(Q)echo '$(BD)Main:$(RS)'
	$(Q)echo
	$(Q)echo '  $(CY)setup$(RS)      - $(BL)sets up im.$(RS)'
	$(Q)echo
	$(Q)echo '$(BD)Install:$(RS)'
	$(Q)echo
	$(Q)echo '  $(CY)ansible$(RS)    - $(BL)installs ansible with pip.$(RS)'
	$(Q)echo '  $(CY)docker$(RS)     - $(BL)installs docker with homebrew.$(RS)'
	$(Q)echo
	$(Q)echo '$(BD)Utility:$(RS)'
	$(Q)echo
	$(Q)echo '  $(CY)shell$(RS)      - $(BL)shells into a docker dev env.$(RS)'
	$(Q)echo
	$(Q)echo '$(BD)Setup:$(RS)'
	$(Q)echo
	$(Q)echo '  $(CY)user.name$(RS)  - $(BL)sets the local git user.$(RS)'
	$(Q)echo '  $(CY)user.email$(RS) - $(BL)sets the local git email.$(RS)'
	$(Q)echo 
	$(Q)echo '$(BD)Miscellaneous:$(RS)'
	$(Q)echo 
	$(Q)echo '  $(CY)kudos$(RS)      - $(BL)pays respects.$(RS)'
	$(Q)echo 

.PHONY: kudos
kudos:
	$(Q)echo 
	$(Q)echo 'In Memoriam $(MG)Ian Murdock$(RS)'
	$(Q)echo 
	$(Q)echo '  Father, Debian founder, manifesto writer, leader, friend.'
	$(Q)echo 

DEBUG ?= no

ifeq (DEBUG,yes)
  Q =
else
  Q = @
endif

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
	      -echo "%T@ %p\n" | sort -n | cut -d " " -f 2- | tail -n 1);$$SHELL -l'

.PHONY: git-config
git-config:
	git config --local user.name 'Skurhse Eris Rage 🌆🌃🌌'
	git config --local user.email 'skurhse.eris@rage.codes'

.PHONY: gh-setup
gh-setup:
	gh auth status || gh auth login --git-protocol https --web
	gh auth setup-git
