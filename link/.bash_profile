
# Homebrew sbin path
export PATH="/usr/local/sbin:$PATH"

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# For node packages which have some compile step involving X11 (e.g. node-canvas)
export PKG_CONFIG_PATH=/usr/X11/lib/pkgconfig

# CUDA for RNN stuff see: http://docs.nvidia.com/cuda/cuda-getting-started-guide-for-mac-os-x/index.html#axzz439EjHtLB
export PATH=/Developer/NVIDIA/CUDA-7.0/bin:$PATH
export DYLD_LIBRARY_PATH=/Developer/NVIDIA/CUDA-7.0/lib:$DYLD_LIBRARY_PATH

eval "$(direnv hook bash)"

# Key bindings, up/down arrow searches through history
# https://stackoverflow.com/questions/41780746/searching-your-command-history-on-macos-terminal
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

# Make GPG work...I don't know why this is necessary
export GPG_TTY=$(tty)