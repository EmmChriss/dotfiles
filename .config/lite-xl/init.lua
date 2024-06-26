--------------------------- Modules -------------------------------------

local core = require "core"

local keymap = require "core.keymap"
local config = require "core.config"
local style = require "core.style"

config.indent_size = 4

------------------------------ Themes ----------------------------------------

-- light theme:
-- core.reload_module("colors.summer")]

--------------------------- Key bindings -------------------------------------

-- key binding:
-- keymap.add { ["ctrl+escape"] = "core:quit" }


------------------------------- Fonts ----------------------------------------

-- customize fonts:
-- style.font = renderer.font.load(DATADIR .. "/fonts/font.ttf", 13 * SCALE)
-- style.code_font = renderer.font.load(DATADIR .. "/fonts/monospace.ttf", 12 * SCALE)
--
-- font names used by lite:
-- style.font          : user interface
-- style.big_font      : big text in welcome screen
-- style.icon_font     : icons
-- style.icon_big_font : toolbar icons
-- style.code_font     : code
--
-- the function to load the font accept a 3rd optional argument like:
--
-- {antialiasing="grayscale", hinting="full"}
--
-- possible values are:
-- antialiasing: grayscale, subpixel
-- hinting: none, slight, full

------------------------------ Plugins ----------------------------------------

-- Lint+
local lintplus = require "plugins.lintplus"
lintplus.setup.lint_on_doc_load()
lintplus.setup.lint_on_doc_save()

-- LSP
local lspconfig = require "plugins.lsp.config"

-- C/Cpp: clangd
lspconfig.clangd.setup {}

-- Rust: rust-anaylzer
lspconfig.rust_analyzer.setup {}

-- Zig: zls
lspconfig.zls.setup {}

