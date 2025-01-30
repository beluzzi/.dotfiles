# 🚀 Dotfiles
Dotfiles for an i3-based Linux desktop environment, managed with GNU Stow.

## ✨ Features
- Multi configuration support for laptop and desktop environments
- Custom configurations for:
  - i3 window manager with distinct laptop/desktop profiles
  - i3blocks status bar
  - Automatic Pywal color schemes
  - Firefox theming
  - Rofi and dmenu launchers

## 📦 Prerequisites
Ensure you have the following packages installed:
```bash
# Arch Linux
pacman -S i3-wm i3blocks vim kitty picom python-pywal firefox dmenu rofi stow
```

### From AUR
[pywalfox](https://github.com/Frewacom/pywalfox)

Paru:
```bash
paru -S python-pywalfox
```

Yay:
```bash
yay -S python-pywalfox
```

## 🔗 Understanding GNU Stow
[GNU Stow](https://www.gnu.org/software/stow/) is a symlink farm manager that was originally designed to manage software installations (e.g., keeping different versions of software in `/usr/local/stow/package-1.0/` and `/usr/local/stow/package-2.0/`). However, it's particularly convenient for managing dotfiles because:

1. By default, Stow looks for target directories relative to the parent of your stow directory. When run from `~/.dotfiles`, it automatically targets your home directory (`~`), which is exactly what we want for dotfiles!

2. We can manage all of our config files in a single git repository.

3. The name of your folder in `.dotfiles` can be anything you want - it doesn't need to match the package name. What matters is the internal directory structure. For example:
```
~/.dotfiles/my-terminal/    # Folder name could be anything, not just "kitty"
└── .config/
    └── kitty/              # This must match the actual config location
        └── kitty.conf

When stowed, becomes:
~/
└── .config/
    └── kitty/
        └── kitty.conf -> ~/.dotfiles/my-terminal/.config/kitty/kitty.conf
```
- TLDR: The key is to mirror the exact path structure from your home directory inside each package directory, regardless of what you name the package folder itself. This makes it easy to organize your configs logically (e.g., grouping related configs together) while maintaining the correct symlinks in your home directory.

## 🛠️ Installation
1. Clone this repository:
```bash
git clone https://github.com/beluzzi/dotfiles.git
cd ~/.dotfiles
```

2. Choose your installation profile:
```bash
# For base configuration
make i3
make all
```
```bash
# For laptop configuration
make laptop
```
```bash
# For desktop configuration
make desktop
```

## 📝 Tutorial: Adding New Configs
Here's how to add a new configuration to the dotfiles:

1. Create the package directory in `.dotfiles`:
```bash
mkdir ~/.dotfiles/new-package
```

2. Mirror the home directory structure:
```bash
# If the config normally lives in ~/.config/new-package
mkdir -p ~/.dotfiles/new-package/.config/new-package
```

3. Move your existing config:
```bash
# Move the existing config
mv ~/.config/new-package/config.conf ~/.dotfiles/new-package/.config/new-package/

# Or copy if you want to test first
cp ~/.config/new-package/config.conf ~/.dotfiles/new-package/.config/new-package/
```

4. Stow the new package:
```bash
stow new-package
```

5. Add to Makefile (optional):
```makefile
# Add to DOTFILES_DIRS variable
DOTFILES_DIRS := doom keepass kitty rofi i3blocks xinit new-package
```

## 🗂️ Directory Structure
```
.
├── doom/          # Doom Emacs configuration
├── i3/            # i3 main config
├── i3blocks/      # i3blocks status bar configuration
├── i3laptop/      # i3 config specific to laptop
├── i3desktop/     # i3 config specific to desktop
├── keepass/       # KeePass passwords
├── kitty/         # Kitty terminal configuration
├── rofi/          # Rofi launcher configuration
├── xinit/         # xinitrc to start i3 without a greeter
└── Makefile       # GNU Make automation
```

## 🎨 Theme Management
This setup uses Pywal to generate color schemes based on your wallpaper. The themes are automatically applied to:
- `Terminal` - via wal cache
- `i3` - via Xresources
- `dmenu` - via i3 config
- `Firefox` - via pywalfox
- `~/.dotfiles/scripts/theme.sh` - triggers pywalfox and walcord on i3 reload

## 📚 Available Make Commands
- `make all` - Stow base configuration
- `make i3` - Stow main i3 configuration
- `make laptop` - Stow laptop-specific configuration
- `make desktop` - Stow desktop-specific configuration
- `make clean` - Remove all symlinks
- `make help` - Display help message

## 💡 Tips
- The i3 configurations share a common base configuration while allowing for device-specific customizations
- Wallpapers are seperate folders in .dotfiles but all link to ~/.config/.wallpapers

## 🤝 Contributing
Feel free to fork this repository and customize it to your needs. Pull requests for improvements are welcome!

## 📝 License
This project is FOSS.
