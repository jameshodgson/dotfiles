set nocompatible              " Must come first because it changes other options.
set nocp
filetype off                  " required
set guifont=DejaVu\ Sans:s12

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins managed by Vundle
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/syntastic'
Plugin 'thoughtbot/vim-rspec'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-fugitive'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-endwise'
Plugin 'mxw/vim-jsx'
Plugin 'kchmck/vim-coffee-script'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'idanarye/vim-merginal'
Plugin 'fatih/vim-go'
Plugin 'shime/vim-livedown'
Plugin 'kopischke/vim-fetch'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'ngmy/vim-rubocop'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'kana/vim-vspec'
Plugin 'w0rp/ale'

" Themes
Plugin 'Sclarki/neonwave.vim'
Plugin 'limadm/vim-blues'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

syntax on

" Theme settings
set t_Co=256
set background=dark
colorscheme blues
let g:airline#extensions#tabline#enabled = 1  " Automatically displays all buffers when there's only one tab open
let g:airline_powerline_fonts = 1
let g:airline_theme='lucius'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline#extensions#syntastic#enabled = 1

" Vim Indent Colours
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg= black  ctermbg=234
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg= darkgrey ctermbg=234

" 100 char vertical line
highlight ColorColumn ctermbg=234
execute "set colorcolumn=" . join(range(120,120), ',')

" NERDTree
let NERDTreeShowHidden=1
let g:NERDTreeNodeDelimiter = "\u00a0"

" RuboCop
let g:vimrubocop_config = '~/development/sage_one_advanced/.rubocop.yml'
let g:vimrubocop_keymap = 0
let g:syntastic_ruby_checkers = ['rubocop', 'mri']

" My Yaml Helper
let g:vim_yaml_helper#always_get_root = 1
let g:vim_yaml_helper#auto_display_path = 1

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.
set incsearch                     " Show match when typing
set hlsearch                      " Highlight all search matches
set laststatus=2                  " Always show status bar
set lazyredraw                    " Dont redraw between macros
set timeoutlen=500                " Time to wait for second key press

set backspace=indent,eol,start    " Intuitive backspacing.
set foldmethod=manual

set number                        " Enable numbers
set hidden                        " Unsaved changes to buffer. :ls to see buffers. :b[n] to switch buffer
set autoindent

set wrap                          " Turn on line wrapping.

set nobackup
set noswapfile

set pastetoggle=<F2>

" last-position-jump
:au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

set mouse=a                      " Enable mouse input
set clipboard=unnamed           " Use system clipboard
noremap ; :
noremap j gj
noremap k gk
set tabstop=2                    " Global tab width.
set shiftwidth=2                 " And again, related.
set expandtab                    " Use spaces instead of tabs
set nocursorcolumn
set nocursorline
set ai
set ts=2
set softtabstop=2
highlight Cursor guifg=white guibg=black
highlight iCursor guifg=white guibg=steelblue
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkwait10

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu
set wildmode=list:longest,list:full
set complete=.,t

set showmatch "show matching brackets

" Code folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

" Map leader to ,
map , \

" VIM-Rspec
let g:rspec_command = "!bundle exec rspec -I . {spec}"
map <Leader>tf :call RunCurrentSpecFile()<CR>
map <Leader>tt :call RunNearestSpec()<CR>
map <Leader>tl :call RunLastSpec()<CR>
map <Leader>ta :call RunAllSpecs()<CR>

" Misc mappings.
nmap <leader>dd :call InsertDebugger()<CR>
nmap <silent><leader>n :NERDTreeToggle<CR>
nmap <silent><leader>f :NERDTreeFind<CR>
nmap <silent><leader>md :LivedownPreview<CR>
nmap <Leader>r :RuboCop<CR>
" Indent the entire file
nnoremap <leader>= mpggVG='pzz

" ,. and ,/ to go between buffers
nmap <leader>. :bp<enter>
nmap <leader>/ :bn<enter>

" Clear search buffer with return
noremap <CR> :nohlsearch<cr>

" CTRL + n = remove blank space at the end of lines
nnoremap <silent> <C-n> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Set file type to Ruby for common files such as ui files and Gemfiles
au BufRead,BufNewFile *.ui set filetype=ruby
au BufRead,BufNewFile *.mustache set filetype=javascript
au BufNewFile,BufRead *.ctp set filetype=html
au BufNewFile,BufRead Gemfile set filetype=ruby
au BufNewFile,BufRead Rakefile set filetype=ruby
au BufNewFile,BufRead Fudgefile set filetype=ruby

function! InsertDebugger()
  if(&filetype == 'ruby')
    :normal orequire 'pry'; binding.pry
  else
    :normal odebugger
  endif
  :normal ==
endfunction
