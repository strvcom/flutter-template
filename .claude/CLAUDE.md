@../AGENTS.md

Project-specific reusable AI workflows live in `../ai/skills/` and are surfaced
to Claude Code two ways:
- **auto-discovery**: `./skills/<name>` is a symlink with target
  `../../ai/skills/<name>` (resolved from `.claude/skills/`, this points
  at `<repo>/ai/skills/<name>`), so Claude reads the SKILL.md frontmatter
  and triggers them based on context.
- **slash commands**: `./commands/<name>.md` exposes each skill as an explicit
  command — `/project-setup`, `/feature-screen`, `/feature-data-flow`,
  `/upgrade`, `/release-prepare`, `/release-builds`, `/secrets-bootstrap`,
  `/pr-review`.

See the "Reusable Workflows" section of `AGENTS.md` for the canonical list of
skills and the four-step convention for adding a new one.
