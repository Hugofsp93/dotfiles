# Customizações do meu Omarchy

Registro de todas as mudanças feitas no sistema, para no futuro gerar um
script de setup automatizado. Cada entrada tem: o que mudou, qual arquivo,
o conteúdo exato e como aplicar.

---

## 1. Teclado: layout US International (com dead keys)

**Motivo:** o teclado físico é americano (sem Ç). O layout ABNT2 (escolhido
na instalação) não batia com as teclas impressas — `/` e `?` viravam `;` e `:`.

**Arquivo:** `~/.config/hypr/input.lua`

**Trecho adicionado (logo após o cabeçalho de comentários):**

```lua
-- Keyboard layout: US International with dead keys.
-- Accents: ' then e = é, ` then a = à, " then u = ü, ~ then n = ñ, ^ then o = ô.
hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "intl",
  },
})
```

**Como aplicar:** Hyprland recarrega sozinho ao salvar. Validar com:

```bash
hyprctl reload && hyprctl configerrors
```

**Observações:**

- O layout padrão do Omarchy vem de `/etc/vconsole.conf` (`XKBLAYOUT=br`,
  definido na instalação). O override acima vale só para a sessão gráfica.
- Backup do arquivo original: `~/.config/hypr/input.lua.bak.<timestamp>`
- **Opcional (NÃO feito):** trocar o TTY/console também:

  ```bash
  sudo localectl set-keymap us && sudo localectl set-x11-keymap us pc105 intl
  ```

---

## 2. Cedilha: `;` + `c` = ç (via compose)

**Motivo:** no US Intl, o padrão do sistema para `' + c` é `ć` (c com agudo),
não ç. E preferência pessoal: usar `; + c`, pois no ABNT2 a tecla ç fica na
mesma posição física do `;` no teclado US.

**Arquivo:** `~/.XCompose`

**Regras adicionadas (depois do `include` do default do Omarchy):**

```
# Cedilha estilo ABNT2: ; + c = ç (mesma posição da tecla ç no ABNT2)
<semicolon> <c> : "ç" ccedilla
<semicolon> <C> : "Ç" Ccedilla
```

**Como aplicar:**

```bash
omarchy restart xcompose   # reinicia o fcitx5
```

**Observações:**

- Apps já abertos podem precisar ser reabertos para pegar a mudança.
- Efeito colateral: o `;` virou dead key — só aparece depois da próxima
  tecla. `;` + qualquer tecla que não seja `c` sai normal (`;x` etc.).
- Alternativas de cedilha que já existem no sistema (sem config):
  - `AltGr + ,` → ç (embutido no layout US Intl)
  - `CapsLock , c` → ç (CapsLock é a tecla compose no Omarchy)
- **Contexto técnico:** quem processa compose/dead keys aqui é o fcitx5,
  lendo `~/.XCompose`. Regras colocadas depois de `include "%L"` (que está
  dentro do `/usr/share/omarchy/default/xcompose`) sobrescrevem o sistema.
- **Histórico:** a primeira versão usava `' + c` (`<dead_acute> <c>`);
  funcionou, mas foi trocada por `; + c` por preferência de memória muscular.

---

## 3. CS2: autoexec.cfg instalado

**Arquivo de origem:** `~/Downloads/autoexec.cfg` (mantido como cópia)

**Destino (pasta de cfg do CS2 via Steam):**

```
~/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg
```

**Como aplicar em um script futuro:**

```bash
cp ~/Downloads/autoexec.cfg \
  ~/.local/share/Steam/steamapps/common/"Counter-Strike Global Offensive"/game/csgo/cfg/autoexec.cfg
```

**Observações:**

- O CS2 executa o `autoexec.cfg` automaticamente ao iniciar.
- Conteúdo: crosshair/HUD, viewmodel, sensibilidade 1.70, radar, binds
  (incl. pulo no scroll do mouse), aliases de inspecionar/dropar C4.
- ⚠️ A cfg contém uma linha `password "..."` (hash) vinda do arquivo
  original — serve para entrar em servidores com senha. Remover se não
  for necessária.

---

## 4. Monitor em 240Hz

