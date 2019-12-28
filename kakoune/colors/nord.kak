# Nord

evaluate-commands %sh{
	nord0='rgb:2E3440'
	nord1='rgb:3B4252'
	nord2='rgb:434C5E'
	nord3='rgb:4C566A'
	nord4='rgb:D8DEE9'
	nord5='rgb:E5E9F0'
	nord6='rgb:ECEFF4'
	nord7='rgb:8FBCBB'
	nord8='rgb:88C0D0'
	nord9='rgb:81A1C1'
	nord10='rgb:5E81AC'
	nord11='rgb:BF616A'
	nord12='rgb:D08770'
	nord13='rgb:EBCB8B'
	nord14='rgb:A3BE8C'
	nord15='rgb:B48EAD'

   echo "
        # code
        face global value              ${nord15}
        face global type               ${nord6}
        face global variable           ${nord6}
        face global module             ${nord6}
        face global function           ${nord9}
        face global string             ${nord14}
        face global keyword            ${nord9}
        face global operator           ${nord9}
        face global attribute          ${nord6}
        face global comment            ${nord3}
        face global meta               ${nord7}
        face global builtin            default+b

        # markup
        face global title              ${nord4}+b
        face global header             ${nord4}
        face global bold               ${nord4}+b
        face global italic             ${nord4}+i
        face global mono               ${nord4}
        face global block              ${nord4}
        face global link               ${nord10}
        face global bullet             ${nord15}
        face global list               ${nord4}

        # builtin
        face global Default            ${nord4},${nord0}
        face global PrimarySelection   ${nord8},${nord1}
        face global SecondarySelection ${nord9},${nord10}
        face global PrimaryCursor      ${nord1},${nord4}
        face global SecondaryCursor    ${nord10},${nord4}
        face global PrimaryCursorEol   ${nord7},${nord7}
        face global SecondaryCursorEol ${nord11},${nord7}
        face global LineNumbers        ${nord3},${nord0}
        face global LineNumberCursor   ${nord10},${nord1}
        face global LineNumbersWrapped ${nord10},${nord1}
        face global MenuForeground     ${nord4},${nord1}
        face global MenuBackground     ${nord4},${nord1}
        face global MenuInfo           ${nord1}
        face global Information        ${nord4},${nord1}
        face global Error              ${nord11},default+b
        face global StatusLine         ${nord4},${nord0}+b
        face global StatusLineMode     ${nord13}
        face global StatusLineInfo     ${nord8}
        face global StatusLineValue    ${nord12}
        face global StatusCursor       ${nord4},${nord1}
        face global Prompt             ${nord4}+b
        face global MatchingChar       ${nord4},${nord1}+b
        face global BufferPadding      ${nord11},${nord0}
    "
}
