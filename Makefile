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
AGENTS_DIR := $(HOME)/.agents
CODEX_DIR := $(HOME)/.codex

# Filter: make link F=vim
F :=

.PHONY: help list link unlink relink link-agents unlink-agents link-claude unlink-claude link-codex unlink-codex

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
	@echo "==> agents"
	@$(call list-agents-skills,$(DOTFILES_DIR))
	@$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call list-agents-skills,$(DOTFILES_PRIVATE_DIR)))
	@echo "==> claude"
	@$(foreach subdir,$(CLAUDE_SUBDIRS), \
		$(call list-claude-dir,$(DOTFILES_DIR),$(subdir)) \
		$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call list-claude-dir,$(DOTFILES_PRIVATE_DIR),$(subdir))) \
	)
	@$(call list-claude-md,$(DOTFILES_DIR))
	@$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call list-claude-md,$(DOTFILES_PRIVATE_DIR)))
	@$(call list-skills-via-agents,claude)
	@echo "==> codex"
	@$(call list-codex-md,$(DOTFILES_DIR))
	@$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call list-codex-md,$(DOTFILES_PRIVATE_DIR)))
	@$(call list-skills-via-agents,codex)

link: link-dotfiles link-config link-agents link-claude link-codex ## Create all symbolic links
	@echo "done!"

unlink: unlink-dotfiles unlink-config unlink-agents unlink-claude unlink-codex ## Remove all symbolic links
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

# --- .agents ---

