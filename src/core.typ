// campus-talk 内核：精简自 touying 主题，无 grayness / 背景透明度 API
#import "@preview/touying:0.5.5": *

#let _underline-highlight(self: none, it) = underline(
  stroke: 0.5em + self.colors.primary-lightest.opacify(-40%),
  evade: false,
  background: true,
  it,
)

#let _tblock(self: none, title: none, it) = {
  grid(
    columns: 1,
    row-gutter: 0pt,
    block(
      fill: self.colors.primary-dark,
      width: 100%,
      radius: (top: 6pt),
      inset: (top: 0.4em, bottom: 0.3em, left: 0.5em, right: 0.5em),
      text(fill: self.colors.neutral-lightest, weight: "bold", title),
    ),
    rect(
      fill: gradient.linear(self.colors.primary-dark, self.colors.primary.lighten(90%), angle: 90deg),
      width: 100%,
      height: 4pt,
    ),
    block(
      fill: self.colors.primary-light.lighten(90%),
      width: 100%,
      radius: (bottom: 6pt),
      inset: (top: 0.4em, bottom: 0.5em, left: 0.5em, right: 0.5em),
      it,
    ),
  )
}

#let tblock(title: none, it) = touying-fn-wrapper(_tblock.with(title: title, it))
#let underline-highlight(it) = touying-fn-wrapper(_underline-highlight.with(it))

#let outline-slide(
  config: (:),
  /// 左侧主标题，例如「目录」
  title: [目录],
  /// 左侧副标题，例如「Contents」；传 `none` 可隐藏
  subtitle: [Contents],
  numbered: true,
  depth: 1,
  panel-ratio: 0.30,
  /// 色块贴左 / header 下 / footer 上 三边（画在 background 上）
  flush: true,
  chrome-header: 2.55em,
  chrome-progress: 7pt,
  chrome-footer: 1.55em,
  page-width: 841.89pt,
  page-height: 473.563pt,
  ..args,
) = touying-slide-wrapper(self => {
  self.store.title = none
  let panel-body = {
    set par(leading: 0.45em)
    set align(center)
    text(
      fill: self.colors.neutral-lightest,
      size: 2.2em,
      weight: 700,
      font: self.store.fonts.title,
      style: "italic",
      title,
    )
    if subtitle != none {
      v(0.5em)
      text(
        fill: self.colors.neutral-lightest.transparentize(18%),
        size: 1.0em,
        weight: 600,
        tracking: 0.08em,
        subtitle,
      )
    }
  }
  let panel-w = page-width * panel-ratio
  let panel-h = page-height - chrome-header - chrome-progress - chrome-footer + 0.5pt
  let entries-h = panel-h - 2.4em
  let entries = context {
    let items = query(heading).filter(h => h.level <= depth and h.outlined)
    grid(
      columns: 1,
      row-gutter: 0.8em,
      ..items.enumerate().map(((i, h)) => {
        let dest = {
          if h.has("label") and str(h.label) == "touying:skip" {
            let nxt = query(selector(heading).after(h.location())).filter(it => it != h)
            if nxt.len() > 0 { nxt.at(0).location() } else { h.location() }
          } else {
            h.location()
          }
        }
        link(dest, {
          grid(
            columns: (3.5pt, auto, auto),
            column-gutter: (0.75em, 0.55em),
            align: (horizon, horizon, horizon),
            block(
              width: 100%,
              height: 1.35em,
              fill: self.colors.primary,
              radius: 1pt,
            ),
            if numbered {
              text(
                fill: self.colors.primary,
                size: 1.35em,
                weight: 800,
                numbering("01", i + 1),
              )
            } else {
              none
            },
            text(
              fill: self.colors.primary-darkest,
              size: 1.35em,
              weight: 700,
              h.body,
            ),
          )
        })
      }),
    )
    args.pos().sum(default: none)
  }
  let chrome = self.store.background
  self = utils.merge-dicts(
    self,
    config-page(
      header: self.store.header.with(title: none),
      footer: self.store.footer,
      background: if flush {
        {
          utils.call-or-display(self, chrome)
          place(
            top + left,
            dy: chrome-header + chrome-progress,
            block(
              width: panel-w,
              height: panel-h,
              fill: self.colors.primary,
              radius: (top-right: 4pt, bottom-right: 4pt),
              align(center + horizon, panel-body),
            ),
          )
        }
      } else {
        utils.call-or-display(self, chrome)
      },
    ),
    config,
  )
  touying-slide(
    self: self,
    if flush {
      // 满高容器：垂直居中 + 左对齐；左侧与色块保持间距
      block(
        width: 100%,
        height: entries-h,
        inset: (
          left: panel-w - 1.85em + 3.6em,
          right: 1.2em,
        ),
        align(horizon + start, entries),
      )
    } else {
      grid(
        columns: (panel-ratio * 1fr, (1 - panel-ratio) * 1fr),
        rows: (entries-h,),
        column-gutter: 2.2em,
        block(
          width: 100%,
          height: 100%,
          fill: self.colors.primary,
          radius: 4pt,
          align(center + horizon, panel-body),
        ),
        align(horizon + start, entries),
      )
    },
  )
})

