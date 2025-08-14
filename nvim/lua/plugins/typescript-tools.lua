-- Replacement for tsserver lsp config
-- https://github.com/pmizio/typescript-tools.nvim

local baseDefinitionHandler = vim.lsp.handlers["textDocument/definition"]
local on_attach = require("nvchad.configs.lspconfig").on_attach

local filter = function(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local filterReactDTS = function(value)
  if value.uri then
    return string.match(value.uri, "%.d.ts") == nil
  elseif value.targetUri then
    return string.match(value.targetUri, "%.d.ts") == nil
  end
end

local handlers = {
  ["textDocument/definition"] = function(err, result, method, ...)
    if vim.tbl_islist(result) and #result > 1 then
      local filtered_result = filter(result, filterReactDTS)
      return baseDefinitionHandler(err, filtered_result, method, ...)
    end

    baseDefinitionHandler(err, result, method, ...)
  end,
  ["textDocument/foldingRange"] = function(err, result, ctx, config)
    if not err and result then
      for _, r in pairs(result) do
        if r.startLine == r.endLine then
          r.kind = "region"
        end
      end
    end
    vim.lsp.handlers["textDocument/foldingRange"](err, result, ctx, config)
  end,
}

return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
  },
  config = function()
    require("typescript-tools").setup {
      -- Load the NvChad LSP config so we get those keybindings and the renamer.
      on_attach = on_attach,
      handlers = handlers,

      settings = {
        separate_diagnostic_server = true,
        -- expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused" },
        expose_as_code_action = "all",
        tsserver_file_preferences = {
          includeCompletionsForModuleExports = true,
          quotePreference = "auto",
          includeCompletionsForImportStatements = true,
          includeAutomaticOptionalChainCompletions = true,
          includeCompletionsWithClassMemberSnippets = true,
          includeCompletionsWithObjectLiteralMethodSnippets = true,
          importModuleSpecifierPreference = "shortest",
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        tsserver_format_options = {
          allowIncompleteCompletions = true,
          allowRenameOfImportPath = true,
        },
        tsserver_plugins = {
          "@styled/typescript-styled-plugin",
        },
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    }
  end,
}
