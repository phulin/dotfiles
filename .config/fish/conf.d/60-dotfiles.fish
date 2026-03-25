if status is-interactive
  set -gx PATH /opt/homebrew/bin $PATH
  fish_vi_key_bindings
  fish_config theme choose Dracula
end
