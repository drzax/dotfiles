if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# Anaconda
export PATH=~/miniconda3/bin:"$PATH"

# For node packages which have some compile step involving X11 (e.g. node-canvas)
export PKG_CONFIG_PATH=/usr/X11/lib/pkgconfig

# Auto-env
source /usr/local/opt/autoenv/activate.sh