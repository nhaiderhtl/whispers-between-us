:- dynamic i_am_at/1, at/2, holding/1, trust/2, looked_at/2, clue/1,
            game_time/1, deadline/1, bell_rung/0, game_over/0, hinted/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(holding(_)),
   retractall(trust(_, _)), retractall(looked_at(_, _)), retractall(clue(_)),
   retractall(game_time(_)), retractall(deadline(_)),
   retractall(bell_rung), retractall(game_over).

/* ===================== Ausgangszustand ===================== */

i_am_at(crash_site).
trust(erna,     neutral).
trust(hilde,    neutral).
trust(jakob,    neutral).
trust(benedikt, neutral).
trust(otto,     neutral).

/* Zeit: vergangene Minuten seit 22 Uhr. Mitternacht = Frist (120 Min). */
game_time(0).
deadline(120).

/* ===================== Karte ===================== */

path(crash_site,       n,  forest_path).
path(forest_path,      s,  crash_site).
path(forest_path,      n,  village_entrance).
path(village_entrance, s,  forest_path).
path(village_entrance, n,  village_square).
path(village_square,   s,  village_entrance).
path(village_square, w, inn) :-
    \+ trust(hilde, feared), !.
path(village_square, w, inn) :-
    write('Die Tuer ist verschlossen. Durch das Glas ist die Kneipe dunkel.'), nl,
    write('Du koenntest klopfen. (knock.)'), nl, fail.
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
    write('Die Kellertuer ist verriegelt.'), nl, fail.
path(inn_cellar, u, inn).

path(church_interior, d, crypt) :-
    holding(crypt_code), !.
path(church_interior, d, crypt) :-
    write('Eine steinerne Tuer, versiegelt mit einer Symbolreihe im Rahmen.'), nl,
    write('Du kennst die Sequenz noch nicht.'), nl, fail.
path(crypt, u, church_interior).

path(village_square, e, mayors_house) :-
    (trust(benedikt, trusted) ; trust(benedikt, devoted) ; holding(mayors_key)), !.
path(village_square, e, mayors_house) :-
    write('Die Haustuer ist abgeschlossen. Schwerer Eisenriegel, kein Griff auf dieser Seite.'), nl, fail.

path(village_square, nw, forest) :-
    holding(mirror), !.
path(village_square, nw, forest) :-
    write('Der Waldrand versinkt in der Dunkelheit. Du findest keinen Weg hindurch.'), nl, fail.

/* Rohe Ausgaenge fuer Richtungsanzeige (ohne Nebenwirkungen) */
raw_exit(crash_site,       n,  forest_path).
raw_exit(forest_path,      s,  crash_site).
raw_exit(forest_path,      n,  village_entrance).
raw_exit(village_entrance, s,  forest_path).
raw_exit(village_entrance, n,  village_square).
raw_exit(village_square,   s,  village_entrance).
raw_exit(village_square,   w,  inn).
raw_exit(inn,              e,  village_square).
raw_exit(village_square,   n,  graveyard).
raw_exit(graveyard,        s,  village_square).
raw_exit(graveyard,        n,  church_interior).
raw_exit(church_interior,  s,  graveyard).
raw_exit(mayors_house,     w,  village_square).
raw_exit(village_square,   sw, barn).
raw_exit(barn,             ne, village_square).
raw_exit(forest,           se, village_square).
raw_exit(inn,              d,  inn_cellar).
raw_exit(inn_cellar,       u,  inn).
raw_exit(church_interior,  d,  crypt).
raw_exit(crypt,            u,  church_interior).
raw_exit(village_square,   e,  mayors_house).
raw_exit(village_square,   nw, forest).

/* ===================== Gegenstaende ===================== */

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

/* ===================== Raumbeschreibungen ===================== */

describe(crash_site) :-
    write('Dein Auto liegt schraeg im Strassengraben, die Vorderachse'), nl,
    write('gebrochen. Ueberall Wald. Der Regen hat aufgehoert, aber der Nebel'), nl,
    write('haengt tief. Im Unterholz knackt etwas.'), nl,
    write('Ein schmaler Pfad fuehrt nach Norden.'), nl.

describe(forest_path) :-
    write('Ein enger Pfad zwischen alten Fichten. Aeste ragen von oben herein.'), nl,
    write('Das Dorf muss nah sein – durch die Baeume siehst du Licht,'), nl,
    write('daempft und gelb. Der Weg fuehrt weiter nach Norden. Sueden geht zurueck.'), nl.

describe(village_entrance) :-
    write('Ein verwittertes Holzschild: "Kalmbach – Erbaut 1648."'), nl,
    write('Die Strasse wird zum Kopfsteinpflaster. Ueberall geschlossene Fensterlaeden.'), nl,
    write('Kein Laut. Keine Bewegung.'), nl,
    write('Und doch – am Rand des Lichts steht eine alte Frau,'), nl,
    write('die dich ansieht, als haette sie gewartet.'), nl.

describe(village_square) :-
    write('Ein kleiner Platz mit einem steinernen Brunnen in der Mitte. Jedes Fenster'), nl,
    write('ist dunkel. Die Laeden sind alle geschlossen – aber nicht alle verriegelt.'), nl,
    write('Du hoerst deine eigenen Schritte zu deutlich.'), nl,
    write('Die Kneipe ist im Westen. Eine Kirche im Norden.'), nl,
    write('Ein grosses Haus im Osten. Eine Scheune irgendwo im Suedwesten.'), nl.

describe(inn) :-
    write('Warmer Raum, Holzrauch, niedrige Decke. Eine Frau hinter der Theke'), nl,
    write('wischt ein Glas, das laengst sauber ist. Sie laechelt, bevor du'), nl,
    write('die Tuer ganz geoeffnet hast.'), nl,
    write('"Du musst ja frozen sein. Setz dich."'), nl.

describe(inn_cellar) :-
    write('Steinstufen, kalt und feucht. Reihen von Weinfassern, die meisten leer.'), nl,
    write('Eine einzige nackte Gluehbirne flackert ueber dir.'), nl,
    write('An der gegenueberliegenden Wand: eine Matratze. Eine gefaltete Decke.'), nl,
    write('Jemand hat hier unten gewohnt.'), nl.

