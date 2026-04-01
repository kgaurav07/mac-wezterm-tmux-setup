-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------
-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- make paste in normal default to paste at current indentation level where cursor is
keymap.set("n", "p", "]p", { desc = "Paste with proper indent" })

-- new file when in explorer
keymap.set("n", "<leader>nf", ":enew<CR>", { desc = "Create a new file" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Keymap to print diagnostics and copy to clipboard
keymap.set("n", "<leader>pd", ":PrintDiagnostics<CR>", { desc = "Print diagnostics and copy to clipboard" })

-- Wrap word in double quotes
keymap.set("n", '<leader>"', 'ciw""<Esc>P', { desc = "Wrap word in double quotes" })

-- Wrap word in single quotes
keymap.set("n", "<leader>'", "ciw''<Esc>P", { desc = "Wrap word in single quotes" })

-- Wrap word in backticks
keymap.set("n", "<leader>`", "ciw``<Esc>P", { desc = "Wrap word in backticks" })

-- Allow saving of files as sudo when I forgot to start vim using sudo.
vim.api.nvim_set_keymap("c", "w!!", "w !sudo tee > /dev/null %", { noremap = true })

-- Refresh the current buffer
keymap.set("n", "<leader>r", ":e!<CR>", { desc = "Refresh current buffer" })

-- Jump 10 lines up/down with Alt+j/k (or Cmd+Option+j/k via WezTerm)
keymap.set("n", "<M-j>", "10jzz", { desc = "Jump 10 lines down" })
keymap.set("n", "<M-k>", "10kzz", { desc = "Jump 10 lines up" })
keymap.set("v", "<M-j>", "10jzz", { desc = "Jump 10 lines down (visual)" })
keymap.set("v", "<M-k>", "10kzz", { desc = "Jump 10 lines up (visual)" })

-- Smart centering - keep cursor centered on all navigation
keymap.set("n", "n", "nzz", { desc = "Next search (centered)" })
keymap.set("n", "N", "Nzz", { desc = "Prev search (centered)" })
keymap.set("n", "gg", "ggzz", { desc = "Go to top (centered)" })
keymap.set("n", "G", "Gzz", { desc = "Go to bottom (centered)" })
keymap.set("n", "*", "*zz", { desc = "Search word under cursor (centered)" })
keymap.set("n", "#", "#zz", { desc = "Search word backward (centered)" })
keymap.set("n", "{", "{zz", { desc = "Previous paragraph (centered)" })
keymap.set("n", "}", "}zz", { desc = "Next paragraph (centered)" })

-- Search for visually selected text
keymap.set("v", "*", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>", { desc = "Search selection forward" })
keymap.set("v", "#", "y?\\V<C-R>=escape(@\",'/\\')<CR><CR>", { desc = "Search selection backward" })

-- Buffer management
keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<CR>", { desc = "Browse buffers" })
keymap.set("n", "<leader>bl", "<C-^>", { desc = "Jump to last buffer" })
keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete current buffer" })
keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
