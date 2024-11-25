return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  opts = {
    hijack_netrw_behavior = "open_default",
    follow_current_file = {
      enabled = true
    },
    filesystem = {
      filtered_items = {
        show_hidden_count = false,
        hide_gitignored = true,
        hide_dotfiles = false
      }
    },
    use_libuv_file_watcher = true -- use os commands instead of vim commands to detect file changes.
  }
}