describe(graveyard) :-
    write('Der Kirchhof ist ueberwuchert, Steine in seltsamen Winkeln geneigt.'), nl,
    write('Die meisten Namen sind vom Wetter ausgewaschen. Ein Grab nahe'), nl,
    write('der Kirchenmauer ist neuer als die anderen.'), nl,
    write('Ein kleines Maedchen sitzt darauf und sieht dich an.'), nl.

describe(church_interior) :-
    write('Kalte Steine und altes Wachs. Kerzen brennen am Gang entlang,'), nl,
    write('obwohl du niemanden gesehen hast, der sie angezuendet hat.'), nl,
    write('Ein Mann in dunkler Robe kniet am fernen Ende, regungslos.'), nl,
    write('Er sieht nicht auf, als du eintrittst.'), nl.

describe(crypt) :-
    write('Unter der Kirche. Die Luft ist vollkommen still.'), nl,
    write('Steinplatten saeumen den Boden, jede mit Namen und Daten graviert.'), nl,
    write('Eine Platte nahe der hinteren Wand wurde verschoben – vor Kurzem.'), nl,
    write('Etwas liegt in der Luecke.'), nl.

describe(mayors_house) :-
    write('Eine saubere Diele, kalter Kamin, ueberall gerahmte Urkunden.'), nl,
    write('Ein Mann steht oben an der Treppe und sieht auf dich herab'), nl,
    write('mit einem Ausdruck, den du nicht ganz deuten kannst.'), nl.

describe(barn) :-
    write('Die Scheunentuer schwingt auf, als du dich naeherst.'), nl,
    write('Heuballen, rostige Werkzeuge, der Geruch von Oel und feuchtem Holz.'), nl,
    write('Ein junger Mann steht hinten, die Arme verschraenkt,'), nl,
    write('als ob er nicht gewartet haette.'), nl.

describe(forest) :-
    write('Die Baeume verschlucken jeden Laut. Der Spiegel hat dich zu einer Luecke'), nl,
    write('im Unterholz gefuehrt – einem Pfad, der auf keiner Karte steht.'), nl,
    write('Er fuehrt tiefer hinein. Der Dorfplatz ist zuruech im Suedosten.'), nl.

/* ===================== Details (zweiter Blick) ===================== */

details(crash_site) :-
    record_clue('Unfallstelle: Zwei Reifenspuren auf der Strasse. Jemand ist dir direkt vor dem Graben sehr nah gekommen.'),
    write('Du musterst die Strasse. Zwei Reifenspuren im Schlamm.'), nl,
    write('Eine gehoert nicht dir. Jemand kam sehr nah – direkt vor dem Graben.'), nl.

details(forest_path) :-
    record_clue('Waldweg: Frische Fussspuren im Schlamm, Richtung Dorf. Mehrere Personen. Vor Minuten.'),
    write('Im Schlamm am Rand des Pfades: Fussspuren.'), nl,
    write('Mehrere. Alle Richtung Dorf. Die Raender noch scharf – vor Minuten.'), nl.

details(village_entrance) :-
    record_clue('Dorfzugang: Die alte Frau hat deinen Namen benutzt. Du hast dich nie vorgestellt.'),
    write('Du gehst es durch. Sie hat etwas gesagt, als du dich naehertest.'), nl,
    write('"Leon." Nur das. Du hast ihr nie deinen Namen gesagt.'), nl.

details(village_square) :-
    record_clue('Dorfplatz: Der Zettel am Brunnen hat ein Datum – vor drei Monaten. Zur selben Zeit wurde der Brief in der Krypta geschrieben.'),
    write('Du pruefst den Zettel noch einmal. Ein Datum in der Ecke, fast zu blass.'), nl,
    write('Vor drei Monaten. Jemand hat das lange im Voraus geplant.'), nl.

details(inn) :-
    record_clue('Kneipe: Der Spiegel ist zur Tuer hin ausgerichtet, nicht zum Raum. Wer hinter der Theke steht, kann sehen, wer eintritt, ohne aufzusehen.'),
    write('Der Spiegel an der Wand ist falsch ausgerichtet – nicht zum Raum.'), nl,
    write('Zur Tuer hin. Eine perfekte Sicht auf jeden Eingang hinter der Bar.'), nl.

details(inn_cellar) :-
    record_clue('Keller der Kneipe: Die Decke hat Initialen in der Ecke eingenaeht. Nicht Hildes Initialen.'),
    write('Du faltest die Decke auseinander. Initialen mit kleinen, sorgfaeltigen Stichen eingenaeht.'), nl,
    write('Nicht H. Nicht Hilde. Jemand anders hat sich hier versteckt.'), nl.

details(graveyard) :-
    record_clue('Friedhof: Das neueste Grab hat frische Blumen – heute hingelegt. Der Stein sagt: Mia Haas, 2004-2014. Sie ist seit zehn Jahren tot.'),
    write('Das neueste Grab hat frische Wildblumen – heute hingelegt.'), nl,
    write('Der Stein sagt: Mia Haas. Geboren 2004. Gestorben 2014.'), nl,
    write('Vor zehn Jahren.'), nl.

details(church_interior) :-
    record_clue('Kircheninneres: Die Kerzen markieren jede dritte Bank auf der linken Seite. Sieben Kerzen. Sieben neuere Graeber auf dem Kirchhof.'),
    write('Die Kerzen sind nicht zufaellig. Jede dritte Bank auf der linken Seite.'), nl,
    write('Due zaehlst: sieben. Dieselbe Anzahl wie die neueren Graeber draussen.'), nl.

details(crypt) :-
    record_clue('Krypta: Die verschobene Platte hat tiefe Kratzer auf der Innenseite. Jemand wurde eingeschlossen und versuchte herauszukommen.'),
    write('Du siehst dir die Unterseite der verschobenen Platte an.'), nl,
    write('Kratzspuren. Tief. Von innen gemacht.'), nl.

