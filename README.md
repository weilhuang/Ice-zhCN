<div align="center">
    <img src="Ice/Assets.xcassets/AppIcon.appiconset/icon_256x256.png" width=200 height=200>
    <h1>Ice</h1>
    <p>简体中文版 · <a href="https://github.com/weilhuang/Ice-zhCN">weilhuang/Ice-zhCN</a></p>
</div>

这是 [jordanbaird/Ice](https://github.com/jordanbaird/Ice) 的个人 fork，提供**简体中文界面**和**应用内语言切换**。上游 Ice 本身几乎没有本地化基础设施；本仓库用 String Catalog（`Localizable.xcstrings`）维护英文原文与简体中文译文。

[![Download](https://img.shields.io/badge/download-latest-brightgreen?style=flat-square)](https://github.com/weilhuang/Ice-zhCN/releases/latest)
![Platform](https://img.shields.io/badge/platform-macOS-blue?style=flat-square)
![Requirements](https://img.shields.io/badge/requirements-macOS%2014%2B-fa4e49?style=flat-square)
[![License](https://img.shields.io/github/license/jordanbaird/Ice?style=flat-square)](LICENSE)

> [!NOTE]
> 当前 fork 版本为 **0.11.12-zhCN**（基于上游 0.11.12）。请从[本仓库 Releases](https://github.com/weilhuang/Ice-zhCN/releases/latest)下载 `Ice.zip`，不要用 Homebrew 的官方 cask，也不要从上游自动更新。

## 简体中文版说明

### 安装 / 覆盖本机 Ice

1. 从 [Releases](https://github.com/weilhuang/Ice-zhCN/releases/latest) 下载 `Ice.zip` 并解压。
2. 将 `Ice.app` 拖到「应用程序」。Bundle ID 仍为 `com.jordanbaird.Ice`，可以直接替换本机未汉化的 Ice。
3. 若 macOS 提示无法验证开发者：对 `Ice.app` **点按鼠标右键 → 打开**，或执行：

```sh
xattr -cr /Applications/Ice.app
```

CI 默认使用 **ad-hoc（仅供本机运行）签名**。仓库以后若添加 Apple Developer 证书，可在 Actions secrets 中配置 `MACOS_CERTIFICATE_P12`、`MACOS_CERTIFICATE_PASSWORD`、`MACOS_CERTIFICATE_IDENTITY`（可选 `APPLE_TEAM_ID`），无需改 workflow 结构。

### 语言切换

打开 **Ice 设置 → 通用 → 语言**，可选：

- **跟随系统**
- **English**
- **简体中文**

选择会写入 `IceAppLanguage`，并设置 `AppleLanguages`。切换后会提示重新打开 Ice，菜单和浮层才会全部更新；设置窗口内的 SwiftUI 文案会尽量即时刷新。

### 自动更新

上游 Ice 用 Sparkle 检查 `jordanbaird.github.io/ice-releases`。此 fork **不会启动 Sparkle**，避免官方英文版覆盖汉化。关于页的「打开 GitHub Releases」以及菜单中的「检查更新…」都会打开[本仓库 Releases](https://github.com/weilhuang/Ice-zhCN/releases)。

以后若要对本 fork 启用 Sparkle，需要自行托管 appcast，并在 `Ice/Info.plist` 加回 `SUFeedURL` / `SUPublicEDKey`，同时恢复 `UpdatesManager` 里的 `SPUStandardUpdaterController`。

### 发布构建

GitHub Actions workflow：`.github/workflows/release.yml`（`macos-latest`，Release 配置，产出 `Ice.zip`）。

触发方式：

```sh
git tag v0.11.12-zhCN.1
git push origin v0.11.12-zhCN.1
```

或在 Actions 里手动运行 **Release**，填写 tag（例如 `v0.11.12-zhCN.1`）。

---

Ice is a powerful menu bar management tool. While its primary function is hiding and showing menu bar items, it aims to cover a wide variety of additional features to make it one of the most versatile menu bar tools available.

![Banner](https://github.com/user-attachments/assets/4423085c-4e4b-4f3d-ad0f-90a217c03470)

[![Sponsor](https://img.shields.io/badge/Sponsor%20%E2%9D%A4%EF%B8%8F-8A2BE2?style=flat-square)](https://github.com/sponsors/jordanbaird)
[![Website](https://img.shields.io/badge/Website-015FBA?style=flat-square)](https://icemenubar.app)

> [!NOTE]
> Upstream Ice is in active development. This fork tracks a localized snapshot; official (English) downloads remain at the [upstream releases](https://github.com/jordanbaird/Ice/releases/latest).

<a href="https://www.buymeacoffee.com/jordanbaird" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;">
</a>

## Install

### This fork (Simplified Chinese)

Download `Ice.zip` from this repository’s [latest release](https://github.com/weilhuang/Ice-zhCN/releases/latest) and move `Ice.app` into `/Applications`.

### Homebrew (upstream, English only)

```sh
brew install --cask jordanbaird-ice
```

## Features/Roadmap

### Menu bar item management

- [x] Hide menu bar items
- [x] "Always-hidden" menu bar section
- [x] Show hidden menu bar items when hovering over the menu bar
- [x] Show hidden menu bar items when an empty area in the menu bar is clicked
- [x] Show hidden menu bar items by scrolling or swiping in the menu bar
- [x] Automatically rehide menu bar items
- [x] Hide application menus when they overlap with shown menu bar items
- [x] Drag and drop interface to arrange individual menu bar items
- [x] Display hidden menu bar items in a separate bar (e.g. for MacBooks with the notch)
- [x] Search menu bar items
- [x] Menu bar item spacing (BETA)
- [ ] Profiles for menu bar layout
- [ ] Individual spacer items
- [ ] Menu bar item groups
- [ ] Show menu bar items when trigger conditions are met

### Menu bar appearance

- [x] Menu bar tint (solid and gradient)
- [x] Menu bar shadow
- [x] Menu bar border
- [x] Custom menu bar shapes (rounded and/or split)
- [ ] Remove background behind menu bar
- [ ] Rounded screen corners
- [ ] Different settings for light/dark mode

### Hotkeys

- [x] Toggle individual menu bar sections
- [x] Show the search panel
- [x] Enable/disable the Ice Bar
- [x] Show/hide section divider icons
- [x] Toggle application menus
- [ ] Enable/disable auto rehide
- [ ] Temporarily show individual menu bar items

### Other

- [x] Launch at login
- [x] Automatic updates
- [ ] Menu bar widgets

## Why does Ice only support macOS 14 and later?

Ice uses a number of system APIs that are available starting in macOS 14. As such, there are no plans to support earlier versions of macOS.

## Gallery

#### Show hidden menu bar items below the menu bar

![Ice Bar](https://github.com/user-attachments/assets/f1429589-6186-4e1b-8aef-592219d49b9b)

#### Drag-and-drop interface to arrange menu bar items

![Menu Bar Layout](https://github.com/user-attachments/assets/095442ba-f2d0-4bb4-9632-91e26ef8d45b)

#### Customize the menu bar's appearance

![Menu Bar Appearance](https://github.com/user-attachments/assets/8c22c185-c3d2-49bb-971e-e1fc17df04b3)

#### Menu bar item search

![Menu Bar Item Search](https://github.com/user-attachments/assets/d1a7df3a-4989-4077-a0b1-8e7d5a1ba5b8)

#### Custom menu bar item spacing

![Menu Bar Item Spacing](https://github.com/user-attachments/assets/b196aa7e-184a-4d4c-b040-502f4aae40a6)

## License

Ice is available under the [GPL-3.0 license](LICENSE).
