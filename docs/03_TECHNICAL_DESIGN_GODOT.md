# Technical Design Godot

## Engine

Godot 4, GDScript, 2D, Compatibility renderer nếu cần nhẹ máy.

## Code style

1. Dùng typed GDScript cho gameplay.
2. Mỗi script có trách nhiệm rõ.
3. Không viết script quá 250 dòng nếu có thể tách.
4. Không hardcode data skill, card, enemy trong logic chính.
5. Dùng Resource cho data.
6. Dùng signal cho event gameplay.
7. Không gọi node path sâu lung tung, cache reference trong `_ready`.
8. Không spawn object liên tục nếu có thể dùng pool cho FX.

## Scene architecture

```text
Main.tscn
  GameRoot
  LevelManager
  RunManager
  UI
  AudioManager

ArenaRoom.tscn
  SpawnPoints
  Bounds
  Camera2D
  RoomTrigger

Player.tscn
  CharacterBody2D
  VisualRoot
  Hurtbox
  AttackOrigin
  StateMachine
  AnimationPlayer

EnemyBase.tscn
  CharacterBody2D
  VisualRoot
  Hurtbox
  AttackOrigin
  StateMachine

Hitbox.tscn
  Area2D
  CollisionShape2D

CardRewardUI.tscn
  Control
```

## Folder architecture

```text
scripts/
  core/
    game_events.gd
    run_manager.gd
    level_manager.gd
    object_pool.gd
  player/
    player_controller.gd
    player_combat.gd
    player_state_machine.gd
    player_stats.gd
  enemies/
    enemy_base.gd
    enemy_ai.gd
    enemy_stats.gd
    enemy_spawner.gd
  combat/
    hitbox.gd
    hurtbox.gd
    damage_packet.gd
    combat_resolver.gd
    hitstop_manager.gd
  data/
    skill_data.gd
    card_data.gd
    enemy_data.gd
    wave_data.gd
  ui/
    hud.gd
    card_reward_ui.gd
    pause_menu.gd
```

## Core classes

### DamagePacket

Dữ liệu truyền khi một hitbox đánh trúng hurtbox.

Fields:

```gdscript
class_name DamagePacket
extends Resource

@export var damage: float = 0.0
@export var knockback: Vector2 = Vector2.ZERO
@export var hitstop: float = 0.0
@export var stun_time: float = 0.0
@export var source_team: int = 0
@export var can_be_parried: bool = true
```

### Hitbox

Nhiệm vụ:

1. Bật trong active frames.
2. Gửi DamagePacket khi chạm Hurtbox.
3. Không tự quyết định máu.
4. Có danh sách target đã trúng để tránh hit nhiều lần ngoài ý muốn.

### Hurtbox

Nhiệm vụ:

1. Nhận DamagePacket.
2. Gửi signal `hit_received`.
3. Không tự xử lý AI.

### CombatResolver

Nhiệm vụ:

1. Kiểm tra team.
2. Kiểm tra parry.
3. Tính damage.
4. Gọi knockback, hitstop, screen shake.
5. Emit event cho UI và audio.

## Input actions

```text
move_left: A
move_right: D
jump_dash: Space
attack: J
skill: K
dodge_parry: L
ultimate: I
pause: Esc
```

## Player state machine

States:

1. Idle
2. Run
3. Jump
4. Fall
5. Attack
6. Dash
7. Parry
8. Hurt
9. Dead
10. Ultimate

Quy tắc:

1. Attack có startup, active, recovery.
2. Dash có invulnerability ngắn.
3. Parry chỉ thành công trong parry window.
4. Hurt bị khóa input ngắn.
5. Ultimate override phần lớn state, trừ Dead.

## Enemy AI MVP

States:

1. Spawn
2. Chase
3. Windup
4. Attack
5. Recover
6. Stagger
7. Dead

AI đơn giản:

1. Nếu xa player, chase.
2. Nếu trong range, windup.
3. Sau windup, attack.
4. Sau attack, recover.
5. Nếu bị hit nặng, stagger.
6. Nếu HP <= 0, dead.

## Performance budget

1. Enemy active cùng lúc: tối đa 12 trong MVP.
2. Hitbox active cùng lúc: tối đa 30.
3. Damage number: có thể tắt bằng setting.
4. Particles: ưu tiên GPUParticles2D hoặc sprite FX nhẹ.
5. Không dùng rigid body cho mọi enemy.
6. Không dùng navigation phức tạp trong MVP.

## Build pipeline MVP

1. Chạy trong editor mỗi khi xong feature.
2. Test input bằng tay.
3. Xuất Windows debug build.
4. Lưu build trong `/builds`.
5. Ghi version vào tên file.

Ví dụ:

```text
builds/stick_rush_mvp_0_1_0_win_debug/
```