**Motivo:** monitor AOC 24G2W1G8 (24", 240Hz) estava rodando a 60Hz —
o modo `preferred` do Hyprland pegou 60Hz por padrão.

**Arquivo:** `~/.config/hypr/monitors.lua`

**Trecho adicionado:**

```lua
-- AOC 24" 240Hz (24G2W1G8): 1920x1080@239.96
hl.monitor({ output = "DP-3", mode = "1920x1080@239.96", position = "0x0", scale = 1 })
```

**Como aplicar:** auto-reload ao salvar. Validar com:

```bash
hyprctl reload && hyprctl configerrors
hyprctl monitors   # deve mostrar 1920x1080@239.96
```

**Observações:**

- Descobrir nome do monitor e modos suportados: `hyprctl monitors all`
- O modo "240Hz" aparece como `239.96` — usar o valor exato.
- Backup do arquivo original: `~/.config/hypr/monitors.lua.bak.<timestamp>`
- VRR (taxa variável) está desligado (`vrr: false`) — possível tweak futuro
  para jogos.

---

## 5. Shell: trocado bash → fish

**Motivo:** autosuggestion, autocomplete inteligente e syntax highlight —
esses recursos são do SHELL, não do terminal (foot/Alacritty tanto faz).
O fish traz tudo isso por padrão, zero config.

**O que foi feito:**

```bash
omarchy pkg add fish                 # instala o pacote
sudo chsh -s /usr/bin/fish usul      # define como shell padrão
```

**Arquivo criado:** `~/.config/fish/config.fish` — replica o essencial do
setup bash do Omarchy:

- `starship init fish` (mesmo prompt)
- `zoxide init --cmd cd fish` (cd inteligente)
- `mise activate fish`
- aliases: `ls/lsa/lt/lta` (eza), `..`/`...`/`....`, `g` (git), `open` (xdg-open)

**Observações:**

- OMARCHY_PATH e PATH vêm da sessão (uwsm), não precisam ser setados no fish.
- Vale para terminais NOVOS (abra outro terminal para ver).
- bash continua instalado; scripts `.sh` não são afetados.
- Uso do autosuggestion: texto cinza aparece → seta direita ou End aceita.
- **Reverter:** `sudo chsh -s /usr/bin/bash usul` e apagar `~/.config/fish/config.fish`.
- Aliases bash do Omarchy que NÃO foram portados (posso adicionar se quiser):
  `ff` (fzf+bat), `t` (tmux), `n` (nvim), aliases de git (`gcm`, `gcam`...) etc.
  Estão em `/usr/share/omarchy/default/bash/aliases`.

---

## 6. Terminal (foot): fonte aumentada de 9pt → 12pt

**Motivo:** fonte do terminal estava muito pequena no monitor 24" 1080p.

**Arquivo:** `~/.config/foot/foot.ini`

```ini
font=JetBrainsMono Nerd Font:size=12
```

**Como aplicar:**

```bash
omarchy restart terminal
```

**Observações:**

- Para ajustar de novo, mude o `size=` no mesmo arquivo (ex.: 12, 13...).
- Alternativa que escala TUDO junto (barra, apps GTK e terminal):
  `omarchy display text size <9-20>` (padrão: 12px = 9pt de terminal).
- **Temas:** as cores do terminal vêm do tema Omarchy ativo
  (`~/.local/state/omarchy/current/theme/foot.ini` é incluído no foot.ini).
  - Temas instalados: `omarchy theme list` (22 temas, atual: Gruvbox)
  - Galeria de temas extras da comunidade: https://omarchy.org/themes
  - Aplicar: `omarchy theme set <nome>` ou `omarchy theme switcher`
  - Instalar tema extra: `omarchy theme install <url-do-git>`

---

## 7. Prompt starship: preset "no-empty-icons"

**Motivo:** o prompt padrão do Omarchy é minimalista (`~ >`). O preset
"no-empty-icons" mostra ícones/módulos só das ferramentas detectadas
(git, linguagens etc.), sem segmentos vazios.

**Arquivo:** `~/.config/starship.toml` (sobrescrito pelo preset)

**Como aplicar:**

```bash
starship preset no-empty-icons --force -o ~/.config/starship.toml
```

**Observações:**

- Aplica na hora (starship relê a config a cada prompt).
- Backup do prompt antigo (padrão Omarchy): `~/.config/starship.toml.bak.<timestamp>`
- Outros presets: `starship preset --list` ou https://starship.rs/presets/
- Nerd Font necessária para os ícones — já é a fonte do terminal
  (JetBrainsMono Nerd Font).

---

## 8. VSCodium: configs puxadas dos dotfiles

**Origem:** repositório público `hugofsp93/dotfiles` (não precisou de auth),
clonado em `~/dotfiles`.

**O que foi aplicado em `~/.config/VSCodium/User/`:**

- `settings.json` ← `~/dotfiles/settings.json`, com adaptações macOS→Linux:
  - `terminal.external.osxExec: Ghostty.app` → `terminal.external.linuxExec: foot`
  - `defaultProfile.osx/profiles.osx (zsh)` → `defaultProfile.linux/profiles.linux (fish)`
  - `terminal.integrated.env.osx` → `env.linux`
- `keybindings.json` ← `~/dotfiles/keybinding.json` (renomeado: o VS Code
  exige o nome no plural)

**Como replicar em script:**

```bash
git clone https://github.com/hugofsp93/dotfiles ~/dotfiles
cp ~/dotfiles/settings.json ~/.config/VSCodium/User/settings.json
cp ~/dotfiles/keybinding.json ~/.config/VSCodium/User/keybindings.json
# + adaptar as chaves osx→linux listadas acima
```

**Observações:**

- Backup do settings antigo: `~/.config/VSCodium/User/settings.json.bak.<timestamp>`
- Settings de extensões (gitlens, custom-ui-style, liveServer, claudeCode,
  material-icon-theme) ficam inertes até as extensões serem instaladas.
  O tema "Maron Theme: Crafter Materials" não está instalado — cai no tema
  padrão até instalar (no VSCodium o marketplace é o Open VSX).
- ⚠️ Keybindings com `cmd+` vêm do macOS: no Linux, `cmd` = tecla **Super**,
  que conflita com atalhos globais do Hyprland (ex.: Super+B abre o browser).
  Pendente: converter `cmd+` → `ctrl+` se fizer sentido.
- GitHub CLI (`gh`) instalado mas NÃO logado. Se um dia precisar de acesso a
  repos privados / push: `gh auth login` (interativo, rodar no terminal).

---

## 9. Dotfiles Linux publicados no GitHub

**Repo:** https://github.com/hugofsp93/dotfiles (branch `main`)

**Estrutura:** configs de macOS ficam na raiz (intactas); as de Linux foram
para a pasta **`linux/`**:

```
linux/
├── README.md            # tabela de destinos + comandos de restore
├── vscodium/            # settings.json + keybindings.json (versão Linux)
├── hypr/                # input.lua (US intl) + monitors.lua (240Hz)
├── foot/foot.ini        # terminal, fonte 12pt
├── fish/config.fish     # shell + aliases
├── starship.toml        # preset no-empty-icons
└── .XCompose            # ; + c = ç
```

**Outras mudanças feitas nesse processo:**

- `git config --global user.name "Hugo"` (estava vazio)
- `gh auth setup-git` (git usa o token do gh para push via HTTPS)
- O `keybinding.json` da raiz (versão mac) foi restaurado com
  `git checkout --` — a versão Linux ficou só em `linux/vscodium/`.

**Observações:**

- ⚠️ O `.XCompose` contém seu e-mail pessoal (sequências Multi_key de
  identificação) e o repo é PÚBLICO. Se incomodar, edite e faça push de novo.
- Fluxo para futuras mudanças: editar config na máquina → copiar para
  `~/dotfiles/linux/...` → commit + push.

---

## 10. Fish: mensagem de boas-vindas desativada

**Arquivo:** `~/.config/fish/config.fish` (sincronizado em `linux/fish/config.fish`)

```fish
set fish_greeting ""
```

Vale para terminais novos. Já commitado e pushed no dotfiles.

---

## 11. Editor padrão: nano + alias cat→bat

**Contexto:** o editor padrão era nvim (desconhecido do usuário). Definido
nano para edições rápidas de terminal (git commit, crontab, sudoedit).
VSCodium continua como editor principal. Vim fica disponível para aprender
(`vimtutor`). Fresh avaliado depois (plano pronto, pendente decisão).

**O que foi feito:**

```bash
pacman -S nano                                       # instalado pelo usuário
echo nano > ~/.local/state/omarchy/defaults/editor   # editor padrão Omarchy
```

**Alias no fish** (`~/.config/fish/config.fish`):

```fish
alias cat='bat'
```

**Observações:**

- O launcher do Omarchy aceita nano em `defaults/editor` mesmo sem estar na
  lista do `omarchy default editor`.
- Alias só vale em shell interativo; scripts não são afetados.
- Sincronizado no dotfiles: `linux/fish/config.fish` + README (restore).

---

## 12. opencode: ferramentas de IA instaladas

Config global em `~/.config/opencode/` — **cross-platform**, registrada no
dotfiles em **`~/dotfiles/opencode/`** (não em `linux/`). Detalhes e restore:
`~/dotfiles/opencode/README.md`.

- **ponytail** (npm plugin): agente "lazy senior dev", ativo por padrão
- **karpathy-guidelines** (skill): guidelines anti-overengineering
- **i-have-adhd** (plugin local em `~/.config/opencode/vendor/`):
  output ADHD-friendly, **always-on** via flag
  `~/.config/opencode/.i-have-adhd-always`
- **rtk** (AUR `rtk-bin` + `rtk init -g --opencode`): comprime output de
  bash em 60-90%
- **DCP** (npm plugin): poda dinâmica de contexto antigo

⚠️ Mudanças em opencode.json/plugins/skills exigem **reiniciar o opencode**.

---

## 13. Claude Code: ferramentas de IA instaladas (espelhando o opencode)

**Motivo:** replicar no Claude Code o mesmo stack de ferramentas de IA já
configurado no opencode (seção 12): ponytail, karpathy-guidelines,
i-have-adhd e rtk. Diferente do opencode (plugins via `opencode.json`),
o Claude Code usa seu próprio sistema de plugins (`claude plugin`) e hooks
em `~/.claude/settings.json`.

### 13.1 ponytail — plugin oficial via marketplace do GitHub

```bash
claude plugin marketplace add DietrichGebert/ponytail
claude plugin install ponytail@ponytail
```

- Precisa ser em dois comandos separados (o próprio autor avisa: instalar
  na mesma leva que adiciona o marketplace não funciona de forma confiável).
- Modo padrão: `full` (resolução: env var `PONYTAIL_DEFAULT_MODE` →
  `~/.config/ponytail/config.json` → `full` como fallback). Como não há
  config, cai no `full` — igual ao opencode.
- Comandos de sessão: `/ponytail lite|full|ultra|off`.

### 13.2 i-have-adhd — plugin oficial via marketplace do GitHub, always-on

```bash
claude plugin marketplace add ayghri/i-have-adhd
claude plugin install i-have-adhd@i-have-adhd
touch ~/.claude/.i-have-adhd-always
```

- Sem o `touch`, o skill só ativa sob demanda (`/i-have-adhd`). Com a flag,
  um hook `SessionStart` injeta o ruleset completo em toda sessão nova —
  equivalente ao `~/.config/opencode/.i-have-adhd-always` do opencode.
- Repo: https://github.com/ayghri/i-have-adhd (mesmo projeto usado no
  opencode, vendorizado lá em `~/.config/opencode/vendor/i-have-adhd`).
