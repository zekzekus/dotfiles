packadd cfilter

set undofile
colorscheme neobones

command! -nargs=1 -complete=command      -bar -range Zredir call     zek#redir(<q-args>, <range>, <line1>, <line2>)
command! -nargs=+ -complete=file_in_path -bar        Zgrep  cgetexpr zek#grep(<f-args>)

augroup general_au
    autocmd!
    autocmd VimResized      *              :wincmd =
    " autocmd CmdlineLeave    :              call zek#autoreply()
    autocmd QuickFixCmdPost cgetexpr,cexpr cwindow
    autocmd TermOpen        *              setlocal nonumber norelativenumber
    autocmd FileType        scala,sbt      lua require("config.nvim-metals").initialize_metals()
augroup END

let g:netrw_liststyle = 3
let g:zek_has_replied = v:false
let g:neo_tree_remove_legacy_commands = 1

highlight Winbar guibg='#2C323C'
