# Define the directories for stowing, excluding i3laptop and i3desktop
DOTFILES_DIRS := doom keepass kitty rofi i3blocks xinit picom bashrc

# Define the default target
.PHONY: all clean i3 sway laptop desktop help

# Experimental Sway config

sway:
	@echo "Stowing sway..."
	@stow sway
	@swaymsg reload

# Default target to stow all packages except i3 and i3desktop
all:
	@echo "Stowing configs..."
	@for dir in $(DOTFILES_DIRS); do \
		stow $$dir; \
	done

# Target to stow default i3 configuration
i3 :
	@echo "Stowing i3..."
	@stow i3
	@stow wallpapers
	@i3-msg reload

# Target to stow all packages except the i3 and i3desktop directories
desktop: all
	@echo "Stowing desktop configuration..."
	@stow i3desktop
	@stow wallpapersdesktop
	@i3-msg reload

# Target to stow i3 for laptop configuration
laptop: all
	@echo "Stowing laptop configuration..."
	@stow i3laptop
	@stow wallpaperslaptop
	@i3-msg reload

# Target to delete all stowed links
clean:
	@echo "Deleting all stowed links..."
	@for dir in $(DOTFILES_DIRS); do \
		stow -D $$dir; \
	done
	@stow -D i3laptop
	@stow -D i3desktop

# Help target to display usage
help:
	@echo "Makefile for managing dotfiles with stow"
	@echo "Usage:"
	@echo "  make all          - Stow all packages except i3"
	@echo "  make i3      - Stow main i3 configuragtion
	@echo "  make laptop  - Stow laptop configuration"
	@echo "  make desktop - Stow desktop configuration"
	@echo "  make clean        - Remove all symlinks"
	@echo "  make help         - Display this help message"
