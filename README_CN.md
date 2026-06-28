# InfoStrip

[English](README.md) | [简体中文](README_CN.md)

InfoStrip 是一个轻量级、多语言的 World of Warcraft Retail 状态信息条插件。它会在屏幕上显示一个可移动的 HUD，用于展示 FPS、Home / World / 总延迟、下载 / 上传带宽、移动速度、人物坐标、服务器区域、日期、本机时间和服务器时间。

作者：Fate's Edge  
GitHub：https://github.com/FatesEdge/InfoStrip  
仓库：https://github.com/FatesEdge/InfoStrip  
版本：1.0.0  
适配接口：120007

## 功能特性

- 可移动、可锁定的 HUD。
- 使用 `{%name}` token 自定义显示模板。
- 每个字段都可以单独控制是否显示、是否显示标签、是否显示图标。
- 支持 FPS、延迟、带宽、移动速度、坐标、服务器区域、日期和时间字段。
- FPS、延迟、带宽和移动速度支持阈值颜色。
- 坐标、服务器区域、日期和时间使用独立的简单颜色设置。
- 使用 WoW 可访问的内置字体，不读取系统字体。
- 支持文字颜色、字体大小、描边、加粗、阴影、阴影偏移、行距和左 / 中 / 右对齐。
- 支持背景、边框、圆角和内边距设置。
- 支持小地图设置按钮和 AddOn Compartment 入口。
- 不依赖第三方库。

## 语言支持

设置界面已做多语言支持：

- Auto：所有界面语言中都统一显示为 `Auto`，并在支持时跟随 WoW 客户端语言。
- English
- 简体中文
- 繁體中文
- Deutsch
- Español
- 日本語
- 한국어

Arabic 和 Thai 暂未加入，因为它们需要额外的 UI、字体和排版测试。

## 显示模板 token

InfoStrip 使用 `{%name}` 格式的 token。普通字符和未知 token 会按输入内容原样显示。

常用完整字段 token：

```text
{%fps} {%home} {%world} {%total} {%bw_in} {%bw_out}
{%speed} {%coord} {%region} {%date} {%local} {%server}
```

也可以手动使用纯值 token。高级页面只显示完整字段按钮，因为每个字段的标签和图标已经可以在“综合”页面单独控制：

```text
{%fps_value} {%home_value} {%world_value} {%total_value}
{%bw_in_value} {%bw_out_value} {%speed_value}
{%coord_value} {%region_value} {%date_value} {%local_time} {%server_time}
```

格式 token：

```text

  换行
	  四个空格
```

如果直接粘贴真实 tab 字符，也会被规范化为四个空格。

## Slash 命令

```text
/is options
/is lock
/is unlock
/is reset
/is lang auto
/is lang enUS
/is lang zhCN
/is lang zhTW
/is lang deDE
/is lang esES
/is lang jaJP
/is lang koKR
```

## 首次安装默认显示

全新安装时，默认只显示最核心的信息条：

```text
{%fps}  {%home}  {%world}
```

也就是默认启用 FPS、Home 延迟和 World 延迟。服务器区域、坐标、带宽、日期和时间等字段仍然可以手动开启，但默认不显示。

默认外观设置：

- 文字对齐：左对齐
- 字号：14
- 坐标精度：2 位小数
- 默认更新间隔：1000 ms

## 安装方式

1. 下载发布包。
2. 解压后确保目录结构是：

```text
World of Warcraft/_retail_/Interface/AddOns/InfoStrip/InfoStrip.toc
```

3. 进入游戏，在插件列表中启用 InfoStrip。
4. 可以通过小地图按钮、AddOn Compartment，或 `/is options` 打开设置。

发布 zip 的根目录应该是 `InfoStrip/`，不要再多套一层父目录。

## 文件结构

```text
InfoStrip.toc
Templates.xml
Defaults.lua
Locale.lua
Utils.lua
Display.lua
Options.lua
OptionsControls.lua
OptionsAbout.lua
OptionsGeneral.lua
OptionsAppearance.lua
OptionsAdvanced.lua
OptionsRegister.lua
Core.lua
README.md
README_CN.md
Media/InfoStripIcon.tga
Media/RegionServer.tga
```

## 开发同步示例

```bash
scp -r   InfoStrip.toc   Templates.xml   Defaults.lua   Locale.lua   Utils.lua   Display.lua   Options.lua   OptionsControls.lua   OptionsAbout.lua   OptionsGeneral.lua   OptionsAppearance.lua   OptionsAdvanced.lua   OptionsRegister.lua   Core.lua   README.md   README_CN.md   Media   "$WINDOWS_USER@$WINDOWS_HOST:"$DEST""
```

## 说明

- SavedVariables 使用 schema version。如果配置结构变化，旧设置可能会被重置为默认值。
- InfoStrip 只在当前模板需要某类数据时才读取对应 API，例如速度、坐标和服务器区域。
- 服务器区域字段使用中性的服务器机柜图标，不使用国家或地区旗帜图标。
- 服务器区域来自 WoW 当前区域相关 API，不是用户所在地检测；在部分边缘情况下，它可能反映登录 / portal 区域。
- 插件使用 WoW 内置 API 和媒体资源，并附带自己的透明图标文件。

## 发布前检查清单

发布前建议确认：

- `InfoStrip.toc` 中的 `## Interface` 与当前 Retail 客户端接口编号一致。游戏内可以使用 `/dump select(4, GetBuildInfo())` 查看当前接口编号。
- zip 根目录是 `InfoStrip/`，不是嵌套父目录。
- 只有在正式发布新版本时才更新 `## Version`、`InfoStrip.version` 和 `schemaVersion`。
- 至少在 English 和 简体中文界面下测试 About、General、Appearance 和 Advanced 页面。
- 打开背景后测试 HUD，确认左 / 中 / 右对齐、0 内边距、多行模板和日期字段都正常。

当前 Retail Interface 目标：`120007`。
