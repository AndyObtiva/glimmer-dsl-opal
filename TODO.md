# TODO

Here is a list of tasks to do (moved to CHANGELOG.md once done).

## Next

## Soon

- Whitelist images exposed online for download
- Support ShellProxy and DialogProxy on_swt_show, on_shell_closed and on_swt_close listeners
- Support ShellProxy maximum_size (as per new support of it in Glimer DSL for SWT)
- Support exposing images to use as a composite background_image or shell image attribute as per those details:
  - glimmer-dsl-opal Rails engine server: Derive image paths from available assets by providing a controller action and route for it (glimmer_dsl_opal_image_paths)
  - Opal client: Patch File.expand_path on available server-side image paths via ajax (cached after first hit), comparing the ending of paths as like matching ./(file)/hello/hello.png vs /assets/images/hello/hello.png
- Update Hello, Table! to latest version in Glimmer DSL for SWT that utilizes an image background (and have working on the web)
- Update README to remove code for all samples except Hello, World!, Hello, Computed!, and Hello Custom Widget!
- Support setting favicon (by setting `image` property inside `shell`)
- rake task to clear copied assets from rails server app

- Translate Tetris sample from Glimmer DSL for SWT to Glimmer DSL for Opal for the web
- Update Glimmer DSL for Opal setup instructions to generate Welcome controller instead of resource and --skip-coffee
- Check if hello world can add libraries that are later used in opal despite passing false to Opal.use_gem
- Implement part of net/http with jQuery Ajax for use in Glimmer apps since it is not implemented by Opal
- Drip Drop Chat: Distraction-Free General Chat with Drip Drop Technology to ensure chats are balanced and one cannot send too many messages without another's acknowledgment. Drip Drop Technology allows no more than one short message without a reply, requiring a reply before you can make another reply, thus auto-moderating itself). It will be free and open-source under the MIT license.
  - Support multiple users
  - No login to start
  - One chat room to start
  - Threaded chat in 2D space open for all
  - Maintain user identity in cookies (store identity cookies in Glimmer DSL for Opal)
- Nav Bar web-only sample (using a `menu_bar` as a navbar, styled with CSS)

