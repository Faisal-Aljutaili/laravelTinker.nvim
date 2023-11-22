-- ~/.config/nvim/lua/myplugin/runInTinker.lua

local M = {}

-- Function to run the content of the current Lua file in Laravel Tinker
M.runInTinker = function()
    -- Get the path of the current Lua file
    local currentFilePath = vim.fn.expand('%:p')

    -- Read the content of the file
    local file = assert(io.open(currentFilePath, "r"))
    local fileContent = file:read("*all")
    file:close()

    -- Use Laravel Tinker to execute the Lua code
    local tinkerCommand = "php artisan tinker <<EOF\n" .. fileContent .. "\nEOF"

    -- Execute the Tinker command and capture the output
    local result = vim.fn.systemlist(tinkerCommand)

    -- Create a new buffer for the result
    vim.cmd("botright new")
    vim.cmd("setlocal buftype=nofile")
    vim.cmd("setlocal bufhidden=delete")
    vim.cmd("setlocal noswapfile")
    vim.cmd("setlocal nobuflisted")
    vim.cmd("setlocal wrap")

    -- Insert the Tinker command output into the new buffer
    vim.fn.setline(1, result)

    -- Set the buffer to read-only
    vim.cmd("setlocal readonly")

    -- Switch back to the original buffer
    vim.cmd("wincmd p")
end

return M

