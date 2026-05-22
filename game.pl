:- dynamic i_am_at/1, at/2, holding/1, trust/2, looked_at/2, clue/1,
           game_time/1, deadline/1, bell_rung/0, game_over/0.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(holding(_)),
   retractall(trust(_, _)), retractall(looked_at(_, _)), retractall(clue(_)),
   retractall(game_time(_)), retractall(deadline(_)),
   retractall(bell_rung), retractall(game_over).

/* ===================== Initial State ===================== */

i_am_at(crash_site).
trust(erna,     neutral).
trust(hilde,    neutral).
trust(jakob,    neutral).
trust(benedikt, neutral).
trust(otto,     neutral).

/* Time: minutes elapsed since 10 PM. Midnight = deadline (120 min). */
game_time(0).
deadline(120).

/* ===================== Map ===================== */

path(crash_site,       n,  forest_path).
path(forest_path,      s,  crash_site).
path(forest_path,      n,  village_entrance).
path(village_entrance, s,  forest_path).
path(village_entrance, n,  village_square).
path(village_square,   s,  village_entrance).
path(village_square,   w,  inn).
path(inn,              e,  village_square).
path(village_square,   n,  graveyard).
path(graveyard,        s,  village_square).
path(graveyard,        n,  church_interior).
path(church_interior,  s,  graveyard).
path(mayors_house,     w,  village_square).
path(village_square,   sw, barn).
path(barn,             ne, village_square).
path(forest,           se, village_square).

path(inn, d, inn_cellar) :-
    (trust(hilde, trusted) ; trust(hilde, devoted) ; holding(cellar_key)), !.
path(inn, d, inn_cellar) :-
    write('The cellar door is bolted shut.'), nl, fail.
path(inn_cellar, u, inn).

path(church_interior, d, crypt) :-
    holding(crypt_code), !.
path(church_interior, d, crypt) :-
    write('A stone door, sealed with a sequence of symbols carved into the frame.'), nl,
    write('You do not know the sequence yet.'), nl, fail.
path(crypt, u, church_interior).

path(village_square, e, mayors_house) :-
    (trust(benedikt, trusted) ; trust(benedikt, devoted) ; holding(mayors_key)), !.
path(village_square, e, mayors_house) :-
    write('The front door is locked. Heavy iron bolt, no handle on this side.'), nl, fail.

path(village_square, nw, forest) :-
    holding(mirror), !.
path(village_square, nw, forest) :-
    write('The forest edge is lost in darkness. You cannot find a way through.'), nl, fail.

/* ===================== Items ===================== */

at(flashlight,    crash_site).
at(rope,          crash_site).
at(well_note,     village_square).
at(mirror,        inn).
at(hildes_diary,  inn_cellar).
at(church_record, church_interior).
at(crypt_code,    graveyard).
at(letter,        crypt).
at(car_key,       barn).
at(ottos_diary,   mayors_house).

/* ===================== Room Descriptions ===================== */

describe(crash_site) :-
    write('Your car lies at an angle in the roadside ditch, the front axle'), nl,
    write('snapped. Forest all around. The rain has stopped, but the fog'), nl,
    write('sits low. Somewhere in the undergrowth, something snaps.'), nl,
    write('A narrow path leads north.'), nl.

describe(forest_path) :-
    write('A tight trail between old spruce trees. Branches close in overhead.'), nl,
    write('The village must be close — you can see light through the trees,'), nl,
    write('muted and yellow. The path continues north. South leads back.'), nl.

describe(village_entrance) :-
    write('A weathered wooden sign: "Kalmbach — Est. 1648."'), nl,
    write('The road becomes cobblestone. Shutters closed everywhere.'), nl,
    write('No sound. No movement.'), nl,
    write('And yet — at the edge of the light stands an old woman,'), nl,
    write('watching you as if she had been waiting.'), nl.

describe(village_square) :-
    write('A small square with a stone well at its center. Every window'), nl,
    write('is dark. The shutters are all closed — but not all locked.'), nl,
    write('You can hear your own footsteps too clearly.'), nl,
    write('The inn is to the west. A church to the north.'), nl,
    write('A large house to the east. A barn somewhere to the southwest.'), nl.

describe(inn) :-
    write('Warm air, woodsmoke, low ceiling. A woman behind the counter'), nl,
    write('wipes a glass that is already clean. She smiles before you'), nl,
    write('have even opened the door fully.'), nl,
    write('"You must be freezing. Sit down."'), nl.

describe(inn_cellar) :-
    write('Stone steps, cold and damp. Rows of wine barrels, most empty.'), nl,
    write('A single bare bulb flickers overhead.'), nl,
    write('Against the far wall: a mattress. A folded blanket.'), nl,
    write('Someone has been living down here.'), nl.

