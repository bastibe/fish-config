set PATH ~/miniconda3/bin $PATH
source ~/.config/fish/conda.fish

alias emacs /usr/local/bin/emacs
alias magit "emacs -nw --eval \"(magit-status \\\".\\\")\""

set -gx EDITOR /usr/local/bin/emacs

# FIXME: These don't work here, so I put them in
#        functions/fish_prompt.fish as well
bind \ep history-search-backward
bind \en history-search-forward