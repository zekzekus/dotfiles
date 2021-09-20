packadd cfilter

set undofile
colorscheme nord

command! -nargs=1 -complete=command      -bar -range Zredir call     zek#redir(<q-args>, <range>, <line1>, <line2>)
command! -nargs=+ -complete=file_in_path -bar        Zgrep  cgetexpr zek#grep(<f-args>)

augroup general_au
	autocmd!
	autocmd VimResized      *                     :wincmd =
	" autocmd ColorScheme     *                     call zek#post_colorscheme()
	autocmd CmdlineLeave    :                     call zek#autoreply()
	autocmd BufEnter        *                     lua require'completion'.on_attach()
	autocmd QuickFixCmdPost cgetexpr,cexpr        cwindow
	autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

let g:netrw_liststyle = 3
let g:vitality_fix_focus = 0
let g:fzf_preview_window = ''
let g:zek_has_replied = v:false