define list-agents-skills
	if [ -d "$(1)/agents/skills" ]; then \
		for src in "$(1)/agents/skills"/*; do \
			name=$$(basename "$$src"); \
			if [ -z "$(F)" ] || echo "skills/$$name" | grep -q "$(F)"; then \
				dst="$(AGENTS_DIR)/skills/$$name"; \
				if [ -L "$$dst" ]; then \
					echo "  [v] .agents/skills/$$name"; \
				else \
					echo "  [-] .agents/skills/$$name"; \
				fi; \
			fi; \
		done; \
	fi;
endef

define link-agents-skills
	if [ -d "$(1)/agents/skills" ]; then \
		mkdir -p "$(AGENTS_DIR)/skills"; \
		for src in "$(1)/agents/skills"/*; do \
			name=$$(basename "$$src"); \
			if [ -z "$(F)" ] || echo "skills/$$name" | grep -q "$(F)"; then \
				dst="$(AGENTS_DIR)/skills/$$name"; \
				if [ -e "$$dst" ]; then \
					echo "  [-] .agents/skills/$$name"; \
				else \
					ln -s "$$src" "$$dst"; \
					echo "  [v] .agents/skills/$$name"; \
				fi; \
			fi; \
		done; \
	fi;
endef

define unlink-agents-skills
	if [ -d "$(1)/agents/skills" ]; then \
		for src in "$(1)/agents/skills"/*; do \
			name=$$(basename "$$src"); \
			if [ -z "$(F)" ] || echo "skills/$$name" | grep -q "$(F)"; then \
				dst="$(AGENTS_DIR)/skills/$$name"; \
				if [ -L "$$dst" ]; then \
					unlink "$$dst"; \
					echo "  [v] .agents/skills/$$name"; \
				else \
					echo "  [-] .agents/skills/$$name"; \
				fi; \
			fi; \
		done; \
	fi;
endef

link-agents:
	@echo "==> agents"
	@$(call link-agents-skills,$(DOTFILES_DIR))
	@$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call link-agents-skills,$(DOTFILES_PRIVATE_DIR)))

unlink-agents:
	@echo "==> agents"
	@$(call unlink-agents-skills,$(DOTFILES_DIR))
	@$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call unlink-agents-skills,$(DOTFILES_PRIVATE_DIR)))

# --- .claude / .codex (skills as individual symlinks via .agents/skills) ---

define list-skills-via-agents
	for src in "$(AGENTS_DIR)/skills"/*; do \
		name=$$(basename "$$src"); \
		if [ -z "$(F)" ] || echo "skills/$$name" | grep -q "$(F)"; then \
			dst="$(HOME)/.$(1)/skills/$$name"; \
			if [ -L "$$dst" ]; then \
				echo "  [v] .$(1)/skills/$$name"; \
			else \
				echo "  [-] .$(1)/skills/$$name"; \
			fi; \
		fi; \
	done;
endef

define link-skills-via-agents
	mkdir -p "$(HOME)/.$(1)/skills"; \
	for src in "$(AGENTS_DIR)/skills"/*; do \
		name=$$(basename "$$src"); \
		if [ -z "$(F)" ] || echo "skills/$$name" | grep -q "$(F)"; then \
			dst="$(HOME)/.$(1)/skills/$$name"; \
			if [ -e "$$dst" ]; then \
				echo "  [-] .$(1)/skills/$$name"; \
			else \
				ln -s "$$src" "$$dst"; \
				echo "  [v] .$(1)/skills/$$name"; \
			fi; \
		fi; \
	done;
endef

define unlink-skills-via-agents
	for dst in "$(HOME)/.$(1)/skills"/*; do \
		[ -L "$$dst" ] || continue; \
		name=$$(basename "$$dst"); \
		if [ -z "$(F)" ] || echo "skills/$$name" | grep -q "$(F)"; then \
			unlink "$$dst"; \
			echo "  [v] .$(1)/skills/$$name"; \
		fi; \
	done;
endef

# --- .claude ---

.PHONY: link-claude unlink-claude

# agents/AGENTS.md → ~/.claude/CLAUDE.md (rename on link)
define list-claude-md
	if [ -f "$(1)/agents/AGENTS.md" ]; then \
		if [ -z "$(F)" ] || echo "claude/CLAUDE.md" | grep -q "$(F)"; then \
			if [ -L "$(HOME)/.claude/CLAUDE.md" ]; then \
				echo "  [v] .claude/CLAUDE.md"; \
			else \
				echo "  [-] .claude/CLAUDE.md"; \
			fi; \
		fi; \
	fi;
endef

define link-claude-md
	if [ -f "$(1)/agents/AGENTS.md" ]; then \
		if [ -z "$(F)" ] || echo "claude/CLAUDE.md" | grep -q "$(F)"; then \
			mkdir -p "$(HOME)/.claude"; \
			dst="$(HOME)/.claude/CLAUDE.md"; \
			if [ -e "$$dst" ]; then \
				echo "  [-] .claude/CLAUDE.md"; \
			else \
				ln -s "$(1)/agents/AGENTS.md" "$$dst"; \
				echo "  [v] .claude/CLAUDE.md"; \
			fi; \
		fi; \
	fi;
endef

define unlink-claude-md
	if [ -f "$(1)/agents/AGENTS.md" ]; then \
		if [ -z "$(F)" ] || echo "claude/CLAUDE.md" | grep -q "$(F)"; then \
			dst="$(HOME)/.claude/CLAUDE.md"; \
			if [ -L "$$dst" ]; then \
				unlink "$$dst"; \
				echo "  [v] .claude/CLAUDE.md"; \
			else \
				echo "  [-] .claude/CLAUDE.md"; \
			fi; \
		fi; \
	fi;
endef

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

link-claude: link-agents
	@echo "==> claude"
	@$(foreach subdir,$(CLAUDE_SUBDIRS), \
		$(call link-claude-dir,$(DOTFILES_DIR),$(subdir)) \
		$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call link-claude-dir,$(DOTFILES_PRIVATE_DIR),$(subdir))) \
	)
	@$(call link-claude-md,$(DOTFILES_DIR))
	@$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call link-claude-md,$(DOTFILES_PRIVATE_DIR)))
	@$(call link-skills-via-agents,claude)

unlink-claude:
	@echo "==> claude"
	@$(foreach subdir,$(CLAUDE_SUBDIRS), \
		$(call unlink-claude-dir,$(DOTFILES_DIR),$(subdir)) \
		$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call unlink-claude-dir,$(DOTFILES_PRIVATE_DIR),$(subdir))) \
	)
	@$(call unlink-claude-md,$(DOTFILES_DIR))
	@$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call unlink-claude-md,$(DOTFILES_PRIVATE_DIR)))
	@$(call unlink-skills-via-agents,claude)

# --- .codex ---
# .codex/skills/ contains .system (managed by codex), use individual symlinks via .agents

# agents/AGENTS.md → ~/.codex/AGENTS.md
define list-codex-md
	if [ -f "$(1)/agents/AGENTS.md" ]; then \
		if [ -z "$(F)" ] || echo "codex/AGENTS.md" | grep -q "$(F)"; then \
			if [ -L "$(HOME)/.codex/AGENTS.md" ]; then \
				echo "  [v] .codex/AGENTS.md"; \
			else \
				echo "  [-] .codex/AGENTS.md"; \
			fi; \
		fi; \
	fi;
endef

define link-codex-md
	if [ -f "$(1)/agents/AGENTS.md" ]; then \
		if [ -z "$(F)" ] || echo "codex/AGENTS.md" | grep -q "$(F)"; then \
			mkdir -p "$(HOME)/.codex"; \
			dst="$(HOME)/.codex/AGENTS.md"; \
			if [ -e "$$dst" ]; then \
				echo "  [-] .codex/AGENTS.md"; \
			else \
				ln -s "$(1)/agents/AGENTS.md" "$$dst"; \
				echo "  [v] .codex/AGENTS.md"; \
			fi; \
		fi; \
	fi;
endef

define unlink-codex-md
	if [ -f "$(1)/agents/AGENTS.md" ]; then \
		if [ -z "$(F)" ] || echo "codex/AGENTS.md" | grep -q "$(F)"; then \
			dst="$(HOME)/.codex/AGENTS.md"; \
			if [ -L "$$dst" ]; then \
				unlink "$$dst"; \
				echo "  [v] .codex/AGENTS.md"; \
			else \
				echo "  [-] .codex/AGENTS.md"; \
			fi; \
		fi; \
	fi;
endef

link-codex: link-agents
	@echo "==> codex"
	@$(call link-codex-md,$(DOTFILES_DIR))
	@$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call link-codex-md,$(DOTFILES_PRIVATE_DIR)))
	@$(call link-skills-via-agents,codex)

unlink-codex:
	@echo "==> codex"
	@$(call unlink-codex-md,$(DOTFILES_DIR))
	@$(if $(wildcard $(DOTFILES_PRIVATE_DIR)),$(call unlink-codex-md,$(DOTFILES_PRIVATE_DIR)))
	@$(call unlink-skills-via-agents,codex)
