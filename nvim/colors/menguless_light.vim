" menguless.vim -- Vim color scheme.
" Author:      Zekeriya Koc (info@zeko.dev)
" Webpage:     https://github.com/zekzekus/dotfiles
" Description: A nice color scheme
" Last Change: 2020-07-01

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "menguless"

if ($TERM =~ '256' || &t_Co >= 256) || has("gui_running")
    hi Normal ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi NonText ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi Comment ctermbg=15 ctermfg=2 cterm=NONE guibg=#f8efd8 guifg=#063a38 gui=NONE
    hi Constant ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi Error ctermbg=15 ctermfg=9 cterm=NONE guibg=#f8efd8 guifg=#d33934 gui=NONE
    hi Identifier ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi Ignore ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi PreProc ctermbg=15 ctermfg=0 cterm=bold guibg=#f8efd8 guifg=#053230 gui=bold
    hi Special ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi Statement ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi String ctermbg=15 ctermfg=6 cterm=NONE guibg=#f8efd8 guifg=#2d555a gui=NONE
    hi Todo ctermbg=15 ctermfg=12 cterm=bold guibg=#f8efd8 guifg=#3b80a1 gui=bold
    hi Type ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi Underlined ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi StatusLine ctermbg=8 ctermfg=0 cterm=NONE guibg=#76929b guifg=#053230 gui=NONE
    hi StatusLineNC ctermbg=15 ctermfg=0 cterm=underline guibg=#f8efd8 guifg=#053230 gui=underline
    hi VertSplit ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi TabLine ctermbg=8 ctermfg=0 cterm=NONE guibg=#76929b guifg=#053230 gui=NONE
    hi TabLineFill ctermbg=8 ctermfg=0 cterm=NONE guibg=#76929b guifg=#053230 gui=NONE
    hi TabLineSel ctermbg=7 ctermfg=0 cterm=NONE guibg=#e6c675 guifg=#053230 gui=NONE
    hi Title ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi CursorLine ctermbg=7 ctermfg=NONE cterm=NONE guibg=#e6c675 guifg=NONE gui=NONE
    hi LineNr ctermbg=7 ctermfg=2 cterm=NONE guibg=#e6c675 guifg=#063a38 gui=NONE
    hi CursorLineNr ctermbg=15 ctermfg=10 cterm=NONE guibg=#f8efd8 guifg=#51a163 gui=NONE
    hi helpLeadBlank ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi helpNormal ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi Visual ctermbg=11 ctermfg=0 cterm=NONE guibg=#969c46 guifg=#053230 gui=NONE
    hi VisualNOS ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi Pmenu ctermbg=8 ctermfg=0 cterm=NONE guibg=#76929b guifg=#053230 gui=NONE
    hi PmenuSbar ctermbg=7 ctermfg=0 cterm=NONE guibg=#e6c675 guifg=#053230 gui=NONE
    hi PmenuSel ctermbg=12 ctermfg=0 cterm=NONE guibg=#3b80a1 guifg=#053230 gui=NONE
    hi PmenuThumb ctermbg=10 ctermfg=0 cterm=NONE guibg=#51a163 guifg=#053230 gui=NONE
    hi FoldColumn ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi Folded ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi WildMenu ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi SpecialKey ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi DiffAdd ctermbg=10 ctermfg=0 cterm=NONE guibg=#51a163 guifg=#053230 gui=NONE
    hi DiffChange ctermbg=12 ctermfg=0 cterm=NONE guibg=#3b80a1 guifg=#053230 gui=NONE
    hi DiffDelete ctermbg=9 ctermfg=0 cterm=NONE guibg=#d33934 guifg=#053230 gui=NONE
    hi DiffText ctermbg=10 ctermfg=0 cterm=NONE guibg=#51a163 guifg=#053230 gui=NONE
    hi IncSearch ctermbg=10 ctermfg=0 cterm=NONE guibg=#51a163 guifg=#053230 gui=NONE
    hi Search ctermbg=10 ctermfg=0 cterm=NONE guibg=#51a163 guifg=#053230 gui=NONE
    hi Directory ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi MatchParen ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi SpellBad ctermbg=15 ctermfg=9 cterm=underline guibg=#f8efd8 guifg=#d33934 gui=underline guisp=#d33934
    hi SpellCap ctermbg=15 ctermfg=0 cterm=underline guibg=#f8efd8 guifg=#053230 gui=underline guisp=#3b80a1
    hi SpellLocal ctermbg=15 ctermfg=0 cterm=underline guibg=#f8efd8 guifg=#053230 gui=underline guisp=#ff00ff
    hi SpellRare ctermbg=15 ctermfg=0 cterm=underline guibg=#f8efd8 guifg=#053230 gui=underline guisp=#00ffff
    hi ColorColumn ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi SignColumn ctermbg=7 ctermfg=0 cterm=NONE guibg=#e6c675 guifg=#053230 gui=NONE
    hi ErrorMsg ctermbg=9 ctermfg=0 cterm=NONE guibg=#d33934 guifg=#053230 gui=NONE
    hi ModeMsg ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi MoreMsg ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi Question ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi Cursor ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi CursorColumn ctermbg=7 ctermfg=NONE cterm=NONE guibg=#e6c675 guifg=NONE gui=NONE
    hi QuickFixLine ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi Conceal ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi ToolbarLine ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi ToolbarButton ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi debugPC ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE
    hi debugBreakpoint ctermbg=15 ctermfg=0 cterm=NONE guibg=#f8efd8 guifg=#053230 gui=NONE

