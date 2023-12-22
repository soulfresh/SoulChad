local present, nvim_dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if not present then
	vim.print("Failed to load nvim-dap-virtual-text")
	return
end

nvim_dap_virtual_text.setup({
	enabled = true,
	-- create commands DapVirtualTextEnable, DapVirtualTextDisable,
	-- DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug
	-- adapter did not notify its termination)
	enabled_commands = true,
	-- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
	highlight_changed_variables = true,
	-- highlight new variables in the same way as changed variables (if highlight_changed_variables)
	highlight_new_as_changed = false,
	-- show stop reason when stopped for exceptions
	show_stop_reason = true,
	-- prefix virtual text with comment string
	commented = true,
	-- only show virtual text at first definition (if there are multiple)
	only_first_definition = true,
	-- show virtual text on all all references of the variable (not only definitions)
	all_references = false,
	-- clear virtual text on "continue" (might cause flickering when stepping)
	clear_on_continue = false,

	display_callback = function(variable, buf, stackframe, node, options)
		if options.virt_text_pos == "inline" then
			return " = " .. variable.value
		else
			return variable.name .. " = " .. variable.value
		end
	end,

	virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

	all_frames = false,
	virt_lines = false,
	virt_text_win_col = nil,
})
