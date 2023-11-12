set undofile

command! -bar -bang Snippets call fzf#vim#snippets({'options': '-n ..'}, <bang>0)
command! -nargs=+ -complete=file_in_path -bar        Zgrep  cgetexpr zek#grep(<f-args>)

augroup general_au
  autocmd!
  autocmd VimResized      *              :wincmd =
  autocmd ColorScheme     *              if &background == 'dark' | highlight Winbar guibg='#2C323C' | else | highlight Winbar guibg='#bdbdbd' | endif
  " autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost cgetexpr,cexpr cwindow
  autocmd TermOpen        *              setlocal nonumber norelativenumber
augroup END

autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype php setlocal ts=2 sw=2 expandtab
autocmd Filetype less setlocal ts=2 sw=2 expandtab
autocmd Filetype dart setlocal ts=2 sw=2 expandtab
autocmd Filetype yaml setlocal ts=2 sw=2 expandtab

let g:neo_tree_remove_legacy_commands = 1
let g:netrw_liststyle = 3
