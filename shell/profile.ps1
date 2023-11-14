$env:Path += ';C:\nvim\bin'
$env:Path += ';C:\mingw64\bin'
$env:Path += ';C:\cmder\bin'
$env:Path += ';C:\ripgrep'

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine

# Smarter CD
remove-item alias:cd

function cddash { if ($args[0] -eq '-') { $pwd=$OLDPWD; } elseif (!$args[0]) { $pwd=$HOME; } else { $pwd=$args[0]; } $tmp=pwd; if ($pwd) {
Set-Location $pwd; } Set-Variable -Name OLDPWD -Value $tmp -Scope global; }

set-alias -Name cd -value cddash -Option AllScope