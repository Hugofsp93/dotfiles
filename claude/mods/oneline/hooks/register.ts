import type { Register } from 'claude-code'

const bar = (pct: number) => {
  const filled = Math.min(10, Math.round(pct / 10))
  return '█'.repeat(filled) + '░'.repeat(10 - filled)
}

// claude-opus-5-5 -> Opus 5.5
const prettyModel = (id: string) => {
  const m = id.match(/^claude-([a-z]+)-(\d+)-(\d+)/)
  return m ? `${m[1]![0]!.toUpperCase()}${m[1]!.slice(1)} ${m[2]}.${m[3]}` : id
}

export const register: Register = on => {
  on('ui.render', { component: 'PromptHint' }, async ($, e, next) => {
    const [model, root, { context }] = await Promise.all([$.session.model(), $.session.root(), $.session.usage()])
    const pct = context.percent ?? 0
    const tail = ` │ ${prettyModel(model)} │ ${root.split('/').pop()} ${bar(pct)} ${pct}%`
    return next({ ...e, props: { ...e.props, tail } })
  })

  // context % changes after each response
  on('turn.complete', ($, e, next) => {
    $.ui.invalidate('ui.render')
    return next(e)
  })
}
