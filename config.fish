set MINICONDAPATH ~/.miniconda3
set PATH $MINICONDAPATH/bin $PATH
source ~/.config/fish/conda.fish

alias emacs /usr/bin/emacs
alias magit "emacs -nw --eval \"(magit-status \\\".\\\")\""

set -gx EDITOR "/usr/bin/emacsclient --alternate-editor=/usr/bin/emacs"
set -gx ALTERNATE_EDITOR /usr/bin/emacs

# FIXME: These don't work here, so I put them in
#        functions/fish_prompt.fish as well
bind \ep history-search-backward
bind \en history-search-forward