.PHONY: all config etc home local

all: config etc home local

XDG_CONFIG_HOME ?= "$(HOME)/.config/"
XDG_DATA_HOME ?= "$(HOME)/.local/share/"

define buildlinks =
@for file in $(shell find $(1) -maxdepth 1 ! -path $(1) ! -name ".*.swp"); do \
	f=$$(basename $$file); \
	mkdir -p $$(dirname $$f); \
	ln -sfn $$file $(2)$$f; \
done
endef

config:
	@echo "Link files from ./config/ dir to related $(XDG_CONFIG_HOME)/..."
	$(call buildlinks,$(CURDIR)/config,$(XDG_CONFIG_HOME))

local:
	@echo "Link files from ./config/ dir to related $(XDG_DATA_HOME)/..."
	$(call buildlinks,$(CURDIR)/local,$(XDG_DATA_HOME))

home:
	@echo "Link files from ./home/ dir to related $$HOME/..."
	$(call buildlinks,$(CURDIR)/home,$(HOME)/.)

etc:
	@echo "Link files from ./etc/ dir to related /etc/..."
	@for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo mkdir -p $$(dirname $$f); \
		sudo ln -f $$file $$f; \
	done
	sudo systemctl daemon-reload
