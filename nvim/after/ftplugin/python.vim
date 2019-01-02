if !empty($VIRTUAL_ENV)
  let g:python_executable = $VIRTUAL_ENV . '/bin/python'
  unlet g:python_path
  runtime! after/ftplugin/python_apathy.vim
endif
