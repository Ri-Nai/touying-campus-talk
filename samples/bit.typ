// 北理工配色 sample（虚构内容）
#import "../lib.typ": *
#import themes.bit: *

#show: bit-theme.with(
  theme-fonts: campus-talk-fonts(body-size: 17pt),
  config-info(
    title: [课程大作业答辩],
    subtitle: [主题色与进度条演示],
    author: [李四],
    institution: [示例学院 · 示例专业],
    date: datetime(year: 2026, month: 6, day: 1),
  ),
)

#title-slide()

#outline-slide(title: [目录], subtitle: [Contents])

= 背景与动机

== 问题陈述

#tblock(title: [动机])[
  用 campus-talk 主题快速切换校色预设，避免每场汇报重写 chrome。
]

- 主色：北理绿 `#006C39`
- 进度条：深棕 `#6B4423` / 浅棕 `#E6D5C3`
- 右下角：透明校徽水印

== 方案概览

1. `#import themes.bit: *` 后 `#show: bit-theme.with(...)`
2. 内容页继续用 heading / `#slide` / `#tblock`
3. 需要时再覆写 `theme-colors` 或 `emblem`

= 实现要点

== 颜色槽位

进度条与 chrome 解耦：

```typ
campus-talk-colors(
  primary: bit-green,
  progress-fill: bit-brown,
  progress-track: bit-brown-light,
)
```

== 自定义校色

无校色预设时用 `themes.campus`：

```typ
#import themes.campus: *
#show: campus-theme.with(
  theme-colors: campus-talk-colors(primary: rgb("#003366")),
  brand: [某某大学],
  emblem: image("my-emblem.svg", width: 3.6cm),
  config-info(
    title: [汇报],
    author: [王五],
    institution: [单位],
    date: datetime.today(),
  ),
)
```

#focus-slide[
  北理绿 · 棕进度条
]

= 谢谢

欢迎交流与反馈。
