:- dynamic i_am_at/1, at/2, holding/1, trust/2, looked_at/2, clue/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(holding(_)),
   retractall(trust(_, _)), retractall(looked_at(_, _)), retractall(clue(_)).

/* ===================== Anfangszustand ===================== */

i_am_at(unfallort).
trust(erna, neutral).

/* ===================== Karte ===================== */

path(unfallort, n, waldweg).
path(waldweg, s, unfallort).
path(waldweg, n, dorfeingang).
path(dorfeingang, s, waldweg).

/* ===================== Items ===================== */

at(taschenlampe, unfallort).

/* ===================== Raumbeschreibungen ===================== */

describe(unfallort) :-
    write('Dein Auto liegt schraeg im Strassengraben, die Vorderachse'), nl,
    write('geknickt. Ringsherum Wald. Der Regen hat aufgehoert, aber'), nl,
    write('der Nebel haengt tief. Irgendwo im Dickicht knackt etwas.'), nl,
    write('Ein schmaler Waldweg fuehrt nach Norden.'), nl.

describe(waldweg) :-
    write('Ein enger Pfad zwischen alten Fichten. Die Baeume schliessen'), nl,
    write('sich fast ueber dir. Das Dorf muss nah sein — du kannst'), nl,
    write('Licht durch die Aeste sehen, gedaempft und gelb.'), nl,
    write('Der Weg fuehrt weiter nach Norden, zurueck nach Sueden.'), nl.

describe(dorfeingang) :-
    write('Ein verwittertes Holzschild: "Kalmbach — Gegruendet 1648."'), nl,
    write('Die Strasse wird zu Kopfsteinpflaster. Fensterlaeden ueberall'), nl,
    write('geschlossen. Kein Gerausch. Keine Bewegung.'), nl,
    write('Und doch — am Rand des Lichtkegels steht eine alte Frau'), nl,
    write('und sieht dich an, als haette sie auf dich gewartet.'), nl.

/* ===================== Details (ab 2. look) ===================== */

details(unfallort) :-
    record_clue('Unfallort: Zwei Reifenspuren auf der Strasse — nicht nur deine. Jemand ist dicht an dir vorbeigefahren.'),
    write('Du schaust die Strasse entlang. Zwei Reifenspuren im Schlamm.'), nl,
    write('Eine davon — nicht deine. Jemand ist sehr dicht an dir'), nl,
    write('vorbeigefahren. Kurz vor dem Graben.'), nl.

details(waldweg) :-
    record_clue('Waldweg: Frische Fussspuren im Schlamm Richtung Dorf — mehrere Personen, vor Kurzem.'),
    write('Im Schlamm am Wegrand: Fussspuren. Mehrere. Alle Richtung Dorf.'), nl,
    write('Frisch — die Kanten noch scharf. Vor wenigen Minuten.'), nl.

details(dorfeingang) :-
    record_clue('Dorfeingang: Die alte Frau hat dich beim Namen genannt — obwohl du dich nicht vorgestellt hast.'),
    write('Du erinnerst dich: die Frau hat etwas gesagt als du naeherkamst.'), nl,
    write('"Leon." Nur das. Kein Hallo, kein Woher-kommst-du.'), nl,
    write('Du hast dich nicht vorgestellt.'), nl.

details(_).

/* ===================== Charaktere ===================== */

character_at(erna, dorfeingang).

talk :-
    i_am_at(Place),
    character_at(Name, Place),
    interact(Name), !.
talk :-
    write('Hier ist niemand, mit dem du reden koenntest.'), nl.

interact(erna) :-
    trust(erna, neutral),
    write('Die alte Frau sieht dich an. Ihre Augen bewegen sich nicht.'), nl,
    write('"Du solltest nicht hier sein. Nicht heute Nacht."'), nl,
    write('Sie macht eine Pause.'), nl,
    write('"Aber du bist hier. Also geh ins Wirtshaus. Hilde laesst dich rein."'), nl,
    write('Sie dreht sich um. Das Gespraech ist beendet.'), nl,
    write('Vertraust du ihr? (vertrauen. / misstrauen.)'), nl, !.

interact(erna) :-
    trust(erna, trusted),
    write('Erna steht reglos. Als du naherkommst, dreht sie den Kopf'), nl,
    write('kaum merklich Richtung Kirche.'), nl,
    write('"Der Pfarrer weiss mehr als er sagt. Frag ihn nach 1987."'), nl, !.

