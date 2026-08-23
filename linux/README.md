# Linux dotfiles (Omarchy / Hyprland)

Configs da máquina Linux (Omarchy, Arch + Hyprland). As configs de macOS
ficam na raiz do repositório.

## Estrutura

| Arquivo | Destino na máquina | O que é |
|---|---|---|
| `vscodium/settings.json` | `~/.config/VSCodium/User/settings.json` | Settings do VSCodium (já adaptadas p/ Linux: foot, fish) |
| `vscodium/keybindings.json` | `~/.config/VSCodium/User/keybindings.json` | Keybindings (ctrl+, não cmd+) |
| `hypr/input.lua` | `~/.config/hypr/input.lua` | Teclado US Intl (dead keys) |
| `hypr/monitors.lua` | `~/.config/hypr/monitors.lua` | Monitor AOC 24" em 240Hz (DP-3) |
| `foot/foot.ini` | `~/.config/foot/foot.ini` | Terminal foot, fonte 12pt |
| `fish/config.fish` | `~/.config/fish/config.fish` | Shell fish: starship, zoxide, mise, aliases |
| `starship.toml` | `~/.config/starship.toml` | Prompt: preset "no-empty-icons" |
| `.XCompose` | `~/.XCompose` | Cedilha via `;` + `c` = ç |

## Restaurar em uma máquina nova

```bash
cp linux/vscodium/settings.json ~/.config/VSCodium/User/settings.json
cp linux/vscodium/keybindings.json ~/.config/VSCodium/User/keybindings.json
cp linux/hypr/input.lua ~/.config/hypr/input.lua
cp linux/hypr/monitors.lua ~/.config/hypr/monitors.lua
cp linux/foot/foot.ini ~/.config/foot/foot.ini
cp linux/fish/config.fish ~/.config/fish/config.fish
cp linux/starship.toml ~/.config/starship.toml
cp linux/.XCompose ~/.XCompose

# Aplicar
hyprctl reload
omarchy restart xcompose
omarchy restart terminal

# Editor padrão: nano (git commit, crontab, sudoedit...)
mkdir -p ~/.local/state/omarchy/defaults
echo nano > ~/.local/state/omarchy/defaults/editor
```

## Dependências

- Omarchy (Arch + Hyprland)
- fish como shell padrão: `chsh -s /usr/bin/fish`
- nano: `pacman -S nano`
- JetBrainsMono Nerd Font
