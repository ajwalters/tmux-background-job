#!/bin/sh

while getopts ":w:c:" option; do
  case $option in
    w)
      window=$OPTARG
      ;;
    c)
      command=$OPTARG
  esac
done

# # Rename the window in case this was a new window
# tmux rename-window -t$spec_window_index $spec_window_name

# Set color to white to reset
tmux set-window-option -t$window window-status-fg white

# Run the spec
if ! eval $command; then
  # Show the error in the main pane
  tmux join-pane -s$window -h
  tmux display-message "FAIL"
else
  # Color the window green to signify the spec passed
  tmux set-window-option -t$window window-status-fg green
  tmux display-message "PASS"
fi
