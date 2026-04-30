# AGENTS.md

Agent-agnostic guidance for any coding agent working in this repository. Keep all agent-agnostic instructions in this file. Agent-specific guidance lives in the agent's own file (e.g. `CLAUDE.md`).

## Repository purpose

Personal dotfiles repo. The working tree is structured to be cloned/symlinked at `$HOME` — the path `.config/nvim/` here corresponds to `~/.config/nvim/` on the user's machine. There is no build, test, or lint step; changes are validated by reloading Neovim.

`.gitignore` excludes `.config/nvim/lazy-lock.json` (lazy.nvim's plugin lockfile is not tracked).

## Neovim configuration architecture

Entry points and load order:
1. `.config/nvim/init.lua` → `require("wicked")`
2. `.config/nvim/lua/wicked/init.lua` requires, in order: `wicked.remap` (keymaps), `wicked.set` (options), `wicked.lazy` (plugin manager bootstrap + spec).
3. After `lazy.setup` runs, Neovim sources every file under `.config/nvim/after/plugin/*.lua` automatically (standard `after/` runtime path). Each of those files configures one plugin loaded by lazy.

This means: plugin **declarations** live in `lua/wicked/lazy.lua`, but plugin **configuration** (setup calls, keymaps, autocmds) lives in `after/plugin/<name>.lua`. When adding a plugin, both files usually need a change unless the plugin is configured inline via `opts`/`config` in the lazy spec.

DAP adapters are split out under `lua/dap/` (`dap-haskell.lua`, `dap-odoo.lua`, `dap-dotnet.lua`) and are required from `after/plugin/dap.lua`.

Leader key is `<Space>`, set in both `remap.lua` and `set.lua` (the duplicate in `set.lua` is intentional defensive ordering).

## Notable plugin choices

- **lazy.nvim** with `checker.enabled = true` (auto-checks for updates daily).
- **snacks.nvim** is used for picker/terminal/etc. — it replaced telescope (see commit `12db5d8`). Don't reintroduce telescope.
- **everforest** is the active colorscheme; nord is installed but not active.
- **codecompanion.nvim** pinned to `^18.0.0`.
- **roslyn.nvim** for C# LSP (separate from the standard `nvim-lspconfig` flow).
- **tidal.nvim** + **strudel.nvim** for live-coding music; tidal expects `ghci` at `~/.ghcup/bin/ghci` and a SuperDirt boot file at `~/.local/share/tidal/BootSuperDirt.scd`.
- **obsidian.nvim** workspace points at `~/notes`.
- **persistence.nvim** stores sessions under `stdpath("state")/sessions/`.
- Undo files live at `~/.vim/undodir` (set in `wicked/set.lua`), not the default location.

## Working in this repo

- To preview changes, reload Neovim or `:source` the affected file. There are no CI or test commands to run.
- `lazy-lock.json` is gitignored — don't try to commit it. Plugin version pinning happens via the spec in `lua/wicked/lazy.lua`.
