# GAME_DESIGN — Whispers Between Us

> Entwickler-Referenz. Bei jeder Spieländerung synchron halten.

---

## Design-Prinzipien

- **Partielles Unwissen:** Spieler bekommt nie das vollständige Bild auf einmal. Infos kommen fragmentiert — durch Items, Dialoge, Raumdetails.
- **Offenes Ende:** Kein Ending löst alles auf. Immer bleibt eine Frage offen. Das soll Neugierde auf zweiten Durchlauf wecken.
- **Mehrere Wahrheiten:** Charaktere lügen nicht immer absichtlich — manche glauben selbst an ihre Version. Spieler muss selbst urteilen.
- **Reversibles Vertrauen:** Neue Beweise können Einschätzungen komplett kippen. Frühe Entscheidungen sind nicht permanent.
- **Belohntes Erkunden:** Wer alle Räume besucht und alle Charaktere befragt, versteht mehr — wird aber nie alles verstehen.

---

## Story-Kern

**Spieler:** Leon Varga, Journalist, freiberuflich  
**Situation:** Autounfall bei Nacht auf Schotterstraße, isoliertes Alpendorf Kalmbach  
**Scheinbares Ziel:** Aus dem Dorf raus, zurück zur Zivilisation  
**Echtes Ziel:** Erst im Spielverlauf klar — jemand hat dafür gesorgt, dass du hier bist  
**Zeitdruck:** Mitternacht — die Prozession beginnt  

**Was der Spieler am Anfang weiß:**
- Unfall, kein Empfang, Lichter im Dorf
- Ein alter Mann am Ortseingang starrt ihn an
- Es ist Vollmond

**Was der Spieler nie vollständig erfährt:**
- Warum genau er ausgewählt wurde
- Was Mia wirklich ist
- Ob Ernas Plan jemals aufgegangen wäre

---

## Karte

```
[Unfallort]
     |
  (Waldweg)
     |
[Dorfeingang]
     |
[Dorfplatz] ──── [Wirtshaus] ──── [Wirtshauskeller]
     |
     ├──── [Kirche/Friedhof] ──── [Kircheninneres] ──── [Krypta]
     |
     ├──── [Bürgermeisterhaus]
     |
     └──── [Scheune]

[Wald] (freischaltbar vom Dorfplatz, nur nachts mit Spiegel)
```

---

## Räume

### Unfallort
- **Beschreibung:** Straßengraben, Vorderachse geknickt, Regen, Nebel. Lichter in der Ferne sichtbar.
- **Items:** Taschenlampe (im Handschuhfach), Seil (im Kofferraum — erst nach Rätsel erreichbar)
- **Verbindungen:** N → Waldweg
- **Details:** Reifenspuren auf der Straße — zwei Sets. Ein Fahrzeug hat dich gedrängt. Spieler bemerkt das vielleicht nicht sofort.

### Waldweg
- **Beschreibung:** Schmaler Pfad, Bäume schließen sich über dir. Geräusche im Unterholz.
- **Items:** —
- **Verbindungen:** S → Unfallort, N → Dorfeingang
- **Details:** Frische Fußspuren im Schlamm Richtung Dorf — mehrere Personen, kürzlich

### Dorfeingang
- **Beschreibung:** Verwittertes Ortsschild: *"Kalmbach — Gegründet 1648."* Erna steht reglos daneben.
- **Charakter:** Erna
- **Items:** —
- **Verbindungen:** S → Waldweg, N → Dorfplatz

### Dorfplatz
- **Beschreibung:** Kleiner Platz, Brunnen in der Mitte. Fensterläden überall geschlossen. Kein Mensch zu sehen außer von weitem Schatten.
- **Items:** Notiz am Brunnen (anonym: *"Glaube niemandem der dir zu schnell hilft."*)
- **Verbindungen:** W → Wirtshaus, N → Kirche/Friedhof, O → Bürgermeisterhaus, S → Dorfeingang, SW → Scheune

### Wirtshaus
- **Beschreibung:** Warm, riecht nach Holzrauch. Hilde wischt die Theke. Zu freundlich für diese Uhrzeit.
- **Charakter:** Hilde
- **Items:** Spiegel (an Wand, nimmt Zeit und Hildes Vertrauen), Schlüssel zu Wirtshauskeller (hinter Theke)
- **Verbindungen:** O → Dorfplatz, Treppe → Wirtshauskeller