describe(graveyard) :-
    write('The churchyard is overgrown, stones leaning at odd angles.'), nl,
    write('Most names have been worn away by weather. One grave near'), nl,
    write('the church wall is newer than the rest.'), nl,
    write('A small girl sits on it, watching you.'), nl.

describe(church_interior) :-
    write('Cold stone and old wax. Candles burn along the aisle'), nl,
    write('though you saw no one light them.'), nl,
    write('A man in dark robes kneels at the far end, motionless.'), nl,
    write('He does not look up when you enter.'), nl.

describe(crypt) :-
    write('Below the church. The air is perfectly still.'), nl,
    write('Stone slabs line the floor, each carved with names and dates.'), nl,
    write('One slab near the far wall has been moved — recently.'), nl,
    write('Something rests in the gap.'), nl.

describe(mayors_house) :-
    write('A neat entrance hall, cold hearth, framed certificates everywhere.'), nl,
    write('Mayor Otto stands at the top of the stairs, looking down'), nl,
    write('at you with an expression you cannot quite read.'), nl.

describe(barn) :-
    write('The barn door swings open as you approach.'), nl,
    write('Hay bales, rusted tools, the smell of oil and damp wood.'), nl,
    write('A young man stands near the back, arms crossed,'), nl,
    write('pretending he was not waiting.'), nl.

describe(forest) :-
    write('The trees swallow all sound. The mirror guided you to a gap'), nl,
    write('in the undergrowth — a trail that does not appear on any map.'), nl,
    write('It leads deeper in. The village square is back to the southeast.'), nl.

/* ===================== Details (2nd look) ===================== */

details(crash_site) :-
    record_clue('Crash site: Two sets of tire tracks on the road. Someone drove very close to you just before the ditch.'),
    write('You scan the road. Two sets of tire tracks in the mud.'), nl,
    write('One is not yours. Someone came very close — right before the ditch.'), nl.

details(forest_path) :-
    record_clue('Forest path: Fresh footprints in the mud heading toward the village. Several people. Minutes ago.'),
    write('In the mud at the edge of the trail: footprints.'), nl,
    write('Several. All heading toward the village. Edges still sharp — minutes ago.'), nl.

details(village_entrance) :-
    record_clue('Village entrance: The old woman used your name. You never introduced yourself.'),
    write('You replay it. She said something as you approached.'), nl,
    write('"Leon." Just that. You never told her your name.'), nl.

details(village_square) :-
    record_clue('Village square: The note at the well has a date — three months ago. The same time the letter in the crypt was written.'),
    write('You check the note again. A date in the corner, almost too faint.'), nl,
    write('Three months ago. Someone planned this long in advance.'), nl.

details(inn) :-
    record_clue('Inn: The mirror is angled toward the door, not the room. Whoever stands behind that counter can watch who enters without looking up.'),
    write('The mirror on the wall is angled wrong — not toward the room.'), nl,
    write('Toward the door. A perfect view of every entrance from behind the bar.'), nl.

details(inn_cellar) :-
    record_clue('Inn cellar: The blanket has initials sewn in the corner. Not Hilde\'s initials.'),
    write('You unfold the blanket. Initials sewn in small, careful stitches.'), nl,
    write('Not H. Not Hilde. Someone else was hiding here.'), nl.

details(graveyard) :-
    record_clue('Graveyard: The newest grave has fresh flowers placed today. The stone reads: Mia Haas, 2004-2014. She has been dead for ten years.'),
    write('The newest grave has fresh wildflowers on it — placed today.'), nl,
    write('The stone reads: Mia Haas. Born 2004. Died 2014.'), nl,
    write('Ten years ago.'), nl.

details(church_interior) :-
    record_clue('Church interior: The candles mark every third pew on the left. Seven candles. Seven newer graves in the churchyard.'),
    write('The candles are not random. Every third pew on the left.'), nl,
    write('You count: seven. The same number as the newer graves outside.'), nl.

details(crypt) :-
    record_clue('Crypt: The moved slab has deep scratch marks on the inside. Someone was sealed in and tried to get out.'),
    write('You look at the underside of the moved slab.'), nl,
    write('Scratch marks. Deep. Made from the inside.'), nl.

details(mayors_house) :-
    record_clue('Mayor\'s house: A group photo from 1987 has one face circled in red. It is Erna.'),
    write('A framed photograph — the whole village, decades ago.'), nl,
    write('One face circled in red marker. You recognize the eyes.'), nl,
    write('Erna. Below the frame, written in pencil: "1987."'), nl.

details(barn) :-
    record_clue('Barn: An oil stain outlines a car that is no longer there. Jakob\'s car was moved very recently.'),
    write('An oil stain on the barn floor — the outline of a car.'), nl,
    write('The stain is still fresh at the edges. Recently moved.'), nl.

details(forest) :-
    record_clue('Forest: A scrap of cloth caught on a branch. Same pattern as the blanket in the inn cellar.'),
    write('A scrap of fabric on a low branch.'), nl,
    write('You have seen this pattern before — the blanket in the inn cellar.'), nl.

