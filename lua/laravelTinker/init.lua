local M = {}

function M.run_laravel_tinker()
	local php_code = vim.fn.getline(".")
	local temp_file = vim.fn.tempname() .. ".php"
	vim.fn.writefile({ php_code }, temp_file)

	local command = string.format("php artisan tinker < %s", temp_file)
	local output = vim.fn.system(command)

	local float_opts = {
		relative = "cursor",
		width = math.floor(vim.fn.winwidth(0) * 0.8),
		height = math.floor(vim.fn.winheight(0) * 0.8),
		row = 1,
		col = 1,
		border = "single",
	}

	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.fn.split(output, "\n"))
	local win_id = vim.api.nvim_open_win(bufnr, true, float_opts)

	-- Set up mappings to close the window
	local close_mappings = {
		["q"] = "<Cmd>q<CR>",
		["<Esc>"] = "<Cmd>q<CR>",
	}

	for key, mapping in pairs(close_mappings) do
		vim.api.nvim_buf_set_keymap(bufnr, "n", key, mapping, { noremap = true, silent = true })
	end

	-- Clean up: delete the temporary file
	vim.fn.delete(temp_file)

	return {
		bufnr = bufnr,
		win_id = win_id,
	}
end

function M.open_tinker_nofile()
	local php_bufnr = vim.api.nvim_create_buf(true, false)

	vim.api.nvim_buf_set_option(php_bufnr, "filetype", "php")
	vim.api.nvim_buf_set_option(php_bufnr, "buftype", "nofile")
	vim.api.nvim_buf_set_option(php_bufnr, "swapfile", false)
	vim.api.nvim_buf_set_option(php_bufnr, "modifiable", true) -- Allow writing to the buffer

	vim.api.nvim_buf_set_name(php_bufnr, "tinker.php") -- Change the buffer name

	vim.api.nvim_buf_set_keymap(
		php_bufnr,
		"n",
		"<Leader>t",
		[[:lua require('laravelTinker').run_laravel_tinker()<CR>]],
		{ noremap = true, silent = true }
	)

	vim.cmd("vsp | b" .. php_bufnr)

	return php_bufnr
end

function M.open_tinker()
	local php_filename = "tinker.php"
	local php_bufnr = vim.api.nvim_create_buf(true, false)

	vim.api.nvim_buf_set_option(php_bufnr, "filetype", "php")
	vim.api.nvim_buf_set_option(php_bufnr, "buftype", "")
	vim.api.nvim_buf_set_option(php_bufnr, "swapfile", false)
	vim.api.nvim_buf_set_option(php_bufnr, "modifiable", true) -- Allow writing to the buffer

	vim.api.nvim_buf_set_name(php_bufnr, php_filename) -- Change the buffer name

	-- Set the current working directory for the buffer
	vim.api.nvim_set_current_dir(vim.fn.getcwd())

	vim.api.nvim_buf_set_option(php_bufnr, "buflisted", false)

	vim.api.nvim_buf_set_keymap(
		php_bufnr,
		"n",
		"<Leader>t",
		[[:lua require('laravelTinker').run_laravel_tinker()<CR>]],
		{ noremap = true, silent = true }
	)

	vim.cmd("vsp " .. php_filename)

	-- Attach LSP to the buffer
	vim.api.nvim_buf_attach(php_bufnr, false, {})

	return php_bufnr
end
return M
