// 包根预览 / 模板入口（与 samples/zju.typ 同内容：campus 自定义配色）
#import "lib.typ": *
#import themes.campus: *

#let zju-blue = rgb("#003F88")
#let zju-red = rgb("#B01F24")

#show: campus-theme.with(
  theme-colors: campus-talk-colors(
    primary: zju-blue,
    highlight: zju-red,
  ),
  theme-fonts: campus-talk-fonts(body-size: 17pt),
  brand: [浙江大学],
  config-info(
    title: [科研进展汇报],
    subtitle: [campus 自定义配色示例],
    author: [赵六],
    institution: [某某实验室],
    date: datetime(year: 2026, month: 5, day: 8),
  ),
)

#title-slide()

#outline-slide()

= 说明

== 思路

学校主题不必都做成 `themes/xxx.typ`。颜色简单时，sample / 业务 deck 里直接改 `campus-theme` 就行：

```typ
#import themes.campus: *

#show: campus-theme.with(
  theme-colors: campus-talk-colors(primary: rgb("#003F88")),
  brand: [浙江大学],
  config-info(...),
)
```

== 需要校徽时

再传 `emblem`：

```typ
#show: campus-theme.with(
  theme-colors: campus-talk-colors(primary: zju-blue),
  brand: [浙江大学],
  emblem: image("zju-emblem.svg", width: 3.6cm),
  config-info(...),
)
```

#tblock(title: [本页用色])[
  - 主色 `#003F88`
  - 强调 `#B01F24`
]

= 占位内容

随便写两句，证明版式能跑。

#focus-slide[
  campus · 自定义浙大蓝
]

= 结束

谢谢。
