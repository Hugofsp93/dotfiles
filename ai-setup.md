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
| **whiteboard** | `devdotfast/whiteboard` | Ferramentas MCP de whiteboard. |

### Restaurar numa máquina nova

```bash
# Requer node no PATH (hooks dos plugins)
claude plugin marketplace add DietrichGebert/ponytail
claude plugin marketplace add ayghri/i-have-adhd
claude plugin marketplace add devdotfast/whiteboard
claude plugin install ponytail@ponytail
claude plugin install i-have-adhd@i-have-adhd
claude plugin install whiteboard@devfast

touch ~/.claude/.i-have-adhd-always
mkdir -p ~/.config/ponytail && echo '{"defaultMode":"ultra"}' > ~/.config/ponytail/config.json
```

Os comandos `/plugin ...` dentro do Claude Code fazem o mesmo. O hook do
herdr só faz sentido se o herdr estiver instalado.

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

### Outros

- Hook próprio de SessionStart: `~/.claude/hooks/herdr-agent-state.sh` (estado do agente para o herdr).
- Skills locais em `~/.claude/skills/`: `omarchy` e `diagnose-crash` (links simbólicos para `/usr/share/omarchy/default/agents/skills/`).
- Os plugins `html-revelo`/`ts-revelo` e as skills docs/pdf/xlsx etc. vêm sincronizados da conta claude.ai.

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
