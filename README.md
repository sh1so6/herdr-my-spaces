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
- `setAgentOrder` gets every agent (inactive ones last) (folded ones too) in display order, only when it changes,
  so `agent.next` / `agent.prev` follow the list.
- **Pin a space**: a pin button appears when you hover a space row (a small pin stays on pinned ones). Pinned
  spaces come first in their machine's group; the rest keep the core's order, and a worktree stays under its checkout.
  Drag-reordering only works between rows of the same machine *and* the same pin state; the core order
  (`space.move`) is never changed by pinning.
- **Inactive group**: spaces you aren't using can be moved to an **Inactive (n)** group at the end of the list
  (after the machine groups and **Other**), folded by default. It lists every machine's inactive spaces flat, in
  core order, with the machine named, and their agents as usual. Its heading shows a dot when an inactive space has a
  blocked or done agent; nothing is activated automatically. Move a space either with the second hover button
  ("Move to Inactive" / "Move back") or by dragging its row onto the Inactive heading (or onto any row in it);
  drag an inactive row onto a machine heading or an active row to bring it back. The heading shows while dragging even
  when empty. Worktree nesting is computed from the active spaces only, so an active worktree of an inactive
  checkout is a plain row. The selected space can be made inactive and stays highlighted.
- The collapsed rail (sidebar narrower than 160 px) is the shipped compact list, no agents.

## Saved state

Per mod copy, in `localStorage` (the core has no pin/hide commands): `spaces.pinned` and `spaces.inactive` (arrays of
space ids), `spaces.inactive.folded` (boolean, default `true`), `spaces.agents.folded`, `machines.folded`.
Ids of spaces that no longer exist are not pruned (a machine that is away must not lose its pins), so old ids
stay in the arrays; they are harmless.

## Dependencies

It draws icons from the shipped **`workspace-chrome`** mod's assets and does not ship its own:
`mods/workspace-chrome/{spinner,chevron-down,chevron-right,pin,pin-off,archive,plus,server,monitor,branch}.svg`.
Its own `mods/my-spaces/archive-restore.svg` (the "Move back" button) ships in the repo.
Agent program icons come from the app's program table (`icons/…`).
The layout also uses the shipped `workspace-chrome`, `tabs`, `pane`, `files`, `changes`, `workspace-status`
mods (as `main` does).

## Files

- `mods/my-spaces/{main.js,mod.json,archive-restore.svg}` — the mod. A clone of `spaces` (0.1.12) with the agent tree added.
- `layouts/my-layout.json` — a clone of `main` whose sidebar is just `my-spaces` at full height.
- `install.ps1` — copies the mod (`main.js`, `mod.json`, `*.svg`) and the layout into `~/.config/herdr-app` (or `$HERDR_APP_HOME`) and runs `herdr-app check`.

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
