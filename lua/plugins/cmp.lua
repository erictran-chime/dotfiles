return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",  -- cmp_nvim_lsp
    "neovim/nvim-lspconfig", -- lspconfig
    "onsails/lspkind-nvim",  -- lspkind (VS pictograms)
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" }, -- Snippets
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        -- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/go.json
      end
    }, { "saadparwaiz1/cmp_luasnip", enabled = true }
  },
  config = function()
    local luasnip = require("luasnip")
    local types = require("luasnip.util.types")

    -- Display virtual text to indicate snippet has more nodes
    luasnip.config.setup({
      ext_opts = {
        [types.choiceNode] = {
          active = { virt_text = { { "⇥", "GruvboxRed" } } }
        },
        [types.insertNode] = {
          active = { virt_text = { { "⇥", "GruvboxBlue" } } }
        }
      }
    })

    local cmp = require("cmp")
    local lspkind = require("lspkind")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" })
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 70,
          show_labelDetails = true
        })
      }
    })

    local lspconfig = require("lspconfig")

    -- All languages: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    -- Default lspconfig values for Go are set by `navigator`
    -- Go: go install golang.org/x/tools/gopls@latest

    -- Python: brew install pyright
    lspconfig["pyright"].setup {}

    -- Ruby: gem install solargraph

    -- Setup for Ruby LSP if not already configured
    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")
    local util = require("lspconfig.util")
    if not configs.ruby_lsp then
      local enabled_features = {
        "documentHighlights",
        "documentSymbols",
        "foldingRanges",
        "selectionRanges",
        -- "semanticHighlighting",
        "formatting",
        "codeActions",
      }

      configs.ruby_lsp = {
        default_config = {
          cmd = { "bundle", "exec", "ruby-lsp" },
          filetypes = { "ruby" },
          root_dir = util.root_pattern("Gemfile", ".git"),
          init_options = {
            enabledFeatures = enabled_features,
          },
          settings = {},
        },
        commands = {
          FormatRuby = {
            function()
              vim.lsp.buf.format({
                name = "ruby_lsp",
                async = true,
              })
            end,
            description = "Format using ruby-lsp",
          },
        },
      }
    end

    -- Attach Ruby LSP
    lspconfig.ruby_lsp.setup({
      on_attach = function(client, bufnr)
        -- Your on_attach logic here
        print("Ruby LSP attached")
        -- Add key bindings or any other setup you want on attach
      end,
      capabilities = vim.lsp.protocol.make_client_capabilities(),
    })
    -- https://phpactor.readthedocs.io/en/master/usage/standalone.html#installation
    lspconfig["phpactor"].setup {}
  end
}
