#!/usr/bin/env python3
"""Validate .agents/skills/* against the Agent Skills spec (agentskills.io/specification)
and this repo's skill-exposure convention (see AGENTS.md "Creating a new skill").

Checks per skill:
  - SKILL.md exists with parseable YAML frontmatter (strict — lenient parsers in
    some clients mask errors that make other clients silently skip the skill)
  - name: required, 1-64 chars, lowercase alphanumerics and single hyphens,
    no leading/trailing hyphen, matches the directory name
  - description: required, 1-1024 chars
  - unknown top-level frontmatter fields (spec fields + known Claude Code
    extensions are accepted; anything else is a warning)
  - SKILL.md body under 500 lines (spec recommendation; warning)
  - Claude Code exposure exists:
      .claude/skills/<name> symlink and .claude/commands/<name>.md slash command

Exits 1 on errors, 0 if only warnings. Requires PyYAML (pip install pyyaml).
"""

import os
import re
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKILLS_DIR = os.path.join(REPO_ROOT, ".agents", "skills")

SPEC_FIELDS = {"name", "description", "license", "compatibility", "metadata", "allowed-tools"}
CLAUDE_EXTENSIONS = {"model", "user-invocable", "disable-model-invocation"}
NAME_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
MAX_BODY_LINES = 500

try:
    import yaml
except ImportError:
    print("error: PyYAML is required: pip install pyyaml")
    sys.exit(1)


def check_skill(skill_dir: str) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    warnings: list[str] = []
    dirname = os.path.basename(skill_dir)
    skill_md = os.path.join(skill_dir, "SKILL.md")

    if not os.path.isfile(skill_md):
        return [f"missing SKILL.md"], warnings

    text = open(skill_md, encoding="utf-8").read()
    match = re.match(r"^---\n(.*?)\n---\n?(.*)$", text, re.S)
    if not match:
        return ["SKILL.md has no YAML frontmatter block"], warnings

    try:
        fm = yaml.safe_load(match.group(1))
    except yaml.YAMLError as exc:
        msg = str(exc).splitlines()[0]
        return [f"frontmatter is not valid YAML ({msg}) — "
                "quote values containing colons or use a '>' block scalar"], warnings
    if not isinstance(fm, dict):
        return ["frontmatter is not a YAML mapping"], warnings

    name = fm.get("name")
    if not name:
        errors.append("missing required field: name")
    else:
        if name != dirname:
            errors.append(f"name '{name}' does not match directory '{dirname}'")
        if not NAME_RE.fullmatch(str(name)):
            errors.append(f"name '{name}' violates spec charset rules")
        if len(str(name)) > 64:
            errors.append("name exceeds 64 characters")

    description = fm.get("description")
    if not description:
        errors.append("missing required field: description")
    elif len(str(description)) > 1024:
        errors.append(f"description is {len(str(description))} chars (max 1024)")

    for key in fm:
        if key not in SPEC_FIELDS | CLAUDE_EXTENSIONS:
            warnings.append(f"unknown frontmatter field '{key}' "
                            "(spec suggests nesting extras under 'metadata:')")

    body_lines = match.group(2).count("\n") + 1
    if body_lines > MAX_BODY_LINES:
        warnings.append(f"body is {body_lines} lines (spec recommends < {MAX_BODY_LINES}; "
                        "consider moving detail into references/)")

    for rel, kind in [
        (os.path.join(".claude", "skills", dirname), "Claude Code symlink"),
        (os.path.join(".claude", "commands", f"{dirname}.md"), "slash command"),
    ]:
        path = os.path.join(REPO_ROOT, rel)
        if not os.path.exists(path):
            errors.append(f"missing {kind}: {rel}")

    return errors, warnings


def main() -> int:
    if not os.path.isdir(SKILLS_DIR):
        print(f"error: skills directory not found: {SKILLS_DIR}")
        return 1

    total_errors = 0
    total_warnings = 0
    for entry in sorted(os.listdir(SKILLS_DIR)):
        skill_dir = os.path.join(SKILLS_DIR, entry)
        if not os.path.isdir(skill_dir):
            continue
        errors, warnings = check_skill(skill_dir)
        total_errors += len(errors)
        total_warnings += len(warnings)
        status = "FAIL" if errors else ("WARN" if warnings else "OK")
        print(f"{status:4} {entry}")
        for issue in errors:
            print(f"     error: {issue}")
        for issue in warnings:
            print(f"     warning: {issue}")

    print(f"\n{total_errors} error(s), {total_warnings} warning(s)")
    return 1 if total_errors else 0


if __name__ == "__main__":
    sys.exit(main())
