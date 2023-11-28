local M = {}


function M.run_laravel_tinker()
    local file_path = vim.fn.expand('%:p')
    local command = string.format('php artisan tinker < %s', file_path)
    local output = vim.fn.system(command)

    local float_opts = {
        relative = 'cursor',
        width = 0.8,
        height = 0.8,
        row = 1, col = 1,
        border = 'single',
    }

    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.fn.split(output, '\n'))
    local win_id = vim.api.nvim_open_win(bufnr, true, float_opts)

    return {
        bufnr = bufnr,
        win_id = win_id,
    }
end

return M

