# Fish Shell Configuration

# Set up PATH
set -gx PATH $HOME/.local/bin $PATH

# FZF integration
# fzf is built from source and symlinked to ~/.local/bin
if command -v fzf &>/dev/null
    source ~/.local/src/fzf/shell/key-bindings.fish
    fzf_key_bindings
    source ~/.local/src/fzf/shell/completion.fish
end

# Tmux auto-start
# Start tmux if available and not already running
if command -v tmux &>/dev/null
    and test -z "$TMUX"
    and test "$TERM" != "screen"
    exec tmux
end
