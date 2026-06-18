:- dynamic i_am_at/1, at/2, holding/1, trust/2, looked_at/2, clue/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(holding(_)),
   retractall(trust(_, _)), retractall(looked_at(_, _)), retractall(clue(_)).

/* ===================== Initial State ===================== */

i_am_at(crash_site).
trust(erna, neutral).

/* ===================== Map ===================== */

path(crash_site, n, forest_path).
path(forest_path, s, crash_site).
path(forest_path, n, village_entrance).
path(village_entrance, s, forest_path).

/* ===================== Items ===================== */

at(flashlight, crash_site).

/* ===================== Room Descriptions ===================== */

describe(crash_site) :-
    write('Your car lies at an angle in the roadside ditch, the front axle'), nl,
    write('snapped. Forest all around. The rain has stopped, but the fog'), nl,
    write('sits low. Somewhere in the undergrowth, something snaps.'), nl,
    write('A narrow forest path leads north.'), nl.

describe(forest_path) :-
    write('A tight trail between old spruce trees. The branches close in'), nl,
    write('overhead. The village must be close — you can see light through'), nl,
    write('the trees, muted and yellow.'), nl,
    write('The path continues north. South leads back.'), nl.

describe(village_entrance) :-
    write('A weathered wooden sign: "Kalmbach — Est. 1648."'), nl,
    write('The road becomes cobblestone. Shutters closed everywhere.'), nl,
    write('No sound. No movement.'), nl,
    write('And yet — at the edge of the light stands an old woman,'), nl,
    write('watching you as if she had been waiting.'), nl.

/* ===================== Details (from 2nd look) ===================== */

details(crash_site) :-
    record_clue('Crash site: Two sets of tire tracks on the road — not just yours. Someone drove very close to you.'),
    write('You scan the road. Two sets of tire tracks in the mud.'), nl,
    write('One of them is not yours. Someone came very close'), nl,
    write('just before the ditch.'), nl.

details(forest_path) :-
    record_clue('Forest path: Fresh footprints in the mud heading toward the village — several people, very recent.'),
    write('In the mud at the edge of the trail: footprints. Several.'), nl,
    write('All heading toward the village. Fresh — edges still sharp.'), nl,
    write('Minutes ago.'), nl.

details(village_entrance) :-
    record_clue('Village entrance: The old woman used your name — you never introduced yourself.'),
    write('You replay it. The woman said something as you approached.'), nl,
    write('"Leon." Just that. No hello, no where-are-you-from.'), nl,
    write('You never told her your name.'), nl.

details(_).

/* ===================== Characters ===================== */

character_at(erna, village_entrance).

talk :-
    i_am_at(Place),
    character_at(Name, Place),
    interact(Name), !.
talk :-
    write('There is no one here to talk to.'), nl.

interact(erna) :-
    trust(erna, neutral),
    write('The old woman holds your gaze. Her eyes do not move.'), nl,
    write('"You should not be here. Not tonight."'), nl,
    write('A pause.'), nl,
    write('"But you are. So go to the inn. Hilde will let you in."'), nl,
    write('She turns away. The conversation is over.'), nl,
    write('Do you trust her? (trust_her. / doubt_her.)'), nl, !.

interact(erna) :-
    trust(erna, trusted),
    write('Erna stands still. As you approach, she turns her head'), nl,
    write('almost imperceptibly toward the church.'), nl,
    write('"The priest knows more than he says. Ask him about 1987."'), nl, !.

interact(erna) :-
    trust(erna, doubted),
    write('Erna looks at you. Almost smiles.'), nl,
    write('"You are careful. Good."'), nl,
    write('Nothing more.'), nl, !.

/* ===================== Trust Decisions ===================== */

trust_her :-
    i_am_at(village_entrance),
    trust(erna, neutral),
    retract(trust(erna, _)),
    assert(trust(erna, trusted)),
    write('You nod. Something about her feels... sincere. Or at least'), nl,
    write('like she has nothing to gain.'), nl, !.

trust_her :-
    i_am_at(village_entrance),
    write('You have already made your decision.'), nl, !.

doubt_her :-
    i_am_at(village_entrance),
    trust(erna, neutral),
    retract(trust(erna, _)),
    assert(trust(erna, doubted)),
    write('Why did she know your name? Why was she standing right here?'), nl,
    write('You note her words — but you do not believe them.'), nl, !.

doubt_her :-
    i_am_at(village_entrance),
    write('You have already made your decision.'), nl, !.

/* ===================== Take / Drop / Inventory ===================== */

take(X) :-
    holding(X),
    write('You are already holding it.'), nl, !.

take(X) :-
    i_am_at(Place),
    at(X, Place),
    retract(at(X, Place)),
    assert(holding(X)),
    write('Taken.'), nl, !.

take(_) :-
    write('You do not see that here.'), nl.

drop(X) :-
    holding(X),
    i_am_at(Place),
    retract(holding(X)),
    assert(at(X, Place)),
    write('Dropped.'), nl, !.

drop(_) :-
    write('You are not carrying that.'), nl.

inventory :-
    write('=== Inventory ==='), nl,
    list_items.

list_items :-
    holding(X),
    write('  - '), write(X), nl,
    fail.
list_items :-
    \+ holding(_),
    write('  Empty.'), nl, !.
list_items.

/* ===================== Clues ===================== */

record_clue(Text) :-
    clue(Text), !.
record_clue(Text) :-
    assert(clue(Text)).

notes :-
    write('=== Notes ==='), nl,
    list_clues.

list_clues :-
    clue(X),
    write('  - '), write(X), nl,
    fail.
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
    nl.

notice_items(Place) :-
    at(X, Place),
    write('You see: '), write(X), write('.'), nl,
    fail.
notice_items(_).

/* ===================== Movement ===================== */

n :- go(n).
s :- go(s).
e :- go(e).
w :- go(w).

go(Dir) :-
    i_am_at(Here),
    path(Here, Dir, There),
    retract(i_am_at(Here)),
    assert(i_am_at(There)),
    look, !.
go(_) :-
    write('You cannot go that way.'), nl.

/* ===================== Engine ===================== */

help :- instructions.
quit :- halt.

instructions :-
    write('-------------------------------------------------------'), nl,
    write('  Commands:'), nl,
    write('  n. / s. / e. / w.   -> move in a direction'), nl,
    write('  look.               -> examine your surroundings'), nl,
    write('  talk.               -> speak to someone nearby'), nl,
    write('  take(X).            -> pick up an item'), nl,
    write('  drop(X).            -> put down an item'), nl,
    write('  inventory.          -> show carried items'), nl,
    write('  notes.              -> show discovered clues'), nl,
    write('  help.               -> show this list'), nl,
    write('  quit.               -> quit the game'), nl,
    write('-------------------------------------------------------'), nl, nl.

/* ===================== Start ===================== */

start :-
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
