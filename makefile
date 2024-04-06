.PHONY: debian noroot

all: debian

debian: site.yml
	ansible-playbook --ask-become-pass $< --tags "debian_tag"

noroot: site.yml
	ansible-playbook $< --tags "config_tag,gnome_tag"
