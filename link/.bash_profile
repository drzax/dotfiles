if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# Anaconda
export PATH=~/miniconda3/bin:"$PATH"

# Auto-env
source /usr/local/opt/autoenv/activate.sh