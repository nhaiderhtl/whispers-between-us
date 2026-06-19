# Whispers Between Us

> *A text adventure in Prolog. Horror. Full moon.*

---

## What Is This?

*Whispers Between Us* is a text-based mystery set in an isolated Alpine village on a full-moon night. You navigate twelve rooms, collect clues, and build — or destroy — trust with six characters who each have their own version of the truth. The game never tells you what to do next. It only shows you what is there, and lets you decide what it means. Every decision you make changes what you can access, what people tell you, and how the night ends. The same rooms look different the second time you play.

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
| `n.` `s.` `e.` `w.` `ne.` `sw.` `nw.` `se.` `u.` `d.` | Move |
| `look.` | Examine your surroundings |
| `talk.` | Speak to someone nearby |
| `take(X).` | Pick up an item |
| `drop(X).` | Put down an item |
| `read_item(X).` | Read a document |
| `inventory.` | Show carried items |
| `notes.` | Show discovered clues |
| `time.` | Check the clock (midnight is the deadline) |
| `reassure.` | Deepen trust with a nearby character |
| `confide.` | Share what you have learned with a nearby character |
| `help.` | Show this list |
| `quit.` | Quit the game |

> Some actions are not listed here. The game will show you when the moment is right.

---

**Three endings.** What happens at midnight depends entirely on what you chose to believe — and who chose to believe in you.
