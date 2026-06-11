---
name: layout-debug
description: >
  Diagnose and fix Flutter layout, overflow, unbounded constraint, scroll, and responsive
  rendering issues in this repository while preserving the template's existing feature,
  theme, localization, and shared widget patterns. Use when UI overflows, text clips,
  widgets disappear, layouts fail on mobile/tablet/desktop, or a feature needs responsive
  behavior.
allowed-tools: Bash, Read, Grep, Glob, Edit, Write
model: claude-sonnet-4-6
---

# Flutter Template Layout Debug

Use this skill for UI fixes and responsive layout work in this Flutter template.

## Read First
- `AGENTS.md`
- `docs/PROJECT_OVERVIEW.md`
- `docs/PROJECT_GUIDELINES.md`
- The affected `*_page.dart` and `*_page_content.dart`
- Shared widgets in `lib/common/component/` or `lib/common/composition/` used by the screen

## Error Signatures
Map console/stack-trace error strings directly to fixes before broader diagnosis:

- **"Vertical viewport was given unbounded height"** — a scrollable (`ListView`, `GridView`)
  sits inside an unconstrained vertical parent (usually a `Column`). Wrap the scrollable in
  `Expanded`, or give it an explicit height via `SizedBox`/`ConstrainedBox`.
- **"An InputDecorator...cannot have an unbounded width"** — a `TextField`/`TextFormField` sits
  inside an unconstrained horizontal parent (usually a `Row`). Wrap it in `Expanded` or `Flexible`.
- **"RenderFlex overflowed by N pixels"** — a `Row`/`Column` child requests more space than the
  parent allows (yellow/black stripes). Wrap the overflowing child in `Expanded` or `Flexible`,
  or let text wrap.
- **"Incorrect use of ParentData widget"** — `Expanded`/`Flexible` is not a direct child of a
  `Row`/`Column`/`Flex`, or `Positioned` is not a direct child of a `Stack`. Move it so it is.
- **"RenderBox was not laid out"** — cascading side effect, not the root cause. Ignore it and
  look further up the output for the primary constraint violation above.

## Diagnosis Checklist
1. Reproduce or identify the failing viewport, text scale, platform, and state.
2. Inspect the nearest `Row`, `Column`, `Stack`, `ListView`, `SingleChildScrollView`,
   `Expanded`, `Flexible`, and fixed-size widget.
3. Find whether the problem is:
   - missing constraints
   - conflicting constraints
   - unbounded scrollable content
   - fixed dimensions where content is dynamic
   - text that cannot wrap or scale within its parent
   - a `Stack` or overlay that visually collides with later content
4. Fix the closest layout cause instead of papering over the symptom with arbitrary sizes.

## Responsive Guidance
- Prefer `LayoutBuilder` when a widget must adapt to the actual space its parent gives it.
- Prefer `MediaQuery.sizeOf(context)` only when the whole screen size matters.
- Use constrained widths for readable desktop/tablet content, but keep page sections unframed
  unless an existing shared composition already frames that content.
- Use breakpoints only when the UI meaningfully changes. Avoid sprinkling one-off magic numbers
  through child widgets.
- Keep page widgets thin; place responsive branching in `*_page_content.dart` or a small local
  helper widget.

## Constraint Patterns
- In a `Row`, wrap long text or flexible content with `Expanded` or `Flexible`.
- In a `Column`, avoid placing unconstrained scrollables directly inside another unbounded parent.
- Give grids and fixed-format controls stable dimensions with `aspectRatio`, `SliverGridDelegate`,
  `ConstrainedBox`, or `SizedBox` when dynamic content would otherwise shift layout.
- Use `SingleChildScrollView` for small form-like pages that can overflow vertically.
- Use `CustomScrollView` or slivers for larger composed screens with independently sized sections.
- Use `SafeArea` or existing system-bar helpers when content collides with system UI.

## Text And Accessibility
- Let user-facing strings wrap unless truncation is clearly intended.
- Use `maxLines` and `overflow` only when the design has a real truncation rule.
- Verify button labels, tab labels, and card text at narrow widths.
- Do not solve text overflow by scaling font size with viewport width.

## Workflow
1. Read the affected widgets and shared components.
2. Identify the smallest widget that owns the broken constraints.
3. Patch the layout using existing theme/context extensions and shared widgets.
4. Add or update a widget test when the issue can be captured deterministically.
5. Run a narrow test when available:
   ```bash
   fvm flutter test test/path/to/file_test.dart
   ```
6. Run `fvm flutter analyze` when the fix touches source code.

## Completion Criteria
- No overflow or unbounded-constraint failure remains for the reported state.
- The fix works for narrow mobile and wider tablet/desktop constraints when the screen supports
  those platforms.
- Text remains readable, wraps or truncates intentionally, and does not overlap neighboring UI.
- The solution follows existing feature and shared-widget boundaries.
