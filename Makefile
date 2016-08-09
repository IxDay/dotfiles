.PHONY: all config etc home local

all: config etc home local

define buildlinks = 
@for file in $(shell find $(1) -maxdepth 1 ! -path $(1) ! -name ".*.swp"); do \
	f=$$(basename $$file); \
	ln -sfn $$file $(2)$$f; \
done
endef

config: 
	@echo "Link files from ./config/ dir to related $$HOME/.config/..."
	$(call buildlinks,$(CURDIR)/config,$(HOME)/.config/)

local: 
	@echo "Link files from ./config/ dir to related $$HOME/.local/share/..."
	$(call buildlinks,$(CURDIR)/local,$(HOME)/.local/share/)

home:
	@echo "Link files from ./home/ dir to related $$HOME/..."
	$(call buildlinks,$(CURDIR)/home,$(HOME)/.)

etc:
	@echo "Link files from ./etc/ dir to related /etc/..."
	@for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo ln -f $$file $$f; \
	done