#let new-section-slide(
  config: (:),
  title: [目录],
  subtitle: [Contents],
  numbered: true,
  ..args,
  body,
) = outline-slide(
  config: config,
  title: title,
  subtitle: subtitle,
  numbered: numbered,
  ..args,
  body,
)

#let title-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      header: self.store.header.with(title: none),
      background: utils.call-or-display(self, self.store.background),
    ),
    config,
  )
  self.store.title = none
  let info = self.info + args.named()
  info.authors = {
    let authors = if "authors" in info {
      info.authors
    } else {
      info.author
    }
    if type(authors) == array {
      authors
    } else {
      (authors,)
    }
  }

  let eyebrow = if self.store.brand != none {
    self.store.brand
  } else {
    [个人陈述]
  }

  let body = {
    align(center + horizon, {
      set par(leading: 0.55em)

      // 眉题：紫色小字（brand）
      text(
        fill: self.colors.primary,
        size: 0.92em,
        weight: 700,
        tracking: 0.06em,
        eyebrow,
      )
      v(1.0em)

      // 中间大横幅：主色底 + 白字（高度随标题/副标题自适应）
      block(
        width: 100%,
        fill: self.colors.primary,
        inset: (x: 1.7em, y: 0.95em),
        {
          set align(center)
          set text(
            fill: self.colors.neutral-lightest,
            font: self.store.fonts.title,
            weight: 700,
            style: "italic",
          )
          text(size: 2.1em, info.title)
          if info.subtitle != none {
            v(0.45em)
            text(
              size: 1.05em,
              weight: 600,
              style: "normal",
              fill: self.colors.neutral-lightest.transparentize(6%),
              info.subtitle,
            )
          }
        },
      )

      v(1.2em)

      // 横幅下：黑 / 紫 信息层
      set text(font: self.store.fonts.main, weight: 700)
      text(size: 1.2em, fill: self.colors.primary-darkest, info.authors.join(" · "))
      v(0.45em)
      if info.institution != none {
        text(size: 1.05em, fill: self.colors.primary, weight: 600, info.institution)
        v(0.35em)
      }
      if info.date != none {
        text(
          size: 0.95em,
          fill: self.colors.primary-darkest.lighten(32%),
          weight: 500,
          info.date.display("[year] 年 [month] 月 [day] 日"),
        )
      }
    })
  }
  touying-slide(self: self, body)
})

/// 焦点页：纯主色背景，不计页码（参考 shuimu-touying）
#let focus-slide(
  config: (:),
  align: horizon + center,
  body,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      fill: self.colors.primary,
      margin: 2em,
      header: none,
      footer: none,
      background: none,
    ),
  )
  set text(
    fill: self.colors.neutral-lightest,
    weight: "bold",
    size: self.store.fonts.focus-size,
  )
  touying-slide(
    self: self,
    config: config,
    std.align(align, body),
  )
})

