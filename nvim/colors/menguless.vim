" menguless.vim -- Vim color scheme.
" Author:      Zekeriya Koc (info@zeko.dev)
" Webpage:     https://github.com/zekzekus/dotfiles
" Description: A nice color scheme
" Last Change: 2020-06-30

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "menguless"

if ($TERM =~ '256' || &t_Co >= 256) || has("gui_running")
    hi Normal ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi NonText ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Comment ctermbg=0 ctermfg=7 cterm=NONE guibg=#053230 guifg=#5b7a80 gui=NONE
    hi Constant ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Error ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Identifier ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Ignore ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi PreProc ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Special ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Statement ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi String ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Todo ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Type ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Underlined ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi StatusLine ctermbg=6 ctermfg=15 cterm=NONE guibg=#2d555a guifg=#f8efd8 gui=NONE
    hi StatusLineNC ctermbg=0 ctermfg=15 cterm=underline guibg=#053230 guifg=#f8efd8 gui=underline
    hi VertSplit ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi TabLine ctermbg=6 ctermfg=15 cterm=NONE guibg=#2d555a guifg=#f8efd8 gui=NONE
    hi TabLineFill ctermbg=6 ctermfg=15 cterm=NONE guibg=#2d555a guifg=#f8efd8 gui=NONE
    hi TabLineSel ctermbg=2 ctermfg=15 cterm=NONE guibg=#063a38 guifg=#f8efd8 gui=NONE
    hi Title ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi CursorLine ctermbg=2 ctermfg=NONE cterm=NONE guibg=#063a38 guifg=NONE gui=NONE
    hi LineNr ctermbg=6 ctermfg=15 cterm=NONE guibg=#2d555a guifg=#f8efd8 gui=NONE
    hi CursorLineNr ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi helpLeadBlank ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi helpNormal ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Visual ctermbg=11 ctermfg=15 cterm=NONE guibg=#969c46 guifg=#f8efd8 gui=NONE
    hi VisualNOS ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Pmenu ctermbg=6 ctermfg=15 cterm=NONE guibg=#2d555a guifg=#f8efd8 gui=NONE
    hi PmenuSbar ctermbg=2 ctermfg=15 cterm=NONE guibg=#063a38 guifg=#f8efd8 gui=NONE
    hi PmenuSel ctermbg=12 ctermfg=15 cterm=NONE guibg=#3b80a1 guifg=#f8efd8 gui=NONE
    hi PmenuThumb ctermbg=10 ctermfg=15 cterm=NONE guibg=#51a163 guifg=#f8efd8 gui=NONE
    hi FoldColumn ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Folded ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi WildMenu ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi SpecialKey ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi DiffAdd ctermbg=10 ctermfg=15 cterm=NONE guibg=#51a163 guifg=#f8efd8 gui=NONE
    hi DiffChange ctermbg=12 ctermfg=15 cterm=NONE guibg=#3b80a1 guifg=#f8efd8 gui=NONE
    hi DiffDelete ctermbg=9 ctermfg=15 cterm=NONE guibg=#d33934 guifg=#f8efd8 gui=NONE
    hi DiffText ctermbg=10 ctermfg=15 cterm=NONE guibg=#51a163 guifg=#f8efd8 gui=NONE
    hi IncSearch ctermbg=10 ctermfg=15 cterm=NONE guibg=#51a163 guifg=#f8efd8 gui=NONE
    hi Search ctermbg=10 ctermfg=15 cterm=NONE guibg=#51a163 guifg=#f8efd8 gui=NONE
    hi Directory ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi MatchParen ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi SpellBad ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE guisp=#d33934
    hi SpellCap ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE guisp=#3b80a1
    hi SpellLocal ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE guisp=#ff00ff
    hi SpellRare ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE guisp=#00ffff
    hi ColorColumn ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi SignColumn ctermbg=2 ctermfg=15 cterm=NONE guibg=#063a38 guifg=#f8efd8 gui=NONE
    hi ErrorMsg ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi ModeMsg ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi MoreMsg ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Question ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Cursor ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi CursorColumn ctermbg=2 ctermfg=NONE cterm=NONE guibg=#063a38 guifg=NONE gui=NONE
    hi QuickFixLine ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi Conceal ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi ToolbarLine ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi ToolbarButton ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi debugPC ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE
    hi debugBreakpoint ctermbg=0 ctermfg=15 cterm=NONE guibg=#053230 guifg=#f8efd8 gui=NONE

