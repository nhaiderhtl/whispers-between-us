    # GAME_DESIGN — Whispers Between Us

> Developer reference. Keep in sync with game.pl at all times.

---

## Design Principles

- **Partial ignorance:** The player never gets the full picture at once. Information comes fragmented — through items, dialogue, room details.
- **Open ending:** No ending resolves everything. A question always remains. This is intentional — it drives curiosity for a second playthrough.
- **Multiple truths:** Characters do not always lie deliberately — some believe their own version. The player must judge.
- **Reversible trust:** New evidence can completely overturn earlier assessments. Early decisions are not permanent.
- **Rewarded exploration:** Players who visit all rooms and question all characters understand more — but will never understand everything.
- **Progressive reveal:** Characters are anonymous on first encounter. Names, actions, and relationships surface through repeated visits and gathered evidence. No command is ever shown before its conditions are met.
- **No hand-holding:** The game never tells the player what to do next. Clues, narrative atmosphere, and contextual room text guide discovery. The player figures out commands through context, not menus.

---

## Story Core

**Player:** Leon Varga, freelance journalist
**Situation:** Car crash at night on a gravel road, isolated Alpine village of Kalmbach
**Apparent goal:** Get out of the village, return to civilization
**Real goal:** Only becomes clear during play — someone made sure Leon ended up here
**Time pressure:** Midnight — the procession begins

**What the player knows at the start:**
- Crash, no signal, lights in the village
- An old woman at the village entrance watches him
- It is a full moon

**What the player never fully learns:**
- Exactly why he was chosen
- What Mia really is
- Whether Erna's plan would ever have worked

---

## Map

```
[Crash Site]
      |
 (Forest Path)
      |
[Village Entrance]
      |
[Village Square] ──── [Inn] ──── [Inn Cellar]
      |
      ├──── [Graveyard] ──── [Church Interior] ──── [Crypt]
      |
      ├──── [Mayor's House]
      |
      └──── [Barn]

[Forest] (unlockable from Village Square with mirror)
```

---

## Rooms

### Crash Site
- **Description:** Roadside ditch, front axle snapped, rain, fog. Lights visible in the distance.
- **Items:** flashlight, rope
- **Connections:** N → Forest Path
- **Details (3rd look):** Tire tracks on the road — two sets. A vehicle pushed you.

### Forest Path
- **Description:** Narrow trail, trees close in overhead. Sounds in the undergrowth.
- **Items:** —
- **Connections:** S → Crash Site, N → Village Entrance
- **Details (3rd look):** Fresh footprints in the mud heading toward the village — several people, very recent.

### Village Entrance
- **Description:** Weathered sign: *"Kalmbach — Est. 1648."* An old woman stands motionless at the road's edge.
- **Character:** Erna (named on 2nd+ visit)
- **Items:** —
- **Connections:** S → Forest Path, N → Village Square
- **Room action:** When conditions for `confront_erna.` are met, a narrative line appears: *"You have it all. The letter. The truth behind it. The bell bought you time. And Hilde is ready."*

### Village Square
- **Description:** Small square, well at center. Shutters closed everywhere. No one visible.
- **Items:** Note at the well
- **Connections:** W → Inn (locked if `trust(hilde, feared)`), N → Graveyard, E → Mayor's House (locked), S → Village Entrance, SW → Barn, NW → Forest (locked without mirror)
- **Room action:** If `trust(hilde, feared)`: *"The inn is dark. The door does not open when you try the handle."*

### Inn
- **Description:** Warm, woodsmoke. A woman wipes the counter. Too friendly for this hour.
- **Character:** Hilde (named on 2nd+ visit)
- **Items:** mirror (wall), cellar_key (behind counter — given at `trusted`)
- **Connections:** E → Village Square, D → Inn Cellar (requires `trust(hilde, trusted/devoted)` or cellar_key)
- **Special:** Inn door locked from outside if `trust(hilde, feared)`. Repair with `knock.` at village_square.

### Inn Cellar
- **Description:** Stone steps, wine barrels, a mattress. Someone lived here recently.
- **Items:** Hilde's diary (hidden behind barrel)
- **Connections:** U → Inn
- **Details (3rd look):** Initials on the blanket — not Hilde's.

