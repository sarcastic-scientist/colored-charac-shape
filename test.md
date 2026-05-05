---
title: "colored-charac-shape lua filter"
author: "sarcastic-scientist"
---

# Shape and Color Tests

Each inline code span below should render as a filled colored shape.

## Squares

- Red square: `square:#FF0000`
- Green square: `square:#00FF00`
- Blue square: `square:#0000FF`

## Circles

- Orange circle: `circle:#FF8800`
- Purple circle: `circle:#8800FF`
- Teal circle: `circle:#008899`

## Triangles

- Gold triangle: `triangle:#FFD700`
- Crimson triangle: `triangle:#DC143C`
- Forest triangle: `triangle:#228B22`

## Diamonds

- Hot pink diamond: `diamond:#FF69B4`
- Navy diamond: `diamond:#001F5B`
- Coral diamond: `diamond:#FF6347`

## Stars

- Magenta star: `star:#FF00FF`
- Cyan star: `star:#00FFFF`
- Olive star: `star:#808000`

## Mixed inline usage

The traffic light uses
`circle:#FF0000` red,
`circle:#FFCC00` yellow, and
`circle:#00CC00` green circles.

A colorful row of shapes:
`square:#E74C3C`
`circle:#2ECC71`
`triangle:#3498DB`
`diamond:#9B59B6`
`star:#F39C12`

## Non-matching code (should pass through unchanged)

- `notashape:#FF0000`
- `square:#GG0000`
- `square:FF0000`
- `square`