details(_).

/* ===================== Characters ===================== */

character_at(erna,     village_entrance).
character_at(hilde,    inn).
character_at(jakob,    barn).
character_at(benedikt, church_interior).
character_at(mia,      graveyard).
character_at(otto,     mayors_house).

talk :- game_over, !, game_over_notice.
talk :-
    i_am_at(Place),
    character_at(Name, Place),
    interact(Name), !.
talk :-
    write('There is no one here to talk to.'), nl.

/* Erna */
interact(erna) :- trust(erna, neutral),
    write('"You should not be here. Not tonight."'), nl,
    write('A pause. "But you are. Go to the inn. Hilde will let you in."'), nl,
    write('She turns away.'), nl,
    write('Do you trust her? (trust_her. / doubt_her.)'), nl, !.
interact(erna) :- trust(erna, trusted),
    write('She turns her head almost imperceptibly toward the church.'), nl,
    write('"The priest knows more than he says. Ask him about 1987."'), nl, !.
interact(erna) :- trust(erna, doubted),
    write('Erna looks at you. Almost smiles. "You are careful. Good."'), nl, !.
interact(erna) :- trust(erna, feared),
    write('Erna is gone. Only footprints in the mud where she stood.'), nl, !.

/* Hilde */
interact(hilde) :- trust(hilde, neutral),
    write('"Rough night? You can stay here — no charge.'), nl,
    write('The roads are bad in weather like this."'), nl,
    write('She is warm. Too warm for 10 PM.'), nl,
    write('Do you trust her? (trust_hilde. / doubt_hilde.)'), nl, !.
interact(hilde) :- trust(hilde, trusted),
    write('"There is something downstairs you should see.'), nl,
    write('Someone has been staying here. Not a guest."'), nl,
    write('She slides a key across the counter.'), nl,
    (holding(cellar_key) -> true ;
     at(cellar_key, _)   -> true ;
     assert(holding(cellar_key)), write('You take the cellar key.'), nl), !.
interact(hilde) :- trust(hilde, devoted),
    write('"Take me with you when you go," she says quietly.'), nl,
    write('"Whatever you find — do not leave without me."'), nl, !.
interact(hilde) :- trust(hilde, doubted),
    write('Hilde wipes the counter again. Does not look at you.'), nl,
    write('"I hope you find what you need."'), nl,
    write('Her voice is flat. Something has closed.'), nl, !.

/* Jakob */
interact(jakob) :- trust(jakob, neutral),
    write('"You the one whose car went off the road? Saw it happen."'), nl,
    write('He pauses just a fraction too long.'), nl,
    write('"I have a car. I can drive you out when you''re ready."'), nl,
    write('Do you trust him? (trust_jakob. / doubt_jakob.)'), nl, !.
interact(jakob) :- trust(jakob, trusted),
    write('Jakob nods and pulls a key from his pocket.'), nl,
    write('"Car is just outside the village. Follow me. Don''t stop."'), nl,
    (holding(car_key) -> true ;
     retractall(at(car_key, _)), assert(holding(car_key)),
     write('He hands you the key.'), nl), !.
interact(jakob) :- trust(jakob, doubted),
    write('"Look, I am trying to help you."'), nl,
    write('He said he saw it happen. From where, exactly?'), nl, !.
interact(jakob) :- trust(jakob, feared),
    write('Jakob backs against the wall as you enter.'), nl,
    write('"I didn''t — it was not supposed to go like this."'), nl,
    write('He will not look at you.'), nl, !.

/* Father Benedikt */
interact(benedikt) :- trust(benedikt, neutral),
    write('He does not stand. Keeps his eyes on the altar.'), nl,
    write('"We do not get visitors. Especially not tonight."'), nl,
    write('A long silence. "The inn is still open. Go there."'), nl,
    write('Do you trust him? (trust_benedikt. / doubt_benedikt.)'), nl, !.
interact(benedikt) :- trust(benedikt, trusted),
    write('"The procession is not what you think.'), nl,
    write('It is a ritual of preservation. Of continuation."'), nl,
    write('"The crypt holds the answer. But understand what you find'), nl,
    write('before you act on it."'), nl,
    (holding(crypt_code) -> true ;
     write('He whispers the sequence. You now know how to open the crypt.'), nl,
     retractall(at(crypt_code, _)),
     assert(holding(crypt_code))), !.
interact(benedikt) :- trust(benedikt, devoted),
    write('Benedikt hands you a small iron key without a word.'), nl,
    write('"The mayor has been following orders too long.'), nl,
    write('He needs to hear this from someone outside."'), nl,
    (holding(mayors_key) -> true ;
     retractall(at(mayors_key, _)), assert(holding(mayors_key)),
     write('He gives you the key to the mayor''s house.'), nl), !.
