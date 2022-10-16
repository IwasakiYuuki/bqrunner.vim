if exists('g:bqrunner_loaded')
  finish
endif
let g:bqrunner_loaded = 1
let w:bqrunner_is_query_success = -1
let w:bqrunner_dry_run_bytes = ''
let w:bqrunner_error_msg = ''

command! DryRun call bqrunner#dry_run(@%)
augroup bqrunner_dryrun
  autocmd!
  autocmd BufRead,BufWritePost *.bq DryRun
augroup END
