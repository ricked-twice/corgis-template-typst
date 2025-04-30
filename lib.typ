#let layouts = (
  "small": ("height": 9cm, "space": 1.4cm),
  "medium": ("height": 10.5cm, "space": 1.6cm),
  "large": ("height": 12cm, "space": 1.8cm),
)

// Colors
#let orange = rgb("#eb811b")
#let font-color = rgb("#23373b")
#let block-color = orange.lighten(90%)
#let header-color = orange.lighten(65%)
#let fill-color = orange.lighten(50%)
#let line-color = font-color.lighten(80%)
#let background-color = rgb("#fafafa")

#let section_counter = counter("section_counter")

#let question_slides() = {
  section_counter.step()
  set page(footer: none, header: none, margin: 1cm)
  align(horizon)[
    #box(fill: font-color, inset: 10pt, width:1fr, radius: 15%)[
      #align(center + horizon)[
        #text(fill: orange.lighten(25%), size: 2.5em, "Questions?")
      ]
    ]
    #align(center)[
      #box(width: 2cm)[
        #image("resources/corgis/corgi_end.png")
      ]
    ]
  ]
}

#let slides(
  content,
  title: none,
  subtitle: none,
  footer-title: none,
  footer-subtitle: none,
  date: none,
  authors: ("John Doe"),
  layout: "medium",
  ratio: 16/9,
  corgis: true,
  toc: true,
  count: "number",
  toc-depth: 1,
  theme: "full"
) = {

  // Parsing
  if layout not in layouts {
      panic("Unknown layout " + layout)
  }
  let (height, space) = layouts.at(layout)
  let width = ratio * height

  // Setup
  set document(
    title: title,
    author: authors,
  )
  set heading(numbering: "1.a")

  // PAGE----------------------------------------------
  set page(
    width: width,
    height: height,
    margin: (x: 0.5 * space, top: space, bottom: 0.6 * space),
  // HEADER
    header: [
      #context {
        let page = here().page()
        let headings = query(selector(heading.where(level: 2)))
        let heading = headings.rev().find(x => x.location().page() <= page)

        if heading != none {
          set align(top)
          if (theme == "full") {
            block(
              width: 100%,
              fill: font-color,
              height: space * 0.75,
              outset: (x: 0.5 * space)
            )[
              #set text(1.4em, weight: "bold", fill: orange)
              #v(space * 0.25)
              #heading.body
              #if not heading.location().page() == page [
                #{numbering("(i)", page - heading.location().page() + 1)}
              ]
            ]
          } else if (theme == "normal") {
            set text(1.4em, weight: "bold", fill: orange)
            v(space / 2)
            heading.body
            if not heading.location().page() == page [
              #{numbering("(i)", page - heading.location().page() + 1)}
            ]
          }
        }
    }
  // COUNTER
    // #if corgis {
    //   context {
    //     let last = counter(page).final().first()
    //     let current = here().page()
    //     // for i in range(1,current) {}
    //     line(
    //       start: (0%, 0%),
    //       stroke: 1pt + rgb("#eb811b")
    //     )
    //   }
    // }
    // #if count == "dot" {
    //   v(-space / 1.5)
    //   set align(right + top)
    //   context {
    //     let last = counter(page).final().first()
    //     let current = here().page()
    //     // Before the current page
    //     for i in range(1,current) {
    //       link((page:i, x:0pt,y:0pt))[
    //         #box(circle(radius: 0.08cm, fill: fill-color, stroke: 1pt+fill-color))
    //       ]
    //     }
    //     // Current Page
    //     link((page:current, x:0pt,y:0pt))[
    //         #box(circle(radius: 0.08cm, fill: fill-color, stroke: 1pt+fill-color))
    //       ]
    //     // After the current page
    //     for i in range(current+1,last+1) {
    //       link((page:i, x:0pt,y:0pt))[
    //         #box(circle(radius: 0.08cm, stroke: 1pt+fill-color))
    //       ]
    //     }
    //   }
    #if count == "number" {
      v(-space / 1.33)
      set align(right + top)
      context {
        let last = counter(page).final().first()
        let current = here().page()
        set text(weight: "bold")
        set text(fill: orange)
        [#current / #last]
      }}
    ],
    header-ascent: 0%,
  // FOOTER
    footer: [
      #if corgis == true {
        v(-0.2cm)
        context {
          let total_number_of_section_and_title_slides = section_counter.final().first() + 1
          let current_number_of_section_and_title_slides = section_counter.get().first() + 1
          let last = counter(page).final().first() - total_number_of_section_and_title_slides
          let current = here().page() - current_number_of_section_and_title_slides
          let ratio = (current / last)
          if ratio > 0.05 {
            ratio -= 0.05
          }
          // Colored Style
          box()[
            #line(
              length: 100% * ratio,
              stroke: 1pt + orange
            )
          ]
          let modulo = calc.rem(current, 3)
          let corgy_img = if modulo == 0 {
            "resources/corgis/corgi_0.png"
          }
          else if modulo == 1 {
            "resources/corgis/corgi_1.png"
          }
          else {
            "resources/corgis/corgi_2.png"
          }
          box(baseline: 25%)[#image(corgy_img)]
          // If not present the second line is not proprely placed, but why this value? Magic is the answer
          let magic_ratio = -65%
          box()[
            #line(
              start: (100% * ratio + 18pt, magic_ratio),
              end: (100%, magic_ratio),
              stroke: 1pt+line-color
            )
          ]
          
          grid(
            columns: (1fr, 1fr),
            align: (right,left),
            inset: 4pt,
            [#smallcaps()[
              #if footer-title != none {footer-title} else {title}]],
            [#if footer-subtitle != none {
                footer-subtitle
            } else if subtitle != none {
                subtitle
            } else if authors != none {
                  if (type(authors) != array) {authors = (authors,)}
                  authors.join(", ", last: " and ")
                } else [#date]
            ],
          )
        }
      }
    ],
    footer-descent:0.2*space,
  )


  // SLIDES STYLING--------------------------------------------------
  // Section Slides
  show heading.where(level: 1): x => {
    set page(header: none,footer: none, margin: 0cm)
    set align(horizon)
      grid(
        columns: (1fr, 3fr),
        inset: 10pt,
        align: (right,left),
        fill: (font-color, background-color),
        [#block(height: 100%)],[#text(1.2em, weight: "bold", fill: orange)[#x]]
      )
    // Increment the section counter
    section_counter.step()
  }
  show heading.where(level: 2): pagebreak(weak: true) // this is where the magic happens
  show heading: set text(1.1em, fill: orange)


  // ADD. STYLING --------------------------------------------------
  // Font color
  show: set text(fill: font-color)

  // Terms
  show terms.item: it => {
    set block(width: 100%, inset: 5pt)
    stack(
      block(fill: header-color, radius: (top: 0.2em, bottom: 0cm), strong(it.term)),
      block(fill: block-color, radius: (top: 0cm, bottom: 0.2em), it.description),
    )
  }

  // Code
  show raw.where(block: false): it => {
    box(fill: block-color, inset: 1pt, radius: 1pt, baseline: 1pt)[#text(size:8pt ,it)]
  }

  show raw.where(block: true): it => {
    block(radius: 0.5em, fill: block-color,
          width: 100%, inset: 1em, it)
  }

  // Bullet List
  show list: set list(marker: (
    text(fill: orange)[•],
    text(fill: orange)[‣],
    text(fill: orange)[-],
  ))

  // Enum
  let color_number(nrs) = text(fill:orange)[*#nrs.*]
  set enum(numbering: color_number)

  // Table
  show table: set table(
    stroke: (x, y) => (
      x: 0.8pt + font-color,
      bottom: 0.8pt+font-color,
      top: if y == 0 {0.8pt+font-color} else if y==1 {0.4pt+font-color} else { 0pt },
    )
  )

  show table.cell.where(y: 0): set text(
    style: "normal", weight: "bold") // for first / header row

  set table.hline(stroke: 0.4pt+black)
  set table.vline(stroke: 0.4pt)

  // Quote
  set quote(block: true)
  show quote.where(block: true): it => {
    v(-5pt)
    block(
      fill: block-color, inset: 5pt, radius: 1pt,
      stroke: (left: 3pt+fill-color), width: 100%,
      outset: (left:-5pt, right:-5pt, top: 5pt, bottom: 5pt)
      )[#it]
    v(-5pt)
  }

  // Link
  show link: it => {
    if type(it.dest) != str { // Local Links
      it
    }
    else {
      underline(stroke: 0.5pt+orange)[#it] // Web Links
    }
  }

  // Outline
  set outline(
    target: heading.where(level: toc-depth),
    indent: auto,
  )

  show outline: set heading(level: 2) // To not make the TOC heading a section slide by itself

  // Bibliography
  set bibliography(
    title: none
  )


  // CONTENT---------------------------------------------
  // Title Slide
  if (title == none) {
    panic("A title is required")
  }
  else {
    if (type(authors) != array) {
      authors = (authors,)
    }
    set page(footer: none, header: none, margin: 0cm)
    block(
      inset: (x:0.5*space, y:10em),
      width: 100%,
      height: 60%,
      align(bottom)[
        #text(
          2.0em, weight: "bold",
          title
        )
        #line(
          length: 100%,
          stroke: 0.5pt + orange
        )
      ]
    )
    block(
      height: 30%,
      width: 100%,
      inset: (x:0.5*space, top:-3cm, bottom: 1em),
      if subtitle != none {[
        #text(1.4em, weight: "bold", subtitle)
      ]} +
      if subtitle != none and date != none { text(1.4em)[ \ ] } +
      v(0.2cm) +
      if date != none {text(1.1em, date)} +
      v(1cm) +
      align(left,
        // authors.join(", ", last: " and ")
        for author in authors {
          if author == authors.first() {
            text(strong(author) + linebreak())
          }
          else {
            author
            if author != authors.last() {
              linebreak()
            }
          }
        }
      )
    )
    // counter(page).update(n => if n > 2 { n - 2 }  else { 0 })
  }

  // Outline
  if (toc == true) {
    outline()
  }
  // Normal Content
  content

}