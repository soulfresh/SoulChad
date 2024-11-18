local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local utils = require("utils")

local lspconfig = require("lspconfig")

-- TODO Maybe use lsp-zero instead of this. I'm not sure how well that will play
-- with NvChad though.
-- https://lsp-zero.netlify.app/v4.x/tutorial.html#complete-code
local servers = utils.loadLanguageConfigs({ "cpp", "js" }, { "lspconfig", "servers" })

-- lsps with default config
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		on_init = on_init,
		capabilities = capabilities,
	})
end

-- If you need to customize specific servers you could do something like the
-- following:
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }

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
