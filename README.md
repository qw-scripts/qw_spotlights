# Spotlights

Basic spotlight system. Completely synced across players.

## Preview

[https://streamable.com/397in7](https://streamable.com/397in7)

## Requirements

- latest version of [ox_lib](https://github.com/overextended/ox_lib/releases/latest)

It is current setup to support ox_core. If you need this to support another framework then you will need to make changes yourself. The only place that uses framework dependent events is in `client/main.lua` on line `49`. You can replace that event handler with your own.
