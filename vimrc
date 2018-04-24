" autocommand, whenever save file ~/.vimrc, it gets automatically sourced
:au! BufWritePost $MYVIMRC source $MYVIMRC

" plugins
source ~/.vim/k/plugins.vim
source ~/.vim/k/editor.vim
source ~/.vim/k/session.vim

" vim-ansible-yaml
let g:ansible_options = {'ignore_blank_lines': 0}
let g:ansible_options = {'documentation_mapping': '<C-K>'} "ctrl-k for docs

