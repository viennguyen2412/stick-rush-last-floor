# Game Design Document Lite

## Thể loại

2D side-view roguelite beat 'em up.

## Camera

Camera ngang, arena từng phòng. Không cuộn map dài trong MVP.

## Core loop

1. Vào phòng.
2. Địch xuất hiện theo wave.
3. Người chơi đánh, né, parry.
4. Dọn phòng.
5. Chọn 1 trong 3 upgrade.
6. Sang phòng tiếp theo.
7. Gặp mini boss.
8. Win hoặc die.
9. Restart.

## Điều khiển

| Phím | Hành động |
|---|---|
| A | Di chuyển trái |
| D | Di chuyển phải |
| Space | Jump hoặc dash ngắn |
| J | Attack |
| K | Skill |
| L | Dodge hoặc Parry |
| I | Ultimate |

## Combat verbs

### Attack

Combo 3 hit. Hit 1 nhanh, hit 2 đẩy nhẹ, hit 3 knockback mạnh.

### Heavy attack

Giữ J để tung đòn nặng. Startup chậm hơn nhưng phá guard.

### Dash attack

Nhấn hướng cộng J để lao đánh.

### Air attack

Nhảy rồi J để đá xuống hoặc đá ngang.

### Parry

Nhấn L đúng timing trước khi bị đánh. Nếu thành công, tạo slow motion ngắn, hồi rage và mở counter.

### Ultimate

Dùng khi rage đầy. Gây sát thương diện rộng, tạm thời miễn stagger.

## Player stats MVP

| Stat | Giá trị đề xuất |
|---|---:|
| Max HP | 100 |
| Move speed | 260 |
| Jump velocity | 420 |
| Dash distance | 150 |
| Attack damage hit 1 | 8 |
| Attack damage hit 2 | 10 |
| Attack damage hit 3 | 16 |
| Parry window | 0.16 giây |
| Hitstop light | 0.05 giây |
| Hitstop heavy | 0.09 giây |

## Enemy MVP

### Grunt

Địch cơ bản. Chạy tới và đấm.

### Shield

Đi chậm, có guard. Cần heavy attack hoặc đánh sau lưng.

### Ranged

Đứng xa ném đồ văn phòng. Ép người chơi di chuyển.

### Manager mini boss

Có 3 move: gọi lính, charge attack, slam mặt đất.

## Upgrade MVP

### Common

1. Tăng 15 phần trăm damage hit 3.
2. Hồi 5 HP khi dọn phòng.
3. Dash xa hơn 20 phần trăm.
4. Parry hồi thêm rage.
5. Combo trên 20 hit tăng damage.

### Rare

1. Hit 3 tạo shockwave.
2. Parry bắn counter projectile.
3. Dash để lại afterimage gây damage.
4. Heavy attack phá shield và stun.
5. Skill cooldown giảm 25 phần trăm.

### Epic

1. Ultimate dùng xong hồi 30 phần trăm rage nếu giết được 3 địch.
2. Mỗi phòng có 1 lần bất tử khi còn 1 HP.
3. Tất cả knockback gây thêm damage khi địch va tường.

## Room MVP

5 phòng:

1. Tutorial combat nhẹ.
2. Thêm ranged.
3. Thêm shield.
4. Mixed wave.
5. Manager mini boss.

## Win condition

Đánh bại Manager.

## Lose condition

HP về 0.

## Không làm trong MVP

1. Save/load phức tạp.
2. Meta progression.
3. Nhiều nhân vật.
4. Nhiều biome.
5. Online.
6. Co-op.
7. Procedural level thật.
8. Skill tree dài.
