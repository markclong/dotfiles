" Leader
let mapleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set wrap
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

let g:indent_guides_enable_on_vim_startup = 1

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  au BufRead,BufNewFile *.psql setfiletype sql
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  "set grepprg=ag\ --nogroup\ --nocolor\ --mmap
  "let g:ackprg = 'ag --vimgrep'

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  "let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  "if !exists(":Agc")
  "  command -nargs=+ -complete=file -bar Agc silent! grep! <args>|cwindow|redraw!
  "  nnoremap \ :Agc<SPACE>
  "endif
  nnoremap \ :Ag<CR>
  nnoremap <C-\> :FZF<CR>
endif
nnoremap <C-t> :Buffers<CR>
let g:fzf_layout = { 'down': '~20%' }

" Make it obvious where 80 characters is
" set textwidth=120
"set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1


" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Switch between the last two files
"nnoremap <leader><leader> <c-^>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <leader>gt :TestVisit<CR>
let test#strategy = 'vimux'
let test#ruby#rspec#options = {
  \ 'nearest': '--format documentation',
  \ 'file':    '--format documentation',
  \ 'suite':   '--tag ~slow',
\}

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" linter settings
let g:ale_sign_column_always = 1
let g:ale_sign_error = '⨉'
let g:ale_sign_warning = '!'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_linters = {'cs': ['OmniSharp']}



" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

"autocmd vimenter * NERDTree
map <silent> <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" Open NERDTree if nothing specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

nmap ,n :NERDTreeFind<CR>

" appearance
syntax enable
set background=dark
colorscheme jellybeans
let g:NERDTreeStatusline="%{getcwd()}"

if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    " share osx clipboard
    set clipboard=unnamed
  endif
endif

" tab completion
set wildmode=longest,list,full
set wildmenu

" autocompletion
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
let g:rubycomplete_use_bundler = 1
inoremap <Nul> <C-x><C-o>

" yank buffer path
noremap <Leader>% :let @+ = expand("%")<CR>

" rubocop
let g:syntastic_ruby_checkers = ['rubocop']

" keybinds
map <silent> <F3> :Gblame<CR>
nnoremap <F5> :buffers<CR>:buffer<Space>
nmap <F8> :TagbarToggle<CR>
map <F7> :e<CR> " Reload

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

" Enable mouse support
set mouse=a

" Some Python stuff
hi pythonSelf  ctermfg=68  guifg=#5f87d7 cterm=bold gui=bold

au BufNewFile,BufRead *.py
\ set tabstop=4
\ | set softtabstop=4
\ | set shiftwidth=4
\ | set textwidth=79
\ | set expandtab
\ | set autoindent
\ | set fileformat=unix


let python_highlight_all=1
syntax on


" Some C# stuff
let g:OmniSharp_selector_ui = 'fzf'    " Use fzf.vim
" :set tags^=./.git/tags;

" More resizey
noremap <C-w>+ :resize +5<CR>
noremap <C-w>- :resize -5<CR>
noremap <C-w>< :vertical:resize -5<CR>
noremap <C-w>> :vertical:resize +5<CR>

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" Fix for put multiple times
xnoremap p pgvy

" // to find the highlighted text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
" ctrl-r to find and replace highlighted text  with confirmation
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Kotlin
autocmd BufNewFile,BufRead *.kt setfiletype kotlin
autocmd BufNewFile,BufRead *.kts setfiletype kotlin
