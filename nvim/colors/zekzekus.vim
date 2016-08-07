hi clear
syntax reset
let g:colors_name = "zekzekus"
if &background == "light"
    hi Boolean gui=NONE guifg=#6e6e6e guibg=NONE
    hi ColorColumn gui=NONE guifg=NONE guibg=#f0f0f0
    hi Comment gui=NONE guifg=#949494 guibg=NONE
    hi Conceal gui=NONE guifg=#6e6e6e guibg=NONE
    hi Conditional gui=NONE guifg=#474747 guibg=NONE
    hi Constant gui=NONE guifg=#6e6e6e guibg=NONE
    hi Cursor gui=reverse guifg=NONE guibg=NONE
    hi CursorColumn gui=NONE guifg=NONE guibg=#f0f0f0
    hi CursorLine gui=NONE guifg=NONE guibg=#f0f0f0
    hi CursorLineNr gui=NONE guifg=#000000 guibg=NONE
    hi DiffAdd gui=NONE guifg=NONE guibg=#d9ffd9
    hi DiffChange gui=NONE guifg=NONE guibg=#fafafa
    hi DiffDelete gui=NONE guifg=NONE guibg=#ffd9d9
    hi DiffText gui=NONE guifg=NONE guibg=#dedede
    hi Directory gui=NONE guifg=#474747 guibg=NONE
    hi Error gui=NONE guifg=NONE guibg=#ffd9d9
    hi ErrorMsg gui=NONE guifg=NONE guibg=#ffd9d9
    hi FoldColumn gui=NONE guifg=#bdbdbd guibg=NONE
    hi Folded gui=NONE guifg=#949494 guibg=NONE
    hi Ignore gui=NONE guifg=NONE guibg=NONE
    hi IncSearch gui=NONE guifg=#ff0000 guibg=#dedede
    hi LineNr gui=NONE guifg=#bdbdbd guibg=NONE
    hi MatchParen gui=NONE guifg=NONE guibg=#dedede
    hi ModeMsg gui=NONE guifg=NONE guibg=NONE
    hi MoreMsg gui=NONE guifg=NONE guibg=NONE
    hi NonText gui=NONE guifg=#bdbdbd guibg=NONE
    hi Normal gui=NONE guifg=#000000 guibg=#e6e6e6
    hi Number gui=NONE guifg=#6e6e6e guibg=NONE
    hi Pmenu gui=NONE guifg=NONE guibg=#f0f0f0
    hi PmenuSbar gui=NONE guifg=NONE guibg=#e8e8e8
    hi PmenuSel gui=NONE guifg=NONE guibg=#dedede
    hi PmenuThumb gui=NONE guifg=NONE guibg=#d6d6d6
    hi Question gui=NONE guifg=NONE guibg=NONE
    hi Search gui=standout guifg=NONE guibg=#e8e8e8
    hi SignColumn gui=NONE guifg=#bdbdbd guibg=NONE
    hi Special gui=NONE guifg=#6e6e6e guibg=NONE
    hi SpecialKey gui=NONE guifg=#bdbdbd guibg=NONE
    hi SpellBad gui=undercurl guisp=NONE guifg=NONE guibg=#ffd9d9
    hi SpellCap gui=undercurl guisp=NONE guifg=NONE guibg=NONE
    hi SpellLocal gui=undercurl guisp=NONE guifg=NONE guibg=#d9ffd9
    hi SpellRare gui=undercurl guisp=NONE guifg=NONE guibg=#e8e8e8
    hi Statement gui=NONE guifg=#474747 guibg=NONE
    hi StatusLine gui=NONE guifg=#262626 guibg=#e8e8e8
    hi StatusLineNC gui=NONE guifg=#949494 guibg=#e8e8e8
    hi StorageClass gui=NONE guifg=#474747 guibg=NONE
    hi String gui=NONE guifg=#6e6e6e guibg=NONE
    hi TabLine gui=NONE guifg=#949494 guibg=#e8e8e8
    hi TabLineFill gui=NONE guifg=NONE guibg=#e8e8e8
    hi TabLineSel gui=NONE guifg=#262626 guibg=#e8e8e8
    hi Title gui=NONE guifg=#6e6e6e guibg=NONE
    hi Todo gui=standout guifg=NONE guibg=NONE
    hi Type gui=NONE guifg=#474747 guibg=NONE
    hi Underlined gui=NONE guifg=NONE guibg=NONE
    hi VertSplit gui=NONE guifg=#dedede guibg=NONE
    hi Visual gui=NONE guifg=NONE guibg=#dedede
    hi VisualNOS gui=NONE guifg=NONE guibg=NONE
    hi WarningMsg gui=NONE guifg=NONE guibg=#ffd9d9
    hi WildMenu gui=NONE guifg=NONE guibg=#cccccc
    hi lCursor gui=NONE guifg=NONE guibg=NONE
    hi Identifier gui=NONE guifg=NONE guibg=NONE
    hi PreProc gui=NONE guifg=NONE guibg=NONE