interact(benedikt) :- trust(benedikt, doubted),
    write('Benedikt turns back to the altar.'), nl,
    write('"Then there is nothing more I can tell you."'), nl, !.

/* Mia */
interact(mia) :-
    write('The girl looks up with an expression too old for her face.'), nl,
    write('"You should look at the names on the stones. The dates matter."'), nl,
    write('She does not blink.'), nl,
    write('"Ask Hilde about the blanket. She knows whose it was."'), nl, !.

/* Mayor Otto */
interact(otto) :- trust(otto, neutral),
    write('The mayor descends two steps and stops.'), nl,
    write('"This is a private residence. The inn is across the square."'), nl,
    write('His voice is practiced. Official.'), nl,
    write('Do you trust him? (trust_otto. / doubt_otto.)'), nl, !.
interact(otto) :- trust(otto, trusted),
    write('Otto sits down heavily on the stairs.'), nl,
    write('"Erna came to me in 1987. Told me what the village needed to survive.'), nl,
    write('I believed her. We all did."'), nl,
    write('He looks at his hands. "I did not know about the letters.'), nl,
    write('I did not know she had been choosing them. Months in advance."'), nl, !.
interact(otto) :- trust(otto, doubted),
    write('"Get out of my house."'), nl,
    write('He points at the door. His hand is shaking.'), nl, !.

/* ===================== Trust Decisions ===================== */

trust_her :-
    i_am_at(village_entrance), trust(erna, neutral),
    retract(trust(erna, _)), assert(trust(erna, trusted)),
    write('Something about her feels sincere. Or like she has nothing to gain.'), nl, !.
trust_her :- i_am_at(village_entrance),
    write('You have already made your decision.'), nl, !.

doubt_her :-
    i_am_at(village_entrance), trust(erna, neutral),
    retract(trust(erna, _)), assert(trust(erna, doubted)),
    write('Why did she know your name? You note her words — but not trust them.'), nl, !.
doubt_her :- i_am_at(village_entrance),
    write('You have already made your decision.'), nl, !.

trust_hilde :-
    i_am_at(inn), trust(hilde, neutral),
    retract(trust(hilde, _)), assert(trust(hilde, trusted)),
    write('Too warm for 10 PM — but maybe that is just who she is.'), nl, !.
trust_hilde :- i_am_at(inn),
    write('You have already made your decision.'), nl, !.

doubt_hilde :-
    i_am_at(inn), trust(hilde, neutral),
    retract(trust(hilde, _)), assert(trust(hilde, doubted)),
    write('Too friendly. Too ready. You keep your distance.'), nl, !.
doubt_hilde :- i_am_at(inn),
    write('You have already made your decision.'), nl, !.

trust_jakob :-
    i_am_at(barn), trust(jakob, neutral),
    retract(trust(jakob, _)), assert(trust(jakob, trusted)),
    write('He seems nervous but sincere. You need a car.'), nl, !.
trust_jakob :- i_am_at(barn),
    write('You have already made your decision.'), nl, !.

doubt_jakob :-
    i_am_at(barn), trust(jakob, neutral),
    retract(trust(jakob, _)), assert(trust(jakob, doubted)),
    write('He said he saw it happen. From where, exactly?'), nl,
    write('You file it away and say nothing.'), nl, !.
doubt_jakob :- i_am_at(barn),
    write('You have already made your decision.'), nl, !.

confront_jakob :-
    i_am_at(barn),
    clue('Crash site: Two sets of tire tracks on the road. Someone drove very close to you just before the ditch.'),
    clue('Hilde\'s diary: Jakob threatened Hilde into silence. She knows he ran you off the road.'),
    retract(trust(jakob, _)), assert(trust(jakob, feared)),
    write('"You said you saw it happen. There were two sets of tracks."'), nl,
    write('Jakob goes pale.'), nl,
    write('"You pushed me off the road. On Erna''s orders."'), nl,
    write('He does not deny it. "It wasn''t supposed to — she said no one would get hurt."'), nl,
    record_clue('Jakob confessed: he ran you off the road on Erna\'s orders.'), !.
confront_jakob :- i_am_at(barn),
    write('You do not have enough to confront him yet.'), nl, !.
confront_jakob :-
    write('Jakob is not here.'), nl.

trust_benedikt :-
    i_am_at(church_interior), trust(benedikt, neutral),
    retract(trust(benedikt, _)), assert(trust(benedikt, trusted)),
    write('He has not lied to you yet — or at least you cannot tell.'), nl, !.
trust_benedikt :- i_am_at(church_interior),
    write('You have already made your decision.'), nl, !.

doubt_benedikt :-
    i_am_at(church_interior), trust(benedikt, neutral),
    retract(trust(benedikt, _)), assert(trust(benedikt, doubted)),
    write('A priest conducting midnight rituals in an unmapped village.'), nl,
    write('You keep your thoughts to yourself.'), nl, !.
