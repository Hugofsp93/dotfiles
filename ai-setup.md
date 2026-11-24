# Setup de agentes de IA (Claude Code + opencode)

Estado em 2026-10-01. Os dois agentes usam as mesmas regras: **ponytail** (no
nível ultra) e **i-have-adhd**, sempre ativos, em qualquer pasta, mesmo para
um simples "oi".

---

## Claude Code (`~/.claude/`)

### Plugins (`settings.json` → `enabledPlugins`)

| Plugin | Marketplace (GitHub) | O que faz |
|---|---|---|
| **ponytail** | `DietrichGebert/ponytail` | "Lazy senior dev": código mínimo (YAGNI ladder). Hooks: SessionStart, SubagentStart, UserPromptSubmit. |
| **i-have-adhd** | `ayghri/i-have-adhd` | Output ADHD-friendly. SessionStart injeta as regras se existir a flag. |
| **skins** | `hellosverre/claude-skins` | Tema/skin da transcrição do Claude Code (skill `skins:skin-designer`). |

### Restaurar numa máquina nova

```bash
# Requer node no PATH (hooks dos plugins)
claude plugin marketplace add DietrichGebert/ponytail
claude plugin marketplace add ayghri/i-have-adhd
claude plugin marketplace add hellosverre/claude-skins
claude plugin install ponytail@ponytail
claude plugin install i-have-adhd@i-have-adhd
claude plugin install skins@hellosverre-mods

touch ~/.claude/.i-have-adhd-always
mkdir -p ~/.config/ponytail && echo '{"defaultMode":"ultra"}' > ~/.config/ponytail/config.json
```

Os comandos `/plugin ...` dentro do Claude Code fazem o mesmo.

### Configs fora do padrão (`~/.claude/settings.json`)

| Chave | Valor | Efeito |
|---|---|---|
| `tui` | `"fullscreen"` | Interface em tela cheia |
| `env.DISABLE_AUTOUPDATER` | `"1"` | Sem auto-update e sem o aviso de "atualize" (atualizo pelo gerenciador de pacotes) |
| `skipDangerousModePermissionPrompt` | `true` | Não pede confirmação ao entrar no modo bypass de permissões |
| `attribution.commit` / `.pr` | `""` | Commits e PRs sem a linha "Co-Authored-By: Claude" |
| `theme` | `"custom:omarchy"` | Tema próprio, em [`claude/themes/omarchy.json`](claude/themes/omarchy.json) (cores gruvbox-material) |

Juntando tudo:

```bash
mkdir -p ~/.claude/themes && cp claude/themes/omarchy.json ~/.claude/themes/
```

```json
{
  "attribution": { "commit": "", "pr": "" },
  "tui": "fullscreen",
  "env": { "DISABLE_AUTOUPDATER": "1" },
  "skipDangerousModePermissionPrompt": true,
  "theme": "custom:omarchy"
}
```

Mescle esse JSON no `~/.claude/settings.json`. O `/plugin install` já adiciona
`enabledPlugins` e `extraKnownMarketplaces`, e o herdr adiciona o próprio hook
(ver abaixo).

### Home como pasta confiável (`~/.claude.json`)

Sempre abro o Claude em `~`, e a resposta à pergunta "confia nesta pasta?"
não era salva para a home. Marquei a home manualmente:

```bash
python3 - <<'EOF'
import json, os
p = os.path.expanduser('~/.claude.json'); d = json.load(open(p))
d.setdefault('projects', {}).setdefault(os.path.expanduser('~'), {})['hasTrustDialogAccepted'] = True
json.dump(d, open(p, 'w'), indent=2)
EOF
```

Efeito: o Claude sobe pelas pastas-pai para checar a confiança, então
**todas as pastas dentro de `~`** passam a ser confiáveis, inclusive repos
clonados que ainda não foram revisados (hooks e MCPs do `.claude/` deles
rodam sem perguntar). Fora da home, ele continua perguntando.

### herdr (multiplexador de terminal para agentes)

