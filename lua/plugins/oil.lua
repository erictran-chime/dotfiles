local opts = {
  'stevearc/oil.nvim',
  opts = {},
  version = 'v2.13.0',
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons', { 'echasnovski/mini.icons', opts = {} } },
  config = function()
    local preview_enabled = false
    require('oil').setup {
      float = {
        win_options = {
          winblend = 0,
        },
      },
      keymaps = {
        ['gp'] = {
          desc = 'Toggle Preview',
          callback = function()
            if not preview_enabled then
              require('oil').open_preview {
                vertical = true,
                split = 'botright',
              }
              preview_enabled = true
            else
              vim.cmd.pclose()
              preview_enabled = false
            end
          end,
        },
        ['gh'] = {
          desc = 'Toggle [H]idden',
          callback = function()
            require('oil').toggle_hidden()
          end,
        },
      },
    }
    vim.keymap.set('n', '<leader>fo', '<CMD>Oil<CR>', { desc = 'Open Oil for current directory' })
  end,
}

return opts

