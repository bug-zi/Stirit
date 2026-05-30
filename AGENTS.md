# AGENTS.md

## Project

This is a Godot 4.6 project. The project root is the folder that contains
`project.godot`.

AI是游戏的一部分。

## Godot editor

- Open this project with the project folder, not by double-clicking
  `project.godot`.
- Use:
  `<godot-exe> --editor --path <project-root>`
- The main scene must be configured in `project.godot` as:
  `run/main_scene="res://main.tscn"`

## File format rules

- Keep Godot text files as UTF-8 without BOM.
- This especially applies to `.tscn`, `.gd`, `.tres`, `.godot`, and `.import`
  files.
- Do not write Godot scene files with PowerShell `Out-File -Encoding utf8`,
  because on this system it may add a UTF-8 BOM.
- Prefer `apply_patch` for edits so text files remain plain UTF-8 without BOM.
- Do not hand-edit `.godot/imported` cache files unless explicitly requested.

## Scene and script rules

- Keep `.tscn` files in Godot text scene format.
- The first line of a `.tscn` file must start directly with `[gd_scene`.
- Do not place hidden characters, comments, or blank lines before `[gd_scene`.
- Use `res://` paths in Godot resources and scripts.
- Use tabs for GDScript indentation.
- Match script base classes to the node they are attached to.

## Validation

After editing `project.godot`, `.tscn`, or `.gd` files, validate the project with:

`<godot-exe> --headless --path <project-root> --quit-after 2`

If Godot reports a scene parsing error, check the first bytes of the scene file.
The file should start with `5B 67 64`, which is `[gd`. It should not start with
`EF BB BF`.

## Scope

- Make the smallest viable change for the requested Godot task.
- Do not refactor scenes, rename nodes, or reorganize folders unless the user
  explicitly asks for it.
- When fixing a Godot error, first reproduce or inspect the exact Godot output,
  then modify only the files needed for that error.
