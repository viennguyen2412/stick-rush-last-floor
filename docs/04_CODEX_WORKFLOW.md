# Codex Workflow

## Vai trò

Codex là lập trình viên. Người dùng là producer, reviewer và QA.

Codex không được tự ý mở rộng scope. Mọi feature cần bám backlog và tiêu chí nghiệm thu.

## Cách giao việc đúng

Mỗi prompt cho Codex nên có 6 phần:

1. Context
2. Task
3. Files được phép sửa
4. Files không được sửa
5. Acceptance criteria
6. Test instructions

## Prompt mẫu

```text
Context:
This is a Godot 4 2D action roguelite project named Stick Rush: Last Floor. The game is keyboard-only. Follow CODEX.md and docs/03_TECHNICAL_DESIGN_GODOT.md.

Task:
Implement the Player movement controller with left/right movement, jump, dash, and facing direction.

Allowed files:
- scripts/player/player_controller.gd
- scenes/player/Player.tscn
- project.godot only for input actions if needed

Do not modify:
- docs/
- enemy files
- combat files unless absolutely necessary

Acceptance criteria:
- A/D moves the player left and right.
- Space performs jump when grounded.
- Space performs dash when already grounded and a direction is held, if that is how the current scene is configured.
- Player flips visual direction correctly.
- Movement variables are exported and typed.
- No mouse input is used.
- No hardcoded scene path outside Player.tscn.

Test:
Explain how to run the scene in Godot and what keys to press.
```

## Quy trình mỗi task

1. Tạo branch hoặc commit checkpoint.
2. Mở Codex ở root repo.
3. Dán task rõ.
4. Đọc diff trước khi accept.
5. Chạy game.
6. Ghi bug.
7. Giao task sửa bug nhỏ.
8. Commit.

## Không giao task kiểu này

```text
Make the whole game.
Add combat.
Make it fun.
Optimize everything.
Create all enemies.
```

## Giao task tốt hơn

```text
Implement a reusable Hitbox and Hurtbox system for Godot 4.
Only modify scripts/combat and scenes/combat.
A hitbox must send a typed DamagePacket to a hurtbox once per activation.
Include a debug scene to test one hitbox hitting one hurtbox.
```

## Chiến lược chia nhỏ MVP

### Sprint 1

1. Project setup.
2. Input actions.
3. Player movement.
4. Camera follow.
5. Debug arena.

### Sprint 2

1. Hitbox and Hurtbox.
2. Basic attack combo.
3. Enemy health and damage.
4. Hitstop.
5. Knockback.

### Sprint 3

1. Enemy AI.
2. Spawner.
3. Wave manager.
4. Room clear condition.
5. Restart flow.

### Sprint 4

1. Upgrade card data.
2. Reward UI.
3. Apply card effects.
4. HUD.
5. Mini boss.

### Sprint 5

1. Polish VFX.
2. SFX placeholders.
3. Balance pass.
4. Export Windows build.
5. Record trailer test.

## Review checklist sau mỗi diff

1. Có code nào quá dài hoặc làm nhiều việc không?
2. Có hardcode node path nguy hiểm không?
3. Có dùng mouse input không?
4. Có phá data/resource architecture không?
5. Có typed GDScript không?
6. Có tạo coupling giữa player và enemy không?
7. Có test instructions không?
8. Có thay file ngoài phạm vi không?
9. Có lỗi Godot API rõ ràng không?
10. Có làm thêm thứ không được yêu cầu không?
