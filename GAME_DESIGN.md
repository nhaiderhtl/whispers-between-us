# GAME_DESIGN — Whispers Between Us

> Developer reference. Keep in sync with game.pl at all times.

---

## Design Principles

- **Partial ignorance:** The player never gets the full picture at once. Information comes fragmented — through items, dialogue, room details.
- **Open ending:** No ending resolves everything. A question always remains. This is intentional — it drives curiosity for a second playthrough.
- **Multiple truths:** Characters do not always lie deliberately — some believe their own version. The player must judge.
- **Reversible trust:** New evidence can completely overturn earlier assessments. Early decisions are not permanent.
- **Rewarded exploration:** Players who visit all rooms and question all characters understand more — but will never understand everything.

---

## Story Core

**Player:** Leon Varga, freelance journalist
**Situation:** Car crash at night on a gravel road, isolated Alpine village of Kalmbach
**Apparent goal:** Get out of the village, return to civilization
**Real goal:** Only becomes clear during play — someone made sure Leon ended up here
**Time pressure:** Midnight — the procession begins

**What the player knows at the start:**
- Crash, no signal, lights in the village
- An old woman at the village entrance stares at him
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
      ├──── [Church / Graveyard] ──── [Church Interior] ──── [Crypt]
      |
      ├──── [Mayor's House]
      |
      └──── [Barn]

[Forest] (unlockable from Village Square, only at night with mirror)
```

---

## Rooms

### Crash Site
- **Description:** Roadside ditch, front axle snapped, rain, fog. Lights visible in the distance.
- **Items:** flashlight (in glove compartment), rope (in trunk — accessible after puzzle)
- **Connections:** N → Forest Path
- **Details:** Tire tracks on the road — two sets. A vehicle pushed you. Player may not notice immediately.

### Forest Path
- **Description:** Narrow trail, trees close in overhead. Sounds in the undergrowth.
- **Items:** —
- **Connections:** S → Crash Site, N → Village Entrance
- **Details:** Fresh footprints in the mud heading toward the village — several people, very recent.

### Village Entrance
- **Description:** Weathered sign: *"Kalmbach — Est. 1648."* Erna stands motionless beside it.
- **Character:** Erna
- **Items:** —
- **Connections:** S → Forest Path, N → Village Square

### Village Square
- **Description:** Small square, well in the center. Shutters closed everywhere. No one visible except distant shadows.
- **Items:** Note at the well (anonymous: *"Trust no one who helps you too quickly."*)
- **Connections:** W → Inn, N → Church/Graveyard, E → Mayor's House, S → Village Entrance, SW → Barn

### Inn
- **Description:** Warm, smells of woodsmoke. Hilde wipes the counter. Too friendly for this hour.
- **Character:** Hilde
- **Items:** mirror (on wall, costs time and Hilde's trust), key to inn cellar (behind counter)
- **Connections:** E → Village Square, stairs → Inn Cellar

### Inn Cellar
- **Description:** Mold, old wine barrels. And a fresh mattress. Someone slept here recently — or was hidden.
- **Items:** Hilde's diary (hidden behind barrel — only findable at `trust(hilde, trusted)`)
- **Connections:** stairs → Inn
- **Details:** Diary reveals: Hilde knew about Jakob. She stayed silent out of fear, not loyalty.

### Church / Graveyard
- **Description:** Old church, graveyard in front. Mia sits on a gravestone.
- **Character:** Mia
- **Items:** Gravestone inscription (readable with flashlight — gives crypt code)
- **Connections:** S → Village Square, door → Church Interior

### Church Interior
- **Description:** Candles burning though no one lit them. Father Benedikt kneels before the altar.
- **Character:** Father Benedikt
- **Items:** Old church record (gives background on the procession, incomplete)
- **Connections:** door → Church/Graveyard, steps → Crypt (only with crypt code)

### Crypt
- **Description:** Below the church. Cold. Stone slabs with names. One slab has been moved recently.
- **Items:** Letter (addressed to "L.V." — Leon's initials. Written three months ago.)
- **Connections:** steps → Church Interior
- **Details:** Letter reveals: the interview was fake. Someone wanted Leon here. Sender unknown — but the handwriting appears again later.

### Mayor's House
- **Description:** Solid, locked. Light in the upper floor.
- **Character:** Mayor Otto (only reachable if `trust(benedikt, trusted)` or with key)
- **Items:** Mayor's diary (requires crypt key to enter)
- **Connections:** W → Village Square

### Barn
- **Description:** Door ajar. Jakob stands inside, waiting. Looks nervous.
- **Character:** Jakob
- **Items:** car key (Jakob's car — working vehicle, but road is blocked)
- **Connections:** NE → Village Square

### Forest
- **Description:** Dense. No moonlight except at one spot — something reflects there.
- **Items:** —
- **Connections:** Village Square (entrance only visible at night with mirror), forest trail → escape route
- **Unlock:** `holding(mirror)` + path locked after midnight

---

## Characters

### Erna
- **Location:** Village Entrance
- **Appears to be:** Old woman, warns the player
- **Truth:** The ringleader. The warning was not a warning — it was an invitation phrased as a warning, to make sure Leon entered the village.
- **Trust effects:**
  - `neutral` → cryptic remarks, nothing concrete
  - `trusted` → gives false tip: go to the priest
  - `doubted` → silent, but her expression betrays unease
  - `feared` → hides, no longer approachable
- **Twist reveal:** Handwriting in the letter from the crypt is Erna's.

### Hilde
- **Location:** Inn
- **Appears to be:** Friendly innkeeper, helpful
- **Truth:** Herself a prisoner of the system. Knows about Jakob's plan. Stayed silent out of fear.
- **Trust effects:**
  - `neutral` → small talk, no substance
  - `trusted` → confesses fear, hints at the cellar
  - `devoted` → gives mirror without condition, warns about Erna
  - `doubted` → refuses mirror, cellar stays locked
- **Reversibility:** If player finds Hilde's diary without trusting her → trust jumps immediately to `trusted`

### Jakob
- **Location:** Barn
- **Appears to be:** The only ally, wants to get Leon out
- **Truth:** He ran Leon's car off the road. Works for Erna. Regrets it — but does not act against it.
- **Trust effects:**
  - `neutral` → offers help, says a car is ready
  - `trusted` → gives car key, leads to the forest edge (trap)
  - `devoted` → Leon follows Jakob blindly → worst ending possible
  - `doubted` → Jakob gets defensive, still gives key under pressure
  - `feared` → Jakob flees, car key stays in barn
- **Reversibility:** Tire tracks at crash site + Hilde's diary together → trust drops to `feared`, key still findable

### Father Benedikt
- **Location:** Church Interior
- **Appears to be:** Sinister, evasive
- **Truth:** Wants to break the curse, but believes the only way is through the procession. Not a villain — a tragic figure.
- **Trust effects:**
  - `neutral` → praying, almost ignores Leon
  - `trusted` → explains the procession (his version), opens crypt access
  - `devoted` → gives key to Mayor's House
  - `doubted` → crypt stays locked without code
- **Note:** Benedikt's version of the truth is incomplete but sincerely meant.

### Mia
- **Location:** Church / Graveyard
- **Appears to be:** A child, hiding, knows strange things
- **Truth:** Dead for ten years. Player never learns this directly — only hints. Her gravestone is readable.
- **Trust effects:** no trust system — Mia behaves the same always, always gives accurate information
- **Special:** The only character who never lies. But the player has no reason to trust her early on.
- **Twist reveal:** Gravestone code → Mia's birth and death date visible → death date: ten years ago. Player does the math.

### Mayor Otto
- **Location:** Mayor's House
- **Appears to be:** Authoritative figure, leader
- **Truth:** Does not know everything himself. Executes what Erna has told him for years. Weak, not evil.
- **Trust effects:**
  - `neutral` → says "go to sleep"
  - `trusted` → shows diary, breaks down internally
  - `doubted` → throws Leon out

---

## Trust System

### Levels
```
feared → doubted → neutral → trusted → devoted
  -2        -1        0        +1        +2
```

### Changes
- Rises through: correct dialogue options, showing matching items, visiting rooms in the right order
- Falls through: exposing lies (via items/diaries), trusting the wrong characters, certain actions
- **Reversible:** Evidence items (diaries, letters, notes) can shift trust sharply regardless of prior decisions

### Dialogue Options
Decisions in dialogue change trust. Examples:
- `trust_her.` / `doubt_her.` / `stay_silent.`
- `confront(jakob).` — only available if tire tracks AND diary found
- `reassure(hilde).` — raises trust if player has not entered cellar yet

---

## Items

| ID | Name | Location | Use |
|---|---|---|---|
| `flashlight` | Flashlight | Crash Site (glove compartment) | Read gravestone, lit dark rooms |
| `rope` | Rope | Crash Site (trunk) | Repair church bell |
| `mirror` | Mirror | Inn (wall) | Make forest path visible at night |
| `crypt_code` | Crypt Code | Gravestone (with flashlight) | Open crypt |
| `hildes_diary` | Hilde's Diary | Inn Cellar | Expose Jakob → trust(jakob) drops |
| `letter` | Letter to L.V. | Crypt | Reveals: interview was a trap |
| `ottos_diary` | Otto's Diary | Mayor's House | Confirm Erna's role |
| `church_record` | Old Church Record | Church Interior | Procession background (incomplete) |
| `car_key` | Car Key | Barn | Start Jakob's car |
| `well_note` | Note at the Well | Village Square | First warning (anonymous) |

---

## Puzzles

| ID | Description | Requires | Unlocks |
|---|---|---|---|
| `rope_trunk` | Trunk is stuck — get the rope | flashlight (see the latch) | rope in inventory |
| `church_bell` | Church bell does not ring | rope | Procession delayed — more time |
| `crypt_lock` | Crypt door is locked | gravestone code (flashlight) | Enter crypt |
| `forest_trail` | Forest entrance invisible at night | mirror | Escape route through forest |
| `confrontation` | Confront Jakob | Tire tracks noticed + Hilde's diary | New dialogue options, trust flips |

---

## Decisions & Consequences

| Action | Requirement | Consequence |
|---|---|---|
| `trust_her.` | village_entrance | trust(erna)+1 |
| `doubt_her.` | village_entrance | trust(erna)-1 |
| `confront(jakob).` | tire tracks + hildes_diary | trust(jakob) → feared, key stays in barn |
| `take(mirror).` | Inn | trust(hilde)-1 if taken without permission |
| `ask(hilde, cellar).` | trust(hilde, trusted) | cellar door opens |
| `ring_bell.` | rope in hand + church interior | +10 minutes game time |
| `read(gravestone).` | flashlight + graveyard | crypt code + Mia's death date visible |

---

## Exit Display (idea, not implemented)

Show available exits at the end of every `look.` output. Each exit shows the direction and destination name — with a visual marker for whether that room has been visited yet.

Example output:
```
Exits: [n] Graveyard  [w] Inn *  [e] Mayor's House ?  [sw] Barn *
```
- `*` = already visited
- `?` = never been there

**Two implementation options:**
1. **Inline in `look`** — append exits automatically after every room description. Simple, always visible.
2. **Separate `exits.` command** — player calls it explicitly when they want to orient themselves. Less intrusive, rewards active exploration.

Option 1 fits better — keeps all spatial info in one place and avoids making the player remember a command.

Uses `looked_at/2` (already tracked) to determine visited vs. unvisited. Conditional paths (locked doors) could show as `[d] Cellar — locked` instead of hiding completely.

---

## Clue System

- `look.` first time → room description only
- `look.` second time → description + hidden detail
- Detail automatically saved to `clue/1` (no duplicates)
- `notes.` → lists all collected clues
- Details are deliberately ambiguous — clear enough to notice, not clear enough to understand immediately

### Detail Text per Room

| Room | Detail (from 2nd look) |
|---|---|
| `crash_site` | Two sets of tire tracks — someone pushed you |
| `forest_path` | Fresh footprints heading toward the village, very recent |
| `village_entrance` | Erna used your name — you never introduced yourself |
| *(further rooms to follow)* | |

---

## Time Pressure

Midnight is the limit. Mechanic: actions consume time (implicit). Ringing the bell buys more time. After midnight: forest path locked, certain characters no longer approachable.

---

## Endings

### Ending A — Escape (alone)
**Condition:** mirror + forest trail + without Jakob
**Tone:** You are outside. You do not know what happens behind you. Your phone has signal again. First message: the Innsbruck interview has been "regretfully cancelled."
**Open:** Who sent the interview request? What happens in Kalmbach without you?

### Ending B — Liberation
**Condition:** Ring bell + confront Erna (ottos_diary + letter) + take Hilde with you
**Tone:** The curse — whatever it was — breaks. Hilde comes with you. The village is silent. Benedikt stays.
**Open:** Mia appears one last time and waves. Was she ever real?

### Ending C — Sacrificed
**Condition:** Midnight reached, or trusted Jakob blindly (devoted)
**Tone:** The procession begins. You understand everything now. Too late.
**Open:** Who comes to Kalmbach next?

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
| Movement n/s/e/w | ✅ implemented |
| look / describe (English) | ✅ implemented |
| Details on second look | ✅ implemented (`looked_at/2` counts visits per room) |
| Clue system (`notes.`) | ✅ implemented (`clue/1` dynamic, no duplicates) |
| Item display (`notice_items`) | ✅ implemented |
| take / drop / inventory | ✅ implemented |
| Starting room `crash_site` | ✅ implemented |
| All 12 rooms implemented | ✅ crash_site, forest_path, village_entrance, village_square, inn, inn_cellar, graveyard, church_interior, crypt, mayors_house, barn, forest |
| All 6 characters implemented | ✅ Erna, Hilde, Jakob, Benedikt, Mia, Otto — all with trust-based dialogue |
| All 10 items placed | ✅ flashlight, rope, well_note, mirror, cellar_key, hildes_diary, church_record, crypt_code, letter, car_key, ottos_diary, mayors_key |
| Conditional paths | ✅ inn→cellar (trust/key), crypt (crypt_code), mayors_house (benedikt trust/key), forest (mirror) |
| read_item(X) mechanic | ✅ all documents have full readable content |
| confront_jakob | ✅ unlocks only if tire tracks + diary clue found |
| Trust decisions all characters | ✅ trust_her, doubt_her, trust_hilde, doubt_hilde, trust_jakob, doubt_jakob, trust_benedikt, doubt_benedikt, trust_otto, doubt_otto |
| Trust system (5 levels) | ✅ implemented (`trust_value/2` ladder, `raise_trust`/`lower_trust`, `reassure`/`confide` reach `devoted`) |
| Time pressure / midnight | ✅ implemented (`game_time/1` + `deadline/1`, every move costs 5 min, `time.` shows clock) |
| Endings | ✅ implemented (A `escape.`, B `confront_erna.`, C midnight or `follow_jakob.` while devoted) |
| Ring bell puzzle | ✅ implemented (`ring_bell.` needs rope, pushes deadline +25 min) |
| Replay | ✅ implemented (`reset_state` — `start.` fully resets a finished game) |