### Graveyard
- **Description:** Overgrown churchyard. A small girl sits on a grave, watching.
- **Character:** Mia (named on 2nd+ visit)
- **Items:** crypt_code inscription (requires flashlight to read)
- **Connections:** S → Village Square, N → Church Interior
- **Details (3rd look):** Newest grave has fresh flowers — placed today. Stone reads: *Mia Haas, 2004–2014.* Ten years ago.

### Church Interior
- **Description:** Cold stone, candles burning without explanation. A man in dark robes kneels at the altar.
- **Character:** Father Benedikt (named on 2nd+ visit)
- **Items:** church record
- **Connections:** S → Graveyard, D → Crypt (requires crypt_code)
- **Room action:** If holding rope and bell not yet rung: *"The rope is in your hands. The bell frame waits above."*

### Crypt
- **Description:** Below the church. Stone slabs. One has been moved recently.
- **Items:** letter (addressed to "L.V.")
- **Connections:** U → Church Interior
- **Details (3rd look):** Scratch marks on the underside of the moved slab — made from the inside.

### Mayor's House
- **Description:** Neat entrance hall. A man stands at the top of the stairs.
- **Character:** Mayor Otto (named on 2nd+ visit)
- **Items:** Otto's diary
- **Connections:** W → Village Square
- **Unlock:** `trust(benedikt, trusted/devoted)` or mayors_key

### Barn
- **Description:** Door ajar. A young man stands inside, arms crossed, pretending he was not waiting.
- **Character:** Jakob (named on 2nd+ visit)
- **Items:** car_key
- **Connections:** NE → Village Square
- **Room actions:**
  - If tire tracks clue + Hilde's diary clue found: *"The tracks. The diary. The pieces fit together now."* → implies `confront_jakob.`
  - If `trust(jakob, trusted/devoted)` or holding car_key: *"His eyes keep drifting to the door."* → implies `follow_jakob.`

### Forest
- **Description:** Dense trees. The mirror led you to a gap in the undergrowth.
- **Items:** —
- **Connections:** SE → Village Square
- **Unlock:** `holding(mirror)`
- **Room action:** Always: *"The trail leads out. You could leave it all behind."* → implies `escape.`

---

## Characters

### Erna
- **Location:** Village Entrance
- **First encounter:** "An old woman at the road's edge" (anonymous)
- **Named:** From 2nd visit onward
- **Appears to be:** Warns the player
- **Truth:** The ringleader. The warning was an invitation phrased as a warning.
- **Trust effects:**
  - `neutral` → cryptic, nothing concrete
  - `trusted` → hints toward the priest
  - `doubted` → silent, unease visible
  - `feared` → gone, no longer reachable
- **Twist:** Handwriting in the crypt letter is Erna's.

### Hilde
- **Location:** Inn
- **First encounter:** "A woman behind the counter" (anonymous)
- **Named:** From 2nd visit onward
- **Appears to be:** Friendly innkeeper
- **Truth:** Knows about Jakob's plan. Stayed silent out of fear.
- **Trust effects:**
  - `neutral` → small talk, no substance
  - `trusted` → gives cellar_key, hints at what is downstairs
  - `devoted` → gives mirror willingly; needed for Ending B
  - `doubted` → cellar stays locked, distant
  - `feared` → inn door locked; `knock.` at village_square resets to `neutral`
- **Mirror rule:** Mirror can only be taken at `devoted`. Any lower trust → Hilde throws Leon out (`feared`), inn locked.
- **Reversibility:** Finding Hilde's diary while `doubted` → auto-jumps to `trusted`

### Jakob
- **Location:** Barn
- **First encounter:** "A young man near the back" (anonymous)
- **Named:** From 2nd visit onward
- **Appears to be:** The only way out
- **Truth:** He ran Leon's car off the road. Works for Erna. Regrets it.
- **Trust effects:**
  - `neutral` → offers help, mentions a car
  - `trusted` → gives car_key, leads to village edge (road blocked)
  - `devoted` → leads Leon into the dark → Ending C
  - `doubted` → defensive, implies guilt
  - `feared` → backs against the wall, won't move
- **Confrontation:** `confront_jakob.` unlocks only if tire tracks clue AND Hilde's diary clue are both in notes → trust → `feared`

