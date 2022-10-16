" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'bqrunner_loaded', 0)
  finish
endif

let s:spc = g:airline_symbols.space

" First we define an init function that will be invoked from extensions.vim
function! airline#extensions#bqrunner#init(ext)

  " Here we define a new part for the plugin.  This allows users to place this
  " extension in arbitrary locations.
  call airline#parts#define_raw('dryrun', '%{airline#extensions#bqrunner#get_dryrun_status()}')

  " Next up we add a funcref so that we can run some code prior to the
  " statusline getting modifed.
  call a:ext.add_statusline_func('airline#extensions#bqrunner#apply')

  " You can also add a funcref for inactive statuslines.
  " call a:ext.add_inactive_statusline_func('airline#extensions#example#unapply')
endfunction

" This function will be invoked just prior to the statusline getting modified.
function! airline#extensions#bqrunner#apply(...)
  " First we check for the filetype.

  " Let's say we want to append to section_c, first we check if there's
  " already a window-local override, and if not, create it off of the global
  " section_c.
  let w:airline_section_x = get(w:, 'airline_section_x', g:airline_section_x)

  " Then we just append this extenion to it, optionally using separators.
  let w:airline_section_x = '%{airline#extensions#bqrunner#get_dryrun_status()}' . s:spc.g:airline_right_alt_sep.s:spc . w:airline_section_x
endfunction

" Finally, this function will be invoked from the statusline.
function! airline#extensions#bqrunner#get_dryrun_status()
  let l:is_query_success = get(w:, 'bqrunner_is_query_success', -1)
  if l:is_query_success == 1
    return "\<Char-0xf058>  " . get(w:, 'bqrunner_dry_run_bytes', '')
  elseif l:is_query_success == 0
    return "\<Char-0xf071>  "
  else
    return ""
  endif
endfunction
