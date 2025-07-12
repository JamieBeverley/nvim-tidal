# nvim-tidal

A very unsophisticated nvim plugin for [TidalCycles](https://tidalcycles.org/)

## Setup (Lazy):
```lua
require("nvim-tidal").setup({
    -- optional, otherwise will look in cwd for BootTidal.hs
    boot_tidal = "/path/to/boot_tidal.hs"
})
```
## Commands:
- TidalStart: start ghci in terminal belowright
- TidalSend: send a string to be interpreted by GHCI/Tidal
- TidalEvaluate: evaluate a block of code under the cursor
- TidalStop: kill the GHCI process

## APIs (same as above):
`require("nvim-tidal")`.):
  - `setup
  - `start
  - `stop
  - `evaluate
  - send

