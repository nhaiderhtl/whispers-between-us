# Whispers Between Us

> *A text adventure in Prolog. Horror. Full moon.*

---

## Background

The village of Kalmbach lies somewhere in the Alps — not on any modern map, not found by any navigation system. The nearest town is 40 kilometers of gravel road away. The residents want it that way.

Once a month, on the full moon, they close their shutters.

---

You are **Leon Varga**. Freelance journalist, barely making ends meet, on your way to an interview in Innsbruck you desperately need. You are driving at night because you are running late. The shortcut through the mountains looked reasonable on the map.

Then the rain. Then the fog. Then the ditch.

Your car is two meters deep in a roadside ditch, the front axle snapped. Your phone shows no signal. It is just past 10 PM. Outside it is cold and the forest makes sounds that forests are not supposed to make.

About a kilometer down the road, you see lights.

---

You do not know Kalmbach. You do not know that tonight is a full moon. You do not know why an old woman stands at the village entrance and looks at you as if you were already dead. You do not know what *"the procession"* is, which the innkeeper murmurs about when she thinks you are asleep.

What you know: you need to get out. Your car is broken. There is no connection to the outside world. And someone in the village knows how to leave.

You just have to figure out who you can trust — before midnight comes.

---

## Start

```prolog
?- start.
```

## Commands

| Command | Action |
|---|---|
| `n.` `s.` `e.` `w.` | Move in a direction |
| `look.` | Examine surroundings |
| `talk.` | Speak to someone nearby |
| `take(X).` | Pick up an item |
| `drop(X).` | Put down an item |
| `inventory.` | Show carried items |
| `notes.` | Show discovered clues |
| `help.` | Show all commands |
| `quit.` | Quit the game |
