-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.cmd([[
    augroup systemd
        autocmd!
        autocmd BufRead,BufNewFile *.service,*.socket,*.target set filetype=systemd
    augroup END
]])
