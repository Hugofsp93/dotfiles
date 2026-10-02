# opencode — config global + ferramentas de IA

Config global do [opencode](https://opencode.ai) (cross-platform: Linux, macOS, Windows).
Não é específico de nenhuma máquina — mora em `~/.config/opencode/`.

## O que está configurado

| Ferramenta | O que faz | Como está instalada |
|---|---|---|
| **ponytail** | Agente "lazy senior dev": pensa antes de codar, escreve o mínimo (YAGNI ladder). Ativo por padrão, injeta regras a cada turno. | Plugin npm `@dietrichgebert/ponytail` no `opencode.json` |
| **i-have-adhd** | Output ADHD-friendly: resposta primeiro, sem preâmbulo, listas curtas, uma ação por vez. **SEMPRE ATIVO** via flag file. | Plugin local em `vendor/i-have-adhd/` + flag `.i-have-adhd-always` |
| **DCP** (dynamic context pruning) | Poda contexto antigo da conversa (dedup, purge de erros, compress). | Plugin npm `@tarquinen/opencode-dcp` no `opencode.json` |

## Restaurar em uma máquina nova

```bash
# 1. Config
cp opencode.json ~/.config/opencode/opencode.json

# 2. i-have-adhd (plugin local — o caminho "./vendor/..." no opencode.json
#    resolve relativo a ~/.config/opencode/)
git clone --depth 1 https://github.com/ayghri/i-have-adhd \
  ~/.config/opencode/vendor/i-have-adhd

# 3. Ativar modo always-on do i-have-adhd
touch ~/.config/opencode/.i-have-adhd-always

# 4. ponytail no ultra (config compartilhada com o Claude Code)
mkdir -p ~/.config/ponytail && echo '{"defaultMode":"ultra"}' > ~/.config/ponytail/config.json

# 5. ponytail e DCP são plugins npm — o opencode baixa sozinho
#    no primeiro start. Reinicie o opencode.
```

## Notas

- Setup completo (Claude Code + o que foi removido e por quê): [`../ai-setup.md`](../ai-setup.md).

- Requer `node` no PATH (hooks do ponytail).
- i-have-adhd: para desligar o always-on, apague
  `~/.config/opencode/.i-have-adhd-always`; para desligar só na sessão,
  diga "stop adhd mode".
- Fontes: [ponytail](https://github.com/DietrichGebert/ponytail) ·
  [i-have-adhd](https://github.com/ayghri/i-have-adhd) ·
  [DCP](https://github.com/Opencode-DCP/opencode-dynamic-context-pruning)
