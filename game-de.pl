:- dynamic ich_bin_in/1, bei/2, habe/1, vertrauen/2, angesehen/2, hinweis/1,
            spielzeit/1, frist/1, glocke_gelaeutet/0, spiel_ende/0, hinweis_gegeben/1.
:- retractall(bei(_, _)), retractall(ich_bin_in(_)), retractall(habe(_)),
   retractall(vertrauen(_, _)), retractall(angesehen(_, _)), retractall(hinweis(_)),
   retractall(spielzeit(_)), retractall(frist(_)),
   retractall(glocke_gelaeutet), retractall(spiel_ende).

/* ===================== Ausgangszustand ===================== */

ich_bin_in(unfallstelle).
vertrauen(erna,     neutral).
vertrauen(hilde,    neutral).
vertrauen(jakob,    neutral).
vertrauen(benedikt, neutral).
vertrauen(otto,     neutral).

/* Zeit: vergangene Minuten seit 22 Uhr. Mitternacht = Frist (120 Min). */
spielzeit(0).
frist(120).

/* ===================== Karte ===================== */

pfad(unfallstelle,       n,  waldweg).
pfad(waldweg,      s,  unfallstelle).
pfad(waldweg,      n,  dorfeingang).
pfad(dorfeingang, s,  waldweg).
pfad(dorfeingang, n,  dorfplatz).
pfad(dorfplatz,   s,  dorfeingang).
pfad(dorfplatz, w, kneipe) :-
    \+ vertrauen(hilde, gefuerchtet), !.
pfad(dorfplatz, w, kneipe) :-
    write('Die Tuer ist verschlossen. Durch das Glas ist die Kneipe dunkel.'), nl,
    write('Du koenntest klopfen. (klopfen.)'), nl, fail.
pfad(kneipe,              o,  dorfplatz).
pfad(dorfplatz,   n,  friedhof).
pfad(friedhof,        s,  dorfplatz).
pfad(friedhof,        n,  kircheninneres).
pfad(kircheninneres,  s,  friedhof).
pfad(buergermeisterhaus,     w,  dorfplatz).
pfad(dorfplatz,   sw, scheune).
pfad(scheune,             no, dorfplatz).
pfad(wald,           so, dorfplatz).

pfad(kneipe, runter, kneipenkeller) :-
    (vertrauen(hilde, vertraut) ; vertrauen(hilde, ergeben) ; habe(kellerschluessel)), !.
pfad(kneipe, runter, kneipenkeller) :-
    write('Die Kellertuer ist verriegelt.'), nl, fail.
pfad(kneipenkeller, rauf, kneipe).

pfad(kircheninneres, runter, krypta) :-
    habe(krypta_code), !.
pfad(kircheninneres, runter, krypta) :-
    write('Eine steinerne Tuer, versiegelt mit einer Symbolreihe im Rahmen.'), nl,
    write('Du kennst die Sequenz noch nicht.'), nl, fail.
pfad(krypta, rauf, kircheninneres).

pfad(dorfplatz, o, buergermeisterhaus) :-
    (vertrauen(benedikt, vertraut) ; vertrauen(benedikt, ergeben) ; habe(buergermeister_schluessel)), !.
pfad(dorfplatz, o, buergermeisterhaus) :-
    write('Die Haustuer ist abgeschlossen. Schwerer Eisenriegel, kein Griff auf dieser Seite.'), nl, fail.

pfad(dorfplatz, nw, wald) :-
    habe(spiegel), !.
pfad(dorfplatz, nw, wald) :-
    write('Der Waldrand versinkt in der Dunkelheit. Du findest keinen Weg hindurch.'), nl, fail.

/* Rohe Ausgaenge fuer Richtungsanzeige (ohne Nebenwirkungen) */
roher_ausgang(unfallstelle,       n,  waldweg).
roher_ausgang(waldweg,      s,  unfallstelle).
roher_ausgang(waldweg,      n,  dorfeingang).
roher_ausgang(dorfeingang, s,  waldweg).
roher_ausgang(dorfeingang, n,  dorfplatz).
roher_ausgang(dorfplatz,   s,  dorfeingang).
roher_ausgang(dorfplatz,   w,  kneipe).
roher_ausgang(kneipe,              o,  dorfplatz).
roher_ausgang(dorfplatz,   n,  friedhof).
roher_ausgang(friedhof,        s,  dorfplatz).
roher_ausgang(friedhof,        n,  kircheninneres).
roher_ausgang(kircheninneres,  s,  friedhof).
roher_ausgang(buergermeisterhaus,     w,  dorfplatz).
roher_ausgang(dorfplatz,   sw, scheune).
roher_ausgang(scheune,             no, dorfplatz).
roher_ausgang(wald,           so, dorfplatz).
roher_ausgang(kneipe,              runter,  kneipenkeller).
roher_ausgang(kneipenkeller,       rauf,  kneipe).
roher_ausgang(kircheninneres,  runter,  krypta).
roher_ausgang(krypta,            rauf,  kircheninneres).
roher_ausgang(dorfplatz,   o,  buergermeisterhaus).
roher_ausgang(dorfplatz,   nw, wald).

/* ===================== Gegenstaende ===================== */

bei(taschenlampe,    unfallstelle).
bei(seil,          unfallstelle).
bei(brunnen_notiz,     dorfplatz).
bei(spiegel,        kneipe).
bei(hildes_tagebuch,  kneipenkeller).
bei(kirchenaufzeichnung, kircheninneres).
bei(krypta_code,    friedhof).
bei(brief,        krypta).
bei(autoschluessel,       scheune).
bei(ottos_tagebuch,   buergermeisterhaus).

/* ===================== Raumbeschreibungen ===================== */

beschreibe(unfallstelle) :-
    write('Dein Auto liegt schraeg im Strassengraben, die Vorderachse'), nl,
    write('gebrochen. Ueberall Wald. Der Regen hat aufgehoert, aber der Nebel'), nl,
    write('haengt tief. Im Unterholz knackt etwas.'), nl,
    write('Ein schmaler Pfad fuehrt nach Norden.'), nl.

beschreibe(waldweg) :-
    write('Ein enger Pfad zwischen alten Fichten. Aeste ragen von oben herein.'), nl,
    write('Das Dorf muss nah sein – durch die Baeume siehst du Licht,'), nl,
    write('daempft und gelb. Der Weg fuehrt weiter nach Norden. Sueden geht zurueck.'), nl.

beschreibe(dorfeingang) :-
    write('Ein verwittertes Holzschild: "Kalmbach – Erbaut 1648."'), nl,
    write('Die Strasse wird zum Kopfsteinpflaster. Ueberall geschlossene Fensterlaeden.'), nl,
    write('Kein Laut. Keine Bewegung.'), nl,
    write('Und doch – am Rand des Lichts steht eine alte Frau,'), nl,
    write('die dich ansieht, als haette sie gewartet.'), nl.

beschreibe(dorfplatz) :-
    write('Ein kleiner Platz mit einem steinernen Brunnen in der Mitte. Jedes Fenster'), nl,
    write('ist dunkel. Die Laeden sind alle geschlossen – aber nicht alle verriegelt.'), nl,
    write('Du hoerst deine eigenen Schritte zu deutlich.'), nl,
    write('Die Kneipe ist im Westen. Eine Kirche im Norden.'), nl,
    write('Ein grosses Haus im Osten. Eine Scheune irgendwo im Suedwesten.'), nl.

beschreibe(kneipe) :-
    write('Warmer Raum, Holzrauch, niedrige Decke. Eine Frau hinter der Theke'), nl,
    write('wischt ein Glas, das laengst sauber ist. Sie laechelt, bevor du'), nl,
    write('die Tuer ganz geoeffnet hast.'), nl,
    write('"Du musst ja frozen sein. Setz dich."'), nl.

