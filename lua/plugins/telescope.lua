local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local Path = require('plenary.path')

local delete_file = function(prompt_bufnr)
  local selected_entry = action_state.get_selected_entry()
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local filepath = selected_entry[1]

  -- Confirm deletion
  vim.ui.input({ prompt = 'Delete file? (y/n): ' }, function(input)
    if input == 'y' then
      -- Delete the file
      local p = Path:new(filepath)
      p:unlink()

      -- Refresh the picker to show the file is deleted
      current_picker:refresh()
    end
  end)
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      enabled = true
    }, { "nvim-telescope/telescope-file-browser.nvim", enabled = true }
  },
  branch = "0.1.x",
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist +
                actions.open_qflist,                     -- send selected to quickfixlist
            ["<C-d>"] = delete_file,
          }
        }
      },
      extensions = {
        file_browser = {
          theme = "ivy",
          path = "%:p:h",         -- open from within the folder of your current buffer
          display_stat = false,   -- don't show file stat
          grouped = true,         -- group initial sorting by directories and then files
          hidden = true,          -- show hidden files
          hide_parent_dir = true, -- hide `../` in the file browser
          hijack_netrw = true,    -- use telescope file browser when opening directory paths
          prompt_path = true,     -- show the current relative path from cwd as the prompt prefix
          use_fd = true           -- use `fd` instead of plenary, make sure to install `fd`
        }
      }
    })

    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")

    local builtin = require("telescope.builtin")
    -- key maps
    -- keys = {
    --   keymap.set("n", "<C-p>", ":Telescope git_files<CR>", keymap_options({ desc = "Find files (Git-aware)" })),
    --   keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", keymap_options({ desc = "Find files" })),
    --   keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", keymap_options({ desc = "Find buffers" })),
    --   keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>", keymap_options({ desc = "Find keymaps" })),
    --   keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", keymap_options({ desc = "Find help tags" })),
    --   keymap.set("n", "<leader>fa", ":Telescope <CR>", keymap_options({ desc = "Find all" })),
    --   keymap.set("n", "<leader>fm", ":Telescope marks<CR>", keymap_options({ desc = "Find marks" })),
    --   keymap.set("n", "<leader>fo", ":Telescope oldfiles<CR>", keymap_options({ desc = "Find previously openfiles" })),
    --   keymap.set("n", "<leader>fv", ":Telescope vim_options<CR>", keymap_options({ desc = "Find vim options" })),
    --   keymap.set("n", "<leader>fy", ":Telescope filetypes<CR>", keymap_options({ desc = "Find available filetypes" })),
    -- },
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }
    -- builtin.lsp_definitions({ reuse_win = false })

    map("n", "-", ":Telescope file_browser<CR>")

    map("n", "<leader>fb", builtin.buffers, opts)    -- Lists open buffers
    map("n", "<leader>fd", builtin.find_files, opts) -- Lists files in your current working directory, respects .gitignore
    map("n", "<leader>fs", builtin.live_grep, opts)  -- Lists files in your current working directory, respects .gitignore
    map("n", "<leader>fx", builtin.treesitter, opts) -- Lists tree-sitter symbols
  end
}
