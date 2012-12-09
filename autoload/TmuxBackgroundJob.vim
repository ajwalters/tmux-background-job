" ------------------------------------------------------------------------------
" Exit when your app has already been loaded (or "compatible" mode set)
if exists("g:loaded_TmuxBackgroundJob") || &cp
  finish
endif
let g:loaded_TmuxBackgroundJob= 2.0.0
let s:background_job_exec = expand("<sfile>:h") . "/../bin/background-job.sh"

function! TmuxBackgroundJob#TmuxBackgroundJob()
  let conf_file = ".tmux-background-job.conf"
  if !filereadable(conf_file)
    echo "Could not locate ./". conf_file
    return
  endif

  let menu = ["\nPlease select: "]
  let commands = []
  for line in readfile(conf_file)
    if match(line, "^window:") != -1
      let s:runner_window = substitute(line, '^window:\s*', "", "g")
    else
      call add(menu, line)
      let command = substitute(matchstr(line, '\[\(.*\)\]'), '\[\|\]', '', 'g')
      call add(commands, command)
    endif
  endfor

  " Prompt user for menu choice
  let valid_selection = 0
  while valid_selection == 0
    let menu_selection = inputlist(menu)
    if menu_selection > 0 && menu_selection <= len(commands)
      let valid_selection = 1
    endif
  endwhile

  " Filename substitution
  let s:command = <SID>SpecialCharacterSubstitution(commands[menu_selection-1])

  call RunBackgroundJob(s:command, s:runner_window)
endfunction

function! TmuxBackgroundJob#TmuxRerunBackgroundJob()
  if exists("s:command") && exists("s:runner_window")
    call <SID>RunBackgroundJob(s:command, s:runner_window)
  else
    call TmuxBackgroundJob#TmuxBackgroundJob()
  endif
endfunction

function! s:RunBackgroundJob(command, runner_window)
  " Create a window in the session
  call system("tmux new-window -dt ". a:runner_window)

  " Clear out current line and submit a:command
  let current_dir = system("pwd")
  let change_dir_cmd = "'ls ". " " . current_dir . "'"
  call system("tmux send-keys -Rt " . a:runner_window ." '". s:background_job_exec ." -w ". a:runner_window . " -c \"". a:command . "\"' C-m")
endfunction

function! s:SpecialCharacterSubstitution(command)
  let modified_command = substitute(a:command, "%F", expand("%"), "g")
  return substitute(modified_command, "%L", line("."), "g")
endfunction
