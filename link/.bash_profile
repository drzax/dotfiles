# scmpuff https://mroth.github.io/scmpuff/
# This is before dotfiles sources so that source/50_vcs.sh can still override
# some git commands
eval "$(scmpuff init -s)"

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# For node packages which have some compile step involving X11 (e.g. node-canvas)
export PKG_CONFIG_PATH=/usr/X11/lib/pkgconfig

# CUDA for RNN stuff see: http://docs.nvidia.com/cuda/cuda-getting-started-guide-for-mac-os-x/index.html#axzz439EjHtLB
export PATH=/Developer/NVIDIA/CUDA-7.0/bin:$PATH
export DYLD_LIBRARY_PATH=/Developer/NVIDIA/CUDA-7.0/lib:$DYLD_LIBRARY_PATH

eval "$(direnv hook bash)"
