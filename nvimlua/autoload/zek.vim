function! zek#grep(...) abort
  return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
