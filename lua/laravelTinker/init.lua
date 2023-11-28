local M = {}

function M.run_laravel_tinker()
	local php_code = vim.fn.getline(".") -- Get the current line

	-- Use a temporary file path
	local temp_file = vim.fn.tempname() .. ".php"

	-- Write the PHP code to the temporary file
	vim.fn.writefile({ php_code }, temp_file)

	-- Run Laravel Tinker with the temporary file
	local command = string.format("php artisan tinker < %s", temp_file)
	local output = vim.fn.system(command)

	-- Display the output in a floating window
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
	vim.api.nvim_exec(
		[[
        augroup LaravelTinkerFloat
            autocmd!
            autocmd WinEnter <buffer> nnoremap <silent> q :q<CR>
            autocmd WinEnter <buffer> nnoremap <silent> <Esc> :q<CR>
        augroup END
    ]],
		false
	)
	-- Clean up: delete the temporary file
	vim.fn.delete(temp_file)

	return {
		bufnr = bufnr,
		win_id = win_id,
	}
end

function M.open_tinker()
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

return M
