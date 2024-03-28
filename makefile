.PHONY: debian noroot

all: debian

debian: site.yml
	ansible-playbook --ask-become-pass $<

noroot: site.yml
	ansible-playbook $<