O [herdr](https://herdr.dev) (`~/.local/bin/herdr`, v0.9.3) mostra numa
sidebar quais agentes estão rodando, parados ou esperando. Para isso, ele
instala um hook em cada agente:

```bash
herdr integration install claude     # cria ~/.claude/hooks/herdr-agent-state.sh + hook SessionStart no settings.json
herdr integration install opencode   # cria ~/.config/opencode/plugins/herdr-agent-state.js
herdr integration status             # conferir
```

Também estão instaladas as integrações `pi` e `codex`. Não edite o script
gerado, porque o herdr o sobrescreve ao atualizar. O hook só age dentro de
um pane do herdr (`HERDR_ENV=1`); fora dele, sai sem fazer nada. Atalho da
sidebar: ver `omarchy/omarchy-customizacoes.md` §18.

### Como as regras entram em toda sessão

Não é pelo `CLAUDE.md` (não existe mais). Cada plugin tem um hook de
**SessionStart** (`startup|resume|clear|compact`) que imprime as regras no
contexto:

- **i-have-adhd**: só fica sempre ativo se existir `~/.claude/.i-have-adhd-always`.
- **ponytail**: o nível vem de `~/.config/ponytail/config.json`, que é
  compartilhado com o opencode:

  ```json
  {"defaultMode":"ultra"}
  ```

  Na sessão: `/ponytail lite|full|ultra`. Para desligar: "stop ponytail".

### Barra inferior numa linha só (GSD + mod `oneline`)

Estado em 2026-11-23, GSD 1.23.0. O instalador do GSD põe um `statusLine`
(`gsd-statusline.js`) que ocupa uma linha própria acima do `⏵⏵ … mode on`, e o
hook `gsd-check-update` acende `⬆ /gsd-update` nela. Troquei os dois pelo mod
[`claude/mods/oneline`](claude/mods/oneline), que escreve modelo, pasta e
contexto no fim da linha do modo:

```
⏵⏵ bypass permissions on (shift+tab to cycle) · ← 2 agents · │ Opus 5.5 │ hugofelipe ░░░░░░░░░░ 0%
```

Depois de instalar/atualizar o GSD (`/gsd-update` ou
`npx -y --package=@opengsd/gsd-core@latest -- gsd-core --claude --global`):

```bash
mkdir -p ~/.claude/mods && cp -r claude/mods/oneline ~/.claude/mods/

# tira o statusLine do GSD e o hook que checa update; liga o mod
node -e '
const f=process.env.HOME+"/.claude/settings.json",fs=require("fs"),s=JSON.parse(fs.readFileSync(f));
delete s.statusLine;
s.hooks.SessionStart=(s.hooks.SessionStart||[]).filter(g=>!g.hooks.some(h=>h.command.includes("gsd-check-update")));
(s.env??={}).CLAUDE_CODE_PLUGIN_DIRS="~/.claude/mods/oneline";
fs.writeFileSync(f,JSON.stringify(s,null,2)+"\n")'
rm -f ~/.cache/gsd/gsd-update-check*.json
```

Reiniciar o Claude Code. Sem o hook, o GSD não avisa mais de versão nova:
rodar `/gsd-update` de vez em quando. O instalador não sobrescreve um
`statusLine` existente (só com `--force-statusline`), mas pode recolocar o
hook `gsd-check-update`: rodar o `node -e` de novo depois de cada update.

Alinhar a info à direita (space-between) não deu certo: o mod não sabe a
largura real da linha nem o tamanho do texto do Claude Code, e um `Box` com
`justifyContent` em volta da linha é recusado.

### Outros

- Skills locais em `~/.claude/skills/`: `omarchy` e `diagnose-crash` (links simbólicos para `/usr/share/omarchy/default/agents/skills/`).
- Os plugins `html-revelo`/`ts-revelo` e as skills docs/pdf/xlsx etc. vêm sincronizados da conta claude.ai.

---

## Claude Code no macOS (2026-10-03)

As regras são as mesmas do Arch (ponytail ultra + i-have-adhd sempre ativos), com
uma diferença: existe um `~/.claude/CLAUDE.md` global.

### Restaurar

```bash
claude plugin marketplace add DietrichGebert/ponytail
claude plugin marketplace add ayghri/i-have-adhd
claude plugin install ponytail@ponytail
claude plugin install i-have-adhd@i-have-adhd

touch ~/.claude/.i-have-adhd-always
mkdir -p ~/.config/ponytail && echo '{"defaultMode":"ultra"}' > ~/.config/ponytail/config.json
```

`~/.claude/CLAUDE.md`:

```md
# Default style
Sempre ativos, em toda resposta, inclusive em "oi":
- ponytail no nível ultra. Desligar só com "stop ponytail".
- i-have-adhd. Desligar só com "stop adhd mode" / "normal mode".
```

O CLAUDE.md declara a obrigação, e os hooks SessionStart dos plugins injetam as
regras completas. O graphify fica por projeto e não entra no global.

### Configs (`~/.claude/settings.json`)

```json
{
  "attribution": { "commit": "", "pr": "" },
  "tui": "fullscreen",
  "viewMode": "default",
  "env": { "DISABLE_AUTOUPDATER": "1" }
}
```

### Removidos no macOS

- rtk: `brew uninstall rtk`, `rm -rf ~/Library/Application\ Support/rtk`, o
  hook `rtk hook claude` e as permissões `Bash(rtk ...)` no `settings.json`.
- `~/.claude/RTK.md` e `~/.claude/KARPATHY.md`.
- O hook SessionStart manual que injetava `skills/i-have-adhd/SKILL.md` via
  `jq`, porque ele duplicava o hook do plugin.

---

## opencode (`~/.config/opencode/`)

Ver [`opencode/README.md`](opencode/README.md). Resumo:

- Instalado via **mise** (`opencode latest` em `~/.config/mise/config.toml`).
- Plugins (`opencode.json`): `@dietrichgebert/ponytail`, `@tarquinen/opencode-dcp`, i-have-adhd local (`vendor/`).
- i-have-adhd sempre ativo: flag `~/.config/opencode/.i-have-adhd-always`.
- ponytail: lê o mesmo `~/.config/ponytail/config.json` (ultra). **Não** pode
  existir `~/.config/opencode/.ponytail-active`, porque ele sobrescreve o default.

---

## Removidos (2026-10-01) e por quê

- **rtk** (Rust Token Killer): o [benchmark da JetBrains](https://blog.jetbrains.com/ai/2026/07/rtk-claude-code-token-savings/)
  mediu custo igual ou maior (+7,6% de custo e +13,8% de turnos com esforço
  baixo). O próprio Claude Code já trunca outputs grandes, e o rtk escondia
  linhas do output. O custo real está nas releituras de contexto (~94%), não
  na escrita.
  Desinstalar: `sudo pacman -Rns rtk-bin`.
- **karpathy-guidelines**: tudo o que ela cobre já está no ponytail, e a regra
  "na dúvida, pare e pergunte" conflita com o ponytail.

As regras fixas (adhd + ponytail, ~3,2K tokens) custam <1% do total, então
deixá-las sempre ativas é barato.
