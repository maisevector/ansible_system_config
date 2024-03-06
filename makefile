.PHONY: all config user root

# Root needs to be first since we need it to setup flatpak, etc.

all: root user config

user: debian_user.yml
	ansible-playbook $<

root: debian_root.yml
	ansible-playbook -b -K $<

config: config.yml
	ansible-playbook $<