doubt_benedikt :- i_am_at(church_interior),
    write('You have already made your decision.'), nl, !.

trust_otto :-
    i_am_at(mayors_house), trust(otto, neutral),
    retract(trust(otto, _)), assert(trust(otto, trusted)),
    write('He looks more scared than threatening. He might actually talk.'), nl, !.
trust_otto :- i_am_at(mayors_house),
    write('You have already made your decision.'), nl, !.

doubt_otto :-
    i_am_at(mayors_house), trust(otto, neutral),
    retract(trust(otto, _)), assert(trust(otto, doubted)),
    write('He runs this village. Whatever happened here, he is not innocent.'), nl, !.
doubt_otto :- i_am_at(mayors_house),
    write('You have already made your decision.'), nl, !.

/* ===================== Trust Ladder (5 levels) ===================== */
/* feared(-2) < doubted(-1) < neutral(0) < trusted(+1) < devoted(+2) */

trust_value(feared,   -2).
trust_value(doubted,  -1).
trust_value(neutral,   0).
trust_value(trusted,   1).
trust_value(devoted,   2).

raise_trust(Char) :-
    trust(Char, Cur), trust_value(Cur, V),
    V1 is min(V + 1, 2), trust_value(New, V1),
    retract(trust(Char, _)), assert(trust(Char, New)).

lower_trust(Char) :-
    trust(Char, Cur), trust_value(Cur, V),
    V1 is max(V - 1, -2), trust_value(New, V1),
    retract(trust(Char, _)), assert(trust(Char, New)).

/* Reaching devoted — deepening an existing trust. */

reassure(hilde) :-
    i_am_at(inn), trust(hilde, trusted),
    raise_trust(hilde),
    write('"You can count on me," you tell her. For a moment she believes it.'), nl,
    write('"Then do not leave without me," she says. "Promise me that."'), nl, !.
reassure(hilde) :-
    i_am_at(inn), trust(hilde, devoted),
    write('She has already decided to trust you with everything.'), nl, !.
reassure(hilde) :-
    i_am_at(inn),
    write('She studies you. It is not the right moment for promises.'), nl, !.
reassure(jakob) :-
    i_am_at(barn), trust(jakob, trusted),
    raise_trust(jakob),
    write('"I believe you, Jakob. Get me out of here — whatever it takes."'), nl,
    write('Relief floods his face. Or something wearing relief''s shape.'), nl,
    write('"Then stay close. Do exactly what I say."'), nl, !.
reassure(jakob) :-
    i_am_at(barn), trust(jakob, devoted),
    write('Jakob already has your complete trust. Perhaps too much of it.'), nl, !.
reassure(jakob) :-
    i_am_at(barn),
    write('He has not earned that kind of faith from you.'), nl, !.
reassure(_) :-
    write('There is no one here to reassure.'), nl.

confide(benedikt) :-
    i_am_at(church_interior), trust(benedikt, trusted),
    clue('Church record: A stranger must witness and choose freely. If kept against their will, something breaks. The record is incomplete.'),
    raise_trust(benedikt),
    write('You tell him what the record said — the part about choosing freely.'), nl,
    write('Something in him settles. "Then perhaps it is not too late."'), nl, !.
confide(benedikt) :-
    i_am_at(church_interior), trust(benedikt, trusted),
    write('He waits. You sense he wants proof you understand — read the church record first.'), nl, !.
confide(benedikt) :-
    i_am_at(church_interior),
    write('He does not yet trust you enough to hear it.'), nl, !.
confide(_) :-
    write('There is no one here to confide in.'), nl.

/* ===================== Time & Bell ===================== */

advance_time(_) :- game_over, !.
advance_time(N) :-
    game_time(T), retract(game_time(T)),
    T1 is T + N, assert(game_time(T1)),
    deadline(D),
    (T1 >= D -> ending_c ; true).