beschreibe(kneipenkeller) :-
    write('Steinstufen, kalt und feucht. Reihen von Weinfassern, die meisten leer.'), nl,
    write('Eine einzige nackte Gluehbirne flackert ueber dir.'), nl,
    write('An der gegenueberliegenden Wand: eine Matratze. Eine gefaltete Decke.'), nl,
    write('Jemand hat hier unten gewohnt.'), nl.

beschreibe(friedhof) :-
    write('Der Kirchhof ist ueberwuchert, Steine in seltsamen Winkeln geneigt.'), nl,
    write('Die meisten Namen sind vom Wetter ausgewaschen. Ein Grab nahe'), nl,
    write('der Kirchenmauer ist neuer als die anderen.'), nl,
    write('Ein kleines Maedchen sitzt darauf und sieht dich an.'), nl.

beschreibe(kircheninneres) :-
    write('Kalte Steine und altes Wachs. Kerzen brennen am Gang entlang,'), nl,
    write('obwohl du niemanden gesehen hast, der sie angezuendet hat.'), nl,
    write('Ein Mann in dunkler Robe kniet am fernen Ende, regungslos.'), nl,
    write('Er sieht nicht auf, als du eintrittst.'), nl.

beschreibe(krypta) :-
    write('Unter der Kirche. Die Luft ist vollkommen still.'), nl,
    write('Steinplatten saeumen den Boden, jede mit Namen und Daten graviert.'), nl,
    write('Eine Platte nahe der hinteren Wand wurde verschoben – vor Kurzem.'), nl,
    write('Etwas liegt in der Luecke.'), nl.

beschreibe(buergermeisterhaus) :-
    write('Eine saubere Diele, kalter Kamin, ueberall gerahmte Urkunden.'), nl,
    write('Ein Mann steht oben an der Treppe und sieht auf dich herab'), nl,
    write('mit einem Ausdruck, den du nicht ganz deuten kannst.'), nl.

beschreibe(scheune) :-
    write('Die Scheunentuer schwingt auf, als du dich naeherst.'), nl,
    write('Heuballen, rostige Werkzeuge, der Geruch von Oel und feuchtem Holz.'), nl,
    write('Ein junger Mann steht hinten, die Arme verschraenkt,'), nl,
    write('als ob er nicht gewartet haette.'), nl.

beschreibe(wald) :-
    write('Die Baeume verschlucken jeden Laut. Der Spiegel hat dich zu einer Luecke'), nl,
    write('im Unterholz gefuehrt – einem Pfad, der auf keiner Karte steht.'), nl,
    write('Er fuehrt tiefer hinein. Der Dorfplatz ist zuruech im Suedosten.'), nl.

/* ===================== Details (zweiter Blick) ===================== */

details(unfallstelle) :-
    speichere_hinweis('Unfallstelle: Zwei Reifenspuren auf der Strasse. Jemand ist dir direkt vor dem Graben sehr nah gekommen.'),
    write('Du musterst die Strasse. Zwei Reifenspuren im Schlamm.'), nl,
    write('Eine gehoert nicht dir. Jemand kam sehr nah – direkt vor dem Graben.'), nl.

details(waldweg) :-
    speichere_hinweis('Waldweg: Frische Fussspuren im Schlamm, Richtung Dorf. Mehrere Personen. Vor Minuten.'),
    write('Im Schlamm am Rand des Pfades: Fussspuren.'), nl,
    write('Mehrere. Alle Richtung Dorf. Die Raender noch scharf – vor Minuten.'), nl.

details(dorfeingang) :-
    speichere_hinweis('Dorfzugang: Die alte Frau hat deinen Namen benutzt. Du hast dich nie vorgestellt.'),
    write('Du gehst es durch. Sie hat etwas gesagt, als du dich naehertest.'), nl,
    write('"Leon." Nur das. Du hast ihr nie deinen Namen gesagt.'), nl.

details(dorfplatz) :-
    speichere_hinweis('Dorfplatz: Der Zettel am Brunnen hat ein Datum – vor drei Monaten. Zur selben Zeit wurde der Brief in der Krypta geschrieben.'),
    write('Du pruefst den Zettel noch einmal. Ein Datum in der Ecke, fast zu blass.'), nl,
    write('Vor drei Monaten. Jemand hat das lange im Voraus geplant.'), nl.

details(kneipe) :-
    speichere_hinweis('Kneipe: Der Spiegel ist zur Tuer hin ausgerichtet, nicht zum Raum. Wer hinter der Theke steht, kann sehen, wer eintritt, ohne aufzusehen.'),
    write('Der Spiegel an der Wand ist falsch ausgerichtet – nicht zum Raum.'), nl,
    write('Zur Tuer hin. Eine perfekte Sicht auf jeden Eingang hinter der Bar.'), nl.

details(kneipenkeller) :-
    speichere_hinweis('Keller der Kneipe: Die Decke hat Initialen in der Ecke eingenaeht. Nicht Hildes Initialen.'),
    write('Du faltest die Decke auseinander. Initialen mit kleinen, sorgfaeltigen Stichen eingenaeht.'), nl,
    write('Nicht H. Nicht Hilde. Jemand anders hat sich hier versteckt.'), nl.

details(friedhof) :-
    speichere_hinweis('Friedhof: Das neueste Grab hat frische Blumen – heute hingelegt. Der Stein sagt: Mia Haas, 2004-2014. Sie ist seit zehn Jahren tot.'),
    write('Das neueste Grab hat frische Wildblumen – heute hingelegt.'), nl,
    write('Der Stein sagt: Mia Haas. Geboren 2004. Gestorben 2014.'), nl,
    write('Vor zehn Jahren.'), nl.

details(kircheninneres) :-
    speichere_hinweis('Kircheninneres: Die Kerzen markieren jede dritte Bank auf der linken Seite. Sieben Kerzen. Sieben neuere Graeber auf dem Kirchhof.'),
    write('Die Kerzen sind nicht zufaellig. Jede dritte Bank auf der linken Seite.'), nl,
    write('Due zaehlst: sieben. Dieselbe Anzahl wie die neueren Graeber draussen.'), nl.

details(krypta) :-
    speichere_hinweis('Krypta: Die verschobene Platte hat tiefe Kratzer auf der Innenseite. Jemand wurde eingeschlossen und versuchte herauszukommen.'),
    write('Du siehst dir die Unterseite der verschobenen Platte an.'), nl,
    write('Kratzspuren. Tief. Von innen gemacht.'), nl.

details(buergermeisterhaus) :-
    speichere_hinweis('Haus des Buergermeisters: Ein Gruppenfoto von 1987 hat ein rot eingekreistes Gesicht. Es ist Erna.'),
    write('Ein gerahmtes Foto – das ganze Dorf, vor Jahrzehnten.'), nl,
    write('Ein Gesicht mit rotem Marker eingekreist. Du erkennst die Augen.'), nl,
    write('Erna. Unter dem Rahmen, mit Bleistift geschrieben: "1987."'), nl.

details(scheune) :-
    speichere_hinweis('Scheune: Ein Oelfleck zeichnet ein Auto nach, das nicht mehr da ist. Jakobs Auto wurde vor sehr kurzer Zeit bewegt.'),
    write('Ein Oelfleck auf dem Scheunenboden – der Umriss eines Autos.'), nl,
    write('Der Fleck ist an den Raendern noch frisch. Vor Kurzem bewegt.'), nl.

details(wald) :-
    speichere_hinweis('Wald: Ein Stofffetzen an einem Ast. Gleiches Muster wie die Decke im Keller der Kneipe.'),
    write('Ein Stofffetzen an einem tiefen Ast.'), nl,
    write('Du kennst dieses Muster – die Decke im Keller der Kneipe.'), nl.

details(_).

/* ===================== Charaktere ===================== */

charakter_in(erna,     dorfeingang).
charakter_in(hilde,    kneipe).
charakter_in(jakob,    scheune).
charakter_in(benedikt, kircheninneres).
charakter_in(mia,      friedhof).
charakter_in(otto,     buergermeisterhaus).

