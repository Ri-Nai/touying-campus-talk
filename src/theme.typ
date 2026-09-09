// campus-talk：大学汇报通用主题（校徽 + 主题色 + 可覆写 chrome 槽位）
#import "core.typ": *

#let header-h = 2.55em
#let progress-h = 7pt
#let footer-h = 1.55em
#let edge-w = 5pt
#let page-h-16-9 = 473.563pt

/// 颜色配置。只传 primary 时自动派生其余色阶。
/// `progress-fill` / `progress-track` 可与主色分离（例如北理工：绿 chrome + 棕进度条）。
#let campus-talk-colors(
  primary: rgb("#660874"),
  primary-light: auto,
  primary-lighter: auto,
  primary-lightest: auto,
  primary-dark: auto,
  primary-darker: auto,
  primary-darkest: rgb("#1A1A1A"),
  neutral-lightest: rgb("#FFFFFF"),
  neutral-darkest: rgb("#1A1A1A"),
  highlight: auto,
  title-color: rgb("#1A1A1A"),
  progress-fill: auto,
  progress-track: auto,
) = {
  let light = if primary-light == auto { primary.lighten(18%) } else { primary-light }
  // 与 THU 默认派生对齐（primary=#660874 时）
  let resolved-light = if primary-light == auto and primary == rgb("#660874") {
    rgb("#920783")
  } else {
    light
  }
  let resolved-lighter = if primary-lighter == auto {
    if primary == rgb("#660874") { rgb("#B07AC7") } else { primary.lighten(40%) }
  } else {
    primary-lighter
  }
  let resolved-lightest = if primary-lightest == auto {
    if primary == rgb("#660874") { rgb("#F4EAF6") } else { primary.lighten(92%) }
  } else {
    primary-lightest
  }
  let resolved-dark = if primary-dark == auto {
    if primary == rgb("#660874") { rgb("#4A0656") } else { primary.darken(20%) }
  } else {
    primary-dark
  }
  let resolved-darker = if primary-darker == auto {
    if primary == rgb("#660874") { rgb("#2D0435") } else { primary.darken(35%) }
  } else {
    primary-darker
  }
  let resolved-highlight = if highlight == auto { resolved-light } else { highlight }
  let resolved-progress-fill = if progress-fill == auto { resolved-light } else { progress-fill }
  let resolved-track = if progress-track == auto {
    if primary == rgb("#660874") { rgb("#E8D4ED") } else { primary.lighten(85%) }
  } else {
    progress-track
  }
  (
    primary: primary,
    primary-light: resolved-light,
    primary-lighter: resolved-lighter,
    primary-lightest: resolved-lightest,
    primary-dark: resolved-dark,
    primary-darker: resolved-darker,
    primary-darkest: primary-darkest,
    neutral-lightest: neutral-lightest,
    neutral-darkest: neutral-darkest,
    highlight: resolved-highlight,
    title-color: title-color,
    progress-fill: resolved-progress-fill,
    progress-track: resolved-track,
  )
}

/// 字体与字号配置。
#let campus-talk-fonts(
  main: ("IBM Plex Sans", "Noto Sans CJK SC", "Times New Roman", "SimSun"),
  title: ("Lora", "LXGW WenKai", "Noto Serif"),
  mono: "Sarasa Mono SC",
  body-size: 17pt,
  header-size: 1.35em,
  footer-size: 0.72em,
  focus-size: 1.5em,
  mono-size: 18pt,
) = (
  main: main,
  title: title,
  mono: mono,
  body-size: body-size,
  header-size: header-size,
  footer-size: footer-size,
  focus-size: focus-size,
  mono-size: mono-size,
)

// background 绘制时 slide-counter 往往尚未 +1：用 Beamer 式 cur/(last-1)，保证首页空、末页满
#let _progress-bar(height: 7pt, primary, secondary) = context {
  let last = utils.last-slide-counter.final().first()
  let cur = utils.slide-counter.get().first()
  let ratio = if last <= 1 {
    1.0
  } else {
    calc.max(0.0, calc.min(1.0, cur / (last - 1)))
  }
  if ratio >= 1.0 {
    rect(width: 100%, height: height, fill: primary, stroke: none)
  } else if ratio <= 0.0 {
    rect(width: 100%, height: height, fill: secondary, stroke: none)
  } else {
    grid(
      columns: (ratio * 1fr, (1 - ratio) * 1fr),
      rows: height,
      gutter: 0pt,
      rect(width: 100%, height: height, fill: primary, stroke: none),
      rect(width: 100%, height: height, fill: secondary, stroke: none),
    )
  }
}

