// 北京理工大学配色主题：主绿 chrome + 深棕/浅棕进度条 + 透明校徽
#import "../src/theme.typ": *

#let bit-green = rgb("#006C39")
#let bit-green-dark = rgb("#004B28")
#let bit-brown = rgb("#6B4423")
#let bit-brown-light = rgb("#E6D5C3")

#let _asset(name) = "../assets/" + name

#let bit-theme(
  theme-colors: campus-talk-colors(
    primary: bit-green,
    primary-light: rgb("#1F8A52"),
    primary-lighter: rgb("#7CBC9A"),
    primary-lightest: rgb("#E8F5EE"),
    primary-dark: bit-green-dark,
    primary-darker: rgb("#00361D"),
    highlight: bit-brown,
    progress-fill: bit-brown,
    progress-track: bit-brown-light,
  ),
  theme-fonts: campus-talk-fonts(),
  brand: [北京理工大学],
  emblem: image(_asset("bit-emblem-soft.svg"), width: 3.8cm),
  emblem-width: 3.8cm,
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
