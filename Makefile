# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# NOTE: For targets run `make help` <>

SHELL = /usr/bin/env bash

ifeq (TRACE,yes)
  V = v
else
  Q = @
endif

BRANCH_NAME := $(shell git name-rev --name-only HEAD)

REMOTE_NAME := $(shell git config branch.$(BRANCH_NAME).remote)
REMOTE_URL  := $(shell git config remote.$(REMOTE_NAME).url)

REPO_NAME   := $(shell basename $(REMOTE_URL) .git)

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
	$(Q)echo '  $(CY)setup$(RS)      - $(BL)runs all setup targets.$(RS)'
	$(Q)echo '  $(CY)install$(RS)    - $(BL)runs all install targets.$(RS)'
	$(Q)echo '  $(CY)reset$(RS)      - $(BL)resets the im project.$(RS)'
	$(Q)echo
	$(Q)echo '$(BD)Setup:$(RS)'
	$(Q)echo
	$(Q)echo '  $(CY)git-config      - $(BL)sets up the local git config.$(RS)'
	$(Q)echo '  $(CY)gh-auth         - $(BL)sets up the local git config.$(RS)'
	$(Q)echo 
	$(Q)echo '$(BD)Install:$(RS)'
	$(Q)echo
	$(Q)echo '  $(CY)ansible$(RS)    - $(BL)installs ansible with pip.$(RS)'
	$(Q)echo '  $(CY)docker$(RS)     - $(BL)installs docker with homebrew.$(RS)'
	$(Q)echo
	$(Q)echo '$(BD)Utility:$(RS)'
	$(Q)echo
	$(Q)echo '  $(CY)shell$(RS)      - $(BL)shells into a docker dev env.$(RS)'
	$(Q)echo '  $(CY)kudos$(RS)      - $(BL)pays respects.$(RS)'
	$(Q)echo 

# TODOC: Add help info for xintermediate targets. <skr>

.PHONY: kudos
kudos:
	$(Q)echo 
	$(Q)echo 'In Memoriam $(MG)Ian Murdock$(RS)'
	$(Q)echo 
	$(Q)echo '  Father, Debian founder, manifesto writer, leader, friend.'
	$(Q)echo 

.PHONY: setup
setup: git-config gh-auth

.PHONY: git-config
git: user.name user.email

user.name user.email: FORCE
	$(if $(shell $(call git-cfg,$@)),,$(call git-cfg,$@,$(shell $(call prompt,$@:))))

define git-cfg
git config --local -- $(1) $(2)
endef

define prompt
read -p $(1) p; echo $${p@Q}
endef

.PHONY: gh-auth
gh-auth:
	gh auth status || gh auth login --git-protocol https --web
	gh auth setup-git

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

.PHONY: shell
shell:
	$(Q)docker container exec -it -- $(REPO_NAME) \
	/usr/bin/env bash -c 'export REMOTE_CONTAINERS_IPC=\
	$$(find /tmp -name '\''vscode-remote-containers-ipc*'\'' \
	-type s -printf "%T@ %p\n" | sort -n | cut -d " " -f 2- | tail -n 1);\
	$$SHELL -l'

.PHONY: reset
reset:
	$(Q)git config --local --remove-section user 2>/dev/null || [[ $$? -eq 128 ]]

.PHONY: shell
shell:
	$(Q)docker container exec -it -- $(REPO_NAME) \
	/usr/bin/env bash -c 'export REMOTE_CONTAINERS_IPC=\
	$$(find /tmp -name '\''vscode-remote-containers-ipc*'\'' \
	-type s -printf "%T@ %p\n" | sort -n | cut -d " " -f 2- | tail -n 1);\
	$$SHELL -l'

FORCE:
