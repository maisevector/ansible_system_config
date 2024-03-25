.PHONY: debian gnome all 

all: debian gnome

debian: site.yml
	ansible-playbook --ask-become-pass $<

gnome: site.yml
	ansible-playbook $<

