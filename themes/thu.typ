// 清华大学配色主题
#import "../src/theme.typ": *

#let thu-purple = rgb("#660874")
#let thu-purple-bright = rgb("#920783")
#let thu-purple-soft = rgb("#F4EAF6")
#let thu-black = rgb("#1A1A1A")
#let thu-white = rgb("#FFFFFF")

#let _asset(name) = "../assets/" + name

#let thu-theme(
  theme-colors: campus-talk-colors(
    primary: thu-purple,
    primary-light: thu-purple-bright,
    primary-lighter: rgb("#B07AC7"),
    primary-lightest: thu-purple-soft,
    primary-dark: rgb("#4A0656"),
    primary-darker: rgb("#2D0435"),
    progress-fill: thu-purple-bright,
    progress-track: rgb("#E8D4ED"),
  ),
  theme-fonts: campus-talk-fonts(),
  brand: [清华大学申请],
  emblem: image(_asset("thu-emblem-soft.svg"), width: 4.0cm),
  emblem-width: 4.0cm,
  ..args,
  body,
) = {
  show: campus-talk-theme.with(
    theme-colors: theme-colors,
    theme-fonts: theme-fonts,
    brand: brand,
    emblem: emblem,
    emblem-width: emblem-width,
    ..args,
  )
  body
}