#let slide(title: auto, ..args) = touying-slide-wrapper(self => {
  if title != auto {
    self.store.title = title
  }
  self = utils.merge-dicts(
    self,
    config-page(
      header: self.store.header,
      footer: self.store.footer,
      background: utils.call-or-display(self, self.store.background),
    ),
  )
  touying-slide(self: self, ..args)
})

#let campus-talk-base(
  aspect-ratio: "16-9",
  font-size: 20pt,
  font: ("IBM Plex Sans", "Noto Sans CJK SC", "Times New Roman", "SimSun"),
  fonts: none,
  ..args,
  body,
) = {
  let resolved-fonts = if fonts != none {
    fonts
  } else {
    (
      main: font,
      title: ("Lora", "LXGW WenKai", "Noto Serif"),
      mono: "Sarasa Mono SC",
      body-size: font-size,
      header-size: 1.35em,
      footer-size: 0.72em,
      focus-size: 1.5em,
      mono-size: 18pt,
    )
  }

  show raw: set text(font: resolved-fonts.mono, size: resolved-fonts.mono-size)
  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (top: 4em, bottom: 2em, x: 2em),
      header-ascent: 1.6em,
    ),
    config-common(slide-fn: slide),
    config-methods(
      alert: utils.alert-with-primary-color,
      tblock: _tblock,
      init: (self: none, body) => {
        set text(font: resolved-fonts.main, size: resolved-fonts.body-size, weight: 600)
        set list(marker: [--])
        show figure.caption: set text(size: 0.6em)
        show footnote.entry: set text(size: 0.6em)
        show heading: set text(fill: self.colors.primary)
        show link: it => if type(it.dest) == str {
          set text(fill: self.colors.primary)
          it
        } else {
          it
        }
        show figure.where(kind: table): set figure.caption(position: top)
        body
      },
    ),
    config-colors(
      primary: rgb(0, 69, 120),
      primary-light: rgb(0, 120, 212),
      primary-lighter: rgb("#85bae3"),
      primary-lightest: rgb(199, 224, 244),
      primary-dark: rgb("#012c76"),
      primary-darker: rgb("#072644"),
      primary-darkest: rgb("#0a0a0a"),
      neutral-lightest: rgb("#F5F5F5"),
      neutral-darkest: rgb("#3F3F3F"),
      highlight: rgb("#f3e037"),
      title-color: rgb("#000000"),
    ),
    config-common(new-section-slide-fn: new-section-slide),
    config-store(
      title: none,
      brand: none,
      fonts: resolved-fonts,
      header: (self, title: auto) => {
        set align(top)
        set align(center)
        show: components.cell.with(height: 180%, width: 100%, inset: 2em)
        set align(horizon)
        set align(left)
        set text(
          fill: self.colors.primary,
          size: 1.5em,
          font: self.store.fonts.title,
          style: "italic",
        )
        if title == none {} else if title == auto {
          context {
            utils.display-current-heading(level: 1, numbered: false)
            if self.store.title != none {
              [#set text(style: "normal"); #utils.call-or-display(self, "  |  ")]
              utils.call-or-display(self, self.store.title)
            } else if utils.current-heading(level: 2) != none {
              [#set text(style: "normal"); #utils.call-or-display(self, "  |  ")]
              utils.display-current-heading(level: 2, numbered: false)
            }
          }
        } else {
          title
        }
      },
      footer: self => {
        show: pad.with(.4em)
        set text(fill: self.colors.primary-dark, size: 0.75em, weight: 500)
        set align(bottom)
        self.info.institution
        h(1fr)
        if "authors" in self.info {
          self.info.authors.join(", ")
        } else {
          self.info.author
        }
        h(1fr)
        self.info.title
        h(1fr)
        self.info.date.display("[year] 年 [month] 月 [day] 日")
        h(1fr)
        set text(fill: self.colors.neutral-lightest)
        context utils.slide-counter.display() + " / " + utils.last-slide-number
      },
      background: self => {},
    ),
    config-info(
      institution: [Institution],
      author: [Author],
      title: [Title],
      date: datetime.today(),
    ),
    ..args,
  )

  body
}
