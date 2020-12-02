# TODO

Here is a list of tasks to do (moved to CHANGELOG.md once done).

## Next

- `table_column` sort block
- `table_column` sort_by block
- `table` default sort via property, compare block, and property block
- `table` additional sort properties
- Update Glimmer DSL for Opal setup instructions to generate Welcome controller instead of resource and --skip-coffee

## Soon

- Custom table column editors (combo, date, time)

- Support context menus `menu`/`menu_item` directly under a widget (using jQuery UI)
- Hello, Pop Up Context Menu! Sample

- Support `on_mouse_up` events on all widgets
- Support `dialog`

- Implement part of net/http with jQuery for use in Glimmer apps since it is not implemented by Opal

- Support exposing images (and any File.read(paths)) directly as downloadables (and linking to them in widgets that way). The 'images' directory could be pre-exposed as assets. Otherwise, any file accessed by File.read could be exposed as a downloadable on the fly and cached in a list that persists across server restarts (save for files being deleted)

- Secure Custom Shell options by passing through localStorage instead of query parameters (and remove query parameter support for options and utilize custom_shell_handled in localStorage)
- Support having any widget contribute static document-wide CSS to ShellProxy

## Issues


## Features

- Support all variations of button (:radio, :check, :arrow)
- Support different themes by detecting browser OS (Mac, Windows, Linux)
- Support Document.ready? as part of Glimmer's top level keywords so clients don't need to use it
- Test and document opal-hot-reloader as an option for hot loading glimmer-dsl-opal
- Consider the idea of supporting multiple web implementations for a widget to allow different looks, perhaps allowing 3rd parties to plug extra implementations as needed as different "adapters"
- Support the idea of configuration of whether to open new custom shells in the same browser tab/window or the default of new tabs/windows. Perhaps even support configuring on a specific custom shell by custom shell basis
- Support the idea of embedding a Glimmer DSL for Opal app inside a greater HTML document instead of directly under body by specifying the element under which it plugs into. Also. perhaps support configuring that element on a custom-shell by custom-shell basis (like some of them do replace the whole page filling the screen)
- Support real menus `menu_bar`
- Hello, Menu Bar! Sample
- MessageBox reimplemented with jQuery UI Dialog supporting all YES/NO button variations
- Hello, Message Box!
- Support `expand_bar` and `expand_item` using the jQuery UI Accordion
- Support `progress_bar` using the jQuery UI Accordion
- Provide a way for disabling included CSS altogether for consumers should they want to use CSS with a clean slate
- Update DateTimeProxy to add date, time, year, month, day, hours, minutes, seconds attribute methods
- Support `spinner` and Hello, Spinner! Sample
- Update `date` and `time` to be spinner based, not drop-down based
- Implement doit in on_key_pressed event for TextProxy et al

## Opal Ruby Extensions/Missing Features
- Figure out a way to do File.read in Opal
- net/http (and dependencies like uri)

## Refactorings

- Optimize table sorting/update performance (perhaps by relying on diff/delta and not truly updating when it's a sort operation only)
- Do away with redraw everywhere possible
- Have Shell/CustomShell render content without attaching to the DOM until #open is called by having each child grab DOM relative to parent (instead of absolute CSS path) while having Shell render to an in-memory DOM until ready to attach with #open
- Refactor tab_folder/tab_item to use jQuery-UI
- Refactor message_box to use jQuery-UI dialog

## Miscellaneous

- Add a gem 'opal' directory and turn into an official Opal gem with `Opal.append_path File.expand_path('../../../opal', __FILE__)`

## Samples

- Style all samples with an alternate version
- Host all internal samples online

## Production Apps

- Desktopify.org (free): freely convert any web app into a desktop app using Glimmer scaffolding. Provide scaffolded app as src, dmg, pkg, app, msi, and jar+script for Linux.
- DripComm.com: Distraction-Free Business Chat (paid business account) with DripComm technology to ensure chats are balanced and one cannot send too many messages without another's acknowledgment. DripComm allows no more than one short message without a reply, requiring a reply before you make another reply, thus auto-moderating itself). DripComm is short for Drip Communication. It will be open-source, but under a special license that requires a paid business account to reuse by 3rd party developers.
- ThoughtBarf (free) to barf thoughts online with short messages relying on self moderating DripComm technology
- DripBlog (free) with comment self moderating DripComm technology and Glimmer Blog as first customer
- FriendsOnly (free): a friends only social networking site that intentionally avoids supporting family-tree and dating relationships/status. This makes it a safe place for networking with friends only. Leverages the DripComm technology
- FreeHire: Web app for requesting software development project services and hiring developers for free in exchange for marketing them with finished software online citation from the start. No guarantees for maintenance though. It is done freely only.
- DripEmail (paid business account) email service using DripComm technology
- DripForum (with self moderating DripComm technology that allows no more than one message without a reply, requiring a reply before you make another reply, thus auto-moderating)
- PublishOrPerish (free) a site to publish articles and receive comments. Leveraged self moderating DripComm technology.
- ProfessionalOpinion: a professional question/answer website relying on self-moderating DripComm technology (free for answering and browsing but not for asking)
- indextheworld.org or cyclopedia.world (free): a publicly co-authored encyclopedia. Circumvents many issues in wikipedia by making pages available for authorship by one person only (thus eliminating the issues of different writing styles and inconsistencies per page on wikipedia). If changes were needed, other people may submit inquiries to the page author to update the page. If the author does not respond in a year and a half, the page is released to the public to be claimed by a different author. If the page author puts inaccurate info, people can complain. Once there are 8 complaints, the page is flagged for review by website volunteer moderators approved by website owner (me). They can accept the complaints or deny them. If they accept the complaints, the page author is revoked and the page becomes available to be claimed by a differnet author. If not, then the page author stays and next time needs 1.5x the complains (12 for example) to flag page for review. This auto-punishes complainers if they complain without the page having any issues as next time it becomes harder to flag it.
- Build FolkAdvice.com (free): a website for asking for and giving advice. Also relies on DripComm self-moderating technology
- GlimmerAppStore.com: cross platform alternative to Mac App Store to host and sell glimmer apps with auto update support
- helpmeteachyou.org (free): free education platform
- social.community (free): online community gathering with DripComm self-moderating technology.
