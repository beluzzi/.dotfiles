# Define the directories for stowing, excluding i3 and i3desktop
DOTFILES_DIRS := doom keepass kitty polybar rofi

# Define the default target
.PHONY: all clean stow-laptop stow-desktop help

# Default target to stow all packages except i3 and i3desktop
all:
	@echo "Stowing configs..."
	@for dir in $(DOTFILES_DIRS); do \
		stow $dir; \
	@done

# Target to stow all packages except the i3 and i3desktop directories
stow-desktop:
	all
	@echo "Stowing desktop configuration..."
	@stow i3desktop

# Target to stow i3 for laptop configuration
stow-laptop:
	all
	@echo "Stowing laptop configuration..."
	stow i3

# Target to delete all stowed links
clean:
	@echo "Deleting all stowed links..."
	@for dir in $(DOTFILES_DIRS); do \
		stow -D $dir; \
	done
	@stow -D i3
	@stow -D i3desktop

# Help target to display usage
help:
	@echo "Makefile for managing dotfiles with stow"
	@echo "Usage:"
	@echo "  make all          - Stow all packages except i3 and i3desktop"
	@echo "  make stow-laptop - Stow i3 configuration for laptop"
	@echo "  make stow-desktop - Stow i3desktop configuration for desktop"
	@echo "  make clean        - Delete all stowed links"
	@echo "  make help         - Display this help message"
