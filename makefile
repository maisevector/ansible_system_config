.PHONY: all 

all: site.yml
	ansible-playbook --ask-become-pass $<
