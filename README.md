# InfoStrip

[简体中文](README_CN.md) | [English](README.md)

InfoStrip is a lightweight multilingual World of Warcraft status strip. It displays client status fields in a compact movable HUD, including FPS, Home/World/total latency, bandwidth, movement speed, player coordinates, server region, date, local time, and server time.

Author: Fate's Edge
GitHub: https://github.com/FatesEdge/InfoStrip
Repository: https://github.com/FatesEdge/InfoStrip
Version: 1.0.0
Interface: 120007

## Features

- Movable and lockable HUD
- Custom display template using `{%name}` tokens
- Per-field show / label / icon controls
- FPS, latency, bandwidth, speed, coordinate, server region, date, and time fields
- Threshold colors for FPS, latency, bandwidth, and speed
- Separate simple colors for coordinates, region, date, and time
- Built-in WoW font selection
- Text color, size, outline, bold, shadow, shadow offsets, line spacing, and left / center / right alignment
- Frame background, border, corner radius, and padding settings
- Minimap settings button and AddOn Compartment entry
- No third-party libraries

## Default first-run display

A fresh installation shows only the core status strip by default:

```text
{%fps}  {%home}  {%world}
```

That means FPS, Home latency, and World latency are enabled first. Other fields such as region, coordinates, bandwidth, date, and time are available but disabled by default.

Default appearance values:

- Text alignment: left
- Font size: 14
- Coordinate precision: 2 decimal places
- Default update interval: 1000 ms

## Languages

The settings UI is localized and supports:

- Auto, kept as `Auto` in every UI language and following the WoW client locale when supported
- English
- 简体中文
- 繁體中文
- Deutsch
- Español
- 日本語
- 한국어

Arabic and Thai are not included yet because they need additional UI and font testing.

## Template tokens

InfoStrip templates use the `{%name}` format. Normal characters and unknown tokens are displayed as typed.

Common full-field tokens:

```text
{%fps} {%home} {%world} {%total} {%bw_in} {%bw_out}
{%speed} {%coord} {%region} {%date} {%local} {%server}
```

Manual value-only token aliases are still accepted, but the Advanced page now shows only full-field buttons because labels and icons can be controlled per field in General:

```text
{%fps_value} {%home_value} {%world_value} {%total_value}
{%bw_in_value} {%bw_out_value} {%speed_value}
{%coord_value} {%region_value} {%date_value} {%local_time} {%server_time}
```

Formatting tokens:

```text
\n  new line
\t  four spaces
```

A real tab character pasted into the template is also normalized to four spaces.

## Slash commands

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

## File structure

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

## Development sync example

```bash
scp -r \
  InfoStrip.toc \
  Templates.xml \
  Defaults.lua \
  Locale.lua \
  Utils.lua \
  Display.lua \
  Options.lua \
  OptionsControls.lua \
  OptionsAbout.lua \
  OptionsGeneral.lua \
  OptionsAppearance.lua \
  OptionsAdvanced.lua \
  OptionsRegister.lua \
  Core.lua \
  Media \
  "$WINDOWS_USER@$WINDOWS_HOST:\"$DEST\""
```

## Notes

- SavedVariables use a schema version. If the schema changes, old settings may be reset to defaults.
- InfoStrip reads expensive data such as speed, coordinates, and region only when the active template needs them.
- Region uses a neutral InfoStrip server-rack icon when its icon toggle is enabled; no country or regional flag icons are used.
- Region uses WoW's current region API. It is not a user location detector and may reflect login/portal region in edge cases.
- The addon uses WoW built-in APIs and media, plus its own transparent icon file.


## Release checklist

Before publishing a release package:

- Verify `## Interface` in `InfoStrip.toc` matches the current Retail client interface number. In game, `/dump select(4, GetBuildInfo())` can be used to check the current interface number.
- Keep the zip root as `InfoStrip/`, not a nested parent folder.
- Update `## Version`, `InfoStrip.version`, and `schemaVersion` only when intentionally making a new release.
- Test the About, General, Appearance, and Advanced pages in at least English and Simplified Chinese.
- Test the HUD with background enabled, left / center / right alignment, 0 padding, and multi-line templates.


Current Retail Interface target: `120007`.


