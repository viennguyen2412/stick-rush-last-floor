# Stick Rush: Last Floor - Codex Starter Pack

## Mục tiêu

Tạo một game PC 2D người que, hành động nhanh, chơi hoàn toàn bằng bàn phím, làm bằng Godot 4 và GDScript. Codex sẽ đóng vai trò lập trình viên chính. Người dùng đóng vai trò producer, game designer, QA và người duyệt code.

## Nguyên tắc sản xuất

1. Làm nhỏ trước, đã tay trước.
2. Mọi task giao cho Codex phải có input, output, phạm vi và tiêu chí nghiệm thu.
3. Không giao task kiểu "làm game hoàn chỉnh".
4. Mỗi task chỉ nên chạm 1 đến 3 hệ thống.
5. Sau mỗi task phải chạy game, test bằng tay, ghi bug.
6. Không thêm feature mới nếu core combat chưa sướng.
7. Không làm online, không làm multiplayer, không làm level editor trong MVP.
8. Không dùng ragdoll physics thật trong MVP.
9. Mọi script gameplay dùng typed GDScript.
10. Mọi thay đổi lớn phải có commit riêng.

## Thứ tự đọc tài liệu

1. `01_PRODUCT_BRIEF.md`
2. `02_GDD_LITE.md`
3. `03_TECHNICAL_DESIGN_GODOT.md`
4. `04_CODEX_WORKFLOW.md`
5. `05_BACKLOG_MVP.md`
6. `06_PROMPT_PACK_CODEX.md`
7. `07_QA_CHECKLIST.md`

## Cấu trúc repo đề xuất

```text
stick-rush-last-floor/
  project.godot
  README.md
  CODEX.md
  docs/
    00_README_START_HERE.md
    01_PRODUCT_BRIEF.md
    02_GDD_LITE.md
    03_TECHNICAL_DESIGN_GODOT.md
    04_CODEX_WORKFLOW.md
    05_BACKLOG_MVP.md
    06_PROMPT_PACK_CODEX.md
    07_QA_CHECKLIST.md
  scenes/
    main/
    player/
    enemies/
    combat/
    levels/
    ui/
    fx/
  scripts/
    core/
    player/
    enemies/
    combat/
    data/
    ui/
  resources/
    skills/
    cards/
    enemies/
    waves/
  assets/
    art/
    sfx/
    music/
    fonts/
  tests/
  builds/
```

## Definition of Done cho MVP

MVP được xem là đạt khi:

1. Có thể chơi 1 run gồm 5 phòng liên tiếp.
2. Player di chuyển, đánh, né, parry và dùng ultimate bằng bàn phím.
3. Có ít nhất 3 loại enemy.
4. Có ít nhất 1 mini boss.
5. Có hệ thống chọn upgrade sau mỗi phòng.
6. Có win, lose, restart.
7. Combat có hitstop, knockback, screen shake và sound placeholder.
8. Game chạy mượt trên máy phổ thông.
9. Build Windows debug được xuất ra từ Godot.
10. Có thể quay video gameplay 30 giây nhìn hiểu ngay game bán gì.
