# NOTE: To see a list of typical targets execute `make help` <skr 2022-07>

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
	      -printf "%T@ %p\n" | sort -n | cut -d " " -f 2- | tail -n 1);$$SHELL -l'

.PHONY: git-config
git-config:
	git config --local user.name 'Skurhse Eris Rage 🌆🌃🌌'
	git config --local user.email 'skurhse.eris@rage.codes'

.PHONY: gh-setup
gh-setup:
	gh auth status || gh auth login --git-protocol https --web
	gh auth setup-git
