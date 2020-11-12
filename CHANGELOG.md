# Change Log

## 0.6.0

- Hello, Date Time! Sample
- Support `date_time`, `date`, `date_drop_down`, `time`, `calendar` keywords
- Format Date/Time correctly as per SWT implementation by default

## 0.5.1

- Fixed issue with Hello, Combo!, Hello, List...! samples

## 0.5.0

- Add `margin_top`, `margin_right`, `margin_bottom`, and `margin_left` to RowLayoutProxy
- `radio`
- Hello, Radio! Sample
- `radio_group`
- Hello, Radio Group! Sample
- `checkbox`
- Hello, Checkbox! Sample
- `checkbox_group`
- Fix issue with `label` `alignment` property
- Fix issues with default `composite` `grid_layout` not getting its styles removed when setting `row_layout`
- `button(:radio)` alias for `radio`
- `check` alias for `checkbox`
- `button(:check)` alias for `checkbox`
- Hello, Group! Sample
- Group widget

## 0.4.0

- Support `display` keyword representing an SWT Display
- Support display `on_swt_keydown` event listener (display-wide widget observer)
- Support `DisplayProxy#shells` method keeping track of open shell
- Make a custom shell open in the same window if there is no shell open already
- Support `sync_exec` keyword as just an alias to `async_exec`
- Provide a makeshift require for 'glimmer-dsl-swt' that requires 'glimmer-dsl-opal' instead
- Fake APIs on the web for OS.os?, File.read, Display.setAppName, Display.setAppVersion
- Provide a minimal URI class that supports URI::encode_www_form_component and URI::decode_www_form_component from Ruby

## 0.3.0

- Support opening a custom shell in a browser tab/window by passing in query parameters to URL (e.g. ?custom_shell=keyword+option1=value1 etc...)
- Make custom shells automatically open in a new tab/window (while standard shells continue to open in the same window by replacing its content)
- Hello, Custom Shell! Sample

## 0.2.0

- Color support
- Font support
- Custom Widget Support
- Hello, Custom Widget! sample
- Updated Hello, Combo! sample to match the latest changes in Glimmer DSL for SWT
- `SWT` full re-implementation in Opal as `Glimmer::SWT` with all the `SWT` style constants

## 0.1.0

- Code redesign to better match the glimmer-dsl-swt APIs
- opal-jquery refactoring
- opal-rspec test coverage

## 0.0.9

- Upgraded to glimmer gem v0.9.3
- Fixed issue with missing Glimmer::Opal::ElementProxy#id=(value) method breaking Contact Manager sample Find feature

## 0.0.8

- Contact Manager sample support

## 0.0.7

- Tic Tac Toe sample support
- Login sample support

## 0.0.6

- Hello, Tab! sample support

## 0.0.5

- Hello, Browser! sample support

## 0.0.4

- Hello, List Single Selection! sample support
- Hello, List Multi Selection! sample support

## 0.0.3

- Hello, Computed! sample support

## 0.0.2

- Hello, Combo! sample support

## 0.0.1

- Initial support for webifying Glimmer SWT apps
- Support for Shell and Label widgets (text property only).
