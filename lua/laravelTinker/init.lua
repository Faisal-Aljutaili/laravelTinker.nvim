local M = {}

function M.run_laravel_tinker()
	local file_path = vim.fn.expand("%:p")
	local command = string.format("php artisan tinker < %s", file_path)
	local output = vim.fn.system(command)

	local float_opts = {
		relative = "cursor",
		width = math.floor(vim.fn.winwidth(0) * 0.8), -- Use 80% of the current window width
		height = math.floor(vim.fn.winheight(0) * 0.8), -- Use 80% of the current window height
		row = 1,
		col = 1,
		border = "single",
	}

	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.fn.split(output, "\n"))
	local win_id = vim.api.nvim_open_win(bufnr, true, float_opts)

	return {
		bufnr = bufnr,
		win_id = win_id,
	}
end

function M.open_tinker()
    local php_bufnr = vim.api.nvim_create_buf(true, false)

    vim.api.nvim_buf_set_option(php_bufnr, 'filetype', 'php')

    vim.api.nvim_buf_set_name(php_bufnr, 'untitled.php')

    vim.api.nvim_buf_set_keymap(php_bufnr, 'n', '<Leader>t', [[:lua require('laravelTinker').run_laravel_tinker()<CR>]], { noremap = true, silent = true })

    vim.cmd('vsp | b' .. php_bufnr)

    return php_bufnr
end

return M