### Wirtshauskeller
- **Beschreibung:** Schimmel, alte Weinfässer. Und eine frische Matratze. Jemand hat hier kürzlich geschlafen — oder versteckt.
- **Items:** Hildes Tagebuch (versteckt hinter Fass — nur bei `trust(hilde, trusted)` auffindbar)
- **Verbindungen:** Treppe → Wirtshaus
- **Details:** Tagebuch enthüllt: Hilde weiß von Jakob. Sie hat geschwiegen aus Angst, nicht aus Loyalität.

### Kirche/Friedhof
- **Beschreibung:** Alte Kirche, Friedhof davor. Mia sitzt auf einem Grabstein.
- **Charakter:** Mia
- **Items:** Grabstein-Inschrift (lesbar mit Taschenlampe — gibt Krypta-Code)
- **Verbindungen:** S → Dorfplatz, Tür → Kircheninneres

### Kircheninneres
- **Beschreibung:** Kerzen brennen, obwohl niemand da ist. Pfarrer Benedikt kniet vor dem Altar.
- **Charakter:** Pfarrer Benedikt
- **Items:** Altes Kirchenbuch (gibt Hintergrund zur Prozession, unvollständig)
- **Verbindungen:** Tür → Kirche/Friedhof, Stufen → Krypta (nur mit Krypta-Code)

### Krypta
- **Beschreibung:** Unter der Kirche. Kalt. Steinplatten mit Namen. Eine Platte ist frisch verschoben.
- **Items:** Brief (adressiert an "L.V." — Leons Initialen. Geschrieben vor 3 Monaten.)
- **Verbindungen:** Stufen → Kircheninneres
- **Details:** Brief enthüllt: Das Interview war gefälscht. Jemand wollte Leon hier haben. Absender unbekannt — aber Handschrift taucht später wieder auf.

### Bürgermeisterhaus
- **Beschreibung:** Massiv, abgesperrt. Licht im Obergeschoss.
- **Charakter:** Bürgermeister Otto (nur erreichbar wenn `trust(benedikt, trusted)` oder mit Schlüssel)
- **Items:** Tagebuch des Bürgermeisters (Krypta-Schlüssel nötig um reinzukommen)
- **Verbindungen:** W → Dorfplatz

### Scheune
- **Beschreibung:** Türspalt offen. Jakob steht drin, wartet. Wirkt nervös.
- **Charakter:** Jakob
- **Items:** Zündschlüssel (Jakobs Auto — funktionierendes Fahrzeug, aber Straße ist blockiert)
- **Verbindungen:** NO → Dorfplatz

### Wald
- **Beschreibung:** Dicht. Kein Mondlicht außer an einer Stelle — dort spiegelt sich etwas.
- **Items:** —
- **Verbindungen:** Dorfplatz (Eingang nur nachts mit Spiegel sichtbar), Waldpfad → Fluchtroute
- **Freischaltung:** `at(spiegel, in_hand)` + nach Mitternacht gesperrter Pfad

---

## Charaktere

### Erna
- **Ort:** Dorfeingang
- **Scheinbar:** Alte Frau, warnt den Spieler
- **Wahrheit:** Anführerin. Die Warnung war keine Warnung — sie war eine Einladung formuliert als Warnung, um sicherzustellen dass Leon ins Dorf kommt.
- **Trust-Effekte:**
  - `neutral` → cryptische Sätze, nichts Konkretes
  - `trusted` → gibt falschen Tipp: soll zum Pfarrer gehen
  - `doubted` → schweigt, aber Mimik verrät Unruhe
  - `feared` → versteckt sich, nicht mehr ansprechbar
- **Twist-Enthüllung:** Handschrift im Brief aus der Krypta ist Ernas.

### Hilde
- **Ort:** Wirtshaus
- **Scheinbar:** Freundliche Wirtin, hilfsbereit
- **Wahrheit:** Selbst Gefangene des Systems. Weiß von Jakobs Plan. Hat geschwiegen aus Angst.
- **Trust-Effekte:**
  - `neutral` → Smalltalk, kein Inhalt
  - `trusted` → gesteht Angst, gibt Hinweis auf Keller
  - `devoted` → gibt Spiegel ohne Bedingung, warnt vor Erna
  - `doubted` → verweigert Spiegel, Keller bleibt zu
- **Reversibilität:** Wenn Spieler Hildes Tagebuch findet ohne ihr zu vertrauen → Trust springt sofort auf `trusted`

