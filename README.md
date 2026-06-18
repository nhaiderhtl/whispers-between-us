# Whispers Between Us

> *Ein Text-Adventure in Prolog. Horror. Vollmond.*

---

## Hintergrundgeschichte

Das Dorf Kalmbach liegt irgendwo in den Alpen — auf keiner modernen Karte eingetragen, von keinem Navi gefunden. Die nächste Stadt ist 40 Kilometer Schotterstraße entfernt. Die Bewohner wollen das so.

Einmal im Monat, bei Vollmond, schließen sie die Fensterläden.

---

Du heißt **Leon Varga**. Journalist. Freiberuflich, mittellos, auf dem Weg zu einem Interview in Innsbruck das du dringend brauchst. Du fährst nachts, weil du spät dran bist. Die Abkürzung durchs Gebirge schien auf der Karte vernünftig aus.

Dann der Regen. Dann der Nebel. Dann der Graben.

Dein Auto liegt zwei Meter tief im Straßengraben, die Vorderachse geknickt. Dein Handy zeigt null Balken. Es ist kurz nach 22 Uhr. Draußen ist es kalt und der Wald macht Geräusche die Wälder eigentlich nicht machen.

Etwa einen Kilometer die Straße runter siehst du Lichter.

---

Du kennst Kalmbach nicht. Du weißt nicht, dass heute Nacht Vollmond ist. Du weißt nicht, warum ein alter Mann am Ortseingang steht und dich ansieht, als wärst du bereits tot. Du weißt nicht, was *"die Prozession"* ist, von der die Wirtin murmelnd spricht, als sie denkt du schläfst.

Was du weißt: Du musst hier weg. Dein Auto ist kaputt. Es gibt keine Verbindung nach außen. Und irgendjemand im Dorf weiß, wie du rauskommst.

Du musst nur herausfinden wem du vertrauen kannst — bevor Mitternacht kommt.

---

## Spielstart

```prolog
?- start.
```

## Befehle

| Befehl | Aktion |
|---|---|
| `n.` `s.` `e.` `w.` | Bewegung |
| `look.` | Umgebung beschreiben |
| `talk.` | Mit Charakter sprechen |
| `take(X).` | Item aufheben |
| `drop(X).` | Item ablegen |
| `inventory.` | Inventar anzeigen |
| `help.` | Befehle anzeigen |
| `quit.` | Spiel beenden |
