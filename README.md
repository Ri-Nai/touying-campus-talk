# touying-campus-talk

基于 [Touying](https://github.com/touying-typ/touying) 的大学汇报主题：顶栏 / 底栏 / 侧边 chrome、进度条、校徽水印、封面与目录页。导入方式对齐 Touying 内置主题（`#import themes.xxx: *`）。

校徽与校色仅供个人汇报参考，版权归各高校所有。

<p align="center">
  <img src="docs/imgs/thu-title.png" width="32%" alt="THU title" />
  <img src="docs/imgs/bit-title.png" width="32%" alt="BIT title" />
  <img src="docs/imgs/zju-title.png" width="32%" alt="ZJU title" />
</p>

<p align="center">
  <img src="docs/imgs/thu-content.png" width="48%" alt="THU content" />
  <img src="docs/imgs/zju-content.png" width="48%" alt="ZJU content" />
</p>

## 结构

```text
touying-campus-talk/
├── lib.typ
├── typst.toml
├── src/
│   ├── core.typ         # title / outline / focus / slide / base
│   └── theme.typ        # campus-talk-theme 内核
├── themes/
│   ├── themes.typ       # 聚合入口（绑定为 themes）
│   ├── campus.typ       # 通用（无校色，自行传色）
│   ├── thu.typ          # 清华（含校色常量 / 校徽）
│   └── bit.typ          # 北理工（含校色常量 / 校徽）
├── assets/
├── docs/imgs/           # README 预览图
└── samples/
    ├── thu.typ          # themes.thu
    ├── bit.typ          # themes.bit
    └── zju.typ          # themes.campus 自定义配色示例（当 campus sample）
```

## 快速使用

```typ
#import "@local/touying-campus-talk:0.1.0": *
#import themes.thu: *   // 或 themes.bit / themes.campus

#show: thu-theme.with(
  config-info(
    title: [个人陈述],
    author: [姓名],
    institution: [单位],
    date: datetime.today(),
  ),
)

#title-slide()
#outline-slide()

= 第一节
== 子页
内容……
```

相对路径开发：

```typ
#import "../theme/touying-campus-talk/lib.typ": *
#import themes.bit: *

#show: bit-theme.with(...)
```

安装到本地包：

```bash
mkdir -p ~/Library/Application\ Support/typst/packages/local/touying-campus-talk
ln -s "$(pwd)" ~/Library/Application\ Support/typst/packages/local/touying-campus-talk/0.1.0
```

## 主题一览

| 导入 | show | 说明 |
|------|------|------|
| `themes.thu` | `thu-theme` | 清华紫 + 校徽 |
| `themes.bit` | `bit-theme` | 北理绿 + 棕进度条 + 校徽 |
| `themes.campus` | `campus-theme` | 通用骨架，自己传 `theme-colors` / `emblem` |

校色常量写在对应 `themes/thu.typ`、`themes/bit.typ` 里，不放内核。

### THU

![THU title](docs/imgs/thu-title.png)

### BIT

![BIT title](docs/imgs/bit-title.png)

### Campus 自定义（ZJU 配色示例）

![ZJU title](docs/imgs/zju-title.png)

## 自定义主题

多数学校**不必**新建 `themes/xxx.typ`：用 `themes.campus`，在 deck 里传配色 / 校名 / 校徽即可。完整示例见 [`samples/zju.typ`](samples/zju.typ)。

只改 `primary` / `brand` 就能换成另一所学校的观感（下图为浙大蓝示例的内容页）：

![ZJU content](docs/imgs/zju-content.png)

### 最小改法（只换主色 + 校名）

```typ
#import "@local/touying-campus-talk:0.1.0": *
#import themes.campus: *

#show: campus-theme.with(
  theme-colors: campus-talk-colors(primary: rgb("#003F88")),
  brand: [浙江大学],
  config-info(
    title: [Title],
    subtitle: [Subtitle],
    author: [Authors],
    institution: [Institution],
    date: datetime.today(),
  ),
)
```

只传 `primary` 时，其余色阶（亮/浅/暗、进度条等）会自动派生。

### 常用参数

| 参数 | 作用 |
|------|------|
| `theme-colors` | `campus-talk-colors(...)`：主色、强调色、进度条色等 |
| `theme-fonts` | `campus-talk-fonts(...)`：正文字体 / 标题字体 / 字号 |
| `brand` | 顶栏校名文案 |
| `emblem` | 校徽，传 `image("xxx.svg", width: 3.6cm)` 或路径字符串 |
| `emblem-width` | 校徽宽度，默认 `3.6cm` |
| `config-info(...)` | 标题、作者、单位、日期等（封面与页脚会用到） |

颜色细调示例：

```typ
#let zju-blue = rgb("#003F88")
#let zju-red = rgb("#B01F24")

#show: campus-theme.with(
  theme-colors: campus-talk-colors(
    primary: zju-blue,
    highlight: zju-red,           // 强调色可与主色分离
    // progress-fill: ...,        // 进度条填充（默认跟主色亮阶）
    // progress-track: ...,       // 进度条底轨
  ),
  theme-fonts: campus-talk-fonts(body-size: 17pt),
  brand: [浙江大学],
  // emblem: image("zju-emblem.svg", width: 3.6cm),
  config-info(...),
)
```

`campus-talk-colors` 还可显式覆盖：`primary-light` / `primary-lighter` / `primary-lightest` / `primary-dark` / `primary-darker`、`title-color` 等。

### 什么时候才新建 `themes/xxx.typ`

- 同一套校色 / 校徽要在多份 deck 复用
- 想写成 `#import themes.foo: *` + `#show: foo-theme.with(...)` 的固定入口

可对照 `themes/thu.typ`：在文件里定好默认 `theme-colors` / `brand` / `emblem`，再包一层 `campus-talk-theme`。颜色简单、只用一次时，继续用上面的 `campus-theme` 内联写法即可。

## 内置页面

- `#title-slide()` 封面
- `#outline-slide()` 目录
- `#focus-slide[...]` 焦点页（不计页码）
- `#slide(...)[...]` 普通页 / 分栏
- `#tblock(title: [...])[...]` 内容块

## 编译 sample

```bash
typst compile --root . samples/thu.typ
typst compile --root . samples/bit.typ
typst compile --root . samples/zju.typ   # campus 自定义配色示例
```

预览图可从 PDF 导出（需 `pdftoppm`）：

```bash
mkdir -p docs/imgs
typst compile --root . samples/thu.typ /tmp/thu.pdf
pdftoppm -png -r 144 -f 1 -l 3 /tmp/thu.pdf docs/imgs/thu-preview
```

## 依赖

- Typst ≥ 0.12
- `@preview/touying:0.5.5`