details(mayors_house) :-
    record_clue('Haus des Buergermeisters: Ein Gruppenfoto von 1987 hat ein rot eingekreistes Gesicht. Es ist Erna.'),
    write('Ein gerahmtes Foto – das ganze Dorf, vor Jahrzehnten.'), nl,
    write('Ein Gesicht mit rotem Marker eingekreist. Du erkennst die Augen.'), nl,
    write('Erna. Unter dem Rahmen, mit Bleistift geschrieben: "1987."'), nl.

details(barn) :-
    record_clue('Scheune: Ein Oelfleck zeichnet ein Auto nach, das nicht mehr da ist. Jakobs Auto wurde vor sehr kurzer Zeit bewegt.'),
    write('Ein Oelfleck auf dem Scheunenboden – der Umriss eines Autos.'), nl,
    write('Der Fleck ist an den Raendern noch frisch. Vor Kurzem bewegt.'), nl.

details(forest) :-
    record_clue('Wald: Ein Stofffetzen an einem Ast. Gleiches Muster wie die Decke im Keller der Kneipe.'),
    write('Ein Stofffetzen an einem tiefen Ast.'), nl,
    write('Du kennst dieses Muster – die Decke im Keller der Kneipe.'), nl.

details(_).

/* ===================== Charaktere ===================== */

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
    write('Hier ist niemand, mit dem du reden kannst.'), nl.

/* Erna */
interact(erna) :- trust(erna, neutral),
    write('"Du solltest nicht hier sein. Nicht heute Nacht."'), nl,
    write('Eine Pause. "Aber du bist hier. Geh zur Kneipe. Hilde laesst dich rein."'), nl,
    write('Sie dreht sich weg.'), nl,
    write('Vertraust du ihr? (trust. / doubt.)'), nl, !.
interact(erna) :- trust(erna, trusted),
    write('Sie dreht den Kopf fast unmerklich zur Kirche.'), nl,
    write('"Der Pfarrer weiss mehr, als er sagt. Frag ihn nach 1987."'), nl, !.
interact(erna) :- trust(erna, doubted),
    write('Erna sieht dich an. Ein fastes Laecheln. "Du bist vorsichtig. Gut."'), nl, !.
interact(erna) :- trust(erna, feared),
    write('Erna ist weg. Nur Fussspuren im Schlamm, wo sie stand.'), nl, !.

/* Hilde */
interact(hilde) :- trust(hilde, neutral),
    write('"Schwere Nacht? Du kannst hier bleiben – kostenlos.'), nl,
    write('Die Strassen sind schlecht bei so einem Wetter."'), nl,
    write('Sie ist warm. Zu warm fuer 22 Uhr.'), nl,
    write('Vertraust du ihr? (trust. / doubt.)'), nl, !.
interact(hilde) :- trust(hilde, trusted),
    write('"Da unten ist etwas, das du sehen solltest.'), nl,
    write('Jemand hat hier gewohnt. Kein Gast."'), nl,
    write('Sie schiebt dir einen Schluessel ueber die Theke.'), nl,
    (holding(cellar_key) -> true ;
     at(cellar_key, _)   -> true ;
     assert(holding(cellar_key)), write('Du nimmst den Kellerschluessel.'), nl), !.
interact(hilde) :- trust(hilde, devoted),
    write('"Nimm mich mit, wenn du gehst", sagt sie leise.'), nl,
    write('"Egal, was du findest – geh nicht ohne mich."'), nl, !.
interact(hilde) :- trust(hilde, doubted),
    write('Hilde wischt wieder die Theke. Sieht dich nicht an.'), nl,
    write('"Ich hoffe, du findest, was du brauchst."'), nl,
    write('Ihre Stimme ist flach. Etwas hat sich verschlossen.'), nl, !.

/* Jakob */
interact(jakob) :- trust(jakob, neutral),
    write('"Bist du der, dessen Auto von der Strasse abkam? Hab''s gesehen."'), nl,
    write('Er macht eine Pause – einen Sekundenbruchteil zu lang.'), nl,
    write('"Ich hab''n Auto. Kann dich rausfahren, wenn du bereit bist."'), nl,
    write('Vertraust du ihm? (trust. / doubt.)'), nl, !.
interact(jakob) :- trust(jakob, trusted),
    write('Jakob nickt und zieht einen Schluessel aus der Tasche.'), nl,
    write('"Das Auto steht direkt ausserhalb des Dorfs. Folge mir. Nicht anhalten."'), nl,
    (holding(car_key) -> true ;
     retractall(at(car_key, _)), assert(holding(car_key)),
     write('Er gibt dir den Schluessel.'), nl), !.
interact(jakob) :- trust(jakob, doubted),
    write('"Hoer mal, ich versuche dir zu helfen."'), nl,
    write('Er hat gesagt, er hat es gesehen. Von wo aus, genau?'), nl, !.
interact(jakob) :- trust(jakob, feared),
    write('Jakob weicht zurueck, als du eintrittst.'), nl,
    write('"Ich hab'' – es sollte nicht so laufen."'), nl,
    write('Er sieht dich nicht an.'), nl, !.

/* Vater Benedikt */
interact(benedikt) :- trust(benedikt, neutral),
    write('Er steht nicht auf. Haelt den Blick auf den Altar gerichtet.'), nl,
    write('"Wir bekommen keine Besucher. Besonders nicht heute Nacht."'), nl,
    write('Ein langes Schweigen. "Die Kneipe hat noch offen. Geh dorthin."'), nl,
    write('Vertraust du ihm? (trust. / doubt.)'), nl, !.
interact(benedikt) :- trust(benedikt, trusted),
    write('"Die Prozession ist nicht, was du denkst.'), nl,
    write('Es ist ein Ritual der Bewahrung. Der Fortfuehrung."'), nl,
    write('"Die Krypta birgt die Antwort. Aber versteh, was du findest,'), nl,
    write('bevor du danach handelst."'), nl,
    (holding(crypt_code) -> true ;
     write('Er fluestert die Sequenz. Du weisst jetzt, wie man die Krypta oeffnet.'), nl,
     retractall(at(crypt_code, _)),
     assert(holding(crypt_code))), !.