- **Reverter:** `rm ~/.claude/.i-have-adhd-always` (volta a ser sob demanda)
  ou `claude plugin uninstall i-have-adhd` (remove de vez).

### 13.3 karpathy-guidelines — skill copiado do opencode

**Arquivo:** `~/.claude/skills/karpathy-guidelines/SKILL.md`

```bash
mkdir -p ~/.claude/skills/karpathy-guidelines
cp ~/.config/opencode/skills/karpathy-guidelines/SKILL.md \
  ~/.claude/skills/karpathy-guidelines/SKILL.md
```

- Cópia direta do arquivo já usado no opencode (mesmo conteúdo, sem
  adaptação — skills do Claude Code são só uma pasta com `SKILL.md`).
- Carrega automaticamente quando o assunto é escrever/revisar código
  (frontmatter `description` decide a relevância).

### 13.4 rtk — hook nativo para Claude Code

```bash
rtk init --global --agent claude --auto-patch
```

**Arquivos afetados:**

- `~/.claude/RTK.md` (criado): referência de comandos do rtk.
- `~/.claude/CLAUDE.md` (criado/editado): ganhou a linha `@RTK.md` no topo,
  importando o RTK.md para o contexto.
- `~/.claude/settings.json` (editado): hook `PreToolUse` no matcher `Bash`
  rodando `rtk hook claude`, que reescreve os comandos automaticamente
  (ex.: `git status` → versão comprimida, 0 tokens extras).
- `~/.config/rtk/filters.toml` (criado): template de filtros globais,
  vazio até editar.
- Backup automático: `~/.claude/settings.json.bak`.

**Observações gerais (13.1–13.4):**

- ponytail e i-have-adhd usam hooks em Node.js — `node` precisa estar no
  PATH da shell não-interativa (atenção com mise/nvm).
- Qualquer instalação/mudança de plugin ou hook exige **reiniciar o
  Claude Code** para pegar efeito.
- Verificar plugins instalados: `claude plugin list`.
- Verificar hook do rtk: `cat ~/.claude/settings.json` (procurar por
  `"PreToolUse"`) ou rodar `rtk gain` depois de usar bash algumas vezes.
- Diferente da seção 12 (DCP, poda de contexto), não há equivalente do
  DCP configurado aqui — não avaliado ainda para Claude Code.

---

*(novas mudanças serão adicionadas abaixo)*
