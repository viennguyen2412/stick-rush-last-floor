# QA Checklist

## Smoke test

1. Project opens in Godot.
2. Main scene runs.
3. Debug arena runs.
4. No blocking errors on launch.
5. Player appears at spawn point.

## Input test

1. A moves left.
2. D moves right.
3. Space performs intended action.
4. J attacks.
5. K uses skill if available.
6. L dodges or parries.
7. I uses ultimate when charged.
8. Esc pauses.
9. Mouse is not needed.

## Combat test

1. Hitbox only damages during active frames.
2. Enemy loses HP when hit.
3. Player loses HP when enemy attack connects.
4. Hitstop does not freeze forever.
5. Knockback direction is correct.
6. Enemy cannot be hit multiple times by one hitbox activation unless intended.
7. Dead enemy cannot damage player.
8. Parry succeeds only inside parry window.
9. Failed parry has recovery.
10. Ultimate does not crash when no enemy exists.

## Enemy test

1. Grunt chases.
2. Ranged keeps distance.
3. Shield blocks frontal light attack.
4. Enemy can be staggered.
5. Enemy death removes it from wave count.
6. Enemy does not push player through walls.

## Room and run test

1. Wave 1 starts.
2. Next wave starts after clear.
3. Room clear triggers reward.
4. Reward selection works by keyboard.
5. Next room starts after reward.
6. Death screen appears at 0 HP.
7. Win screen appears after boss.
8. Restart reloads cleanly.

## Balance test MVP

1. First room should be easy.
2. Player should not die before learning attack.
3. Ranged enemy should be annoying but fair.
4. Shield enemy should teach heavy or positioning.
5. Mini boss should be beatable on first or second try.
6. A full MVP run should take 5 to 7 minutes.

## Feel test

Score from 1 to 5:

1. Movement responsiveness.
2. Attack impact.
3. Hitstop feel.
4. Knockback satisfaction.
5. Parry satisfaction.
6. Enemy readability.
7. Restart desire.

Target before expanding scope: average score at least 4.