#let campus-talk-theme(
  aspect-ratio: "16-9",
  theme-colors: campus-talk-colors(),
  theme-fonts: campus-talk-fonts(),
  emblem: none,
  emblem-width: 3.6cm,
  brand: none,
  header-title: auto,
  footer-institution: self => self.info.institution,
  footer-author: self => {
    if "authors" in self.info {
      self.info.authors.join(", ")
    } else {
      self.info.author
    }
  },
  footer-deck-title: self => self.info.title,
  footer-date: self => self.info.date.display("[year] 年 [month] 月 [day] 日"),
  footer-slide-counter: text(weight: 700)[
    #context utils.slide-counter.display() / #utils.last-slide-number
  ],
  display-section-slides: false,
  // 兼容旧参数名
  font-size: auto,
  font: auto,
  emblem-path: auto,
  ..args,
  body,
) = {
  let colors = theme-colors
  let fonts = theme-fonts
  let resolved-font-size = if font-size == auto { fonts.body-size } else { font-size }
  let resolved-font = if font == auto { fonts.main } else { font }
  let resolved-emblem = if emblem-path != auto { emblem-path } else { emblem }
  let emblem-content = if resolved-emblem == none {
    none
  } else if type(resolved-emblem) == str {
    image(resolved-emblem, width: emblem-width)
  } else {
    resolved-emblem
  }
  let resolved-fonts = fonts + (body-size: resolved-font-size, main: resolved-font)

  let default-header-title = if header-title != auto {
    header-title
  } else {
    (self, title: auto) => {
      if title == none {
        none
      } else if title == auto {
        context {
          utils.display-current-heading(level: 1, numbered: false)
          if self.store.title != none {
            text(style: "normal")[  ·  ]
            utils.call-or-display(self, self.store.title)
          } else if utils.current-heading(level: 2) != none {
            text(style: "normal")[  ·  ]
            utils.display-current-heading(level: 2, numbered: false)
          }
        }
      } else {
        title
      }
    }
  }

  show: campus-talk-base.with(
    aspect-ratio: aspect-ratio,
    font-size: resolved-font-size,
    font: resolved-font,
    fonts: resolved-fonts,
    config-page(
      paper: "presentation-" + aspect-ratio,
      fill: colors.neutral-lightest,
      margin: (
        top: header-h + progress-h + 1.05em,
        bottom: footer-h + 0.55em,
        x: 1.85em,
      ),
      header-ascent: 0%,
      footer-descent: 0%,
    ),
    config-colors(
      primary: colors.primary,
      primary-light: colors.primary-light,
      primary-lighter: colors.primary-lighter,
      primary-lightest: colors.primary-lightest,
      primary-dark: colors.primary-dark,
      primary-darker: colors.primary-darker,
      primary-darkest: colors.primary-darkest,
      neutral-lightest: colors.neutral-lightest,
      neutral-darkest: colors.neutral-darkest,
      highlight: colors.highlight,
      title-color: colors.title-color,
    ),
    config-common(
      new-section-slide-fn: if display-section-slides { new-section-slide } else { none },
    ),
    config-store(
      brand: brand,
      fonts: resolved-fonts,
      progress-fill: colors.progress-fill,
      progress-track: colors.progress-track,
      footer-institution: footer-institution,
      footer-author: footer-author,
      footer-deck-title: footer-deck-title,
      footer-date: footer-date,
      footer-slide-counter: footer-slide-counter,
      header: (self, title: auto) => {
        set align(top + left)
        set block(spacing: 0pt)
        pad(
          left: 1.35em,
          top: 0.7em,
          {
            set text(
              fill: self.colors.neutral-lightest,
              size: self.store.fonts.header-size,
              font: self.store.fonts.title,
              style: "italic",
              weight: 600,
            )
            if type(default-header-title) == function {
              default-header-title(self, title: title)
            } else if title == none {
              // 封面：色带留空，brand 放到横幅眉题
              none
            } else if title == auto {
              utils.call-or-display(self, default-header-title)
            } else {
              title
            }
          },
        )
      },
      footer: self => {
        set align(bottom)
        set block(spacing: 0pt)
        pad(
          left: 1.1em,
          right: 0.2em,
          bottom: 0.38em,
          {
            set text(
              fill: self.colors.neutral-lightest,
              size: self.store.fonts.footer-size,
              weight: 500,
            )
            utils.call-or-display(self, self.store.footer-institution)
            h(1fr)
            utils.call-or-display(self, self.store.footer-author)
            h(1fr)
            utils.call-or-display(self, self.store.footer-deck-title)
            h(1fr)
            utils.call-or-display(self, self.store.footer-date)
            h(0.7em)
            utils.call-or-display(self, self.store.footer-slide-counter)
          },
        )
      },
      background: self => {
        place(top + left, rect(width: 100%, height: header-h, fill: self.colors.primary))
        place(
          top + left,
          dy: header-h,
          block(
            width: 100%,
            _progress-bar(
              height: progress-h,
              self.store.progress-fill,
              self.store.progress-track,
            ),
          ),
        )
        place(bottom + left, rect(width: 100%, height: footer-h, fill: self.colors.primary))
        place(top + left, rect(width: edge-w, height: 100%, fill: self.colors.primary))
        place(top + right, rect(width: edge-w, height: 100%, fill: self.colors.primary))

        if emblem-content != none {
          place(
            top + right,
            dx: -1em,
            dy: page-h-16-9 - 3.6cm - 3em,
            emblem-content,
          )
        }
      },
    ),
    ..args,
  )

  body
}
