# my-spaces — spaces and agents in one tree (Herdr app)

A mod for the Herdr desktop app (GPUI; not the `herdr` CLI) that merges the shipped
`spaces` and `agents` sidebar blocks into one list: every space row has its agents
hanging under it.

## What it does

- Machine headers (click to fold), `+` buttons, loading/reconnect, git info, worktree
  nesting, drag to reorder and the right-click menu are the shipped `spaces` mod's, unchanged.
- Under each space (and each nested worktree) its agents: program icon, title, time since the
  last state change, and state (spinner = working, `!` = blocked, dot = done, ring = idle).
  Pinned first, then blocked > done > working > idle. Click focuses the agent's pane;
  hover shows a pin button. Sub-agents (`hc run` children) hang under their parent; click peeks.
- The chevron at the right of a space row folds its agents (open by default, remembered).
  Spaces without agents show no chevron.
- Agents with no space row to hang under (space not shown yet, machine being reconnected)
  are listed last under **Other**, never dropped.
- `setAgentOrder` gets every agent (folded ones too) in display order, only when it changes,
  so `agent.next` / `agent.prev` follow the list.
- The collapsed rail (sidebar narrower than 160 px) is the shipped compact list, no agents.

## Dependencies

It draws icons from the shipped **`workspace-chrome`** mod's assets and does not ship its own:
`mods/workspace-chrome/{spinner,chevron-down,chevron-right,pin,pin-off,plus,server,monitor,branch}.svg`.
Agent program icons come from the app's program table (`icons/…`).
The layout also uses the shipped `workspace-chrome`, `tabs`, `pane`, `files`, `changes`, `workspace-status`
mods (as `main` does).

## Files

- `mods/my-spaces/{main.js,mod.json}` — the mod. A clone of `spaces` (0.1.12) with the agent tree added.
- `layouts/my-layout.json` — a clone of `main` whose sidebar is just `my-spaces` at full height.
- `install.ps1` — copies both into `~/.config/herdr-app` (or `$HERDR_APP_HOME`) and runs `herdr-app check`.

## Install

```powershell
.\install.ps1            # copy mod + layout, then check
.\install.ps1 -Switch    # ...and show my-layout
```

Saving `main.js` in the config folder hot-reloads every copy of the mod, so re-run the
script after each edit. (A junction was not used: the app watches the real folder, and a copy is
the documented, safe way.) `my-layout` is shown with `shared("layout")`; Ctrl-Shift-L cycles layouts,
`herdr-app do layout.switch '{"name":"main"}'` goes back.

The script overwrites `layouts/my-layout.json` in the config folder; sizes you dragged live in
`layouts/.state/` and survive.

## Check

```sh
herdr-app check ~/.config/herdr-app/mods/my-spaces
```
