<!-- This Source Code Form is subject to the terms of the Mozilla Public
   - License, v. 2.0. If a copy of the MPL was not distributed with this
   - file, You can obtain one at https://mozilla.org/MPL/2.0/. -->

# 📚 Mission

`zim` is a userscript library for a brand-new kind of Linux distribution: [Debian 13 Trixie](https://wiki.debian.org/DebianTrixie).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;seeks to help infrastructure engineers develop automations with complex tooling. 

## Anti-Features

`zim` only validates script dependencies; it does not attempt to resolve them.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;compartmentalizes operations with shared contigencies into individual script files. This can sometimes result in a need for multiple scripts to be run in sequence to complete an installation task.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;granularity is evaluated lazily based on need.

## Features
`zim` is idempotent.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;is reversible with contingency validation.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;is annotated with [PEP 350](https://peps.python.org/pep-0350/) codetags.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;is licensed under [MPL 2.0](https://www.mozilla.org/en-US/MPL/2.0/).

## Kudos
🕊️ *In Memoriam [Ian Murdock](https://www.debian.org/doc/manuals/project-history/manifesto.en.html)*