interact(erna) :-
    trust(erna, doubted),
    write('Erna sieht dich an. Laechelt fast.'), nl,
    write('"Du bist vorsichtig. Gut."'), nl,
    write('Mehr sagt sie nicht.'), nl, !.

/* ===================== Entscheidungen ===================== */

vertrauen :-
    i_am_at(dorfeingang),
    trust(erna, neutral),
    retract(trust(erna, _)),
    assert(trust(erna, trusted)),
    write('Du nickst. Irgendwas an ihr wirkt... aufrichtig. Oder zumindest'), nl,
    write('so, als haette sie nichts zu gewinnen.'), nl, !.

vertrauen :-
    i_am_at(dorfeingang),
    write('Du hast deine Entscheidung bereits getroffen.'), nl, !.

misstrauen :-
    i_am_at(dorfeingang),
    trust(erna, neutral),
    retract(trust(erna, _)),
    assert(trust(erna, doubted)),
    write('Warum wusste sie deinen Namen? Warum stand sie genau hier?'), nl,
    write('Du merkst dir ihre Worte — aber glaubst ihnen nicht.'), nl, !.

misstrauen :-
    i_am_at(dorfeingang),
    write('Du hast deine Entscheidung bereits getroffen.'), nl, !.

/* ===================== Items nehmen/ablegen ===================== */

nehmen(X) :-
    holding(X),
    write('Du haeltst es bereits in der Hand.'), nl, !.

nehmen(X) :-
    i_am_at(Place),
    at(X, Place),
    retract(at(X, Place)),
    assert(holding(X)),
    write('Genommen.'), nl, !.

nehmen(_) :-
    write('Das siehst du hier nicht.'), nl.

ablegen(X) :-
    holding(X),
    i_am_at(Place),
    retract(holding(X)),
    assert(at(X, Place)),
    write('Abgelegt.'), nl, !.

ablegen(_) :-
    write('Du traegst das nicht bei dir.'), nl.

inventar :-
    write('=== Inventar ==='), nl,
    list_items.

list_items :-
    holding(X),
    write('  - '), write(X), nl,
    fail.
list_items :-
    \+ holding(_),
    write('  Leer.'), nl, !.
list_items.

/* ===================== Erkenntnisse ===================== */

record_clue(Text) :-
    clue(Text), !.
record_clue(Text) :-
    assert(clue(Text)).

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
    write('Du siehst: '), write(X), write('.'), nl,
    fail.
notice_items(_).

/* ===================== Bewegung ===================== */

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
    write('In diese Richtung kommst du nicht weiter.'), nl.

/* ===================== Engine ===================== */

help :- instructions.
quit :- halt.

instructions :-
    write('-------------------------------------------------------'), nl,
    write('  Befehle:'), nl,
    write('  n. / s. / e. / w.   -> Richtung gehen'), nl,
    write('  look.               -> Umgebung betrachten'), nl,
    write('  talk.               -> mit jemandem reden'), nl,
    write('  nehmen(X).          -> Item aufheben'), nl,
    write('  ablegen(X).         -> Item ablegen'), nl,
    write('  inventar.           -> Inventar anzeigen'), nl,
    write('  notes.              -> Erkenntnisse anzeigen'), nl,
    write('  help.               -> Befehle anzeigen'), nl,
    write('  quit.               -> Spiel beenden'), nl,
    write('-------------------------------------------------------'), nl, nl.

/* ===================== Start ===================== */

start :-
    nl,
    write('======================================================='), nl,
    write('              WHISPERS BETWEEN US'), nl,
    write('======================================================='), nl,
    nl,
    write('Der Regen hat aufgehoert.'), nl,
    nl,
    write('Du weisst nicht wie lange du bewusstlos warst.'), nl,
    write('Das Armaturenbrett ist kalt. Die Scheibe beschlagen.'), nl,
    write('Draussen: Wald. Stille. Und etwas, das sich wie'), nl,
    write('Beobachtetwerden anfuehlt.'), nl,
    nl,
    write('Dein Handy zeigt kein Signal.'), nl,
    write('Die Vorderachse ist geknickt.'), nl,
    write('Du kommst hier nicht weg — nicht mit dem Auto.'), nl,
    nl,
    write('Etwa einen Kilometer die Strasse runter siehst du Lichter.'), nl,
    nl,
    write('Es ist kurz nach 22 Uhr. Heute ist Vollmond.'), nl,
    nl,
    instructions,
    write('Du steigst aus dem Auto.'), nl,
    nl,
    look.