### Father Benedikt
- **Location:** Church Interior
- **First encounter:** "A man in dark robes" (anonymous)
- **Named:** From 2nd visit onward
- **Appears to be:** Evasive, sinister
- **Truth:** Wants to end the cycle but believes the procession is the only way. Tragic, not evil.
- **Trust effects:**
  - `neutral` → praying, almost ignores Leon
  - `trusted` → explains procession, gives crypt access code
  - `devoted` → gives mayors_key
  - `doubted` → crypt unreachable without the code

### Mia
- **Location:** Graveyard
- **First encounter:** "A small girl on the grave" (anonymous)
- **Named:** From 2nd visit onward
- **Truth:** Dead for ten years. Never stated directly — only hinted.
- **Trust effects:** No trust system. Always gives accurate information. The only character who never lies.
- **Twist:** Gravestone in graveyard reads: *Mia Haas, 2004–2014.*

### Mayor Otto
- **Location:** Mayor's House
- **First encounter:** "A man at the top of the stairs" (anonymous)
- **Named:** From 2nd visit onward
- **Appears to be:** Authority figure
- **Truth:** Follows Erna's orders. Weak, not evil.
- **Trust effects:**
  - `neutral` → official, dismissive
  - `trusted` → shows diary, breaks down
  - `doubted` → throws Leon out

---

## Trust System

### Levels
```
feared → doubted → neutral → trusted → devoted
  -2        -1        0        +1        +2
```

