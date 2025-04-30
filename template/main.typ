#import "@local/corgis:0.0.1": *

#show: slides.with(
  title: "Corgis", // Required
  subtitle: "Template for CORGIS seminar",
  date: "XX.XX.XX",
  authors: ("Jane Doe", "John Doe"),
  // footer-title: none,
  // footer-subtitle: none,
  // layout: "medium",
  // ratio: 16/9,
  // corgis: true,
  // toc: true,
  // count: "number",
  // toc-depth: 1,
  // theme: "normal" or "full" (default is "full")
)

= First Section

== First Slide

#lorem(50)

/ *Term*: Definition

== Slide 2

#lorem(150)

= Section 2

== This is itemize in typst

- Item A
- Item B
  - Subitem B.A
    + Numbered sub-subitem B.A.1

#question_slides()

== Backup slide

Hello there!