elseif &t_Co == 8 || $TERM !~# '^linux' || &t_Co == 16
    set t_Co=16

    hi Normal ctermbg=white ctermfg=black cterm=NONE
    hi NonText ctermbg=white ctermfg=black cterm=NONE
    hi Comment ctermbg=white ctermfg=darkgreen cterm=NONE
    hi Constant ctermbg=white ctermfg=black cterm=NONE
    hi Error ctermbg=white ctermfg=red cterm=NONE
    hi Identifier ctermbg=white ctermfg=black cterm=NONE
    hi Ignore ctermbg=white ctermfg=black cterm=NONE
    hi PreProc ctermbg=white ctermfg=black cterm=bold
    hi Special ctermbg=white ctermfg=black cterm=NONE
    hi Statement ctermbg=white ctermfg=black cterm=NONE
    hi String ctermbg=white ctermfg=darkcyan cterm=NONE
    hi Todo ctermbg=white ctermfg=blue cterm=bold
    hi Type ctermbg=white ctermfg=black cterm=NONE
    hi Underlined ctermbg=white ctermfg=black cterm=NONE
    hi StatusLine ctermbg=darkgray ctermfg=black cterm=NONE
    hi StatusLineNC ctermbg=white ctermfg=black cterm=underline
    hi VertSplit ctermbg=white ctermfg=black cterm=NONE
    hi TabLine ctermbg=darkgray ctermfg=black cterm=NONE
    hi TabLineFill ctermbg=darkgray ctermfg=black cterm=NONE
    hi TabLineSel ctermbg=gray ctermfg=black cterm=NONE
    hi Title ctermbg=white ctermfg=black cterm=NONE
    hi CursorLine ctermbg=gray ctermfg=NONE cterm=NONE
    hi LineNr ctermbg=gray ctermfg=darkgreen cterm=NONE
    hi CursorLineNr ctermbg=white ctermfg=green cterm=NONE
    hi helpLeadBlank ctermbg=white ctermfg=black cterm=NONE
    hi helpNormal ctermbg=white ctermfg=black cterm=NONE
    hi Visual ctermbg=yellow ctermfg=black cterm=NONE
    hi VisualNOS ctermbg=white ctermfg=black cterm=NONE
    hi Pmenu ctermbg=darkgray ctermfg=black cterm=NONE
    hi PmenuSbar ctermbg=gray ctermfg=black cterm=NONE
    hi PmenuSel ctermbg=blue ctermfg=black cterm=NONE
    hi PmenuThumb ctermbg=green ctermfg=black cterm=NONE
    hi FoldColumn ctermbg=white ctermfg=black cterm=NONE
    hi Folded ctermbg=white ctermfg=black cterm=NONE
    hi WildMenu ctermbg=white ctermfg=black cterm=NONE
    hi SpecialKey ctermbg=white ctermfg=black cterm=NONE
    hi DiffAdd ctermbg=green ctermfg=black cterm=NONE
    hi DiffChange ctermbg=blue ctermfg=black cterm=NONE
    hi DiffDelete ctermbg=red ctermfg=black cterm=NONE
    hi DiffText ctermbg=green ctermfg=black cterm=NONE
    hi IncSearch ctermbg=green ctermfg=black cterm=NONE
    hi Search ctermbg=green ctermfg=black cterm=NONE
    hi Directory ctermbg=white ctermfg=black cterm=NONE
    hi MatchParen ctermbg=white ctermfg=black cterm=NONE
    hi SpellBad ctermbg=white ctermfg=red cterm=underline
    hi SpellCap ctermbg=white ctermfg=black cterm=underline
    hi SpellLocal ctermbg=white ctermfg=black cterm=underline
    hi SpellRare ctermbg=white ctermfg=black cterm=underline
    hi ColorColumn ctermbg=white ctermfg=black cterm=NONE
    hi SignColumn ctermbg=gray ctermfg=black cterm=NONE
    hi ErrorMsg ctermbg=red ctermfg=black cterm=NONE
    hi ModeMsg ctermbg=white ctermfg=black cterm=NONE
    hi MoreMsg ctermbg=white ctermfg=black cterm=NONE
    hi Question ctermbg=white ctermfg=black cterm=NONE
    hi Cursor ctermbg=white ctermfg=black cterm=NONE
    hi CursorColumn ctermbg=gray ctermfg=NONE cterm=NONE
    hi QuickFixLine ctermbg=white ctermfg=black cterm=NONE
    hi Conceal ctermbg=white ctermfg=black cterm=NONE
    hi ToolbarLine ctermbg=white ctermfg=black cterm=NONE
    hi ToolbarButton ctermbg=white ctermfg=black cterm=NONE
    hi debugPC ctermbg=white ctermfg=black cterm=NONE
    hi debugBreakpoint ctermbg=white ctermfg=black cterm=NONE
endif

hi link EndOfBuffer NonText
hi link Number Constant
hi link StatusLineTerm StatusLine
hi link StatusLineTermNC StatusLineNC
hi link WarningMsg Error
hi link CursorIM Cursor
hi link Terminal Normal
hi link diffAdded DiffAdd
hi link diffRemoved DiffDelete
hi link clojureParen Comment

let g:terminal_ansi_colors = [
        \ '#000000',
        \ '#800000',
        \ '#008000',
        \ '#808000',
        \ '#000080',
        \ '#800080',
        \ '#008080',
        \ '#c0c0c0',
        \ '#808080',
        \ '#d33934',
        \ '#51a163',
        \ '#969c46',
        \ '#3b80a1',
        \ '#ff00ff',
        \ '#00ffff',
        \ '#ffffff',
        \ ]

" Generated with RNB (https://github.com/romainl/vim-rnb)