reden :- spiel_ende, !, spiel_ende_nachricht.
reden :-
    ich_bin_in(Ort),
    charakter_in(Name, Ort),
    interagiere(Name), !.
reden :-
    write('Hier ist niemand, mit dem du reden kannst.'), nl.

/* Erna */
interagiere(erna) :- vertrauen(erna, neutral),
    write('"Du solltest nicht hier sein. Nicht heute Nacht."'), nl,
    write('Eine Pause. "Aber du bist hier. Geh zur Kneipe. Hilde laesst dich rein."'), nl,
    write('Sie dreht sich weg.'), nl,
    write('Vertraust du ihr? (vertrauen. / zweifeln.)'), nl, !.
interagiere(erna) :- vertrauen(erna, vertraut),
    write('Sie dreht den Kopf fast unmerklich zur Kirche.'), nl,
    write('"Der Pfarrer weiss mehr, als er sagt. Frag ihn nach 1987."'), nl, !.
interagiere(erna) :- vertrauen(erna, angezweifelt),
    write('Erna sieht dich an. Ein fastes Laecheln. "Du bist vorsichtig. Gut."'), nl, !.
interagiere(erna) :- vertrauen(erna, gefuerchtet),
    write('Erna ist weg. Nur Fussspuren im Schlamm, wo sie stand.'), nl, !.

/* Hilde */
interagiere(hilde) :- vertrauen(hilde, neutral),
    write('"Schwere Nacht? Du kannst hier bleiben – kostenlos.'), nl,
    write('Die Strassen sind schlecht bei so einem Wetter."'), nl,
    write('Sie ist warm. Zu warm fuer 22 Uhr.'), nl,
    write('Vertraust du ihr? (vertrauen. / zweifeln.)'), nl, !.
interagiere(hilde) :- vertrauen(hilde, vertraut),
    write('"Da unten ist etwas, das du sehen solltest.'), nl,
    write('Jemand hat hier gewohnt. Kein Gast."'), nl,
    write('Sie schiebt dir einen Schluessel ueber die Theke.'), nl,
    (habe(kellerschluessel) -> true ;
     bei(kellerschluessel, _)   -> true ;
     assert(habe(kellerschluessel)), write('Du nimmst den Kellerschluessel.'), nl), !.
interagiere(hilde) :- vertrauen(hilde, ergeben),
    write('"Nimm mich mit, wenn du gehst", sagt sie leise.'), nl,
    write('"Egal, was du findest – geh nicht ohne mich."'), nl, !.
interagiere(hilde) :- vertrauen(hilde, angezweifelt),
    write('Hilde wischt wieder die Theke. Sieht dich nicht an.'), nl,
    write('"Ich hoffe, du findest, was du brauchst."'), nl,
    write('Ihre Stimme ist flach. Etwas hat sich verschlossen.'), nl, !.

/* Jakob */
interagiere(jakob) :- vertrauen(jakob, neutral),
    write('"Bist du der, dessen Auto von der Strasse abkam? Hab''s gesehen."'), nl,
    write('Er macht eine Pause – einen Sekundenbruchteil zu lang.'), nl,
    write('"Ich hab''n Auto. Kann dich rausfahren, wenn du bereit bist."'), nl,
    write('Vertraust du ihm? (vertrauen. / zweifeln.)'), nl, !.
interagiere(jakob) :- vertrauen(jakob, vertraut),
    write('Jakob nickt und zieht einen Schluessel aus der Tasche.'), nl,
    write('"Das Auto steht direkt ausserhalb des Dorfs. Folge mir. Nicht anhalten."'), nl,
    (habe(autoschluessel) -> true ;
     retractall(bei(autoschluessel, _)), assert(habe(autoschluessel)),
     write('Er gibt dir den Schluessel.'), nl), !.
interagiere(jakob) :- vertrauen(jakob, angezweifelt),
    write('"Hoer mal, ich versuche dir zu helfen."'), nl,
    write('Er hat gesagt, er hat es gesehen. Von wo aus, genau?'), nl, !.
interagiere(jakob) :- vertrauen(jakob, gefuerchtet),
    write('Jakob weicht zurueck, als du eintrittst.'), nl,
    write('"Ich hab'' – es sollte nicht so laufen."'), nl,
    write('Er sieht dich nicht an.'), nl, !.

/* Vater Benedikt */
interagiere(benedikt) :- vertrauen(benedikt, neutral),
    write('Er steht nicht auf. Haelt den Blick auf den Altar gerichtet.'), nl,
    write('"Wir bekommen keine Besucher. Besonders nicht heute Nacht."'), nl,
    write('Ein langes Schweigen. "Die Kneipe hat noch offen. Geh dorthin."'), nl,
    write('Vertraust du ihm? (vertrauen. / zweifeln.)'), nl, !.
interagiere(benedikt) :- vertrauen(benedikt, vertraut),
    write('"Die Prozession ist nicht, was du denkst.'), nl,
    write('Es ist ein Ritual der Bewahrung. Der Fortfuehrung."'), nl,
    write('"Die Krypta birgt die Antwort. Aber versteh, was du findest,'), nl,
    write('bevor du danach handelst."'), nl,
    (habe(krypta_code) -> true ;
     write('Er fluestert die Sequenz. Du weisst jetzt, wie man die Krypta oeffnet.'), nl,
     retractall(bei(krypta_code, _)),
     assert(habe(krypta_code))), !.
interagiere(benedikt) :- vertrauen(benedikt, ergeben),
    write('Benedikt gibt dir wortlos einen kleinen eisernen Schluessel.'), nl,
    write('"Der Buergermeister folgt schon zu lange Befehlen.'), nl,
    write('Er muss das von jemandem von aussen hoeren."'), nl,
    (habe(buergermeister_schluessel) -> true ;
     retractall(bei(buergermeister_schluessel, _)), assert(habe(buergermeister_schluessel)),
     write('Er gibt dir den Schluessel zum Haus des Buergermeisters.'), nl), !.
interagiere(benedikt) :- vertrauen(benedikt, angezweifelt),
    write('Benedikt wendet sich wieder dem Altar zu.'), nl,
    write('"Dann kann ich dir nichts mehr sagen."'), nl, !.

/* Mia */
interagiere(mia) :-
    write('Das Maedchen sieht mit einem viel zu alten Gesichtsausdruck auf.'), nl,
    write('"Du solltest dir die Namen auf den Steinen ansehen. Die Daten sind wichtig."'), nl,
    write('Sie blinzelt nicht.'), nl,
    write('"Frag Hilde nach der Decke. Sie weiss, wem sie gehoerte."'), nl, !.

/* Buergermeister Otto */
interagiere(otto) :- vertrauen(otto, neutral),
    write('Der Buergermeister kommt zwei Stufen herunter und bleibt stehen.'), nl,
    write('"Dies ist ein Privathaus. Die Kneipe ist auf der anderen Seite des Platzes."'), nl,
    write('Seine Stimme ist geuebt. Amtlich.'), nl,
    write('Vertraust du ihm? (vertrauen. / zweifeln.)'), nl, !.
interagiere(otto) :- vertrauen(otto, vertraut),
    write('Otto setzt sich schwer auf die Treppe.'), nl,
    write('"Erna kam 1987 zu mir. Sagte mir, was das Dorf braucht, um zu ueberleben.'), nl,
    write('Ich hab'' ihr geglaubt. Wir alle."'), nl,
    write('Er sieht auf seine Haende. "Ich wusste nichts von den Briefen.'), nl,
    write('Ich wusste nicht, dass sie Leute ausgesucht hatte. Monate im Voraus."'), nl, !.
interagiere(otto) :- vertrauen(otto, angezweifelt),
    write('"Raus aus meinem Haus."'), nl,
    write('Er zeigt auf die Tuer. Seine Hand zittert.'), nl, !.

/* ===================== Vertrauensentscheidungen ===================== */