elseif &t_Co == 8 || $TERM !~# '^linux' || &t_Co == 16
    set t_Co=16

    hi Normal ctermbg=black ctermfg=white cterm=NONE
    hi NonText ctermbg=black ctermfg=white cterm=NONE
    hi Comment ctermbg=black ctermfg=gray cterm=NONE
    hi Constant ctermbg=black ctermfg=white cterm=NONE
    hi Error ctermbg=black ctermfg=white cterm=NONE
    hi Identifier ctermbg=black ctermfg=white cterm=NONE
    hi Ignore ctermbg=black ctermfg=white cterm=NONE
    hi PreProc ctermbg=black ctermfg=white cterm=NONE
    hi Special ctermbg=black ctermfg=white cterm=NONE
    hi Statement ctermbg=black ctermfg=white cterm=NONE
    hi String ctermbg=black ctermfg=white cterm=NONE
    hi Todo ctermbg=black ctermfg=white cterm=NONE
    hi Type ctermbg=black ctermfg=white cterm=NONE
    hi Underlined ctermbg=black ctermfg=white cterm=NONE
    hi StatusLine ctermbg=darkcyan ctermfg=white cterm=NONE
    hi StatusLineNC ctermbg=black ctermfg=white cterm=underline
    hi VertSplit ctermbg=black ctermfg=white cterm=NONE
    hi TabLine ctermbg=darkcyan ctermfg=white cterm=NONE
    hi TabLineFill ctermbg=darkcyan ctermfg=white cterm=NONE
    hi TabLineSel ctermbg=darkgreen ctermfg=white cterm=NONE
    hi Title ctermbg=black ctermfg=white cterm=NONE
    hi CursorLine ctermbg=darkgreen ctermfg=NONE cterm=NONE
    hi LineNr ctermbg=darkcyan ctermfg=white cterm=NONE
    hi CursorLineNr ctermbg=black ctermfg=white cterm=NONE
    hi helpLeadBlank ctermbg=black ctermfg=white cterm=NONE
    hi helpNormal ctermbg=black ctermfg=white cterm=NONE
    hi Visual ctermbg=yellow ctermfg=white cterm=NONE
    hi VisualNOS ctermbg=black ctermfg=white cterm=NONE
    hi Pmenu ctermbg=darkcyan ctermfg=white cterm=NONE
    hi PmenuSbar ctermbg=darkgreen ctermfg=white cterm=NONE
    hi PmenuSel ctermbg=blue ctermfg=white cterm=NONE
    hi PmenuThumb ctermbg=green ctermfg=white cterm=NONE
    hi FoldColumn ctermbg=black ctermfg=white cterm=NONE
    hi Folded ctermbg=black ctermfg=white cterm=NONE
    hi WildMenu ctermbg=black ctermfg=white cterm=NONE
    hi SpecialKey ctermbg=black ctermfg=white cterm=NONE
    hi DiffAdd ctermbg=green ctermfg=white cterm=NONE
    hi DiffChange ctermbg=blue ctermfg=white cterm=NONE
    hi DiffDelete ctermbg=red ctermfg=white cterm=NONE
    hi DiffText ctermbg=green ctermfg=white cterm=NONE
    hi IncSearch ctermbg=green ctermfg=white cterm=NONE
    hi Search ctermbg=green ctermfg=white cterm=NONE
    hi Directory ctermbg=black ctermfg=white cterm=NONE
    hi MatchParen ctermbg=black ctermfg=white cterm=NONE
    hi SpellBad ctermbg=black ctermfg=white cterm=NONE
    hi SpellCap ctermbg=black ctermfg=white cterm=NONE
    hi SpellLocal ctermbg=black ctermfg=white cterm=NONE
    hi SpellRare ctermbg=black ctermfg=white cterm=NONE
    hi ColorColumn ctermbg=black ctermfg=white cterm=NONE
    hi SignColumn ctermbg=darkgreen ctermfg=white cterm=NONE
    hi ErrorMsg ctermbg=black ctermfg=white cterm=NONE
    hi ModeMsg ctermbg=black ctermfg=white cterm=NONE
    hi MoreMsg ctermbg=black ctermfg=white cterm=NONE
    hi Question ctermbg=black ctermfg=white cterm=NONE
    hi Cursor ctermbg=black ctermfg=white cterm=NONE
    hi CursorColumn ctermbg=darkgreen ctermfg=NONE cterm=NONE
    hi QuickFixLine ctermbg=black ctermfg=white cterm=NONE
    hi Conceal ctermbg=black ctermfg=white cterm=NONE
    hi ToolbarLine ctermbg=black ctermfg=white cterm=NONE
    hi ToolbarButton ctermbg=black ctermfg=white cterm=NONE
    hi debugPC ctermbg=black ctermfg=white cterm=NONE
    hi debugBreakpoint ctermbg=black ctermfg=white cterm=NONE
endif

hi link EndOfBuffer NonText
hi link Number Constant
hi link StatusLineTerm StatusLine
hi link StatusLineTermNC StatusLineNC
hi link WarningMsg Error
hi link CursorIM Cursor
hi link Terminal Normal

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