### Jakob
- **Ort:** Scheune
- **Scheinbar:** Einziger Verbündeter, will Leon rausbringen
- **Wahrheit:** Hat Leons Auto von der Straße gedrängt. Arbeitet für Erna. Bereut es — aber handelt nicht dagegen.
- **Trust-Effekte:**
  - `neutral` → bietet Hilfe an, sagt Auto steht bereit
  - `trusted` → gibt Zündschlüssel, führt zum Waldrand (Falle)
  - `devoted` → Leon folgt Jakob blind → schlechtestes Ending möglich
  - `doubted` → Jakob wird defensiv, gibt trotzdem Key wenn Spieler ihn unter Druck setzt
  - `feared` → Jakob flieht, Zündschlüssel bleibt in Scheune
- **Reversibilität:** Reifenspuren am Unfallort + Hildes Tagebuch zusammen → Trust fällt auf `feared`, Schlüssel trotzdem findbar

### Pfarrer Benedikt
- **Ort:** Kircheninneres
- **Scheinbar:** Sinister, weicht aus
- **Wahrheit:** Will den Fluch brechen, aber glaubt der einzige Weg ist durch die Prozession. Kein Bösewicht — tragische Figur.
- **Trust-Effekte:**
  - `neutral` → betet, ignoriert Leon fast
  - `trusted` → erklärt Prozession (seine Version), öffnet Krypta-Zugang
  - `devoted` → gibt Schlüssel zu Bürgermeisterhaus
  - `doubted` → Krypta bleibt zu ohne Code
- **Wichtig:** Benedikts Version der Wahrheit ist unvollständig aber ehrlich gemeint

### Mia
- **Ort:** Kirchhof/Friedhof
- **Scheinbar:** Kind, versteckt sich, weiß seltsame Dinge
- **Wahrheit:** Seit 10 Jahren tot. Spieler erfährt das nie direkt — nur Andeutungen. Grabstein mit ihrem Namen ist lesbar.
- **Trust-Effekte:** kein Trust-System — Mia verhält sich immer gleich, gibt immer korrekte Infos
- **Besonderheit:** Einzige Figur die nie lügt. Aber Spieler hat keinen Grund ihr früh zu vertrauen.
- **Twist-Enthüllung:** Grabstein-Code → Mias Geburts- und Sterbedatum sichtbar → Sterbedatum: vor 10 Jahren. Spieler rechnet nach.

### Bürgermeister Otto
- **Ort:** Bürgermeisterhaus
- **Scheinbar:** Autoritäre Figur, Anführer
- **Wahrheit:** Weiß selbst nicht alles. Führt aus was ihm Erna seit Jahren sagt. Schwach, nicht böse.
- **Trust-Effekte:**
  - `neutral` → sagt "geh schlafen"
  - `trusted` → zeigt Tagebuch, bricht innerlich zusammen
  - `doubted` → wirft Leon raus

---

## Trust-System

### Stufen
```
feared → doubted → neutral → trusted → devoted
  -2        -1        0        +1        +2
```

### Änderungen
- Steigt durch: richtige Dialogoptionen, passende Items vorzeigen, Räume in richtiger Reihenfolge
- Sinkt durch: Lügen aufdecken (via Items/Tagebücher), falschen Charakteren vertrauen, bestimmte Aktionen
- **Reversibel:** Beweisitems (Tagebücher, Briefe, Notizen) können Trust sprunghaft ändern unabhängig von bisherigen Entscheidungen

### Dialogoptionen
Entscheidungen im Dialog ändern Trust. Beispiele:
- `glauben.` / `zweifeln.` / `schweigen.`
- `konfrontieren(jakob).` — nur möglich wenn Reifenspuren UND Tagebuch gefunden
- `beruhigen(hilde).` — erhöht Trust wenn Spieler vorher Keller nicht betreten hat

---

## Items

| ID | Name | Ort | Verwendung |
|---|---|---|---|
| `taschenlampe` | Taschenlampe | Unfallort (Handschuhfach) | Grabstein lesen, dunkle Räume |
| `seil` | Seil | Unfallort (Kofferraum) | Kirchturm-Glocke reparieren |
| `spiegel` | Spiegel | Wirtshaus (Wand) | Waldpfad nachts sichtbar machen |
| `kryptagruppe` | Krypta-Code | Grabstein (mit Taschenlampe) | Krypta öffnen |
| `hildebuch` | Hildes Tagebuch | Wirtshauskeller | Jakob entlarven → Trust(jakob) sinkt |
| `brief` | Brief an L.V. | Krypta | Enthüllt: Interview war Falle |
| `ottobuch` | Ottos Tagebuch | Bürgermeisterhaus | Ernas Rolle bestätigen |
| `kirchenbuch` | Altes Kirchenbuch | Kircheninneres | Prozession-Hintergrund (unvollständig) |
| `zuendschluessel` | Zündschlüssel | Scheune | Jakobs Auto starten |
| `brunnennotiz` | Notiz am Brunnen | Dorfplatz | Erste Warnung (anonym) |