aktueller_charakter(erna)     :- ich_bin_in(dorfeingang).
aktueller_charakter(hilde)    :- ich_bin_in(kneipe).
aktueller_charakter(jakob)    :- ich_bin_in(scheune).
aktueller_charakter(benedikt) :- ich_bin_in(kircheninneres).
aktueller_charakter(otto)     :- ich_bin_in(buergermeisterhaus).

vertrauen_nachricht(erna,     'Irgendwas an ihr wirkt aufrichtig. Oder als haette sie nichts zu gewinnen.').
vertrauen_nachricht(hilde,    'Zu warm fuer 22 Uhr – aber vielleicht ist sie einfach so.').
vertrauen_nachricht(jakob,    'Er wirkt nervoes, aber ehrlich. Du brauchst ein Auto.').
vertrauen_nachricht(benedikt, 'Er hat dich noch nicht angelogen – oder du merkst es zumindest nicht.').
vertrauen_nachricht(otto,     'Er sieht mehr veraeangstigt aus als bedrohlich. Er koennte wirklich reden.').

zweifeln_nachricht(erna) :-
    write('Warum wusste sie deinen Namen? Du nimmst ihre Worte zur Kenntnis – aber vertraust ihnen nicht.'), nl.
zweifeln_nachricht(hilde) :-
    write('Zu freundlich. Zu bereit. Du haeltst Distanz.'), nl.
zweifeln_nachricht(jakob) :-
    write('Er hat gesagt, er hat es gesehen. Von wo aus, genau?'), nl,
    write('Du merkst es vor und sagst nichts.'), nl.
zweifeln_nachricht(benedikt) :-
    write('Ein Pfarrer, der um Mitternacht Rituale in einem unkartierten Dorf durchfuehrt.'), nl,
    write('Du behaeltst deine Gedanken fuer dich.'), nl.
zweifeln_nachricht(otto) :-
    write('Er fuehrt dieses Dorf. Was auch immer hier passiert ist, er ist nicht unschuldig.'), nl.

vertrauen :- spiel_ende, !, spiel_ende_nachricht.
vertrauen :-
    aktueller_charakter(Charakter), vertrauen(Charakter, neutral), !,
    retract(vertrauen(Charakter, _)), assert(vertrauen(Charakter, vertraut)),
    vertrauen_nachricht(Charakter, Nachricht), write(Nachricht), nl.
vertrauen :-
    aktueller_charakter(_), !,
    write('Du hast dich bereits entschieden.'), nl.
vertrauen :-
    write('Hier ist niemand, dem du vertrauen oder den du anzweifeln koenntest.'), nl.

zweifeln :- spiel_ende, !, spiel_ende_nachricht.
zweifeln :-
    aktueller_charakter(Charakter), vertrauen(Charakter, neutral), !,
    retract(vertrauen(Charakter, _)), assert(vertrauen(Charakter, angezweifelt)),
    zweifeln_nachricht(Charakter).
zweifeln :-
    aktueller_charakter(_), !,
    write('Du hast dich bereits entschieden.'), nl.
zweifeln :-
    write('Hier ist niemand, dem du vertrauen oder den du anzweifeln koenntest.'), nl.

konfrontiere_jakob :- spiel_ende, !, spiel_ende_nachricht.
konfrontiere_jakob :-
    ich_bin_in(scheune),
    hinweis('Unfallstelle: Zwei Reifenspuren auf der Strasse. Jemand ist dir direkt vor dem Graben sehr nah gekommen.'),
    hinweis('Hildes Tagebuch: Jakob hat Hilde zum Schweigen gedaengt. Sie weiss, dass er dich von der Strasse gedaengt hat.'),
    retract(vertrauen(jakob, _)), assert(vertrauen(jakob, gefuerchtet)),
    write('"Du sagtest, du hast es gesehen. Es gab zwei Spuren."'), nl,
    write('Jakob wird blass.'), nl,
    write('"Du hast mich von der Strasse gedaengt. Auf Ernas Befehl."'), nl,
    write('Er leugnet nicht. "Es sollte nicht – sie sagte, niemand wuerde verletzt."'), nl,
    speichere_hinweis('Jakob gestand: Er hat dich auf Ernas Befehl von der Strasse gedaengt.'), !.
konfrontiere_jakob :- ich_bin_in(scheune),
    write('Du hast noch nicht genug, um ihn zu konfrontieren.'), nl, !.
konfrontiere_jakob :-
    write('Jakob ist nicht hier.'), nl.


/* ===================== Vertrauensleiter (5 Stufen) ===================== */
/* gefuerchtet(-2) < angezweifelt(-1) < neutral(0) < vertraut(+1) < ergeben(+2) */

vertrauen_wert(gefuerchtet,   -2).
vertrauen_wert(angezweifelt,  -1).
vertrauen_wert(neutral,   0).
vertrauen_wert(vertraut,   1).
vertrauen_wert(ergeben,   2).

erhoehe_vertrauen(Charakter) :-
    vertrauen(Charakter, Aktuell), vertrauen_wert(Aktuell, V),
    V1 is min(V + 1, 2), vertrauen_wert(Neu, V1),
    retract(vertrauen(Charakter, _)), assert(vertrauen(Charakter, Neu)).

senke_vertrauen(Charakter) :-
    vertrauen(Charakter, Aktuell), vertrauen_wert(Aktuell, V),
    V1 is max(V - 1, -2), vertrauen_wert(Neu, V1),
    retract(vertrauen(Charakter, _)), assert(vertrauen(Charakter, Neu)).

/* Devoted erreichen – bestehendes Vertrauen vertiefen. */

beruhigen :- spiel_ende, !, spiel_ende_nachricht.
beruhigen :-
    aktueller_charakter(Charakter), !,
    beruhigen(Charakter).
beruhigen :-
    write('Hier ist niemand, den du beruhigen kannst.'), nl.

beruhigen(_) :- spiel_ende, !, spiel_ende_nachricht.
beruhigen(hilde) :-
    ich_bin_in(kneipe), vertrauen(hilde, vertraut),
    erhoehe_vertrauen(hilde),
    write('"Du kannst mit mir rechnen", sagst du zu ihr. Einen Moment lang glaubt sie es.'), nl,
    write('"Dann geh nicht ohne mich", sagt sie. "Versprich mir das."'), nl, !.
beruhigen(hilde) :-
    ich_bin_in(kneipe), vertrauen(hilde, ergeben),
    write('Sie hat sich bereits entschieden, dir alles anzuvertrauen.'), nl, !.
beruhigen(hilde) :-
    ich_bin_in(kneipe),
    write('Sie mustert dich. Es ist nicht der richtige Moment fuer Versprechen.'), nl, !.
beruhigen(jakob) :-
    ich_bin_in(scheune), vertrauen(jakob, vertraut),
    erhoehe_vertrauen(jakob),
    write('"Ich glaube dir, Jakob. Bring mich hier raus – egal, was es kostet."'), nl,
    write('Erloesung ueberflutet sein Gesicht. Oder etwas, das die Gestalt der Erloesung traegt.'), nl,
    write('"Dann bleib in meiner Naehe. Mach genau, was ich sage."'), nl, !.
beruhigen(jakob) :-
    ich_bin_in(scheune), vertrauen(jakob, ergeben),
    write('Jakob hat bereits dein volles Vertrauen. Vielleicht zu viel davon.'), nl, !.
beruhigen(jakob) :-
    ich_bin_in(scheune),
    write('Er hat sich diese Art von Vertrauen nicht verdient.'), nl, !.
beruhigen(Charakter) :-
    charakter_in(Charakter, _), \+ aktueller_charakter(Charakter), !,
    write('Diese Person ist nicht hier.'), nl.
beruhigen(_) :-
    write('Hier ist niemand, den du beruhigen kannst.'), nl.

anvertrauen :- spiel_ende, !, spiel_ende_nachricht.
anvertrauen :-
    aktueller_charakter(Charakter), !,
    anvertrauen(Charakter).
