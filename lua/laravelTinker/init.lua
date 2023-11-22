
vim.cmd[[set runtimepath+=~/.config/nvim]]

vim.api.nvim_command("command! RunInTinker lua require('myplugin.runInTinker').runInTinker()")