### Commands
- `trust.` — trusts the character in the current room (neutral → trusted)
- `doubt.` — doubts the character in the current room (neutral → doubted)
- `reassure(X).` — deepens existing trust (trusted → devoted); only works at the right moment
- `confide(X).` — shares evidence with a character to raise trust
- `confront_jakob.` — confronts Jakob with combined evidence (tire tracks + diary)
- `confront_erna.` — confronts Erna with full proof (letter + Otto's diary + bell rung + Hilde devoted)

### Changes
- Rises through: `trust.`, `reassure(X).`, `confide(X).`, finding matching evidence
- Falls through: `doubt.`, taking the mirror without `devoted`, confronting with evidence
- **Reversible:** Evidence items (diaries, letters) can shift trust sharply regardless of prior decisions

### Discovery
Commands for trust decisions are not shown in the help menu. After `talk.`, if a character's trust is `neutral`, the prompt asks: *"Do you trust her/him? (trust. / doubt.)"*

---

## Items

| ID | Name | Location | Use |
|---|---|---|---|
| `flashlight` | Flashlight | Crash Site | Read gravestone inscription, see in dark rooms |
| `rope` | Rope | Crash Site | Ring the church bell |
| `mirror` | Mirror | Inn wall | Make forest path visible; requires `trust(hilde, devoted)` to take |
| `crypt_code` | Crypt Code | Graveyard (flashlight needed) | Open crypt door |
| `hildes_diary` | Hilde's Diary | Inn Cellar | Expose Jakob; auto-upgrades Hilde trust if doubted |
| `letter` | Letter to L.V. | Crypt | Reveals fabricated interview; needed for Ending B |
| `ottos_diary` | Otto's Diary | Mayor's House | Confirms Erna's plan; needed for Ending B |
| `church_record` | Old Church Record | Church Interior | Procession background (incomplete) |
| `car_key` | Car Key | Barn | Start Jakob's car (road blocked anyway) |
| `well_note` | Note at the Well | Village Square | First warning (anonymous, no signature) |
| `cellar_key` | Cellar Key | Given by Hilde | Opens inn cellar door |
| `mayors_key` | Mayor's Key | Given by Benedikt | Opens Mayor's House |

---

## Puzzles

| ID | Description | Requires | Unlocks |
|---|---|---|---|
| `church_bell` | Bell rope frame needs a rope to reach | `holding(rope)` in church interior | `ring_bell.` → deadline +25 min |
| `crypt_lock` | Crypt door sealed with symbol sequence | crypt_code in inventory | Enter crypt |
| `forest_trail` | Forest entrance hidden in darkness | `holding(mirror)` | `escape.` route through forest |
| `inn_cellar` | Cellar door bolted | `trust(hilde, trusted/devoted)` or cellar_key | Access inn cellar |
| `mayors_house` | Front door locked | `trust(benedikt, trusted/devoted)` or mayors_key | Access Mayor's House |
| `mirror_access` | Mirror requires real trust | `trust(hilde, devoted)` | `take(mirror)` — else kicked out |
| `hilde_repair` | Inn locked after taking mirror without trust | `knock.` at village_square | Inn door reopens, trust → neutral |
| `confrontation` | Confront Jakob with combined evidence | tire tracks clue + hildes_diary clue | `confront_jakob.` → trust(jakob) → feared |

---

## Decisions & Consequences

| Action | Requirement | Consequence |
|---|---|---|
| `trust.` | At room with character, trust = neutral | trust(char) → trusted |
| `doubt.` | At room with character, trust = neutral | trust(char) → doubted |
| `reassure(hilde).` | inn, trust(hilde, trusted) | trust(hilde) → devoted |
| `reassure(jakob).` | barn, trust(jakob, trusted) | trust(jakob) → devoted |
| `confide(benedikt).` | church_interior, trusted | trust(benedikt) → devoted |
| `confront_jakob.` | tire tracks + hildes_diary clues | trust(jakob) → feared |
| `take(mirror).` | inn, trust(hilde, devoted) | mirror in inventory |
| `take(mirror).` | inn, trust NOT devoted | kicked to village_square, trust(hilde) → feared, inn locked |
| `knock.` | village_square, trust(hilde, feared) | inn unlocked, trust(hilde) → neutral |
| `ring_bell.` | church_interior, holding(rope) | deadline +25 min, bell_rung asserted |
| `confront_erna.` | village_entrance + letter clue + ottos_diary clue + bell_rung + trust(hilde, devoted) | Ending B |
| `follow_jakob.` | barn, trust(jakob, devoted) | Ending C |
| `escape.` | forest | Ending A |

---

## Progressive Reveal System

### Character Names
- **1st visit:** Character described anonymously in room description ("an old woman", "a woman behind the counter", "a young man", "a man in dark robes", "a small girl", "a man at the top of the stairs")
- **2nd+ visit:** `[Name] is here.` shown at end of room output

### Item Visibility
- **1st look:** Room description only — no items shown
- **2nd+ look:** Items in room listed (`You see: X.`)
- **3rd+ look:** Room detail text shown + automatically saved to notes

### Contextual Action Hints
Special actions (`confront_jakob.`, `confront_erna.`, `ring_bell.`, `follow_jakob.`, `escape.`) are never listed in the help menu. Instead:
- When conditions are **not** met: nothing shown
- When conditions are **met**: a narrative line in the room description implies the action
- Player must infer the command from context

### Start Screen
No command list shown. Only: `(Type help. for a list of commands.)`

---

## Exit Display

Shown at the end of every `look.` output:

```
You can go: n  s (crash_site)  w (inn)  sw
```

- Direction shown always
- Room name shown in parentheses only if that room has been visited before
- Unvisited destinations: direction only, no name

Implemented via `raw_exit/3` facts (separate from conditional `path/3`) to avoid triggering locked-door side effects during display.

---

## Clue System

- `look.` 1st time → room description only
- `look.` 2nd time → description + items visible
- `look.` 3rd time → description + items + hidden detail, detail saved to notes
- `notes.` → lists all collected clues
- Details are deliberately ambiguous — clear enough to notice, not immediately interpretable

### Detail Text per Room (3rd look)

| Room | Detail |
|---|---|
| `crash_site` | Two sets of tire tracks — someone drove very close before the ditch |
| `forest_path` | Fresh footprints toward the village, edges sharp — minutes ago |
| `village_entrance` | Erna used your name — you never introduced yourself |
| `village_square` | Note at well has a date — three months ago, matching the crypt letter |
| `inn` | Mirror angled toward door, not room — perfect view of every entrance from behind the bar |
| `inn_cellar` | Blanket initials — not Hilde's |
| `graveyard` | Newest grave has today's flowers — stone reads: Mia Haas, 2004–2014 |
| `church_interior` | Candles mark every third pew on the left — seven. Same as newer graves outside |
| `crypt` | Scratch marks on moved slab underside — made from the inside |
| `mayors_house` | Group photo from 1987, one face circled in red: Erna |
| `barn` | Oil stain outline of a car — still fresh at edges, moved recently |
| `forest` | Scrap of fabric on a branch — same pattern as the inn cellar blanket |

---

## Time Pressure

Game starts at 22:00. Deadline: midnight (120 minutes). Every movement costs 5 minutes. `ring_bell.` adds 25 minutes to the deadline. Clock displayed as `HH:MM` after every `look.`

After midnight → Ending C triggers (procession begins).

---

## Endings

### Ending A — Out (alone)
**Trigger:** `escape.` while in forest (requires mirror → trust(hilde, devoted) → forest path)
**Tone:** The trail spits you out onto a logging road. Kalmbach disappears in fog. Phone buzzes — one bar. Message: *"We regret the Innsbruck feature has been cancelled."* You never applied.
**Open:** Who sent for you? What happens in Kalmbach without a witness?

### Ending B — The Bell
**Trigger:** `confront_erna.` at village_entrance, requires:
- clue: letter (interview was fabricated)
- clue: Otto's diary (Erna wrote it three months ago)
- `bell_rung` (procession delayed)
- `trust(hilde, devoted)` (Hilde willing to leave)

**Tone:** You hold the letter up to Erna. For the first time she looks her age. The plan needed Leon to stay of his own will — he is leaving, and not alone. Hilde takes your arm. Shutters open one by one. Benedikt stays behind. At the village edge, Mia waves once. Then she is not there.
**Open:** Was Mia ever real?

### Ending C — The Procession
**Trigger:** Midnight reached without escaping, OR `follow_jakob.` while `trust(jakob, devoted)`
**Tone:** Midnight. Shutters open all at once. They come with candles — every face you have met, and many you have not. You understand all of it now. Too late.
**Open:** Who comes to Kalmbach next full moon?

---

## Open Questions (intentionally never resolved)

- Who wrote the letter in the crypt? (Handwriting = Erna's, but why three months in advance?)
- What is Mia, really?
- What happens on the next full moon?
- Are there other villages like Kalmbach?

---

## Technical Status

| Feature | Status |
|---|---|
| Movement n/s/e/w/ne/sw/nw/se/u/d | ✅ implemented |
| All 12 rooms with describe + details | ✅ implemented |
| Progressive item reveal (2nd look) | ✅ implemented |
| Progressive detail reveal (3rd look) | ✅ implemented (`looked_at/2` counts per room) |
| Clue system (`notes.`) | ✅ implemented (`clue/1` dynamic, no duplicates) |
| Character anonymous 1st visit, named 2nd+ | ✅ implemented (`show_character_name/2`) |
| Contextual action hints (no explicit commands) | ✅ implemented (`show_room_actions/0` per room) |
| Exit display with visited room names | ✅ implemented (`raw_exit/3` + `show_exits/0`) |
| Time display HH:MM | ✅ implemented |
| Start: hint only, no command list | ✅ implemented |
| Help menu (core commands only) | ✅ special actions removed |
| take / drop / inventory | ✅ implemented |
| read_item(X) for all documents | ✅ implemented |
| Unified trust/doubt commands | ✅ `trust.` / `doubt.` check current room character |
| Trust system (5 levels, all characters) | ✅ feared/doubted/neutral/trusted/devoted |
| reassure(X) / confide(X) → devoted | ✅ implemented |
| Mirror: devoted only, kick-out mechanic | ✅ implemented |
| Inn locked when trust(hilde, feared) | ✅ implemented |
| knock. repair mechanic | ✅ implemented |
| confront_jakob (evidence-gated) | ✅ implemented |
| confront_erna (full conditions) | ✅ implemented |
| follow_jakob (trust-dependent outcomes) | ✅ implemented |
| ring_bell puzzle (rope + deadline +25) | ✅ implemented |
| Conditional paths (cellar/crypt/mayor/forest) | ✅ implemented |
| All 6 characters with trust-based dialogue | ✅ Erna, Hilde, Jakob, Benedikt, Mia, Otto |
| All 12 items placed and readable | ✅ implemented |
| 3 endings (A/B/C) | ✅ implemented |
| Replay (`start.` resets everything) | ✅ implemented |
