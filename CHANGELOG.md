# Change Log

## 0.9.0

- Support `menu_bar`
- Hello, Menu Bar! Sample
- Remove the need to call Document.ready? before opening a Glimmer shell

## 0.8.0

- Hello, Pop Up Context Menu! Sample
- Hello Message Box!
- Update hello list samples
- Support context menus `menu`/`menu_item` directly under a widget (using jQuery UI)
- Support generating new lines when entering `label` `text` with \n (auto-converting to <br />)
- Support generating new lines when entering `message_box` `message` with \n (auto-converting to <br />)
- Support having any widget contribute static CSS to ShellProxy
- Add Kernel#include_package shim to allow running JRuby include_package from Glimmer DSL for SWT without failing
- Add WidgetProxy#swt_widget to allow running include_package from Glimmer DSL for SWT without failing

## 0.7.5

- Update login sample from Glimmer DSL for SWT's latest changes
- Update contact_manager sample from Glimmer DSL for SWT's latest changes
- Fixed issue regarding unavailable localStorage data when accessed by custom_widget_expression in hello_checkbox_group, hello_radio_group, and hello_custom_widget

## 0.7.4

- Hello, Button! Sample
- Fix issue with aligning label as :left, :center, or :right via style style when fill_layout is used
- Fix Hello, Browser sample by accessing https ssl website
- Fix issue with filling space horizontally when using grid layout
- Fix broken embedded `calendar` widget data-binding for hello_date_time.rb sample
- Fix broken message_box after opening multiple shells
- Fix issue with opening custom shells in new tabs/windows when CustomShell subclass is required conditionally

## 0.7.3

- Refactor to use to_collection gem
- Fix issue with breaking `date`/`date_drop_down` data-binding as table editor on focus lost
- Fix issue with requiring OS, File, and Display class after they've been extracted out

## 0.7.2

- `date_drop_down` `table_column` `editor`
- `date` `table_column` `editor`
- `time` `table_column` `editor`
- Implement `on_focus_gained`, `on_focus_lost` universally on all widgets
- Add support for Struct keyword_init to Opal
- Fix issue with hello_table button/combo not being centered (yet stretched)
- Fix issue with table item selection for booking not working after editing has been added
- Fix escape keyboard event handling for combo table editor

## 0.7.1

- Combo table editor (enabled in Hello, Table! sample)
- Fix issue with table cell selection for editing not working
- Remove widget from parent upon dispose
- Remove listeners upon widget dispose

## 0.7.0

- Hello, Table! Sample
- `table` :editable style to enable auto-editing
- `table` `header_visible` property to hide header when false
- `table` `item_count` property to set minimum item count (fill empty rows when below in table items)
- `table` selection data-binding
- `table` built-in sorting support
- `table_column` left text alignment and padding of 5px by default
- `table` sort property and direction in GUI
- `table_column` sort_property
- `table_column` sort_by block
- `table_column` sort block
- `table` default sort via property, compare block, and property block
- `table` additional sort properties
- Prevent `table` unnecessary updates by comparing data to previous data and not updating when it's the same
- Contact Manager sample support for on_key_pressed in text widgets upon hitting ENTER
- Fix issue with edit table item error on sorting table

## 0.6.1

- Fix issue with rendering date_time without a block
- Made listener event handling async to improve performance when triggering multiple events
- Brought Tic Tac Toe sample up-to-date with changes in Glimmer DSL for SWT
- Fixed silent error encountered in rendering custom widgets

## 0.6.0

- Hello, Date Time! Sample
- Support `date_time`, `date`, `date_drop_down`, `time`, `calendar` keywords
- Format Date/Time correctly as per SWT implementation by default
- Make glimmer-dsl-opal gem into a Rails engine to support importing default static assets like CSS styles and images
- Show drop down icon next to `date_drop_down` and `time`

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
- Hello, World! sample support