elseif &background == "dark"
    hi Boolean gui=NONE guifg=#7d7d7d guibg=NONE
    hi ColorColumn gui=NONE guifg=NONE guibg=#1a1a1a
    hi Comment gui=NONE guifg=#6e6e6e guibg=NONE
    hi Conceal gui=NONE guifg=#7d7d7d guibg=NONE
    hi Conditional gui=NONE guifg=#8c8c8c guibg=NONE
    hi Constant gui=NONE guifg=#7d7d7d guibg=NONE
    hi Cursor gui=reverse guifg=NONE guibg=NONE
    hi CursorColumn gui=NONE guifg=NONE guibg=#1a1a1a
    hi CursorLine gui=NONE guifg=NONE guibg=#1a1a1a
    hi CursorLineNr gui=NONE guifg=#fafafa guibg=NONE
    hi DiffAdd gui=NONE guifg=NONE guibg=#003600
    hi DiffChange gui=NONE guifg=NONE guibg=#000000
    hi DiffDelete gui=NONE guifg=NONE guibg=#360000
    hi DiffText gui=NONE guifg=NONE guibg=#333333
    hi Directory gui=NONE guifg=#8c8c8c guibg=NONE
    hi Error gui=NONE guifg=NONE guibg=#360000
    hi ErrorMsg gui=NONE guifg=NONE guibg=#360000
    hi FoldColumn gui=NONE guifg=#5e5e5e guibg=NONE
    hi Folded gui=NONE guifg=#6e6e6e guibg=NONE
    hi Ignore gui=NONE guifg=NONE guibg=NONE
    hi IncSearch gui=NONE guifg=#ff0000 guibg=#333333
    hi LineNr gui=NONE guifg=#5e5e5e guibg=NONE
    hi MatchParen gui=NONE guifg=NONE guibg=#333333
    hi ModeMsg gui=NONE guifg=NONE guibg=NONE
    hi MoreMsg gui=NONE guifg=NONE guibg=NONE
    hi NonText gui=NONE guifg=#5e5e5e guibg=NONE
    hi Normal gui=NONE guifg=#ababab guibg=#212121
    hi Number gui=NONE guifg=#7d7d7d guibg=NONE
    hi Pmenu gui=NONE guifg=NONE guibg=#1a1a1a
    hi PmenuSbar gui=NONE guifg=NONE guibg=#262626
    hi PmenuSel gui=NONE guifg=NONE guibg=#333333
    hi PmenuThumb gui=NONE guifg=NONE guibg=#404040
    hi Question gui=NONE guifg=NONE guibg=NONE
    hi Search gui=standout guifg=NONE guibg=#262626
    hi SignColumn gui=NONE guifg=#5e5e5e guibg=NONE
    hi Special gui=NONE guifg=#7d7d7d guibg=NONE
    hi SpecialKey gui=NONE guifg=#5e5e5e guibg=NONE
    hi SpellBad gui=undercurl guisp=NONE guifg=NONE guibg=#360000
    hi SpellCap gui=undercurl guisp=NONE guifg=NONE guibg=NONE
    hi SpellLocal gui=undercurl guisp=NONE guifg=NONE guibg=#003600
    hi SpellRare gui=undercurl guisp=NONE guifg=NONE guibg=#262626
    hi Statement gui=NONE guifg=#8c8c8c guibg=NONE
    hi StatusLine gui=NONE guifg=#999999 guibg=#262626
    hi StatusLineNC gui=NONE guifg=#6e6e6e guibg=#262626
    hi StorageClass gui=NONE guifg=#8c8c8c guibg=NONE
    hi String gui=NONE guifg=#7d7d7d guibg=NONE
    hi TabLine gui=NONE guifg=#6e6e6e guibg=#262626
    hi TabLineFill gui=NONE guifg=NONE guibg=#262626
    hi TabLineSel gui=NONE guifg=#999999 guibg=#262626
    hi Title gui=NONE guifg=#7d7d7d guibg=NONE
    hi Todo gui=standout guifg=NONE guibg=NONE
    hi Type gui=NONE guifg=#8c8c8c guibg=NONE
    hi Underlined gui=NONE guifg=NONE guibg=NONE
    hi VertSplit gui=NONE guifg=#333333 guibg=NONE
    hi Visual gui=NONE guifg=NONE guibg=#333333
    hi VisualNOS gui=NONE guifg=NONE guibg=NONE
    hi WarningMsg gui=NONE guifg=NONE guibg=#360000
    hi WildMenu gui=NONE guifg=NONE guibg=#4f4f4f
    hi lCursor gui=NONE guifg=NONE guibg=NONE
    hi Identifier gui=NONE guifg=NONE guibg=NONE
    hi PreProc gui=NONE guifg=NONE guibg=NONE
endif
