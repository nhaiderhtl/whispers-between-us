:- dynamic i_am_at/1, at/2, holding/1, trust/2.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(holding(_)), retractall(trust(_, _)).

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
    write('Marcus: "Did you hear that? I think something is in the walls."'), nl,
    write('Do you trust him? (trust_him. / doubt_him.)'), nl.

/* Decisions */
trust_him :-
    i_am_at(storage_room),
    retract(trust(marcus, _)),
    assert(trust(marcus, trusted)),
    write('You nod. Marcus looks relieved. "We stay together then."'), nl, !.

doubt_him :-
    i_am_at(storage_room),
    retract(trust(marcus, _)),
    assert(trust(marcus, doubted)),
    write('You look at him skeptically. Marcus narrows his eyes. "Fine. Watch your own back."'), nl, !.

/* Descriptions */
describe(dark_hallway) :-
    write('You are in a cold, dark hallway. The air is thick with the smell of damp earth.'), nl,
    write('A door to the north leads to a storage room.'), nl.

describe(storage_room) :-
    write('The storage room is cluttered with old crates. Marcus is standing in the corner, looking pale.'), nl.

/* Basic Engine */
n :- go(n).
s :- go(s).

go(Dir) :-
    i_am_at(Here),
    path(Here, Dir, There),
    retract(i_am_at(Here)),
    assert(i_am_at(There)),
    look, !.
go(_) :- write('You cannot go that way.'), nl.

look :-
    i_am_at(Place),
    describe(Place), nl.

instructions :-
    write('Commands:
     n. -> go north
     s. -> go south 
     look. -> look around
     talk. -> talk to someone
     trust_him. -> trust the character
     doubt_him. -> doubt the character
     quit. or halt. -> quit the game
     
     '), nl.

start :-
    instructions,
    look.