interact(benedikt) :- trust(benedikt, devoted),
    write('Benedikt gibt dir wortlos einen kleinen eisernen Schluessel.'), nl,
    write('"Der Buergermeister folgt schon zu lange Befehlen.'), nl,
    write('Er muss das von jemandem von aussen hoeren."'), nl,
    (holding(mayors_key) -> true ;
     retractall(at(mayors_key, _)), assert(holding(mayors_key)),
     write('Er gibt dir den Schluessel zum Haus des Buergermeisters.'), nl), !.
interact(benedikt) :- trust(benedikt, doubted),
    write('Benedikt wendet sich wieder dem Altar zu.'), nl,
    write('"Dann kann ich dir nichts mehr sagen."'), nl, !.

/* Mia */
interact(mia) :-
    write('Das Maedchen sieht mit einem viel zu alten Gesichtsausdruck auf.'), nl,
    write('"Du solltest dir die Namen auf den Steinen ansehen. Die Daten sind wichtig."'), nl,
    write('Sie blinzelt nicht.'), nl,
    write('"Frag Hilde nach der Decke. Sie weiss, wem sie gehoerte."'), nl, !.

/* Buergermeister Otto */
interact(otto) :- trust(otto, neutral),
    write('Der Buergermeister kommt zwei Stufen herunter und bleibt stehen.'), nl,
    write('"Dies ist ein Privathaus. Die Kneipe ist auf der anderen Seite des Platzes."'), nl,
    write('Seine Stimme ist geuebt. Amtlich.'), nl,
    write('Vertraust du ihm? (trust. / doubt.)'), nl, !.
interact(otto) :- trust(otto, trusted),
    write('Otto setzt sich schwer auf die Treppe.'), nl,
    write('"Erna kam 1987 zu mir. Sagte mir, was das Dorf braucht, um zu ueberleben.'), nl,
    write('Ich hab'' ihr geglaubt. Wir alle."'), nl,
    write('Er sieht auf seine Haende. "Ich wusste nichts von den Briefen.'), nl,
    write('Ich wusste nicht, dass sie Leute ausgesucht hatte. Monate im Voraus."'), nl, !.
interact(otto) :- trust(otto, doubted),
    write('"Raus aus meinem Haus."'), nl,
    write('Er zeigt auf die Tuer. Seine Hand zittert.'), nl, !.

/* ===================== Vertrauensentscheidungen ===================== */

current_char(erna)     :- i_am_at(village_entrance).
current_char(hilde)    :- i_am_at(inn).
current_char(jakob)    :- i_am_at(barn).
current_char(benedikt) :- i_am_at(church_interior).
current_char(otto)     :- i_am_at(mayors_house).

trust_msg(erna,     'Irgendwas an ihr wirkt aufrichtig. Oder als haette sie nichts zu gewinnen.').
trust_msg(hilde,    'Zu warm fuer 22 Uhr – aber vielleicht ist sie einfach so.').
trust_msg(jakob,    'Er wirkt nervoes, aber ehrlich. Du brauchst ein Auto.').
trust_msg(benedikt, 'Er hat dich noch nicht angelogen – oder du merkst es zumindest nicht.').
trust_msg(otto,     'Er sieht mehr veraeangstigt aus als bedrohlich. Er koennte wirklich reden.').

doubt_msg(erna) :-
    write('Warum wusste sie deinen Namen? Du nimmst ihre Worte zur Kenntnis – aber vertraust ihnen nicht.'), nl.
doubt_msg(hilde) :-
    write('Zu freundlich. Zu bereit. Du haeltst Distanz.'), nl.
doubt_msg(jakob) :-
    write('Er hat gesagt, er hat es gesehen. Von wo aus, genau?'), nl,
    write('Du merkst es vor und sagst nichts.'), nl.
doubt_msg(benedikt) :-
    write('Ein Pfarrer, der um Mitternacht Rituale in einem unkartierten Dorf durchfuehrt.'), nl,
    write('Du behaeltst deine Gedanken fuer dich.'), nl.
doubt_msg(otto) :-
    write('Er fuehrt dieses Dorf. Was auch immer hier passiert ist, er ist nicht unschuldig.'), nl.

trust :- game_over, !, game_over_notice.
trust :-
    current_char(Char), trust(Char, neutral), !,
    retract(trust(Char, _)), assert(trust(Char, trusted)),
    trust_msg(Char, Msg), write(Msg), nl.
trust :-
    current_char(_), !,
    write('Du hast dich bereits entschieden.'), nl.
trust :-
    write('Hier ist niemand, dem du vertrauen oder den du anzweifeln koenntest.'), nl.

doubt :- game_over, !, game_over_notice.
doubt :-
    current_char(Char), trust(Char, neutral), !,
    retract(trust(Char, _)), assert(trust(Char, doubted)),
    doubt_msg(Char).
doubt :-
    current_char(_), !,
    write('Du hast dich bereits entschieden.'), nl.
doubt :-
    write('Hier ist niemand, dem du vertrauen oder den du anzweifeln koenntest.'), nl.

confront_jakob :- game_over, !, game_over_notice.
confront_jakob :-
    i_am_at(barn),
    clue('Crash site: Two sets of tire tracks on the road. Someone drove very close to you just before the ditch.'),
    clue('Hilde\'s diary: Jakob threatened Hilde into silence. She knows he ran you off the road.'),
    retract(trust(jakob, _)), assert(trust(jakob, feared)),
    write('"Du sagtest, du hast es gesehen. Es gab zwei Spuren."'), nl,
    write('Jakob wird blass.'), nl,
    write('"Du hast mich von der Strasse gedaengt. Auf Ernas Befehl."'), nl,
    write('Er leugnet nicht. "Es sollte nicht – sie sagte, niemand wuerde verletzt."'), nl,
    record_clue('Jakob gestand: Er hat dich auf Ernas Befehl von der Strasse gedaengt.'), !.
confront_jakob :- i_am_at(barn),
    write('Du hast noch nicht genug, um ihn zu konfrontieren.'), nl, !.
confront_jakob :-
    write('Jakob ist nicht hier.'), nl.


/* ===================== Vertrauensleiter (5 Stufen) ===================== */
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

/* Devoted erreichen – bestehendes Vertrauen vertiefen. */

reassure :- game_over, !, game_over_notice.
reassure :-
    current_char(Char), !,
    reassure(Char).
