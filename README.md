# InfoStrip

InfoStrip is a lightweight multilingual World of Warcraft status strip. It displays client status fields in a compact movable HUD, including FPS, Home/World/total latency, bandwidth, movement speed, player coordinates, date, local time, and server time.

Author / GitHub display name: Edge of Fate

## Features

- Movable and lockable HUD
- Custom display template using `{%name}` tokens
- Per-field show / label / icon controls
- FPS, latency, bandwidth, speed, coordinate, date, and time fields
- Threshold colors for FPS, latency, bandwidth, and speed
- Separate simple colors for coordinates, date, and time
- Built-in WoW font selection
- Text color, size, outline, bold, shadow, shadow offsets, line spacing, and left / center / right alignment
- Frame background, border, corner radius, and padding settings
- Minimap settings button and AddOn Compartment entry
- No third-party libraries

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
{%speed} {%coord} {%date} {%local} {%server}
```

Value-only tokens:

```text
{%fps_value} {%home_value} {%world_value} {%total_value}
{%bw_in_value} {%bw_out_value} {%speed_value}
{%coord_value} {%date_value} {%local_time} {%server_time}
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
Media/InfoStripIcon.tga
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
- InfoStrip reads expensive data such as speed and coordinates only when the active template needs them.
- The addon uses WoW built-in APIs and media, plus its own transparent icon file.
