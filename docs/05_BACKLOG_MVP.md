# MVP Backlog

## Milestone 0: Project setup

### Task 0.1: Create Godot project structure

Acceptance:

1. Folder structure exists.
2. Empty main scene exists.
3. Input actions are configured.
4. README and docs are added.
5. Project runs without error.

### Task 0.2: Create debug arena

Acceptance:

1. Arena has floor and walls.
2. Player spawn point exists.
3. Camera shows arena.
4. Scene can be run directly.

## Milestone 1: Player feel

### Task 1.1: Player movement

Acceptance:

1. A/D moves.
2. Space jumps or dashes depending design choice.
3. Facing direction works.
4. Exported variables control speed.

### Task 1.2: Player attack combo

Acceptance:

1. J performs 3-hit combo.
2. Combo resets after timeout.
3. Each hit has startup, active, recovery.
4. Debug hitbox appears only during active frames.

### Task 1.3: Dodge and parry

Acceptance:

1. L triggers dodge or parry.
2. Parry has a narrow success window.
3. Successful parry emits event.
4. Failed parry has recovery.

## Milestone 2: Combat system

### Task 2.1: DamagePacket resource

Acceptance:

1. Resource exists.
2. Contains damage, knockback, hitstop, stun, team.
3. Used by hitbox.

### Task 2.2: Hitbox and Hurtbox

Acceptance:

1. Hitbox detects Hurtbox.
2. Team check prevents friendly fire.
3. Target is hit once per activation.
4. Signal is emitted on hit.

### Task 2.3: Health and death

Acceptance:

1. Player and enemy can take damage.
2. Death state works.
3. Dead enemy no longer attacks.
4. HUD updates player HP.

### Task 2.4: Hit feedback

Acceptance:

1. Hitstop works.
2. Knockback works.
3. Screen shake placeholder works.
4. Impact FX placeholder spawns.

## Milestone 3: Enemies

### Task 3.1: Grunt enemy

Acceptance:

1. Chases player.
2. Attacks in range.
3. Has windup and recovery.
4. Can be killed.

### Task 3.2: Ranged enemy

Acceptance:

1. Keeps distance.
2. Throws projectile.
3. Projectile can hit player.
4. Projectile can be destroyed or expires.

### Task 3.3: Shield enemy

Acceptance:

1. Blocks frontal light attacks.
2. Heavy attack or back hit damages it.
3. Staggers when guard breaks.

## Milestone 4: Run structure

### Task 4.1: Wave manager

Acceptance:

1. Spawns wave list.
2. Starts next wave after previous cleared.
3. Emits room cleared signal.

### Task 4.2: Room sequence

Acceptance:

1. 5 rooms play in order.
2. Player moves to next room after reward.
3. Win after mini boss.

### Task 4.3: Restart flow

Acceptance:

1. Death shows lose UI.
2. Win shows win UI.
3. Restart key reloads run.

## Milestone 5: Upgrade cards

### Task 5.1: Card data resource

Acceptance:

1. CardData exists.
2. Cards have id, name, rarity, description, effect type, numeric value.
3. Cards are stored as resources.

### Task 5.2: Reward UI

Acceptance:

1. Shows 3 cards.
2. Keyboard selects card.
3. Chosen card applies effect.
4. UI closes and next room starts.

### Task 5.3: Apply card effects

Acceptance:

1. Damage card works.
2. Dash card works.
3. Parry rage card works.
4. Shockwave card works as placeholder if needed.

## Milestone 6: Mini boss and polish

### Task 6.1: Manager mini boss

Acceptance:

1. Has 3 attacks.
2. Has larger HP.
3. Has clear telegraphs.
4. Defeating boss ends run.

### Task 6.2: Audio and FX placeholders

Acceptance:

1. Attack SFX.
2. Hit SFX.
3. Parry SFX.
4. Ultimate SFX.
5. Basic music loop placeholder.

### Task 6.3: Windows debug build

Acceptance:

1. Export preset exists.
2. Build runs outside editor.
3. Controls work.
4. No blocking errors in console.
