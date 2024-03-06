.PHONY: all config user root

# Root needs to be first since we need it to setup flatpak, etc.

default: user.txt config.txt

all: root.txt user.txt config.txt

user: user.txt

config: config.txt

root: root.txt

user.txt: debian_user.yml
	ansible-playbook $<; \
	if [ $$? -eq 0 ]; then touch user.txt; fi

root.txt: debian_root.yml
	ansible-playbook -b -K $<; \
	if [ $$? -eq 0 ]; then touch root.txt; fi

config.txt: config.yml
	ansible-playbook $<; \
	if [ $$? -eq 0 ]; then touch $@; fi