reassure :-
    write('Hier ist niemand, den du beruhigen kannst.'), nl.

reassure(_) :- game_over, !, game_over_notice.
reassure(hilde) :-
    i_am_at(inn), trust(hilde, trusted),
    raise_trust(hilde),
    write('"Du kannst mit mir rechnen", sagst du zu ihr. Einen Moment lang glaubt sie es.'), nl,
    write('"Dann geh nicht ohne mich", sagt sie. "Versprich mir das."'), nl, !.
reassure(hilde) :-
    i_am_at(inn), trust(hilde, devoted),
    write('Sie hat sich bereits entschieden, dir alles anzuvertrauen.'), nl, !.
reassure(hilde) :-
    i_am_at(inn),
    write('Sie mustert dich. Es ist nicht der richtige Moment fuer Versprechen.'), nl, !.
reassure(jakob) :-
    i_am_at(barn), trust(jakob, trusted),
    raise_trust(jakob),
    write('"Ich glaube dir, Jakob. Bring mich hier raus – egal, was es kostet."'), nl,
    write('Erloesung ueberflutet sein Gesicht. Oder etwas, das die Gestalt der Erloesung traegt.'), nl,
    write('"Dann bleib in meiner Naehe. Mach genau, was ich sage."'), nl, !.
reassure(jakob) :-
    i_am_at(barn), trust(jakob, devoted),
    write('Jakob hat bereits dein volles Vertrauen. Vielleicht zu viel davon.'), nl, !.
reassure(jakob) :-
    i_am_at(barn),
    write('Er hat sich diese Art von Vertrauen nicht verdient.'), nl, !.
reassure(Char) :-
    character_at(Char, _), \+ current_char(Char), !,
    write('Diese Person ist nicht hier.'), nl.
reassure(_) :-
    write('Hier ist niemand, den du beruhigen kannst.'), nl.

confide :- game_over, !, game_over_notice.
confide :-
    current_char(Char), !,
    confide(Char).
confide :-
    write('Hier ist niemand, dem du dich anvertrauen kannst.'), nl.

confide(_) :- game_over, !, game_over_notice.
confide(benedikt) :-
    i_am_at(church_interior), trust(benedikt, trusted),
    clue('Church record: A stranger must witness and choose freely. If kept against their will, something breaks. The record is incomplete.'),
    raise_trust(benedikt),
    write('Du erzaehlst ihm, was in der Aufzeichnung stand – der Teil ueber das freie Waehlen.'), nl,
    write('Etwas in ihm beruhigt sich. "Dann ist es vielleicht noch nicht zu spaet."'), nl, !.
confide(benedikt) :-
    i_am_at(church_interior), trust(benedikt, trusted),
    write('Er wartet. Du spuerst, er will Beweise, dass du es verstehst – lies zuerst die Kirchenaufzeichnung.'), nl, !.
confide(benedikt) :-
    i_am_at(church_interior),
    write('Er vertraut dir noch nicht genug, um es zu hoeren.'), nl, !.
confide(Char) :-
    character_at(Char, _), \+ current_char(Char), !,
    write('Diese Person ist nicht hier.'), nl.
confide(_) :-
    write('Hier ist niemand, dem du dich anvertrauen kannst.'), nl.

/* ===================== Zeit & Glocke ===================== */

advance_time(_) :- game_over, !.
advance_time(N) :-
    game_time(T), retract(game_time(T)),
    T1 is T + N, assert(game_time(T1)),
    deadline(D),
    (T1 >= D -> ending_c ; true).

