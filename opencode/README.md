# opencode — config global + ferramentas de IA

Config global do [opencode](https://opencode.ai) (cross-platform: Linux, macOS, Windows).
Não é específico de nenhuma máquina — mora em `~/.config/opencode/`.

## O que está configurado

| Ferramenta | O que faz | Como está instalada |
|---|---|---|
| **ponytail** | Agente "lazy senior dev": pensa antes de codar, escreve o mínimo (YAGNI ladder). Ativo por padrão, injeta regras a cada turno. | Plugin npm `@dietrichgebert/ponytail` no `opencode.json` |
| **karpathy-guidelines** | Skill com guidelines do Karpathy contra erros comuns de LLM (overcomplication, mudanças não-cirúrgicas etc.). | Skill em `skills/karpathy-guidelines/SKILL.md` |
| **i-have-adhd** | Output ADHD-friendly: resposta primeiro, sem preâmbulo, listas curtas, uma ação por vez. **SEMPRE ATIVO** via flag file. | Plugin local em `vendor/i-have-adhd/` + flag `.i-have-adhd-always` |
| **rtk** | Comprime output de comandos bash (git status, ls, testes) em 60-90% antes de chegar no contexto do LLM. | Binário (`rtk`) + plugin gerado por `rtk init -g --opencode` |
| **DCP** (dynamic context pruning) | Poda contexto antigo da conversa (dedup, purge de erros, compress). | Plugin npm `@tarquinen/opencode-dcp` no `opencode.json` |

## Restaurar em uma máquina nova

```bash
# 1. Config + skill
cp opencode.json ~/.config/opencode/opencode.json
mkdir -p ~/.config/opencode/skills
cp -r skills/* ~/.config/opencode/skills/

# 2. i-have-adhd (plugin local — o caminho "./vendor/..." no opencode.json
#    resolve relativo a ~/.config/opencode/)
git clone --depth 1 https://github.com/ayghri/i-have-adhd \
  ~/.config/opencode/vendor/i-have-adhd

# 3. Ativar modo always-on do i-have-adhd
touch ~/.config/opencode/.i-have-adhd-always

# 4. rtk: instalar o binário e gerar o plugin do opencode
#    Arch:  yay -S rtk-bin     macOS:  brew install rtk
rtk init -g --opencode

# 5. ponytail e DCP são plugins npm — o opencode baixa sozinho
#    no primeiro start. Reinicie o opencode.
```

## Notas

- Requer `node` no PATH (hooks do ponytail).
- i-have-adhd: para desligar o always-on, apague
  `~/.config/opencode/.i-have-adhd-always`; para desligar só na sessão,
  diga "stop adhd mode".
- Fontes: [ponytail](https://github.com/DietrichGebert/ponytail) ·
  [karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) ·
  [i-have-adhd](https://github.com/ayghri/i-have-adhd) ·
  [rtk](https://github.com/rtk-ai/rtk) ·
  [DCP](https://github.com/Opencode-DCP/opencode-dynamic-context-pruning)
