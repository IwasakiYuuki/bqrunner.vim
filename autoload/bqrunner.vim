fun! bqrunner#dry_run(file) abort
  let l:command = 'cat ' . a:file . ' | bq query --dry_run --use_legacy_sql=false --'
  let l:result = system(l:command)
  let w:bqrunner_is_query_success = s:is_query_success(l:result)
  if w:bqrunner_is_query_success
    let l:bytes = s:get_bytes_from_result(l:result)
    let w:bqrunner_dry_run_bytes = s:convert_bytes_unit(l:bytes)
  else
    let w:bqrunner_error_msg = s:get_error_msg_from_result(l:result)
    call setqflist([w:bqrunner_error_msg], 'r')
  endif
endf

fun! s:get_error_msg_from_result(result) abort
  if match(a:result, '\[[0-9]\+:[0-9]\+\]') != -1
    let l:ml = matchlist(a:result, '\[\([0-9]\+\):\([0-9]\+\)\]')
    return {
    \ 'filename': @%,
    \ 'lnum': l:ml[1],
    \ 'vcol': l:ml[2],
    \ 'text': a:result,
    \ 'type': 'E',
    \ 'nr': '1',
    \ }
  else
    return {
    \ 'filename': @%,
    \ 'text': a:result,
    \ 'type': 'E',
    \ 'nr': '1',
    \ }
  endif
endf

fun! s:is_query_success(result) abort
  return match(a:result, "successfully") != -1 ? 1 : 0
endf

fun! s:get_bytes_from_result(result) abort
  return matchstr(a:result, '[0-9]\+')
endf

fun! s:convert_bytes_unit(bytes) abort
  if type(a:bytes) == 1
    let l:num_bytes = str2float(a:bytes)
  else
    let l:num_bytes = a:bytes
  endif
  let l:thousand = 0
  while l:num_bytes > 1000.0
    let l:num_bytes = l:num_bytes / 1000.0
    let l:thousand += 1
  endw
  let l:units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB']
  return printf('%.2f %s', l:num_bytes, l:units[l:thousand])
endf