print_time :-
    game_time(T), Total is 1320 + T,
    H is (Total // 60) mod 24, M is Total mod 60,
    (M < 10
    -> format('Die Kirchenuhr zeigt ~d:0~d.~n', [H, M])
    ;  format('Die Kirchenuhr zeigt ~d:~d.~n',  [H, M])
    ).

time :- game_over, !, game_over_notice.
time :- print_time.

ring_bell :- game_over, !, game_over_notice.
ring_bell :-
    i_am_at(church_interior), bell_rung,
    write('Die Glocke hallt immer noch nach. Sie wird dir nicht zweimal Zeit kaufen.'), nl, !.
ring_bell :-
    i_am_at(church_interior), holding(rope),
    assert(bell_rung),
    deadline(D), retract(deadline(D)), D1 is D + 25, assert(deadline(D1)),
    write('Du ziehst am Seil. Die alte Glocke sträubt sich, dann schwingt sie –'), nl,
    write('ein einzelner tiefer Ton rollt ueber Kalmbach.'), nl,
    write('Irgendwo schlaegt eine Tuer zu. Die Prozession wird heute Nacht zu spaet kommen.'), nl,
    record_clue('Du hast die Kirchenglocke gelaeutet. Die Prozession ist verzoegert – mehr Zeit.'), !.
ring_bell :-
    i_am_at(church_interior),
    write('Ueber dir ist ein Glockenseilrahmen, aber kein Seil, um ihn zu erreichen.'), nl,
    write('Du brauchst ein Seil.'), nl, !.
ring_bell :-
    write('Hier ist keine Glocke.'), nl.

/* ===================== Nehmen / Fallenlassen / Inventar ===================== */

take :- write('Gib einen Gegenstand an. Beispiel: take(flashlight).'), nl.
take(X) :- var(X), !, write('Gib einen Gegenstand an. Beispiel: take(flashlight).'), nl.
take(_) :- game_over, !, game_over_notice.

take(rope) :-
    at(rope, crash_site), \+ holding(flashlight),
    write('Es ist zu dunkel, um in den Kofferraum zu sehen.'), nl, !.

take(crypt_code) :-
    at(crypt_code, graveyard), \+ holding(flashlight),
    write('Es ist zu dunkel, um die Inschrift zu entziffern.'), nl, !.

take(mirror) :-
    at(mirror, inn),
    trust(hilde, devoted), !,
    retract(at(mirror, inn)),
    assert(holding(mirror)),
    write('Hilde hebt den Spiegel eigenhaendig von der Wand und haelt ihn hin.'), nl,
    write('"Er hat immer mehr als nur ein Spiegelbild gezeigt", sagt sie.'), nl.

take(mirror) :-
    at(mirror, inn), !,
    retract(trust(hilde, _)), assert(trust(hilde, feared)),
    retract(i_am_at(_)), assert(i_am_at(village_square)),
    write('"Raus."'), nl,
    write('Sie ist um die Theke herum, bevor du reagieren kannst.'), nl,
    write('Die Tuer schliesst sich schwer hinter dir.'), nl,
    write('Du stehst auf dem Platz. Das Licht in der Kneipe geht aus.'), nl.

take(hildes_diary) :-
    at(hildes_diary, inn_cellar),
    retract(at(hildes_diary, inn_cellar)),
    assert(holding(hildes_diary)),
    write('Ein Tagebuch, hinter einem der Faesser versteckt.'), nl,
    write('Due blaetterst zu den letzten Eintraegen. Der Name Jakob taucht auf.'), nl,
    write('Und das Wort "Unfall" – in Anfuerungszeichen.'), nl,
    record_clue('Hildes Tagebuch: Jakob hat Hilde zum Schweigen gedaengt. Sie weiss, dass er dich von der Strasse gedaengt hat.'),
    (trust(hilde, doubted) ->
        retract(trust(hilde, _)), assert(trust(hilde, trusted)),
        write('Deine Meinung ueber Hilde veraendert sich. Sie hat dich beschuetzt.')
    ; true), nl, !.

take(X) :-
    holding(X),
    write('Du haeltst es bereits in der Hand.'), nl, !.

take(X) :-
    i_am_at(Place), at(X, Place),
    retract(at(X, Place)),
    assert(holding(X)),
    write('Genommen.'), nl, !.

take(_) :-
    write('Das siehst du hier nicht.'), nl.


drop :- write('Gib einen Gegenstand an. Beispiel: drop(rope).'), nl.
drop(_) :- game_over, !, game_over_notice.
drop(X) :-
    holding(X), i_am_at(Place),
    retract(holding(X)), assert(at(X, Place)),
    write('Fallen gelassen.'), nl, !.
drop(_) :-
    write('Das traegst du nicht bei dir.'), nl.

knock :- game_over, !, game_over_notice.
knock :-
    i_am_at(village_square), trust(hilde, feared), !,
    retract(trust(hilde, _)), assert(trust(hilde, neutral)),
    write('Du klopfst. Einmal. Zweimal.'), nl,
    write('Eine lange Pause. Das Licht hinter der Scheibe bewegt sich.'), nl,
    write('Der Riegel klickt. Die Tuer oeffnet sich einen Spalt.'), nl,
    write('"Der Spiegel bleibt, wo er ist", sagt sie. "Verstanden?"'), nl.
knock :-
    write('Hier gibt es nichts, an das du klopfen koenntest.'), nl.

inventory :- game_over, !, game_over_notice.
inventory :-
    write('=== Inventar ==='), nl,
    list_items.

list_items :-
    holding(X), write('  - '), write(X), nl, fail.
list_items :-
    \+ holding(_),
    write('  Leer.'), nl, !.
list_items.

/* ===================== Lesen ===================== */

read_item :- write('Gib einen Gegenstand an. Beispiel: read_item(letter).'), nl.
read_item(_) :- game_over, !, game_over_notice.
read_item(well_note) :-
    holding(well_note),
    write('"Traue niemandem, der dir zu schnell hilft."'), nl,
    write('Kein Name. In der Ecke ein Datum – fast zu blass zum Lesen.'), nl, !.

read_item(hildes_diary) :-
    holding(hildes_diary),
    write('"J. kam wieder heute Nacht. Ich sagte ihm, ich wuerde nichts sagen.'), nl,
    write('Er erinnerte mich daran, was 2019 passiert ist."'), nl,
    write('"Der Mann von der Strasse – wenn er es rausfindet, ist J. erledigt.'), nl,
    write('Und ich auch. Aber ich kann nicht weiter so tun."'), nl,
    record_clue('Hildes Tagebuch kompletter Eintrag: Jakob bedroht Hilde seit 2019.'), !.

read_item(letter) :-
    holding(letter),
    write('Adressiert an: L. Varga.'), nl,
    write('"Wir haben Ihre Bewerbung fuer die Innsbruck-Reportage erhalten.'), nl,
    write('Bitte bestaetigen Sie Ihre Ankunft fuer den 14."'), nl,
    write('Der Briefkopf ist von einem Magazin, von dem du noch nie gehoert hast.'), nl,
    write('Die Telefonnummer fuehrt ins Leere.'), nl,
    write('Jemand hat das gefaelseht. Die Handschrift auf dem Umschlag –'), nl,
    write('sorgfaeltig, ueberlegt. Du hast sie schon einmal gesehen.'), nl,
    record_clue('Der Brief: Das Innsbruck-Vorstellungsgespraech war erfunden. Jemand hat dich hierher gelockt. Die Handschrift kommt dir bekannt vor.'), !.

read_item(church_record) :-
    holding(church_record),
    write('Ein Bericht ueber die Gruendung Kalmbachs, 1648.'), nl,
    write('Erbaut ueber einer aelteren Siedlung. Die urspruenglichen Bewohner'), nl,
    write('hatten einen Brauch: Jede Generation muss ein Fremder Zeuge sein'), nl,
    write('und sich frei entscheiden – zu bleiben oder zu gehen.'), nl,
    write('Wenn er geht, setzt sich der Kreislauf fort.'), nl,
    write('Wenn er festgehalten wird – "ist der Vertrag erfuellt."'), nl,
    write('Die Aufzeichnung sagt nicht, wofuer der Vertrag ist.'), nl,
    record_clue('Kirchenaufzeichnung: Ein Fremder muss Zeuge sein und sich frei entscheiden. Wenn er gegen seinen Willen festgehalten wird, bricht etwas. Die Aufzeichnung ist unvollstaendig.'), !.

read_item(ottos_diary) :-
    holding(ottos_diary),
    write('"Erna sagt, der Fremde wird vor dem Vollmond eintreffen.'), nl,
    write('Ich fragte, woher sie das wisse. Sie sagte, sie habe ihm geschrieben."'), nl,
    write('"Ich fragte, wann. Sie sagte, vor drei Monaten."'), nl,
    write('"Ich fragte, warum sie es uns nicht gesagt habe.'), nl,
    write('Sie sagte, wir haetten sie aufgehalten."'), nl,
    record_clue('Ottos Tagebuch: Erna hat den Vorstellungsbrief selbst geschrieben, vor drei Monaten. Sie plante Leons Ankunft, ohne es dem Dorf zu sagen.'), !.

read_item(X) :-
    holding(X),
    write('Due siehst es genau an. Nichts Neues faellt auf.'), nl, !.
read_item(X) :-
    write('Du traegst '), write(X), write(' nicht bei dir.'), nl.

/* ===================== Gegenstaende bemerken ===================== */

notice_items(graveyard) :-
    at(crypt_code, graveyard),
    (holding(flashlight) ->
        write('Deine Taschenlampe zeigt eine Inschrift auf einem der Grabsteine.'), nl,
        write('Du kannst take(crypt_code) eingeben, um die Sequenz zu kopieren.')
    ;
        write('Die Grabsteine sind im Dunkeln kaum zu erkennen.')
    ), nl, fail.
notice_items(Place) :-
    at(X, Place), X \= crypt_code,
    write('Du siehst: '), write(X), write('.'), nl, fail.
notice_items(_).

/* ===================== Hinweise ===================== */

record_clue(Text) :- clue(Text), !.
record_clue(Text) :- assert(clue(Text)).

notes :- game_over, !, game_over_notice.
notes :-
    write('=== Notizen ==='), nl, list_clues.

list_clues :-
    clue(X), write('  - '), write(X), nl, fail.
list_clues :-
    \+ clue(_),
    write('  Noch nichts aufgezeichnet.'), nl, !.
list_clues.

/* ===================== Umschauen ===================== */

look :- game_over, !, game_over_notice.
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
    (NewCount >= 2 -> notice_items(Place) ; true),
    (NewCount >= 3 -> details(Place) ; true),
    nl,
    show_exits,
    show_room_actions,
    nl,
    print_time, nl, !.

/* ===================== Ausgaenge anzeigen ===================== */

show_exits :-
    i_am_at(Here),
    findall(Dir-There, raw_exit(Here, Dir, There), Exits),
    (Exits = [] -> true ;
     write('Du kannst gehen:'),
     forall(member(Dir-There, Exits),
            (write(' '), write(Dir),
             (looked_at(There, _) -> write(' ('), write(There), write(')') ; true))),
     nl).

/* ===================== Raumaktionen ===================== */

show_room_actions :- i_am_at(village_square), trust(hilde, feared), !,
    write('Die Kneipe ist dunkel. Die Tuer oeffnet sich nicht, als du die Klinke pruefst.'), nl.
show_room_actions :- i_am_at(village_entrance), !, show_character_name(village_entrance, 'Erna'),        show_erna_action.
show_room_actions :- i_am_at(inn),              !, show_character_name(inn,              'Hilde').
show_room_actions :- i_am_at(barn),             !, show_character_name(barn,             'Jakob'),       show_jakob_actions.
show_room_actions :- i_am_at(graveyard),        !, show_character_name(graveyard,        'Mia').
show_room_actions :- i_am_at(church_interior),  !, show_character_name(church_interior,  'Vater Benedikt'), show_bell_action.
show_room_actions :- i_am_at(mayors_house),     !, show_character_name(mayors_house,     'Buergermeister Otto').
show_room_actions :- i_am_at(forest),           !,
    write('Der Pfad fuehrt hinaus. Du koenntest alles hinter dir lassen.'), nl,
    (hinted(escape) -> write('(escape.)'), nl ; assert(hinted(escape))).
show_room_actions.

show_character_name(Place, Name) :-
    looked_at(Place, N), N >= 2, !,
    write(Name), write(' ist hier.'), nl.
show_character_name(_, _).

show_bell_action :-
    bell_rung, !.
show_bell_action :-
    holding(rope), !,
    write('Das Seil ist in deinen Haenden. Der Glockenrahmen wartet oben.'), nl,
    (hinted(ring_bell) -> write('(ring_bell.)'), nl ; assert(hinted(ring_bell))).
show_bell_action.

show_jakob_actions :-
    show_jakob_confront_action,
    show_jakob_follow_action.

show_jakob_confront_action :-
    trust(jakob, feared), !.
show_jakob_confront_action :-
    clue('Crash site: Two sets of tire tracks on the road. Someone drove very close to you just before the ditch.'),
    clue('Hilde\'s diary: Jakob threatened Hilde into silence. She knows he ran you off the road.'), !,
    write('Die Spuren. Das Tagebuch. Die Teile fuegen sich zusammen.'), nl,
    (hinted(confront_jakob) -> write('(confront.)'), nl ; assert(hinted(confront_jakob))).
show_jakob_confront_action.

show_jakob_follow_action :-
    trust(jakob, feared), !.
show_jakob_follow_action :-
    (trust(jakob, trusted) ; trust(jakob, devoted) ; holding(car_key)), !,
    write('Sein Blick schweift immer wieder zur Tuer.'), nl,
    (hinted(follow_jakob) -> write('(follow.)'), nl ; assert(hinted(follow_jakob))).
show_jakob_follow_action.

show_erna_action :-
    trust(erna, feared), !.
show_erna_action :-
    clue('The letter: The Innsbruck interview was fabricated. Someone lured you here. The handwriting is familiar.'),
    clue('Otto\'s diary: Erna wrote the interview letter herself, three months ago. She planned Leon\'s arrival without telling the village.'),
    bell_rung,
    trust(hilde, devoted), !,
    write('Du hast alles. Den Brief. Die Wahrheit dahinter. Die Glocke hat dir Zeit gekauft. Und Hilde ist bereit.'), nl,
    (hinted(confront_erna) -> write('(confront.)'), nl ; assert(hinted(confront_erna))).
show_erna_action.

/* ===================== Bewegung ===================== */

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
    write('Dorthin kannst du nicht gehen.'), nl.

/* ===================== Enden ===================== */

end_banner :-
    nl, write('======================================================='), nl.

ending_a :-
    assert(game_over),
    end_banner,
    write('              ENDE A — RAUS'), nl,
    end_banner, nl,
    write('Der Spiegelpfad spuckt dich auf eine Forststrasse aus.'), nl,
    write('Hinter dir ist Kalmbach bereits im Nebel verschwunden.'), nl,
    write('Due siehst nicht zurueck. Du weisst nicht, was hinter dir'), nl,
    write('passiert, und ein Teil von dir will es nie wissen.'), nl, nl,
    write('Dein Handy vibriert. Ein Balken. Eine Nachricht:'), nl,
    write('"Wir bedauern, die Innsbruck-Reportage wurde abgesagt."'), nl,
    write('Du hast dich nie fuer eine Reportage beworben.'), nl, nl,
    write('Wer hat nach dir geschickt? Was passiert in Kalmbach ohne dich?'), nl,
    write('(start. um nochmal zu spielen)'), nl, !.

ending_b :-
    assert(game_over),
    end_banner,
    write('              ENDE B — DIE GLOCKE'), nl,
    end_banner, nl,
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

ending_c :-
    assert(game_over),
    end_banner,
    write('              ENDE C — DIE PROZESSION'), nl,
    end_banner, nl,
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

game_over_notice :-
    write('Es ist vorbei. Tippe start. um nochmal zu beginnen.'), nl.

/* ----- Fluchtwege ----- */

escape :- game_over, !, game_over_notice.
escape :-
    i_am_at(forest),
    write('Du nimmst den verborgenen Pfad allein, den Weg, den der Spiegel dir gezeigt hat.'), nl,
    ending_a, !.
escape :-
    write('Hier gibt es keinen Ausweg. Der Waldpfad ist die einzige Strasse.'), nl, !.

follow_jakob :- game_over, !, game_over_notice.
follow_jakob :-
    i_am_at(barn), trust(jakob, devoted),
    write('Due folgst Jakob ohne eine einzige Frage in die Dunkelheit.'), nl,
    write('Das Auto ist nicht da, wo er es sagte. Die Strasse auch nicht.'), nl,
    write('Laternen naehern sich aus den Baeumen.'), nl,
    ending_c, !.
follow_jakob :-
    i_am_at(barn), (trust(jakob, trusted) ; holding(car_key)),
    write('Jakob fuehrt dich zum Dorfrand – dann bleibt er eiskalt stehen.'), nl,
    write('Die Strasse ist blockiert. "Ich... ich kann nicht. Tut mir leid."'), nl,
    write('Er kehrt um. Das Auto war nie der Weg nach draussen.'), nl, !.
follow_jakob :-
    i_am_at(barn),
    write('Jakob wird dich nirgendwo hinfuehren. Nicht so.'), nl, !.
follow_jakob :-
    write('Jakob ist nicht hier.'), nl.

/* ----- Die Abrechnung mit Erna ----- */

confront_erna :- game_over, !, game_over_notice.
confront_erna :-
    i_am_at(village_entrance), trust(erna, feared),
    write('Erna ist weg. Du stehst nur vor der leeren Strasse.'), nl, !.
confront_erna :-
    i_am_at(village_entrance),
    clue('The letter: The Innsbruck interview was fabricated. Someone lured you here. The handwriting is familiar.'),
    clue('Otto\'s diary: Erna wrote the interview letter herself, three months ago. She planned Leon\'s arrival without telling the village.'),
    bell_rung,
    trust(hilde, devoted),
    ending_b, !.
confront_erna :-
    i_am_at(village_entrance),
    write('Du stellst dich Erna mit dem, was du hast – aber es reicht nicht,'), nl,
    write('noch nicht. Du brauchst den Brief und den Beweis, dass sie ihn schrieb,'), nl,
    write('die gelaeutete Glocke, um Zeit zu kaufen, und Hilde bereit, mit dir zu gehen.'), nl, !.
confront_erna :-
    write('Erna ist nicht hier.'), nl.

confront :- game_over, !, game_over_notice.
confront :- i_am_at(barn),             !, confront_jakob.
confront :- i_am_at(village_entrance), !, confront_erna.
confront :- write('Hier ist niemand, den du konfrontieren kannst.'), nl.

follow :- game_over, !, game_over_notice.
follow :- i_am_at(barn), !, follow_jakob.
follow :- write('Hier ist niemand, dem du folgen kannst.'), nl.

/* ===================== Engine ===================== */

help  :- instructions.
quit  :- halt.

instructions :-
    write('-------------------------------------------------------'), nl,
    write('  Befehle:'), nl,
    write('  n. s. e. w. ne. sw. nw. se. u. d.  -> bewegen'), nl,
    write('  look.           -> umsehen'), nl,
    write('  talk.           -> mit jemandem sprechen'), nl,
    write('  take(X).        -> Gegenstand aufheben'), nl,
    write('  drop(X).        -> Gegenstand fallenlassen'), nl,
    write('  read_item(X).   -> Dokument lesen'), nl,
    write('  inventory.      -> getragene Gegenstaende anzeigen'), nl,
    write('  notes.          -> entdeckte Hinweise anzeigen'), nl,
    write('  time.           -> Uhrzeit pruefen (Mitternacht ist die Frist)'), nl,
    write('  reassure.        -> Vertrauen zu einem nahen Charakter vertiefen'), nl,
    write('  confide.         -> teilen, was du gelernt hast'), nl,
    write('  help.           -> diese Liste anzeigen'), nl,
    write('  quit.           -> Spiel beenden'), nl,
    write('-------------------------------------------------------'), nl,
    write('  Wenn du nicht weiterkommst, schau genauer hin...'), nl,
    write('  Menschen veraendern sich.'), nl,
    write('-------------------------------------------------------'), nl, nl.

/* ===================== Start ===================== */

reset_state :-
    retractall(i_am_at(_)), retractall(at(_, _)), retractall(holding(_)),
    retractall(trust(_, _)), retractall(looked_at(_, _)), retractall(clue(_)),
    retractall(game_time(_)), retractall(deadline(_)),
    retractall(bell_rung), retractall(game_over), retractall(hinted(_)),
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
    write('(Tippe help. fuer eine Liste der Befehle.)'), nl,
    nl,
    write('Due steigst aus dem Auto.'), nl,
    nl,
    look.
