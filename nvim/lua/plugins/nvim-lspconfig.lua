local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- TODO Maybe use lsp-zero instead of this. I'm not sure how well that will play
-- with NvChad though.
-- https://lsp-zero.netlify.app/v4.x/tutorial.html#complete-code
-- local servers = utils.loadLanguageConfigs({ "cpp", "js" }, { "lspconfig", "servers" })

local setup = function(servers)
  -- lsps with default config
  for key, value in pairs(servers) do
    local name, config

    local baseConfig = {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
    }

    if type(value) == "table" then
      -- Custom configuration for servers specified as key-value pairs
      name = key
      config = vim.tbl_extend("force", baseConfig, value)
    elseif type(value) == "string" then
      -- Default configuration for servers specified as strings
      name = value
      config = baseConfig
    end

    if name and config then
      lspconfig[name].setup(config)
    end
  end

  -- Global configs for diagnostics
  vim.diagnostic.config({
    virtual_text = false,
    float = {
      border = "rounded",
    },
    signs = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
  })

  local border = {
    { "╭", "CmpBorder" },
    { "─", "CmpBorder" },
    { "╮", "CmpBorder" },
    { "│", "CmpBorder" },
    { "╯", "CmpBorder" },
    { "─", "CmpBorder" },
    { "╰", "CmpBorder" },
    { "│", "CmpBorder" },
  }

  -- Make sure all floating windows have a border
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
  })
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- web stuff
      "html",
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
      "eslint",
      -- Using pmizio/typescript-tools.nvim instead
      -- "tsserver",
      -- TODO Try these out
      -- "css_variables",
      -- "cssls",
      -- "css_modules",
      "somesass_ls",

      -- cpp stuff
      "clangd",
      "cmake",

      -- swift stuff
      "sourcekit",

      -- ruby stuff
      -- "ruby_lsp",
      ruby_lsp = {
        mason = false,
        cmd = { vim.fn.expand("~/.local/share/mise/shims/ruby-lsp") },
        -- cmd = { "/Users/marcwren/.local/share/mise/installs/ruby/3.4.4/bin/ruby"},
        -- cmd = { vim.fn.expand("~/.local/share/mise/installs/ruby/3.4.4/bin/ruby")},
        -- cmd = { "/Users/marcwren/.local/share/mise/installs/ruby/3.4.4/bin/ruby-lsp"},
        -- cmd = {"ruby-lsp"},
        -- cmd = {
        --   "bash", "-c", "echo 'Ruby version:' $(~/.local/share/mise/shims/rubocop -v) >> /tmp/ruby_lsp.log && ~/.local/share/mise/shims/ruby-lsp"
        -- },
        -- cmd = {
        --   "bash", "-c", "env >> /tmp/ruby_lsp_env.log && ruby -v >> /tmp/ruby_lsp.log && ~/.local/share/mise/shims/ruby-lsp"
        -- },
        -- cmd = {
        --   "bash", "-c", "ruby -v >> /tmp/ruby_lsp.log && ~/.local/share/mise/shims/ruby-lsp && ~/.local/share/mise/shims/ruby -S rubocop -v >> /tmp/rubocop_version.log"
        -- },
        init_options = {
          formatter = false,
          -- formatter = 'standard',
          -- diagnostics = false,
        }
      },
      -- "rubocop",
      rubocop = {
        cmd = { vim.fn.expand("~/.local/share/mise/shims/rubocop") },
      }
    },
  },
  config = function(config)
    require("nvchad.configs.lspconfig").defaults()
    setup(config.opts.servers)
  end,
}
