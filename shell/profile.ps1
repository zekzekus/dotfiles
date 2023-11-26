$env:Path += ';C:\nvim\bin'
$env:Path += ';C:\mingw64\bin'
$env:Path += ';C:\cmder\bin'
$env:Path += ';C:\ripgrep'
$env:Path += ';C:\PostgreSQL\pgsql\bin'

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine

# Smarter CD
remove-item alias:cd

function cddash { if ($args[0] -eq '-') { $pwd=$OLDPWD; } elseif (!$args[0]) { $pwd=$HOME; } else { $pwd=$args[0]; } $tmp=pwd; if ($pwd) {
Set-Location $pwd; } Set-Variable -Name OLDPWD -Value $tmp -Scope global; }

set-alias -Name cd -value cddash -Option AllScope

Function START_PGSQL {pg_ctl -D C:\PostgreSQL\pgsql\data -l logfile start}
Function STOP_PGSQL {pg_ctl -D C:\PostgreSQL\pgsql\data -l logfile stop}

set-alias -Name pgstart -Value START_PGSQL
set-alias -Name pgstop -Value STOP_PGSQL
