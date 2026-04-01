# Lua Cheatsheet

Lua is a **lightweight scripting language** used to configure Neovim.
You don't need to become a Lua programmer — but reading and tweaking nvim config files
becomes much easier once you know the basics.

> This is a practical reference, not a full language guide.
> You only need enough Lua to read and edit your `~/.config/nvim/` files.

---

## Why Lua in Nvim?

Neovim moved from Vimscript to Lua for configuration because Lua is:
- Faster to execute
- Easier to read
- Has proper programming constructs (functions, tables, conditionals)

Your entire nvim config (`~/.config/nvim/lua/`) is written in Lua.

---

## The Basics You'll Actually Use

### Variables

```lua
local x = 10           -- local variable (use this always)
local name = "hello"   -- string
local flag = true      -- boolean
```

> Always use `local`. Without it, the variable is global and can cause bugs.

### Tables (Lua's only data structure)

Tables are used for everything — arrays, dictionaries, config options:

```lua
-- As a list (array)
local fruits = { "apple", "banana", "cherry" }
print(fruits[1])   -- "apple" (Lua is 1-indexed, not 0)

-- As a dictionary (key-value)
local person = { name = "Alice", age = 30 }
print(person.name)   -- "Alice"
print(person["age"]) -- 30 (same thing, bracket syntax)

-- Nested (common in plugin configs)
local opts = {
  options = {
    mode = "tabs",
    separator_style = "slant",
  }
}
```

### Functions

```lua
-- Define
local function greet(name)
  return "Hello, " .. name  -- ".." joins strings
end

-- Call
greet("Marion")   -- returns "Hello, Marion"

-- Anonymous function (common in keymaps and plugin configs)
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end)
```

### Conditionals

```lua
if x > 10 then
  print("big")
elseif x == 10 then
  print("exactly ten")
else
  print("small")
end
```

### String operations

```lua
local s = "hello world"
s .. " !"          -- concatenate: "hello world !"
#s                 -- length: 11
string.upper(s)    -- "HELLO WORLD"
string.find(s, "world")  -- returns position
```

---

## Nvim-Specific Lua Patterns

These are the patterns you'll see constantly in nvim config files.

### vim.opt — set options

```lua
vim.opt.number = true          -- enable line numbers
vim.opt.tabstop = 2            -- tab = 2 spaces
vim.opt.clipboard = "unnamedplus"  -- use system clipboard
```

### vim.keymap.set — define keybindings

```lua
-- vim.keymap.set(mode, key, action, options)
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {
  desc = "Find files"   -- shows in which-key popup
})

-- Modes:
-- "n" = Normal
-- "i" = Insert
-- "v" = Visual
-- {"n", "v"} = Normal and Visual
```

### vim.api.nvim_create_user_command — create a command

```lua
-- Creates :MyCommand
vim.api.nvim_create_user_command("MyCommand", function()
  print("Hello!")
end, {})
```

### require — load a module

```lua
local telescope = require("telescope")      -- load installed plugin
local actions = require("telescope.actions") -- load submodule
```

### Plugin config with opts table

Most plugins in lazy.nvim are configured with an `opts` table:

```lua
return {
  "plugin-author/plugin-name",
  opts = {
    setting_one = true,
    setting_two = "value",
  },
}
```

Or with a `config` function for more control:

```lua
return {
  "plugin-author/plugin-name",
  config = function()
    require("plugin-name").setup({
      setting_one = true,
    })
    -- extra setup code here
  end,
}
```

---

## Reading Your Nvim Config

### File structure

```
~/.config/nvim/
├── init.lua                    ← entry point, loads everything
└── lua/
    └── blake/                  ← module namespace (just a folder name)
        ├── core/
        │   ├── options.lua     ← vim.opt settings
        │   └── keymaps.lua     ← vim.keymap.set bindings
        ├── lazy.lua            ← plugin manager bootstrap
        └── plugins/            ← one file per plugin
            ├── telescope.lua
            ├── nvim-tree.lua
            └── ...
```

### How init.lua wires everything together

```lua
require("blake.core")    -- loads lua/blake/core/init.lua
require("blake.lazy")    -- loads lua/blake/lazy.lua (plugins)
```

### How a plugin file works

Each file in `plugins/` returns a table that lazy.nvim reads:

```lua
-- lua/blake/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",   -- plugin to install from GitHub
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- setup runs after install
    require("telescope").setup({ ... })

    -- keymaps only active when this plugin is loaded
    vim.keymap.set("n", "<leader>ff", ...)
  end,
}
```

---

## Common Patterns When Editing Config

### Add a new keymap

Open `lua/blake/core/keymaps.lua` and add:

```lua
vim.keymap.set("n", "<leader>xy", "<cmd>SomeCommand<CR>", { desc = "What it does" })
```

### Change a plugin option

Find the plugin file in `lua/blake/plugins/`, locate the `opts` table, and change the value:

```lua
opts = {
  separator_style = "slope",  -- was "slant"
}
```

### Disable a plugin temporarily

Add `enabled = false` to the plugin spec:

```lua
return {
  "some/plugin",
  enabled = false,   -- won't load until you remove this line
  ...
}
```

---

## Quick Reference Card

```lua
-- Variables
local x = 10
local s = "hello"
local t = { key = "value", list = { 1, 2, 3 } }

-- Table access
t.key          -- "value"
t["key"]       -- same
t.list[1]      -- 1  (1-indexed!)

-- String join
"hello" .. " " .. "world"   -- "hello world"

-- Function
local function f(a, b) return a + b end

-- Nvim options
vim.opt.number = true

-- Keymap
vim.keymap.set("n", "<leader>x", "<cmd>Command<CR>", { desc = "..." })

-- Load plugin
local plug = require("plugin-name")
plug.setup({ option = true })

-- Conditional
if condition then ... elseif other then ... else ... end
```
