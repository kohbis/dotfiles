DOTFILES_DIR := $(HOME)/workspace/dotfiles
DOTFILES_PRIVATE_DIR := $(DOTFILES_DIR)/dotfiles-private

DOT_FILES := \
	bash_local \
	bash_profile \
	bashrc \
	clang-format \
	git-cz.json \
	rufo \
	sqlfluff \
	tmux.conf \
	vimrc \
	zshrc

CONFIG_TOOLS := $(shell find $(DOTFILES_DIR)/config -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)
CLAUDE_SUBDIRS := $(shell find $(DOTFILES_DIR)/claude -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)

# Filter: make link F=vim
F :=

.PHONY: help list link unlink relink

help: ## Show this help
	@grep -E '^[a-z]+:.*## ' $(MAKEFILE_LIST) | awk -F ':.*## ' '{printf "  make %-10s %s\n", $$1, $$2}'
	@echo ""
	@echo "  Filter with F=<string>: make link F=vim"

list: ## List symbolic link status ([v] linked [-] unlinked)
	@echo "==> dotfiles"
	@$(foreach f,$(DOT_FILES), \
		if [ -z "$(F)" ] || echo "$(f)" | grep -q "$(F)"; then \
			if [ -L "$(HOME)/.$(f)" ]; then \
				echo "  [v] .$(f)"; \
			else \
				echo "  [-] .$(f)"; \
			fi; \
		fi; \
	)
	@echo "==> config"
	@$(foreach tool,$(CONFIG_TOOLS), \
		if [ -d "$(DOTFILES_DIR)/config/$(tool)" ]; then \
			for src in "$(DOTFILES_DIR)/config/$(tool)"/*; do \
				name=$$(basename "$$src"); \
				if [ -z "$(F)" ] || echo "$(tool)/$$name" | grep -q "$(F)"; then \
					if [ -L "$(HOME)/.config/$(tool)/$$name" ]; then \
						echo "  [v] .config/$(tool)/$$name"; \
					else \
						echo "  [-] .config/$(tool)/$$name"; \
					fi; \
				fi; \
			done; \
		fi; \
	)
	@echo "==> claude"
	@$(foreach subdir,$(CLAUDE_SUBDIRS), \
		$(call list-claude-dir,$(DOTFILES_DIR),$(subdir)) \
		$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call list-claude-dir,$(DOTFILES_PRIVATE_DIR),$(subdir))) \
	)

link: link-dotfiles link-config link-claude ## Create all symbolic links
	@echo "done!"

unlink: unlink-dotfiles unlink-config unlink-claude ## Remove all symbolic links
	@echo "done!"

relink: unlink link ## Recreate all symbolic links

# --- dotfiles ---

.PHONY: link-dotfiles unlink-dotfiles

link-dotfiles:
	@echo "==> dotfiles"
	@$(foreach f,$(DOT_FILES), \
		if [ -z "$(F)" ] || echo "$(f)" | grep -q "$(F)"; then \
			if [ -e "$(HOME)/.$(f)" ]; then \
				echo "  [-] .$(f)"; \
			else \
				ln -s "$(DOTFILES_DIR)/$(f)" "$(HOME)/.$(f)"; \
				echo "  [v] .$(f)"; \
			fi; \
		fi; \
	)

unlink-dotfiles:
	@echo "==> dotfiles"
	@$(foreach f,$(DOT_FILES), \
		if [ -z "$(F)" ] || echo "$(f)" | grep -q "$(F)"; then \
			if [ -L "$(HOME)/.$(f)" ]; then \
				unlink "$(HOME)/.$(f)"; \
				echo "  [v] .$(f)"; \
			else \
				echo "  [-] .$(f)"; \
			fi; \
		fi; \
	)

# --- .config ---

.PHONY: link-config unlink-config

link-config:
	@echo "==> config"
	@$(foreach tool,$(CONFIG_TOOLS), \
		if [ -d "$(DOTFILES_DIR)/config/$(tool)" ]; then \
			mkdir -p "$(HOME)/.config/$(tool)"; \
			for src in "$(DOTFILES_DIR)/config/$(tool)"/*; do \
				name=$$(basename "$$src"); \
				if [ -z "$(F)" ] || echo "$(tool)/$$name" | grep -q "$(F)"; then \
					dst="$(HOME)/.config/$(tool)/$$name"; \
					if [ -e "$$dst" ]; then \
						echo "  [-] .config/$(tool)/$$name"; \
					else \
						ln -s "$$src" "$$dst"; \
						echo "  [v] .config/$(tool)/$$name"; \
					fi; \
				fi; \
			done; \
		fi; \
	)

unlink-config:
	@echo "==> config"
	@$(foreach tool,$(CONFIG_TOOLS), \
		if [ -d "$(DOTFILES_DIR)/config/$(tool)" ]; then \
			for src in "$(DOTFILES_DIR)/config/$(tool)"/*; do \
				name=$$(basename "$$src"); \
				if [ -z "$(F)" ] || echo "$(tool)/$$name" | grep -q "$(F)"; then \
					dst="$(HOME)/.config/$(tool)/$$name"; \
					if [ -L "$$dst" ]; then \
						unlink "$$dst"; \
						echo "  [v] .config/$(tool)/$$name"; \
					else \
						echo "  [-] .config/$(tool)/$$name"; \
					fi; \
				fi; \
			done; \
		fi; \
	)

# --- .claude ---

.PHONY: link-claude unlink-claude

define list-claude-dir
	if [ -d "$(1)/claude/$(2)" ]; then \
		for src in "$(1)/claude/$(2)"/*; do \
			name=$$(basename "$$src"); \
			if [ -z "$(F)" ] || echo "$(2)/$$name" | grep -q "$(F)"; then \
				dst="$(HOME)/.claude/$(2)/$$name"; \
				if [ -L "$$dst" ]; then \
					echo "  [v] .claude/$(2)/$$name"; \
				else \
					echo "  [-] .claude/$(2)/$$name"; \
				fi; \
			fi; \
		done; \
	fi;
endef

define link-claude-dir
	if [ -d "$(1)/claude/$(2)" ]; then \
		mkdir -p "$(HOME)/.claude/$(2)"; \
		for src in "$(1)/claude/$(2)"/*; do \
			name=$$(basename "$$src"); \
			if [ -z "$(F)" ] || echo "$(2)/$$name" | grep -q "$(F)"; then \
				dst="$(HOME)/.claude/$(2)/$$name"; \
				if [ -e "$$dst" ]; then \
					echo "  [-] .claude/$(2)/$$name"; \
				else \
					ln -s "$$src" "$$dst"; \
					echo "  [v] .claude/$(2)/$$name"; \
				fi; \
			fi; \
		done; \
	fi;
endef

define unlink-claude-dir
	if [ -d "$(1)/claude/$(2)" ]; then \
		for src in "$(1)/claude/$(2)"/*; do \
			name=$$(basename "$$src"); \
			if [ -z "$(F)" ] || echo "$(2)/$$name" | grep -q "$(F)"; then \
				dst="$(HOME)/.claude/$(2)/$$name"; \
				if [ -L "$$dst" ]; then \
					unlink "$$dst"; \
					echo "  [v] .claude/$(2)/$$name"; \
				else \
					echo "  [-] .claude/$(2)/$$name"; \
				fi; \
			fi; \
		done; \
	fi;
endef

link-claude:
	@echo "==> claude"
	@$(foreach subdir,$(CLAUDE_SUBDIRS), \
		$(call link-claude-dir,$(DOTFILES_DIR),$(subdir)) \
		$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call link-claude-dir,$(DOTFILES_PRIVATE_DIR),$(subdir))) \
	)

unlink-claude:
	@echo "==> claude"
	@$(foreach subdir,$(CLAUDE_SUBDIRS), \
		$(call unlink-claude-dir,$(DOTFILES_DIR),$(subdir)) \
		$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call unlink-claude-dir,$(DOTFILES_PRIVATE_DIR),$(subdir))) \
	)