print_time :-
    game_time(T), Total is 1320 + T,
    H is (Total // 60) mod 24, M is Total mod 60,
    format('The church clock reads ~|~`0t~d~2|:~|~`0t~d~2|.~n', [H, M]).

time :- print_time.

ring_bell :-
    i_am_at(church_interior), bell_rung,
    write('The bell still echoes. It will not buy you more time twice.'), nl, !.
ring_bell :-
    i_am_at(church_interior), holding(rope),
    assert(bell_rung),
    deadline(D), retract(deadline(D)), D1 is D + 25, assert(deadline(D1)),
    write('You haul on the rope. The old bell resists, then swings —'), nl,
    write('a single deep toll rolls out over Kalmbach.'), nl,
    write('Somewhere a door slams. The procession will be late tonight.'), nl,
    record_clue('You rang the church bell. The procession is delayed — more time.'), !.
ring_bell :-
    i_am_at(church_interior),
    write('There is a bell rope frame above, but no rope to reach it.'), nl,
    write('You need a rope.'), nl, !.
ring_bell :-
    write('There is no bell here.'), nl.

/* ===================== Take / Drop / Inventory ===================== */

take(rope) :-
    at(rope, crash_site), \+ holding(flashlight),
    write('It is too dark to see into the trunk.'), nl, !.

take(crypt_code) :-
    at(crypt_code, graveyard), \+ holding(flashlight),
    write('It is too dark to make out the inscription.'), nl, !.

take(mirror) :-
    at(mirror, inn), trust(hilde, neutral),
    write('Hilde looks up. "That belonged to my mother. Please don''t take it."'), nl,
    write('Take it anyway? (take_mirror.)'), nl, !.

take(hildes_diary) :-
    at(hildes_diary, inn_cellar),
    retract(at(hildes_diary, inn_cellar)),
    assert(holding(hildes_diary)),
    write('A diary, hidden behind one of the barrels.'), nl,
    write('You flip to the last entries. The name Jakob appears.'), nl,
    write('And the word "accident" — in quotation marks.'), nl,
    record_clue('Hilde\'s diary: Jakob threatened Hilde into silence. She knows he ran you off the road.'),
    (trust(hilde, doubted) ->
        retract(trust(hilde, _)), assert(trust(hilde, trusted)),
        write('Your opinion of Hilde shifts. She has been protecting you.')
    ; true), nl, !.

take(X) :-
    holding(X),
    write('You are already holding it.'), nl, !.

take(X) :-
    i_am_at(Place), at(X, Place),
    retract(at(X, Place)),
    assert(holding(X)),
    write('Taken.'), nl, !.

take(_) :-
    write('You do not see that here.'), nl.

take_mirror :-
    i_am_at(inn), at(mirror, inn),
    retract(at(mirror, inn)),
    assert(holding(mirror)),
    retract(trust(hilde, _)), assert(trust(hilde, doubted)),
    write('You take it. Hilde says nothing.'), nl,
    write('But something closes in her expression.'), nl, !.
take_mirror :-
    write('There is no mirror to take.'), nl.

drop(X) :-
    holding(X), i_am_at(Place),
    retract(holding(X)), assert(at(X, Place)),
    write('Dropped.'), nl, !.
drop(_) :-
    write('You are not carrying that.'), nl.

inventory :-
    write('=== Inventory ==='), nl,
    list_items.

list_items :-
    holding(X), write('  - '), write(X), nl, fail.
list_items :-
    \+ holding(_),
    write('  Empty.'), nl, !.
list_items.

/* ===================== Read ===================== */

read_item(well_note) :-
    holding(well_note),
    write('"Trust no one who helps you too quickly."'), nl,
    write('No name. In the corner, a date — almost too faint to read.'), nl, !.

read_item(hildes_diary) :-
    holding(hildes_diary),
    write('"J. came again tonight. I told him I would not say anything.'), nl,
    write('He reminded me what happened in 2019."'), nl,
    write('"The man from the road — if he finds out, J. is finished.'), nl,
    write('And so am I. But I cannot keep pretending."'), nl,
    record_clue('Hilde\'s diary full entry: Jakob has been threatening Hilde since 2019.'), !.

read_item(letter) :-
    holding(letter),
    write('Addressed to: L. Varga.'), nl,
    write('"We received your application for the Innsbruck feature.'), nl,
    write('Please confirm your arrival for the 14th."'), nl,
    write('The letterhead is from a magazine you have never heard of.'), nl,
    write('The phone number goes nowhere.'), nl,
    write('Someone fabricated this. The handwriting on the envelope —'), nl,
    write('careful, deliberate. You have seen it somewhere before.'), nl,
    record_clue('The letter: The Innsbruck interview was fabricated. Someone lured you here. The handwriting is familiar.'), !.

read_item(church_record) :-
    holding(church_record),
    write('An account of Kalmbach''s founding, 1648.'), nl,
    write('Built over an older settlement. The original inhabitants'), nl,
    write('had a practice: every generation, a stranger must witness'), nl,
    write('the village and choose — freely — to stay or leave.'), nl,
    write('If they leave, the cycle continues.'), nl,
    write('If they are kept — "the contract is fulfilled."'), nl,
    write('The record does not say what the contract is for.'), nl,
    record_clue('Church record: A stranger must witness and choose freely. If kept against their will, something breaks. The record is incomplete.'), !.

read_item(ottos_diary) :-
    holding(ottos_diary),
    write('"Erna says the stranger will arrive before the full moon.'), nl,
    write('I asked how she could know. She said she had written to him."'), nl,
    write('"I asked when. She said three months ago."'), nl,
    write('"I asked why she had not told us.'), nl,
    write('She said we would have stopped her."'), nl,
    record_clue('Otto\'s diary: Erna wrote the interview letter herself, three months ago. She planned Leon\'s arrival without telling the village.'), !.

read_item(X) :-
    holding(X),
    write('You look at it closely. Nothing new stands out.'), nl, !.
read_item(X) :-
    write('You are not carrying '), write(X), write('.'), nl.

/* ===================== Notice Items ===================== */

notice_items(graveyard) :-
    at(crypt_code, graveyard),
    (holding(flashlight) ->
        write('Your flashlight reveals an inscription on one of the gravestones.'), nl,
        write('You could take(crypt_code) to copy the sequence.')
    ;
        write('The gravestones are barely visible in the dark.')
    ), nl, fail.
notice_items(Place) :-
    at(X, Place), X \= crypt_code,
    write('You see: '), write(X), write('.'), nl, fail.
notice_items(_).

/* ===================== Clues ===================== */

record_clue(Text) :- clue(Text), !.
record_clue(Text) :- assert(clue(Text)).

notes :-
    write('=== Notes ==='), nl, list_clues.

list_clues :-
    clue(X), write('  - '), write(X), nl, fail.
list_clues :-
    \+ clue(_),
    write('  Nothing recorded yet.'), nl, !.
list_clues.

/* ===================== Look ===================== */

look :-
    i_am_at(Place),
    describe(Place), nl,
    notice_items(Place),
    (   looked_at(Place, Count)
    ->  NewCount is Count + 1,
        retract(looked_at(Place, Count)),
        assert(looked_at(Place, NewCount))
    ;   assert(looked_at(Place, 1)),
        NewCount = 1
    ),
    (NewCount >= 2 -> details(Place) ; true),
    nl,
    print_time, nl, !.

/* ===================== Movement ===================== */

n  :- go(n).  s  :- go(s).  e  :- go(e).  w  :- go(w).
ne :- go(ne). sw :- go(sw). nw :- go(nw). se :- go(se).
u  :- go(u).  d  :- go(d).

go(_) :- game_over, !, game_over_notice.
go(Dir) :-
    i_am_at(Here),
    path(Here, Dir, There),
    retract(i_am_at(Here)),
    assert(i_am_at(There)),
    advance_time(5),
    (game_over -> true ; look), !.
go(_) :-
    write('You cannot go that way.'), nl.

/* ===================== Endings ===================== */

end_banner :-
    nl, write('======================================================='), nl.

ending_a :-
    assert(game_over),
    end_banner,
    write('              ENDING A — OUT'), nl,
    end_banner, nl,
    write('The mirror-trail spits you out onto a logging road.'), nl,
    write('Behind you, Kalmbach is already gone in the fog.'), nl,
    write('You do not look back. You do not know what happens'), nl,
    write('behind you, and part of you never wants to.'), nl, nl,
    write('Your phone buzzes. One bar. A message:'), nl,
    write('"We regret the Innsbruck feature has been cancelled."'), nl,
    write('You never applied for any feature.'), nl, nl,
    write('Who sent for you? What happens in Kalmbach without you?'), nl,
    write('(start. to play again)'), nl, !.

ending_b :-
    assert(game_over),
    end_banner,
    write('              ENDING B — THE BELL'), nl,
    end_banner, nl,
    write('You hold the letter up to Erna. "You wrote this. Months ago."'), nl,
    write('The bell still hangs in the air between you.'), nl,
    write('For the first time she looks her age. The plan needed you'), nl,
    write('to stay of your own will. You are leaving — and not alone.'), nl, nl,
    write('Whatever the contract was, it goes unfulfilled.'), nl,
    write('Hilde takes your arm. The shutters open, one by one.'), nl,
    write('Benedikt stays behind, at peace.'), nl, nl,
    write('At the village edge, Mia waves once. Then she is not there.'), nl,
    write('Was she ever?'), nl,
    write('(start. to play again)'), nl, !.

ending_c :-
    assert(game_over),
    end_banner,
    write('              ENDING C — THE PROCESSION'), nl,
    end_banner, nl,
    write('Midnight. The shutters open all at once.'), nl,
    write('They come out with candles, every face you have met'), nl,
    write('and many you have not. Erna at the front. Hilde will not'), nl,
    write('meet your eyes.'), nl, nl,
    write('You understand all of it now — the letter, the choosing,'), nl,
    write('the contract. You understand it completely.'), nl,
    write('Too late to matter.'), nl, nl,
    write('Who comes to Kalmbach next full moon?'), nl,
    write('(start. to play again)'), nl, !.

game_over_notice :-
    write('It is over. Type start. to begin again.'), nl.

/* ----- Escape routes ----- */

escape :- game_over, !, game_over_notice.
escape :-
    i_am_at(forest),
    write('You take the hidden trail alone, the way the mirror showed you.'), nl,
    ending_a, !.
escape :-
    write('There is no way out from here. The forest trail is the only road.'), nl, !.

follow_jakob :- game_over, !, game_over_notice.
follow_jakob :-
    i_am_at(barn), trust(jakob, devoted),
    write('You follow Jakob into the dark without a single question.'), nl,
    write('The car is not where he said. Neither is the road.'), nl,
    write('Lanterns close in from the trees.'), nl,
    ending_c, !.
follow_jakob :-
    i_am_at(barn), (trust(jakob, trusted) ; holding(car_key)),
    write('Jakob leads you to the village edge — then stops cold.'), nl,
    write('The road is blocked. "I... I can''t. I''m sorry."'), nl,
    write('He turns back. The car was never the way out.'), nl, !.
follow_jakob :-
    i_am_at(barn),
    write('Jakob will not lead you anywhere. Not like this.'), nl, !.
follow_jakob :-
    write('Jakob is not here.'), nl.

/* ----- The reckoning with Erna ----- */

confront_erna :- game_over, !, game_over_notice.
confront_erna :-
    i_am_at(village_entrance), trust(erna, feared),
    write('Erna is gone. You confront only the empty road.'), nl, !.
confront_erna :-
    i_am_at(village_entrance),
    clue('The letter: The Innsbruck interview was fabricated. Someone lured you here. The handwriting is familiar.'),
    clue('Otto\'s diary: Erna wrote the interview letter herself, three months ago. She planned Leon\'s arrival without telling the village.'),
    bell_rung,
    trust(hilde, devoted),
    ending_b, !.
confront_erna :-
    i_am_at(village_entrance),
    write('You face Erna with what you have — but it is not enough,'), nl,
    write('not yet. You need the letter and the proof she wrote it,'), nl,
    write('the bell rung to buy time, and Hilde ready to leave with you.'), nl, !.
confront_erna :-
    write('Erna is not here.'), nl.

/* ===================== Engine ===================== */

help  :- instructions.
quit  :- halt.

instructions :-
    write('-------------------------------------------------------'), nl,
    write('  Commands:'), nl,
    write('  n. s. e. w. ne. sw. nw. se. u. d.  -> move'), nl,
    write('  look.           -> examine your surroundings'), nl,
    write('  talk.           -> speak to someone nearby'), nl,
    write('  take(X).        -> pick up an item'), nl,
    write('  drop(X).        -> put down an item'), nl,
    write('  read_item(X).   -> read a document'), nl,
    write('  inventory.      -> show carried items'), nl,
    write('  notes.          -> show discovered clues'), nl,
    write('  time.           -> check the clock (midnight is the deadline)'), nl,
    write('  ring_bell.      -> ring the church bell (needs rope)'), nl,
    write('  reassure(X).    -> deepen trust with a character'), nl,
    write('  confide(X).     -> share what you have learned'), nl,
    write('  confront_jakob. -> confront Jakob with evidence'), nl,
    write('  confront_erna.  -> face Erna at the village entrance'), nl,
    write('  follow_jakob.   -> let Jakob lead you out'), nl,
    write('  escape.         -> take the forest trail out (in the forest)'), nl,
    write('  help.           -> show this list'), nl,
    write('  quit.           -> quit the game'), nl,
    write('-------------------------------------------------------'), nl, nl.

/* ===================== Start ===================== */

reset_state :-
    retractall(i_am_at(_)), retractall(at(_, _)), retractall(holding(_)),
    retractall(trust(_, _)), retractall(looked_at(_, _)), retractall(clue(_)),
    retractall(game_time(_)), retractall(deadline(_)),
    retractall(bell_rung), retractall(game_over),
    assert(i_am_at(crash_site)),
    assert(trust(erna, neutral)), assert(trust(hilde, neutral)),
    assert(trust(jakob, neutral)), assert(trust(benedikt, neutral)),
    assert(trust(otto, neutral)),
    assert(game_time(0)), assert(deadline(120)),
    assert(at(flashlight, crash_site)), assert(at(rope, crash_site)),
    assert(at(well_note, village_square)), assert(at(mirror, inn)),
    assert(at(hildes_diary, inn_cellar)), assert(at(church_record, church_interior)),
    assert(at(crypt_code, graveyard)), assert(at(letter, crypt)),
    assert(at(car_key, barn)), assert(at(ottos_diary, mayors_house)).

start :-
    reset_state,
    nl,
    write('======================================================='), nl,
    write('              WHISPERS BETWEEN US'), nl,
    write('======================================================='), nl,
    nl,
    write('The rain has stopped.'), nl,
    nl,
    write('You do not know how long you were unconscious.'), nl,
    write('The dashboard is cold. The windshield fogged over.'), nl,
    write('Outside: forest. Silence. And something that feels'), nl,
    write('like being watched.'), nl,
    nl,
    write('Your phone shows no signal.'), nl,
    write('The front axle is snapped.'), nl,
    write('You are not driving out of here.'), nl,
    nl,
    write('About a kilometer down the road, you see lights.'), nl,
    nl,
    write('It is just past 10 PM. Tonight is a full moon.'), nl,
    nl,
    instructions,
    write('You step out of the car.'), nl,
    nl,
    look.
