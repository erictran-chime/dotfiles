local opts = {
  'folke/trouble.nvim',
  tag = 'v3.6.0',
  opts = {
    auto_preview = true,
    win = {
      type = 'split',
      position = 'bottom',
      size = { width = 0.4, height = 0.25 },
    },
    preview = {
      type = 'split',
      relative = 'win',
      position = 'right',
      size = 0.3,
    }, -- for default options, refer to the configuration section for custom setup.
  },
  cmd = 'Trouble',
  keys = {
    {
      '<leader>qtd',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>qtD',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>qtc',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>qtC',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>qtL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>qtq',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
  },
  config = function(_, opts)
    local trouble = require 'trouble'
    trouble.setup(opts)
  end,
}

return opts
