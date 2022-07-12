CONTAINER ?= nervous_mclean

.PHONY: container
container:
	docker container exec -it -- $(CONTAINER) /usr/bin/env bash -c ' \
	  export REMOTE_CONTAINERS_IPC=$$( \
	    find /tmp -name '\''vscode-remote-containers-ipc*'\'' -type s \
	      -printf "%T@ %p\n" | sort -n | cut -d " " -f 2- | tail -n 1);$$SHELL -l'

.PHONY: git-config
git-config:
	git config --local user.name 'Skurhse Eris Rage 🌆🌃🌌'
	git config --local user.email 'hello@drruruu.dev'
