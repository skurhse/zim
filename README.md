<!-- This Source Code Form is subject to the terms of the Mozilla Public
   - License, v. 2.0. If a copy of the MPL was not distributed with this
   - file, You can obtain one at https://mozilla.org/MPL/2.0/. -->

# zim 📚
A standalone userscript library for a brand-new kind of Linux distribution.

## Design Intention
`zim` targets [Debian “bookworm”](https://www.debian.org/releases/bookworm/).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;only validates script dependencies, it does not resolve them.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;isolates component operations into self-contained script files.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;is annotated with [PEP 350](https://peps.python.org/pep-0350/) codetags.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;is [MPl-licensed](https://www.mozilla.org/en-US/MPL/2.0/).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;is verbose.

## Error Codes

Code | Description
:-- | :--
1 | script failure
2 | unresolved dependency
3 | broken dependency

## Kudos
🕊️ *In Memoriam [Ian Murdock](https://en.wikipedia.org/wiki/Ian_Murdock)*
