# CODEX.md

## Project

Stick Rush: Last Floor is a lightweight Godot 4 2D keyboard-only action roguelite beat 'em up.

## Absolute constraints

1. Gameplay must be keyboard-only.
2. Do not require mouse input.
3. Keep the project lightweight.
4. Use Godot 4 and GDScript.
5. Use typed GDScript for gameplay scripts.
6. Do not implement online multiplayer.
7. Do not implement local co-op in MVP.
8. Do not implement real ragdoll physics in MVP.
9. Do not add large external dependencies.
10. Do not expand scope without explicit approval.

## Coding standards

1. Prefer small, focused scripts.
2. Prefer Resource data for skills, cards, enemies and waves.
3. Prefer signals for gameplay events.
4. Avoid hardcoded node paths across distant scene hierarchies.
5. Keep player, enemy, combat and UI systems decoupled.
6. Use explicit types for variables, parameters and return values.
7. Every gameplay feature must have a simple manual test path.
8. Add comments only when the code is not obvious.
9. Do not create final art assets unless asked.
10. Use placeholders for visuals and audio during MVP.

## Architecture references

Read these before changing code:

1. docs/01_PRODUCT_BRIEF.md
2. docs/02_GDD_LITE.md
3. docs/03_TECHNICAL_DESIGN_GODOT.md
4. docs/05_BACKLOG_MVP.md

## Working style

For every task:

1. State what files will be changed.
2. Make the smallest useful change.
3. Explain how to test it.
4. Do not modify unrelated files.
5. Mention any assumptions.
6. Mention any Godot editor setup required.

## Definition of Done

A task is done when:

1. Code compiles.
2. The scene can run.
3. The requested behavior works.
4. No unrelated feature was added.
5. Manual test instructions are provided.
