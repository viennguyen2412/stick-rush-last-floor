# Codex Prompt Pack

## Prompt 1: Initialize project docs awareness

```text
Read CODEX.md and all files in docs/. Summarize the project constraints, architecture, and MVP scope. Do not edit files yet.
```

## Prompt 2: Create project structure

```text
Create the Godot project folder structure described in docs/00_README_START_HERE.md and docs/03_TECHNICAL_DESIGN_GODOT.md.

Allowed changes:
- Create folders.
- Create placeholder .gd files with class_name and typed stubs.
- Create CODEX.md if missing.
- Do not implement gameplay yet.

Acceptance:
- Folders match the documented structure.
- Placeholder scripts compile as empty typed classes.
- No feature logic is implemented.
```

## Prompt 3: Configure input

```text
Implement keyboard-only input actions in project.godot:
move_left A
move_right D
jump_dash Space
attack J
skill K
dodge_parry L
ultimate I
pause Esc

Acceptance:
- No mouse input action is required for gameplay.
- Input action names match docs exactly.
- Include a short explanation of how to verify in Godot.
```

## Prompt 4: Player movement

```text
Implement player movement for Godot 4 using CharacterBody2D.

Allowed files:
- scripts/player/player_controller.gd
- scenes/player/Player.tscn
- scenes/levels/DebugArena.tscn if needed

Acceptance:
- A/D moves.
- Space jumps when grounded.
- Direction flips visual root.
- Exported typed variables exist for speed, acceleration, jump velocity and gravity.
- No combat logic yet.
```

## Prompt 5: Hitbox and Hurtbox

```text
Implement reusable Hitbox, Hurtbox, and DamagePacket.

Allowed files:
- scripts/combat/
- scenes/combat/

Acceptance:
- DamagePacket is typed.
- Hitbox detects Hurtbox using Area2D.
- Hitbox tracks targets already hit during one activation.
- Hurtbox emits hit_received with DamagePacket and source.
- Include a simple debug scene or instructions to test collision.
```

## Prompt 6: Three-hit combo

```text
Implement the player's 3-hit attack combo.

Allowed files:
- scripts/player/player_combat.gd
- scripts/player/player_controller.gd only if input routing is needed
- scenes/player/Player.tscn
- scenes/combat/Hitbox.tscn if needed

Acceptance:
- J performs hit 1, hit 2, hit 3.
- Combo advances only within combo buffer time.
- Each hit has startup, active and recovery timing.
- Hit 3 has stronger knockback.
- Code uses exported typed values for tuning.
```

## Prompt 7: Grunt enemy

```text
Implement Grunt enemy AI.

Allowed files:
- scripts/enemies/
- scenes/enemies/
- resources/enemies/

Acceptance:
- Grunt chases player.
- Grunt attacks when in range.
- Attack has windup and recovery.
- Grunt can receive damage and die.
- AI is simple and readable.
```

## Prompt 8: Hit feedback pass

```text
Add hit feedback to the combat system.

Acceptance:
- Light hits trigger small hitstop.
- Heavy hits trigger larger hitstop.
- Knockback applies to enemies.
- Camera shake event is emitted.
- Placeholder impact FX is spawned.
- Do not add final art assets.
```

## Prompt 9: Wave manager

```text
Implement a simple wave manager for a debug arena.

Acceptance:
- Wave data defines enemy scene, count and spawn points.
- Manager spawns next wave after all enemies die.
- Emits room_cleared when all waves are done.
- Debug arena can run 3 waves.
```

## Prompt 10: Card reward system

```text
Implement the MVP reward card system.

Acceptance:
- CardData Resource exists.
- Reward UI shows 3 cards.
- Keyboard selection works.
- Choosing a card applies a gameplay modifier.
- At least 5 placeholder cards exist.
```

## Prompt 11: Mini boss

```text
Implement Manager mini boss.

Acceptance:
- Boss has HP bar.
- Boss has 3 attacks: call adds, charge, ground slam.
- Each attack has readable telegraph.
- Defeating boss triggers win state.
```

## Prompt 12: Export build

```text
Create or update Windows Desktop export preset.

Acceptance:
- Debug export can be created.
- Build path uses builds/stick_rush_mvp_0_1_0_win_debug/.
- Document exact export command or editor steps.
```
