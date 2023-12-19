local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {

	-- webdev stuff
	b.formatting.prettier,
	-- Use the following for faster but less configurable formatting with deno
	-- b.formatting.deno_fmt.with { extra_args = {"--no-semicolons", "--single-quote"}}, -- choosed deno for ts/js files cuz its very fast!
	-- b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

	-- Lua
	b.formatting.stylua,
	-- If you want to specify config file
	-- b.formatting.stylua.with {
	--   extra_args = { "--config-path", vim.fn.expand "~/.config/stylua.toml" },
	-- },

	-- cpp
	b.formatting.clang_format,

	-- rust
	b.formatting.rustfmt,

	-- Code actions
	b.code_actions.refactoring,
}

null_ls.setup({
	debug = true,
	sources = sources,
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
	-- you can reuse a shared lspconfig on_attach callback here
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
					-- vim.lsp.buf.formatting_sync()
          vim.sp.buf.format({ async = false })
				end,
			})
		end
	end,
})
