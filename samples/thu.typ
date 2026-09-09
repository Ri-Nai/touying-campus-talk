// 清华配色 sample（虚构内容，仅演示主题）
#import "../lib.typ": *
#import themes.thu: *

#show: thu-theme.with(
  theme-fonts: campus-talk-fonts(body-size: 17pt),
  config-info(
    title: [研究计划汇报],
    subtitle: [示例 Deck · Demo Only],
    author: [张三],
    institution: [某某大学 · 计算机学院],
    date: datetime(year: 2026, month: 3, day: 15),
  ),
)

#title-slide()

#outline-slide()

= 背景介绍

== 问题陈述

#tblock(title: [一句话])[
  本页只用来展示封面横幅、目录与内容块的版式，内容均为占位。
]

- 苹果香蕉西瓜菠萝
- 红橙黄绿青蓝紫
- Lorem ipsum dolor sit amet

== 相关工作

随便写几条引用占位：

1. Foo et al., 2020
2. Bar & Baz, 2023
3. Qux Survey, 2024

= 方法与实验

== 方法概览

#slide(composer: (1fr, 1fr))[
  *模块 A*
  - 预处理
  - 特征抽取
][
  *模块 B*
  - 训练 / 评测
  - 可视化
]

== 结果示意

准确率从 42% 涨到 43%，非常科学。

#focus-slide[
  中间休息一下
]

= 总结

感谢聆听。问题请丢到空气里。