anvertrauen :-
    write('Hier ist niemand, dem du dich anvertrauen kannst.'), nl.

anvertrauen(_) :- spiel_ende, !, spiel_ende_nachricht.
anvertrauen(benedikt) :-
    ich_bin_in(kircheninneres), vertrauen(benedikt, vertraut),
    hinweis('Kirchenaufzeichnung: Ein Fremder muss Zeuge sein und sich frei entscheiden. Wenn er gegen seinen Willen festgehalten wird, bricht etwas. Die Aufzeichnung ist unvollstaendig.'),
    erhoehe_vertrauen(benedikt),
    write('Du erzaehlst ihm, was in der Aufzeichnung stand – der Teil ueber das freie Waehlen.'), nl,
    write('Etwas in ihm beruhigt sich. "Dann ist es vielleicht noch nicht zu spaet."'), nl, !.
anvertrauen(benedikt) :-
    ich_bin_in(kircheninneres), vertrauen(benedikt, vertraut),
    write('Er wartet. Du spuerst, er will Beweise, dass du es verstehst – lies zuerst die Kirchenaufzeichnung.'), nl, !.
anvertrauen(benedikt) :-
    ich_bin_in(kircheninneres),
    write('Er vertraut dir noch nicht genug, um es zu hoeren.'), nl, !.
anvertrauen(Charakter) :-
    charakter_in(Charakter, _), \+ aktueller_charakter(Charakter), !,
    write('Diese Person ist nicht hier.'), nl.
anvertrauen(_) :-
    write('Hier ist niemand, dem du dich anvertrauen kannst.'), nl.

/* ===================== Zeit & Glocke ===================== */

zeit_vorruecken(_) :- spiel_ende, !.
zeit_vorruecken(N) :-
    spielzeit(T), retract(spielzeit(T)),
    T1 is T + N, assert(spielzeit(T1)),
    frist(D),
    (T1 >= D -> ende_c ; true).

