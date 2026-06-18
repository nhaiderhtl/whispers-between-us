:- dynamic i_am_at/1, at/2, holding/1, trust/2, looked_at/2, clue/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(holding(_)),
   retractall(trust(_, _)), retractall(looked_at(_, _)), retractall(clue(_)).

/* Initial State */
i_am_at(dark_hallway).
trust(marcus, neutral).

/* Locations and Paths */
path(dark_hallway, n, storage_room).
path(storage_room, s, dark_hallway).

/* Character Interaction */
talk :-
    i_am_at(Place),
    character_at(Name, Place),
    interact(Name), !.
talk :-
    write('There is no one here to talk to.'), nl.

character_at(marcus, storage_room).

interact(marcus) :-
    trust(marcus, neutral),
    write('Marcus: "Did you hear that? I think something is in the walls."'), nl,
    write('Do you trust him? (trust_him. / doubt_him.)'), nl, !.

interact(marcus) :-
    trust(marcus, trusted),
    write('Marcus looks at you. "We need to keep moving. Together."'), nl, !.

interact(marcus) :-
    trust(marcus, doubted),
    write('Marcus stays away from you, watching the walls in silence.'), nl, !.

/* Decisions */
trust_him :-
    i_am_at(storage_room),
    trust(marcus, neutral),
    retract(trust(marcus, _)),
    assert(trust(marcus, trusted)),
    write('You nod. Marcus looks relieved. "We stay together then."'), nl, !.

trust_him :-
    i_am_at(storage_room),
    write('You have already made your decision regarding Marcus.'), nl, !.

doubt_him :-
    i_am_at(storage_room),
    trust(marcus, neutral),
    retract(trust(marcus, _)),
    assert(trust(marcus, doubted)),
    write('You look at him skeptically. Marcus narrows his eyes. "Fine. Watch your own back."'), nl, !.

doubt_him :-
    i_am_at(storage_room),
    write('You have already made your decision regarding Marcus.'), nl, !.

/* Descriptions */
describe(dark_hallway) :-
    write('You are in a cold, dark hallway. The air is thick with the smell of damp earth.'), nl,
    write('A door to the north leads to a storage room.'), nl.

describe(storage_room) :-
    write('The storage room is cluttered with old crates. Marcus is standing in the corner, looking pale.'), nl.

/* Details — shown only on second look, saved as clues */
details(dark_hallway) :-
    record_clue('Flur: Der Boden ist nass. Frische Schmutzspuren fuehren Richtung Norden.'),
    write('Der Boden ist nass. Frische Schmutzspuren fuehren Richtung Norden.'), nl.

details(storage_room) :-
    record_clue('Abstellraum: Hinter einer alten Kiste liegt ein zerknuelltes Stueck Papier.'),
    write('Hinter einer alten Kiste liegt ein zerknuelltes Stueck Papier.'), nl.

details(_).

/* Save clue only if not already known */
record_clue(Text) :-
    clue(Text), !.
record_clue(Text) :-
    assert(clue(Text)).

/* Look — tracks visits per room, shows details on second look */
look :-
    i_am_at(Place),
    describe(Place), nl,
    (   looked_at(Place, Count)
    ->  NewCount is Count + 1,
        retract(looked_at(Place, Count)),
        assert(looked_at(Place, NewCount))
    ;   assert(looked_at(Place, 1)),
        NewCount = 1
    ),
    (NewCount >= 2 -> details(Place) ; true),
    nl.

/* Notes — list all discovered clues */
notes :-
    write('=== Erkenntnisse ==='), nl,
    list_clues.

list_clues :-
    clue(X),
    write('  - '), write(X), nl,
    fail.
list_clues :-
    \+ clue(_),
    write('  Noch keine Erkenntnisse.'), nl, !.
list_clues.

/* Basic Engine */
help :- instructions.
quit :- halt.

n :- go(n).
s :- go(s).

go(Dir) :-
    i_am_at(Here),
    path(Here, Dir, There),
    retract(i_am_at(Here)),
    assert(i_am_at(There)),
    look, !.
go(_) :- write('You cannot go that way.'), nl.

instructions :-
    write('Commands:'), nl,
    write('  help.      -> show instructions'), nl,
    write('  n. / s.    -> go north / south'), nl,
    write('  look.      -> look around'), nl,
    write('  notes.     -> show discovered clues'), nl,
    write('  talk.      -> talk to someone'), nl,
    write('  trust_him. -> trust the character'), nl,
    write('  doubt_him. -> doubt the character'), nl,
    write('  quit.      -> quit the game'), nl, nl.

start :-
    instructions,
    look.