- Document each widget separately in each hello sample
- Support `progress_bar` using jQuery UI and Hello, Progress Bar!
- Support the idea of a virtual hard drive pretending to be local with full permissions, but actually lives on the server
- Support Authentication (username/password)
- Support the idea of embedding a Glimmer DSL for Opal app inside a greater HTML document instead of directly under body by specifying the element under which it plugs into via a global Display#shell_element_path, shell_element_id or something of the like. Also. perhaps support configuring that element on a custom-shell by custom-shell basis (like some of them do replace the whole page filling the screen)
this can be done by providing "parent_path" option (css selector) to Shell (e.g. shell(parent_path: 'div#glimmer-app'). Also, generate shell IDs in localStorage since multiple shells can be spawned in separate tabs and cannot keep track of IDs in the same JS runtime.
Consider the idea of having shells render a div without as an addition to current document instead of replacement
- Secure Custom Shell options by passing through localStorage database instead of query parameters (and remove query parameter support for options and utilize custom_shell_handled in localStorage)
- Support downloading any file accessed by File.read could be exposed as a downloadable on the fly and cached in a list that persists across server restarts (save for files being deleted)
Consider a security model where you pre-add all gem Ruby files to make available for download, but only enable download at runtime when a file is requested (keeping all other fiels sealed and protected) using some authorized scheme/model (e.g. pundit)

- Always open a second shell in a separate browser tab/window even if not a custom shell (auto-id'ing uniquely via shell title text using as hashtag)
- Support hiding a shell and opening a new one while staying in the same page (equivalent of page changes with shell title text used to autogenerate hashtag unique URL)
- Extract glimmer dsl engine code to glimmer gem

- Support for multiple consecutive message boxes feeding results to each other
- Update Hello, Message Box! Sample include Yes/No, Abort/Retry/Ignore, OK, Retry/Cancel button variations
- MessageBox support for all Yes/No, Abort/Retry/Ignore, OK, Retry/Cancel button variations
- Refactor message_box to use jQuery-UI dialog

- Move Glimmer::SWT to Glimmer::SWT::SWTProxy or something like that to avoid its conflict when expressions expand words like Selection (for a property data-binding with shine)
- Any File.read(paths) calls directly as downloadables (and linking to them in widgets that way). The 'images' directory could be pre-exposed as assets.

## Issues

- Fix issue with enter key triggering button behind a message_box (like in Hello, Message Box!)
- Focus on next enabled widget when disabling a widget
- Resolve issue with custom shell detecting dialogs and blocking (it seems to work only with shell) (Flip Tic Tac Toe to a custom shell and you encounter the problem)

## Features

- Hello, Link!
- Support for shell :no_trim style (via absolute position divs)
- Support `spinner` and Hello, Spinner! Sample / User Profile Sample
- User Profile Sample (dependent on spinner support)
- `spinner` table editor
- Support all variations of button (:radio, :check, :arrow)
- Support different themes by detecting browser OS (Mac, Windows, Linux)
- Test and document opal-hot-reloader as an option for hot loading glimmer-dsl-opal
- Consider the idea of supporting multiple web implementations for a widget to allow different looks, perhaps allowing 3rd parties to plug extra implementations as needed as different "adapters"
- Consider the idea of configuration of whether to open new custom shells in the same browser tab/window or the default of new tabs/windows. Perhaps even support configuring on a specific custom shell by custom shell basis
- Hello, Message Box!
- Support `expand_bar` and `expand_item` using the jQuery UI Accordion
- Provide a way for disabling included CSS altogether for consumers should they want to use CSS with a clean slate
- Update DateTimeProxy to add date, time, year, month, day, hours, minutes, seconds attribute methods

- Update `date` and `time` to be spinner based, not drop-down based
- Implement doit in on_key_pressed event for TextProxy and other events
- Support table multi-selection
- Specify table default sort direction (e.g. sort_direction property or otherwise an option on sort_property :some_prop, direction: :ascending ; and add that to Glimmer DSL for SWT
- Support double-click events
- Consider including mobile-responsive CSS themes that auto-convert menu bar into a drop-down mobile-menu button
- glimmer command for adding a gem automatically appending gem to assets via Opal.use_gem

- Build a Ruby repl in the browser
- Build a Glimmer GUI repl in the browser

## Technical Tasks

- fire on_widget_disposed listener in WidgetProxy on calling `#dispose`
- Consider making it a configurable option to whether open a secondary shell as a new tab or an internal modeless dialog

## Opal Ruby Extensions/Missing Features
- Figure out a way to do File.read in Opal
- net/http (and dependencies like uri)
- consider reimplementing net/http through fetch instead of opal-jquery

## Refactorings

- Optimize table sorting/update performance (perhaps by relying on diff/delta and not truly updating when it's a sort operation only)
- Do away with redraw everywhere possible
- Have Shell/CustomShell render content without attaching to the DOM until #open is called by having each child grab DOM relative to parent (instead of absolute CSS path) while having Shell render to an in-memory DOM until ready to attach with #open
- Refactor tab_folder/tab_item to use jQuery-UI
- Boilerplate dom method on most widgets that follow the default in markup (perhaps relying only on specifying `#element`)

## Miscellaneous

- Add a gem 'opal' directory and turn into an official Opal gem with `Opal.append_path File.expand_path('../../../opal', __FILE__)`

## Samples

- Style all samples with an alternate version
- Host all internal samples online
- Web-Only Samples

## Production Apps

- Desktopify.org (free): freely convert any web app into a desktop app using Glimmer scaffolding. Provide scaffolded app as src, dmg, pkg, app, msi, and jar+script for Linux.
- ThoughtBarf (free) to barf thoughts online with short messages relying on self moderating Drip Drop Technology
- DripBlog (free) with comment self moderating Drip Drop Technology and Glimmer Blog as first customer
- FriendsOnly (free): a friends only social networking site that intentionally avoids supporting family-tree and dating relationships/status. This makes it a safe place for networking with friends only. Leverages the Drip Drop Technology
- FreeHire: Web app for requesting software development project services and hiring developers for free in exchange for marketing them with finished software online citation from the start. No guarantees for maintenance though. It is done freely only.
- DripEmail (paid business account) email service using Drip Drop Technology
- DripForum (with self moderating Drip Drop Technology that allows no more than one message without a reply, requiring a reply before you make another reply, thus auto-moderating)
- PublishOrPerish (free) a site to publish articles and receive comments. Leveraged self moderating Drip Drop Technology.
- ProfessionalOpinion: a professional question/answer website relying on self-moderating Drip Drop Technology (free for answering and browsing but not for asking)
- indextheworld.org or cyclopedia.world (free): a publicly co-authored encyclopedia. Circumvents many issues in wikipedia by making pages available for authorship by one person only (thus eliminating the issues of different writing styles and inconsistencies per page on wikipedia). If changes were needed, other people may submit inquiries to the page author to update the page. If the author does not respond in a year and a half, the page is released to the public to be claimed by a different author. If the page author puts inaccurate info, people can complain. Once there are 8 complaints, the page is flagged for review by website volunteer moderators approved by website owner (me). They can accept the complaints or deny them. If they accept the complaints, the page author is revoked and the page becomes available to be claimed by a differnet author. If not, then the page author stays and next time needs 1.5x the complains (12 for example) to flag page for review. This auto-punishes complainers if they complain without the page having any issues as next time it becomes harder to flag it.
- Build FolkAdvice.com (free): a website for asking for and giving advice. Also relies on Drip Drop self-moderating technology
- GlimmerAppStore.com: cross platform alternative to Mac App Store to host and sell glimmer apps with auto update support
- helpmeteachyou.org (free): free education platform
- social.community (free): online community gathering with Drip Drop self-moderating technology.

## Documentation

- Document a styled Tic Tac Toe at the top of the README
