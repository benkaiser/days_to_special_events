# Open Questions

## 1. Epoch reset on New Year's — what happens to ticks?
The spec says "on the next year it resets the epoch to January 1st." Currently, when the year changes, the epoch resets to Jan 1 and **all ticks are cleared**. Should previous year ticks be preserved/archived somehow, or is a clean slate correct?

## 2. Day 0 behavior
The spec says "the day when we first open it" is day 0. If the user first opens the app on April 18, day 0 is April 18. But later it says "on the next year it resets the epoch to January 1st." After that reset, does day 0 become January 1st? (Currently: yes, it does.)

## 3. Special event days — are they also tappable/tickable?
The spec describes ticking regular day chips. Should special event cards also be tickable, or are they display-only? (Currently: display-only.)

## 4. Scrolling direction
The spec says you can "scroll down and up." Currently, the list starts at the epoch date and goes forward in time as you scroll down. Past days (negative numbers) appear at the top. Should the list be reversed (newest at top)?

## 5. What happens if special event falls on the same day as epoch?
If the app is first opened on someone's birthday, does the user see both the special card AND the regular day-0 chip? (Currently: yes, both are shown.)

## 6. Color persistence when re-ticking
If a day is already ticked with red, and the user selects blue and taps the day, should it:
- **A)** Un-tick the day (toggle off) — current behavior
- **B)** Change the tick color to blue

## 7. Generated image style
The cartoon images were generated with Ideogram v3 Turbo using a "cute kawaii" style prompt. If the art style doesn't match expectations, the prompts can be adjusted and images regenerated (each image costs $0.03).

## 8. Multiple special events on the same date
If two events fall on the same date (unlikely but possible with Easter moving), should both cards be shown? (Currently: only the last one in the list wins due to map key collision.)