---

## Rätsel

| ID | Beschreibung | Benötigt | Freischaltet |
|---|---|---|---|
| `seil_kofferraum` | Kofferraum klemmt — Seil holen | Taschenlampe (Schloss sehen) | Seil im Inventar |
| `glocke` | Kirchturmglocke läutet nicht | Seil | Prozession verzögert sich — mehr Zeit |
| `krypta_code` | Krypta-Tür verschlossen | Grabstein-Code (Taschenlampe) | Krypta betreten |
| `waldpfad` | Waldeingang nachts unsichtbar | Spiegel | Fluchtroute durch Wald |
| `konfrontation` | Jakob konfrontieren | Reifenspuren bemerkt + Hildes Tagebuch | Neue Dialogoptionen, Trust kippt |

---

## Entscheidungen & Konsequenzen

| Aktion | Voraussetzung | Konsequenz |
|---|---|---|
| `glauben(jakob).` | storage_room | Trust(jakob)+1 |
| `zweifeln(jakob).` | storage_room | Trust(jakob)-1 |
| `konfrontieren(jakob).` | Reifenspuren + hildebuch | Trust(jakob) → feared, Schlüssel bleibt in Scheune |
| `nehmen(spiegel).` | Wirtshaus | Trust(hilde)-1 wenn ohne Erlaubnis |
| `fragen(hilde, keller).` | Trust(hilde, trusted) | Keller-Tür öffnet |
| `glocke_lauten.` | Seil in hand + Kircheninneres | +10 Minuten Spielzeit |
| `lesen(grabstein).` | Taschenlampe + Friedhof | Krypta-Code + Mias Sterbedatum sichtbar |

---

## Zeitdruck

Mitternacht als Grenze. Mechanik: Aktionen verbrauchen Zeit (implizit). Glocke läuten gibt mehr Zeit. Nach Mitternacht: Waldpfad gesperrt, bestimmte Charaktere nicht mehr ansprechbar.

---

## Endings

### Ende A — Flucht (alleine)
**Bedingung:** Spiegel + Waldpfad + ohne Jakob  
**Ton:** Du bist draußen. Du weißt nicht was hinter dir passiert. Dein Handy hat wieder Empfang. Erste Nachricht: das Interview in Innsbruck wurde "leider abgesagt."  
**Offen:** Wer hat das Interview geschickt? Was passiert in Kalmbach ohne dich?

### Ende B — Befreiung
**Bedingung:** Glocke läuten + Erna konfrontieren (ottobook + brief) + Hilde mitnehmen  
**Ton:** Der Fluch — was auch immer er war — bricht. Hilde kommt mit. Das Dorf ist still. Benedikt bleibt.  
**Offen:** Mia taucht ein letztes Mal auf und winkt. War sie je real?

### Ende C — Geopfert
**Bedingung:** Mitternacht erreicht oder Jakob blind vertraut (devoted)  
**Ton:** Die Prozession beginnt. Du verstehst jetzt alles. Zu spät.  
**Offen:** Wer kommt als nächstes nach Kalmbach?

---

## Offene Fragen (bewusst nie aufgelöst)

- Wer hat den Brief in der Krypta geschrieben? (Handschrift = Erna, aber warum 3 Monate vorher?)
- Was ist Mia wirklich?
- Was passiert beim nächsten Vollmond?
- Gibt es andere Dörfer wie Kalmbach?

---

## Technischer Stand

| Feature | Status |
|---|---|
| Bewegung n/s | ✅ implementiert |
| look / describe | ✅ implementiert |
| talk / interact | ✅ implementiert (marcus) |
| Trust-System (2 Stufen) | ✅ implementiert (neutral/trusted/doubted) |
| Trust-System (5 Stufen) | ⬜ geplant |
| take / drop | ⬜ geplant |
| inventory | ⬜ geplant |
| Zeitdruck / Mitternacht | ⬜ geplant |
| Items | ⬜ geplant |
| Vollständige Karte | ⬜ geplant |
| Vollständige Charaktere | ⬜ geplant |
| Rätsel | ⬜ geplant |
| Endings | ⬜ geplant |
