# neovim-laravel-tinker

A Neovim plugin for running Laravel Tinker in a floating window.

## Features

- Run Laravel Tinker on the content of the current file.
- Display the output in a floating window.
- Create a new unsavable buffer with a `.php` extension for ad-hoc PHP code execution.

## Installation

Install using your favorite plugin manager. For example, using Lazy:

    {"Faisal-Aljutaili/laravelTinker.nvim"}
    

## Usage

### Run Laravel Tinker
To run the content of the current file run:
```command
:lua require('laravelTinker').run_laravel_tinker()
```

to open a tinker buffer run the command:
```command
:lua require('laravelTinker').open_tinker()
```
then to run the buffer press:
```<leader>t```
or run the previous command to run the content of the file.
but this command will show an error "no write since last change on tinker.php",
if you don't want this error you can use this command to run a nofile buffer:
```command
:lua require('laravelTinker').open_tinker_nofile()
```
*but this nofile buffer will not work with LSPs*