zeit_ausgeben :-
    spielzeit(T), Gesamt is 1320 + T,
    H is (Gesamt // 60) mod 24, M is Gesamt mod 60,
    (M < 10
    -> format('Die Kirchenuhr zeigt ~d:0~d.~n', [H, M])
    ;  format('Die Kirchenuhr zeigt ~d:~d.~n',  [H, M])
    ).

zeit :- spiel_ende, !, spiel_ende_nachricht.
zeit :- zeit_ausgeben.

glocke_laeuten :- spiel_ende, !, spiel_ende_nachricht.
glocke_laeuten :-
    ich_bin_in(kircheninneres), glocke_gelaeutet,
    write('Die Glocke hallt immer noch nach. Sie wird dir nicht zweimal Zeit kaufen.'), nl, !.
glocke_laeuten :-
    ich_bin_in(kircheninneres), habe(seil),
    assert(glocke_gelaeutet),
    frist(D), retract(frist(D)), D1 is D + 25, assert(frist(D1)),
    write('Du ziehst am Seil. Die alte Glocke sträubt sich, dann schwingt sie –'), nl,
    write('ein einzelner tiefer Ton rollt ueber Kalmbach.'), nl,
    write('Irgendwo schlaegt eine Tuer zu. Die Prozession wird heute Nacht zu spaet kommen.'), nl,
    speichere_hinweis('Du hast die Kirchenglocke gelaeutet. Die Prozession ist verzoegert – mehr Zeit.'), !.
glocke_laeuten :-
    ich_bin_in(kircheninneres),
    write('Ueber dir ist ein Glockenseilrahmen, aber kein Seil, um ihn zu erreichen.'), nl,
    write('Du brauchst ein Seil.'), nl, !.
glocke_laeuten :-
    write('Hier ist keine Glocke.'), nl.

/* ===================== Nehmen / Fallenlassen / Inventar ===================== */

nehmen :- write('Gib einen Gegenstand an. Beispiel: nehmen(taschenlampe).'), nl.
nehmen(X) :- var(X), !, write('Gib einen Gegenstand an. Beispiel: nehmen(taschenlampe).'), nl.
nehmen(_) :- spiel_ende, !, spiel_ende_nachricht.

nehmen(seil) :-
    bei(seil, unfallstelle), \+ habe(taschenlampe),
    write('Es ist zu dunkel, um in den Kofferraum zu sehen.'), nl, !.

nehmen(krypta_code) :-
    bei(krypta_code, friedhof), \+ habe(taschenlampe),
    write('Es ist zu dunkel, um die Inschrift zu entziffern.'), nl, !.

nehmen(spiegel) :-
    bei(spiegel, kneipe),
    vertrauen(hilde, ergeben), !,
    retract(bei(spiegel, kneipe)),
    assert(habe(spiegel)),
    write('Hilde hebt den Spiegel eigenhaendig von der Wand und haelt ihn hin.'), nl,
    write('"Er hat immer mehr als nur ein Spiegelbild gezeigt", sagt sie.'), nl.

nehmen(spiegel) :-
    bei(spiegel, kneipe), !,
    retract(vertrauen(hilde, _)), assert(vertrauen(hilde, gefuerchtet)),
    retract(ich_bin_in(_)), assert(ich_bin_in(dorfplatz)),
    write('"Raus."'), nl,
    write('Sie ist um die Theke herum, bevor du reagieren kannst.'), nl,
    write('Die Tuer schliesst sich schwer hinter dir.'), nl,
    write('Du stehst auf dem Platz. Das Licht in der Kneipe geht aus.'), nl.

nehmen(hildes_tagebuch) :-
    bei(hildes_tagebuch, kneipenkeller),
    retract(bei(hildes_tagebuch, kneipenkeller)),
    assert(habe(hildes_tagebuch)),
    write('Ein Tagebuch, hinter einem der Faesser versteckt.'), nl,
    write('Due blaetterst zu den letzten Eintraegen. Der Name Jakob taucht auf.'), nl,
    write('Und das Wort "Unfall" – in Anfuerungszeichen.'), nl,
    speichere_hinweis('Hildes Tagebuch: Jakob hat Hilde zum Schweigen gedaengt. Sie weiss, dass er dich von der Strasse gedaengt hat.'),
    (vertrauen(hilde, angezweifelt) ->
        retract(vertrauen(hilde, _)), assert(vertrauen(hilde, vertraut)),
        write('Deine Meinung ueber Hilde veraendert sich. Sie hat dich beschuetzt.')
    ; true), nl, !.

nehmen(X) :-
    habe(X),
    write('Du haeltst es bereits in der Hand.'), nl, !.

nehmen(X) :-
    ich_bin_in(Ort), bei(X, Ort),
    retract(bei(X, Ort)),
    assert(habe(X)),
    write('Genommen.'), nl, !.

nehmen(_) :-
    write('Das siehst du hier nicht.'), nl.


ablegen :- write('Gib einen Gegenstand an. Beispiel: ablegen(seil).'), nl.
ablegen(_) :- spiel_ende, !, spiel_ende_nachricht.
ablegen(X) :-
    habe(X), ich_bin_in(Ort),
    retract(habe(X)), assert(bei(X, Ort)),
    write('Fallen gelassen.'), nl, !.
ablegen(_) :-
    write('Das traegst du nicht bei dir.'), nl.

klopfen :- spiel_ende, !, spiel_ende_nachricht.
klopfen :-
    ich_bin_in(dorfplatz), vertrauen(hilde, gefuerchtet), !,
    retract(vertrauen(hilde, _)), assert(vertrauen(hilde, neutral)),
    write('Du klopfst. Einmal. Zweimal.'), nl,
    write('Eine lange Pause. Das Licht hinter der Scheibe bewegt sich.'), nl,
    write('Der Riegel klickt. Die Tuer oeffnet sich einen Spalt.'), nl,
    write('"Der Spiegel bleibt, wo er ist", sagt sie. "Verstanden?"'), nl.
klopfen :-
    write('Hier gibt es nichts, an das du klopfen koenntest.'), nl.

inventar :- spiel_ende, !, spiel_ende_nachricht.
inventar :-
    write('=== Inventar ==='), nl,
    zeige_gegenstaende.

zeige_gegenstaende :-
    habe(X), write('  - '), write(X), nl, fail.
zeige_gegenstaende :-
    \+ habe(_),
    write('  Leer.'), nl, !.
zeige_gegenstaende.

/* ===================== Lesen ===================== */

lesen :- write('Gib einen Gegenstand an. Beispiel: lesen(brief).'), nl.
lesen(_) :- spiel_ende, !, spiel_ende_nachricht.
lesen(brunnen_notiz) :-
    habe(brunnen_notiz),
    write('"Traue niemandem, der dir zu schnell hilft."'), nl,
    write('Kein Name. In der Ecke ein Datum – fast zu blass zum Lesen.'), nl, !.

lesen(hildes_tagebuch) :-
    habe(hildes_tagebuch),
    write('"J. kam wieder heute Nacht. Ich sagte ihm, ich wuerde nichts sagen.'), nl,
    write('Er erinnerte mich daran, was 2019 passiert ist."'), nl,
    write('"Der Mann von der Strasse – wenn er es rausfindet, ist J. erledigt.'), nl,
    write('Und ich auch. Aber ich kann nicht weiter so tun."'), nl,
    speichere_hinweis('Hildes Tagebuch kompletter Eintrag: Jakob bedroht Hilde seit 2019.'), !.

lesen(brief) :-
    habe(brief),
    write('Adressiert an: L. Varga.'), nl,
    write('"Wir haben Ihre Bewerbung fuer die Innsbruck-Reportage erhalten.'), nl,
    write('Bitte bestaetigen Sie Ihre Ankunft fuer den 14."'), nl,
    write('Der Briefkopf ist von einem Magazin, von dem du noch nie gehoert hast.'), nl,
    write('Die Telefonnummer fuehrt ins Leere.'), nl,
    write('Jemand hat das gefaelseht. Die Handschrift auf dem Umschlag –'), nl,
    write('sorgfaeltig, ueberlegt. Du hast sie schon einmal gesehen.'), nl,
    speichere_hinweis('Der Brief: Das Innsbruck-Vorstellungsgespraech war erfunden. Jemand hat dich hierher gelockt. Die Handschrift kommt dir bekannt vor.'), !.

lesen(kirchenaufzeichnung) :-
    habe(kirchenaufzeichnung),
    write('Ein Bericht ueber die Gruendung Kalmbachs, 1648.'), nl,
    write('Erbaut ueber einer aelteren Siedlung. Die urspruenglichen Bewohner'), nl,
    write('hatten einen Brauch: Jede Generation muss ein Fremder Zeuge sein'), nl,
    write('und sich frei entscheiden – zu bleiben oder zu gehen.'), nl,
    write('Wenn er geht, setzt sich der Kreislauf fort.'), nl,
    write('Wenn er festgehalten wird – "ist der Vertrag erfuellt."'), nl,
    write('Die Aufzeichnung sagt nicht, wofuer der Vertrag ist.'), nl,
    speichere_hinweis('Kirchenaufzeichnung: Ein Fremder muss Zeuge sein und sich frei entscheiden. Wenn er gegen seinen Willen festgehalten wird, bricht etwas. Die Aufzeichnung ist unvollstaendig.'), !.

lesen(ottos_tagebuch) :-
    habe(ottos_tagebuch),
    write('"Erna sagt, der Fremde wird vor dem Vollmond eintreffen.'), nl,
    write('Ich fragte, woher sie das wisse. Sie sagte, sie habe ihm geschrieben."'), nl,
    write('"Ich fragte, wann. Sie sagte, vor drei Monaten."'), nl,
    write('"Ich fragte, warum sie es uns nicht gesagt habe.'), nl,
    write('Sie sagte, wir haetten sie aufgehalten."'), nl,
    speichere_hinweis('Ottos Tagebuch: Erna hat den Vorstellungsbrief selbst geschrieben, vor drei Monaten. Sie plante Leons Ankunft, ohne es dem Dorf zu sagen.'), !.

lesen(X) :-
    habe(X),
    write('Due siehst es genau an. Nichts Neues faellt auf.'), nl, !.
lesen(X) :-
    write('Du traegst '), write(X), write(' nicht bei dir.'), nl.

/* ===================== Gegenstaende bemerken ===================== */

bemerke_gegenstaende(friedhof) :-
    bei(krypta_code, friedhof),
    (habe(taschenlampe) ->
        write('Deine Taschenlampe zeigt eine Inschrift auf einem der Grabsteine.'), nl,
        write('Du kannst nehmen(krypta_code) eingeben, um die Sequenz zu kopieren.')
    ;
        write('Die Grabsteine sind im Dunkeln kaum zu erkennen.')
    ), nl, fail.
bemerke_gegenstaende(Ort) :-
    bei(X, Ort), X \= krypta_code,
    write('Du siehst: '), write(X), write('.'), nl, fail.
bemerke_gegenstaende(_).

/* ===================== Hinweise ===================== */

speichere_hinweis(Text) :- hinweis(Text), !.
speichere_hinweis(Text) :- assert(hinweis(Text)).

notizen :- spiel_ende, !, spiel_ende_nachricht.
notizen :-
    write('=== Notizen ==='), nl, zeige_hinweise.

zeige_hinweise :-
    hinweis(X), write('  - '), write(X), nl, fail.
zeige_hinweise :-
    \+ hinweis(_),
    write('  Noch nichts aufgezeichnet.'), nl, !.
zeige_hinweise.

/* ===================== Umschauen ===================== */

umschauen :- spiel_ende, !, spiel_ende_nachricht.
umschauen :-
    ich_bin_in(Ort),
    beschreibe(Ort), nl,
    (   angesehen(Ort, Anzahl)
    ->  NeueAnzahl is Anzahl + 1,
        retract(angesehen(Ort, Anzahl)),
        assert(angesehen(Ort, NeueAnzahl))
    ;   assert(angesehen(Ort, 1)),
        NeueAnzahl = 1
    ),
    (NeueAnzahl >= 2 -> bemerke_gegenstaende(Ort) ; true),
    (NeueAnzahl >= 3 -> details(Ort) ; true),
    nl,
    zeige_ausgaenge,
    zeige_raumaktionen,
    nl,
    zeit_ausgeben, nl, !.

/* ===================== Ausgaenge anzeigen ===================== */

zeige_ausgaenge :-
    ich_bin_in(Hier),
    findall(Richtung-Dort, roher_ausgang(Hier, Richtung, Dort), Ausgaenge),
    (Ausgaenge = [] -> true ;
     write('Du kannst gehen:'),
     forall(member(Richtung-Dort, Ausgaenge),
            (write(' '), write(Richtung),
             (angesehen(Dort, _) -> write(' ('), write(Dort), write(')') ; true))),
     nl).

/* ===================== Raumaktionen ===================== */

zeige_raumaktionen :- ich_bin_in(dorfplatz), vertrauen(hilde, gefuerchtet), !,
    write('Die Kneipe ist dunkel. Die Tuer oeffnet sich nicht, als du die Klinke pruefst.'), nl.
zeige_raumaktionen :- ich_bin_in(dorfeingang), !, zeige_charaktername(dorfeingang, 'Erna'),        zeige_erna_aktion.
zeige_raumaktionen :- ich_bin_in(kneipe),              !, zeige_charaktername(kneipe,              'Hilde').
zeige_raumaktionen :- ich_bin_in(scheune),             !, zeige_charaktername(scheune,             'Jakob'),       zeige_jakob_aktionen.
zeige_raumaktionen :- ich_bin_in(friedhof),        !, zeige_charaktername(friedhof,        'Mia').
zeige_raumaktionen :- ich_bin_in(kircheninneres),  !, zeige_charaktername(kircheninneres,  'Vater Benedikt'), zeige_glocke_aktion.
zeige_raumaktionen :- ich_bin_in(buergermeisterhaus),     !, zeige_charaktername(buergermeisterhaus,     'Buergermeister Otto').
zeige_raumaktionen :- ich_bin_in(wald),           !,
    write('Der Pfad fuehrt hinaus. Du koenntest alles hinter dir lassen.'), nl,
    (hinweis_gegeben(fliehen) -> write('(fliehen.)'), nl ; assert(hinweis_gegeben(fliehen))).
zeige_raumaktionen.

zeige_charaktername(Ort, Name) :-
    angesehen(Ort, N), N >= 2, !,
    write(Name), write(' ist hier.'), nl.
zeige_charaktername(_, _).

zeige_glocke_aktion :-
    glocke_gelaeutet, !.
zeige_glocke_aktion :-
    habe(seil), !,
    write('Das Seil ist in deinen Haenden. Der Glockenrahmen wartet oben.'), nl,
    (hinweis_gegeben(glocke_laeuten) -> write('(glocke_laeuten.)'), nl ; assert(hinweis_gegeben(glocke_laeuten))).
zeige_glocke_aktion.

zeige_jakob_aktionen :-
    zeige_jakob_konfrontieren_aktion,
    zeige_jakob_folgen_aktion.

zeige_jakob_konfrontieren_aktion :-
    vertrauen(jakob, gefuerchtet), !.
zeige_jakob_konfrontieren_aktion :-
    hinweis('Unfallstelle: Zwei Reifenspuren auf der Strasse. Jemand ist dir direkt vor dem Graben sehr nah gekommen.'),
    hinweis('Hildes Tagebuch: Jakob hat Hilde zum Schweigen gedaengt. Sie weiss, dass er dich von der Strasse gedaengt hat.'), !,
    write('Die Spuren. Das Tagebuch. Die Teile fuegen sich zusammen.'), nl,
    (hinweis_gegeben(konfrontiere_jakob) -> write('(konfrontieren.)'), nl ; assert(hinweis_gegeben(konfrontiere_jakob))).
zeige_jakob_konfrontieren_aktion.

zeige_jakob_folgen_aktion :-
    vertrauen(jakob, gefuerchtet), !.
zeige_jakob_folgen_aktion :-
    (vertrauen(jakob, vertraut) ; vertrauen(jakob, ergeben) ; habe(autoschluessel)), !,
    write('Sein Blick schweift immer wieder zur Tuer.'), nl,
    (hinweis_gegeben(folge_jakob) -> write('(folgen.)'), nl ; assert(hinweis_gegeben(folge_jakob))).
zeige_jakob_folgen_aktion.

zeige_erna_aktion :-
    vertrauen(erna, gefuerchtet), !.
zeige_erna_aktion :-
    hinweis('Der Brief: Das Innsbruck-Vorstellungsgespraech war erfunden. Jemand hat dich hierher gelockt. Die Handschrift kommt dir bekannt vor.'),
    hinweis('Ottos Tagebuch: Erna hat den Vorstellungsbrief selbst geschrieben, vor drei Monaten. Sie plante Leons Ankunft, ohne es dem Dorf zu sagen.'),
    glocke_gelaeutet,
    vertrauen(hilde, ergeben), !,
    write('Du hast alles. Den Brief. Die Wahrheit dahinter. Die Glocke hat dir Zeit gekauft. Und Hilde ist bereit.'), nl,
    (hinweis_gegeben(konfrontiere_erna) -> write('(konfrontieren.)'), nl ; assert(hinweis_gegeben(konfrontiere_erna))).
zeige_erna_aktion.

/* ===================== Bewegung ===================== */

n  :- gehen(n).  s  :- gehen(s).  o  :- gehen(o).  w  :- gehen(w).
no :- gehen(no). sw :- gehen(sw). nw :- gehen(nw). so :- gehen(so).
rauf  :- gehen(rauf).  runter  :- gehen(runter).

gehen(_) :- spiel_ende, !, spiel_ende_nachricht.
gehen(Richtung) :-
    ich_bin_in(Hier),
    pfad(Hier, Richtung, Dort),
    retract(ich_bin_in(Hier)),
    assert(ich_bin_in(Dort)),
    zeit_vorruecken(5),
    (spiel_ende -> true ; umschauen), !.
gehen(_) :-
    write('Dorthin kannst du nicht gehen.'), nl.

/* ===================== Enden ===================== */

ende_banner :-
    nl, write('======================================================='), nl.

ende_a :-
    assert(spiel_ende),
    ende_banner,
    write('              ENDE A — RAUS'), nl,
    ende_banner, nl,
    write('Der Spiegelpfad spuckt dich auf eine Forststrasse aus.'), nl,
    write('Hinter dir ist Kalmbach bereits im Nebel verschwunden.'), nl,
    write('Due siehst nicht zurueck. Du weisst nicht, was hinter dir'), nl,
    write('passiert, und ein Teil von dir will es nie wissen.'), nl, nl,
    write('Dein Handy vibriert. Ein Balken. Eine Nachricht:'), nl,
    write('"Wir bedauern, die Innsbruck-Reportage wurde abgesagt."'), nl,
    write('Du hast dich nie fuer eine Reportage beworben.'), nl, nl,
    write('Wer hat nach dir geschickt? Was passiert in Kalmbach ohne dich?'), nl,
    write('(start. um nochmal zu spielen)'), nl, !.

ende_b :-
    assert(spiel_ende),
    ende_banner,
    write('              ENDE B — DIE GLOCKE'), nl,
    ende_banner, nl,
    write('Due haeltst Erna den Brief hin. "Du hast das geschrieben. Vor Monaten."'), nl,
    write('Die Glocke schwingt noch zwischen euch in der Luft.'), nl,
    write('Zum ersten Mal sieht sie ihr Alter aus. Der Plan brauchte dich'), nl,
    write('freiwillig hier. Du gehst – und nicht allein.'), nl, nl,
    write('Was auch immer der Vertrag war, er bleibt unerfuellt.'), nl,
    write('Hilde nimmt deinen Arm. Die Laeden oeffnen sich, einer nach dem anderen.'), nl,
    write('Benedikt bleibt zurueck, im Frieden.'), nl, nl,
    write('Am Dorfrand winkt Mia einmal. Dann ist sie nicht mehr da.'), nl,
    write('War sie es je?'), nl,
    write('(start. um nochmal zu spielen)'), nl, !.

ende_c :-
    assert(spiel_ende),
    ende_banner,
    write('              ENDE C — DIE PROZESSION'), nl,
    ende_banner, nl,
    write('Mitternacht.'), nl, nl,
    write('Die Laeden oeffnen sich alle auf einmal – jedes Fenster im Dorf,'), nl,
    write('in derselben Sekunde, ohne einen Laut.'), nl, nl,
    write('Sie kommen mit Kerzen heraus. Jedes Gesicht, das du kennst.'), nl,
    write('Und viele, die du nicht kennst.'), nl,
    write('Erna geht vorne. Sie sieht nicht triumphierend aus.'), nl,
    write('Sie sieht erloest aus.'), nl, nl,
    write('Hilde ist auch da. Sie wird deinen Blicken ausweichen.'), nl,
    write('Sie hat versucht, dich zu warnen. Du hast nicht zugehoert – oder doch,'), nl,
    write('aber nicht rechtzeitig.'), nl, nl,
    write('Du verstehst jetzt alles.'), nl,
    write('Den Brief. Die Wahl. Den Vertrag. Warum du hergebracht wurdest.'), nl,
    write('Warum es dir niemand einfach sagen konnte.'), nl, nl,
    write('Das Verstaendnis hilft dir nicht.'), nl, nl,
    write('Die Kerzen bilden einen Kreis. Die Glocke, die du nie gelaeutet hast'), nl,
    write('– oder zu spaet gelaeutet hast – spielt keine Rolle mehr.'), nl,
    write('Das Dorf hat seinen Zeugen. Der Vertrag ist erfuellt.'), nl, nl,
    write('Du wirst Kalmbach nicht verlassen.'), nl, nl,
    write('Irgendwo jenseits des Nebels liest jemand anders eine Vorstellungsanfrage,'), nl,
    write('um die er nie gebeten hat.'), nl,
    write('(start. um nochmal zu spielen)'), nl, !.

spiel_ende_nachricht :-
    write('Es ist vorbei. Tippe start. um nochmal zu beginnen.'), nl.

/* ----- Fluchtwege ----- */

fliehen :- spiel_ende, !, spiel_ende_nachricht.
fliehen :-
    ich_bin_in(wald),
    write('Du nimmst den verborgenen Pfad allein, den Weg, den der Spiegel dir gezeigt hat.'), nl,
    ende_a, !.
fliehen :-
    write('Hier gibt es keinen Ausweg. Der Waldpfad ist die einzige Strasse.'), nl, !.

folge_jakob :- spiel_ende, !, spiel_ende_nachricht.
folge_jakob :-
    ich_bin_in(scheune), vertrauen(jakob, ergeben),
    write('Due folgst Jakob ohne eine einzige Frage in die Dunkelheit.'), nl,
    write('Das Auto ist nicht da, wo er es sagte. Die Strasse auch nicht.'), nl,
    write('Laternen naehern sich aus den Baeumen.'), nl,
    ende_c, !.
folge_jakob :-
    ich_bin_in(scheune), (vertrauen(jakob, vertraut) ; habe(autoschluessel)),
    write('Jakob fuehrt dich zum Dorfrand – dann bleibt er eiskalt stehen.'), nl,
    write('Die Strasse ist blockiert. "Ich... ich kann nicht. Tut mir leid."'), nl,
    write('Er kehrt um. Das Auto war nie der Weg nach draussen.'), nl, !.
folge_jakob :-
    ich_bin_in(scheune),
    write('Jakob wird dich nirgendwo hinfuehren. Nicht so.'), nl, !.
folge_jakob :-
    write('Jakob ist nicht hier.'), nl.

/* ----- Die Abrechnung mit Erna ----- */

konfrontiere_erna :- spiel_ende, !, spiel_ende_nachricht.
konfrontiere_erna :-
    ich_bin_in(dorfeingang), vertrauen(erna, gefuerchtet),
    write('Erna ist weg. Du stehst nur vor der leeren Strasse.'), nl, !.
konfrontiere_erna :-
    ich_bin_in(dorfeingang),
    hinweis('Der Brief: Das Innsbruck-Vorstellungsgespraech war erfunden. Jemand hat dich hierher gelockt. Die Handschrift kommt dir bekannt vor.'),
    hinweis('Ottos Tagebuch: Erna hat den Vorstellungsbrief selbst geschrieben, vor drei Monaten. Sie plante Leons Ankunft, ohne es dem Dorf zu sagen.'),
    glocke_gelaeutet,
    vertrauen(hilde, ergeben),
    ende_b, !.
konfrontiere_erna :-
    ich_bin_in(dorfeingang),
    write('Du stellst dich Erna mit dem, was du hast – aber es reicht nicht,'), nl,
    write('noch nicht. Du brauchst den Brief und den Beweis, dass sie ihn schrieb,'), nl,
    write('die gelaeutete Glocke, um Zeit zu kaufen, und Hilde bereit, mit dir zu gehen.'), nl, !.
konfrontiere_erna :-
    write('Erna ist nicht hier.'), nl.

konfrontieren :- spiel_ende, !, spiel_ende_nachricht.
konfrontieren :- ich_bin_in(scheune),             !, konfrontiere_jakob.
konfrontieren :- ich_bin_in(dorfeingang), !, konfrontiere_erna.
konfrontieren :- write('Hier ist niemand, den du konfrontieren kannst.'), nl.

folgen :- spiel_ende, !, spiel_ende_nachricht.
folgen :- ich_bin_in(scheune), !, folge_jakob.
folgen :- write('Hier ist niemand, dem du folgen kannst.'), nl.

/* ===================== Engine ===================== */

hilfe  :- anweisungen.
ende  :- halt.

anweisungen :-
    write('-------------------------------------------------------'), nl,
    write('  Befehle:'), nl,
    write('  n. s. o. w. no. sw. nw. so. rauf. runter.  -> bewegen'), nl,
    write('  umschauen.           -> umsehen'), nl,
    write('  reden.           -> mit jemandem sprechen'), nl,
    write('  nehmen(X).        -> Gegenstand aufheben'), nl,
    write('  ablegen(X).        -> Gegenstand fallenlassen'), nl,
    write('  lesen(X).   -> Dokument lesen'), nl,
    write('  inventar.      -> getragene Gegenstaende anzeigen'), nl,
    write('  notizen.          -> entdeckte Hinweise anzeigen'), nl,
    write('  zeit.           -> Uhrzeit pruefen (Mitternacht ist die Frist)'), nl,
    write('  beruhigen.        -> Vertrauen zu einem nahen Charakter vertiefen'), nl,
    write('  anvertrauen.         -> teilen, was du gelernt hast'), nl,
    write('  hilfe.           -> diese Liste anzeigen'), nl,
    write('  ende.           -> Spiel beenden'), nl,
    write('-------------------------------------------------------'), nl,
    write('  Wenn du nicht weiterkommst, schau genauer hin...'), nl,
    write('  Menschen veraendern sich.'), nl,
    write('-------------------------------------------------------'), nl, nl.

/* ===================== Start ===================== */

status_zuruecksetzen :-
    retractall(ich_bin_in(_)), retractall(bei(_, _)), retractall(habe(_)),
    retractall(vertrauen(_, _)), retractall(angesehen(_, _)), retractall(hinweis(_)),
    retractall(spielzeit(_)), retractall(frist(_)),
    retractall(glocke_gelaeutet), retractall(spiel_ende), retractall(hinweis_gegeben(_)),
    assert(ich_bin_in(unfallstelle)),
    assert(vertrauen(erna, neutral)), assert(vertrauen(hilde, neutral)),
    assert(vertrauen(jakob, neutral)), assert(vertrauen(benedikt, neutral)),
    assert(vertrauen(otto, neutral)),
    assert(spielzeit(0)), assert(frist(120)),
    assert(bei(taschenlampe, unfallstelle)), assert(bei(seil, unfallstelle)),
    assert(bei(brunnen_notiz, dorfplatz)), assert(bei(spiegel, kneipe)),
    assert(bei(hildes_tagebuch, kneipenkeller)), assert(bei(kirchenaufzeichnung, kircheninneres)),
    assert(bei(krypta_code, friedhof)), assert(bei(brief, krypta)),
    assert(bei(autoschluessel, scheune)), assert(bei(ottos_tagebuch, buergermeisterhaus)).

start :-
    status_zuruecksetzen,
    nl,
    write('======================================================='), nl,
    write('              WHISPERS BETWEEN US'), nl,
    write('======================================================='), nl,
    nl,
    write('Der Regen hat aufgehoert.'), nl,
    nl,
    write('Du weisst nicht, wie lange du bewusstlos warst.'), nl,
    write('Das Armaturenbrett ist kalt. Die Windschutzscheibe beschlagen.'), nl,
    write('Draussen: Wald. Stille. Und etwas, das sich anfuehlt'), nl,
    write('wie beobachtet werden.'), nl,
    nl,
    write('Dein Handy zeigt kein Signal.'), nl,
    write('Die Vorderachse ist gebrochen.'), nl,
    write('Du wirst hier nicht rausfahren.'), nl,
    nl,
    write('Etwa einen Kilometer die Strasse entlang siehst du Lichter.'), nl,
    nl,
    write('Es ist kurz nach 22 Uhr. Heute Nacht ist Vollmond.'), nl,
    nl,
    write('(Tippe hilfe. fuer eine Liste der Befehle.)'), nl,
    nl,
    write('Due steigst aus dem Auto.'), nl,
    nl,
    umschauen.
