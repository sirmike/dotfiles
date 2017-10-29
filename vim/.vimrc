call plug#begin('~/.vim/plugged')
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'w0rp/ale'
  Plug 'rizzatti/dash.vim'
  Plug 'rust-lang/rust.vim'
  Plug 'wellle/targets.vim'
  Plug 'jgdavey/tslime.vim'
  Plug 'Quramy/tsuquyomi'
  Plug 'leafgarland/typescript-vim'
  Plug 'kchmck/vim-coffee-script'
  Plug 'altercation/vim-colors-solarized'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-haml'
  Plug 'elzr/vim-json'
  Plug 'tpope/vim-repeat'
  Plug 'thoughtbot/vim-rspec'
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-surround'
  Plug 'nelstrom/vim-textobj-rubyblock'
  Plug 'kana/vim-textobj-user'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'cespare/vim-toml'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-vinegar'
  Plug 'jremmen/vim-ripgrep'
call plug#end()

runtime macros/matchit.vim

set shell=$SHELL
set vb
set ruler
set nobackup
set number
set numberwidth=3
set mouse=a
set ignorecase
set smartcase
set noswapfile
set splitbelow
set splitright
set hlsearch
set backspace=indent,eol,start
set ttimeoutlen=10
set laststatus=2
set cmdheight=1
set list
set diffopt+=vertical

syntax on
set background=dark
colorscheme solarized
let g:EasyMotion_leader_key = '<Leader>'

let g:rspec_command='Dispatch bin/rspec {spec}'

let g:syntastic_rust_checkers = ['cargo']
let g:syntastic_always_populate_loc_list = 1
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.

filetype plugin indent on
set shiftwidth=2 tabstop=2 expandtab

function! FormatXmlFast()
  :silent! %s/&lt;/</g
  :silent! %s/&gt;/>/g
  :silent! %s/&quot;/"/g
  :silent! %s/&amp;amp;/\&/g
  :silent! %s/&amp;/\&/g
  :silent! %s/>[ ]*</></g
  :silent! %s/></>\r</g
  set filetype=xml
  :normal gg=G
endfunction

function! FormatXmlFromClipboard()
  :normal "*p
  :call FormatXmlFast()
endfunction

function! FormatRubyHashFromClipboard()
  :normal "*p
  :silent! %!ruby_hash.rb
endfunction

function! FormatJsonFromClipboard()
  :normal "*p
  :silent! %!python -m json.tool
  set filetype=json
endfunction

function! FormatJSON()
  set filetype=json
  :silent! %!python -m json.tool
endfunction

function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

function! DispatchLastSpecsInSeparateWindow()
  let old_rspec_command = g:rspec_command
  let g:rspec_command='Start bin/rspec {spec}'
  call RunLastSpec()
  let g:rspec_command = old_rspec_command
endfunction

" mappings to easily manage vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>rv :source $MYVIMRC<CR>

" global non-leader mappings
inoremap jk <esc>
nnoremap <F9> :call FormatXmlFast()<CR>
nnoremap <F3> :silent! !`/usr/local/bin/brew --prefix`/bin/ctags -R *<CR> :redraw!<CR>
nnoremap <C-f> :Rg 
nnoremap <C-b> :Buffers<CR>
nnoremap <C-p> :Files<CR>
nnoremap <S-l> gt
nnoremap <S-h> gT

" global leader mappings
nnoremap <Leader><Leader> :nohlsearch<CR>
nnoremap <Leader><Space> :Rg<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>q :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <Leader>l :lclose<CR>
nnoremap <Leader>z :tabclose<CR>
nmap <silent> <Leader>d <Plug>DashSearch

" Ctrl + S always saves
nnoremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR><ESC>
inoremap <silent> <C-S> <C-O>:update<CR><ESC>

" ruby mappings
function! SetRubyMappings()
  nnoremap <buffer> <Leader>f :call RunCurrentSpecFile()<CR>
  nnoremap <buffer> <Leader>s :call RunNearestSpec()<CR>
  nnoremap <buffer> <Leader>l :call RunLastSpec()<CR>
  nnoremap <buffer> <Leader>L :call DispatchLastSpecsInSeparateWindow()<CR>
  nnoremap <buffer> <Leader>a :call RunAllSpecs()<CR>
  nnoremap <buffer> <Leader>c :Start bin/rails c<CR>
  nnoremap <buffer> <Leader>r :Dispatch bundle exec rubocop %<CR>
  nnoremap <buffer> <Leader>ra :Dispatch bundle exec rubocop<CR>
  nnoremap <buffer> <Leader>v ysiw}i#cs'"
  nnoremap <buffer> <Leader>1 :.!python -m json.tool<CR>
  vnoremap <buffer> <Leader>1 :!python -m json.tool<CR>
  nnoremap <buffer> <Leader>2 :.!ruby_hash.rb<CR>
  vnoremap <buffer> <Leader>2 :!ruby_hash.rb<CR>
  set shiftwidth=2 tabstop=2 expandtab
  nnoremap <buffer> <Leader>t :silent! !`ripper-tags -R`<CR> :redraw!<CR>
endfunction

augroup ruby_mappings
  autocmd!
  autocmd FileType ruby call SetRubyMappings()
augroup end

" cpp mappings
function! SetCppMappings()
  setlocal makeprg=ninja\ -C\ build<CR>
  nnoremap <buffer> <Leader>m :Dispatch<CR>
  nnoremap <buffer> <Leader>x :Start build/app<CR>
  set shiftwidth=4 tabstop=4 expandtab
endfunction

augroup cpp_mappings
  autocmd!
  autocmd FileType cpp call SetCppMappings()
augroup end

" rust mappings
function! SetRustMappings()
  compiler cargo
  nnoremap <buffer> <Leader>m :Make check<CR>
  nnoremap <buffer> <Leader>x :Make run<CR>
  nnoremap <buffer> <Leader>a :Make test<CR>
  set shiftwidth=2 tabstop=2 expandtab
endfunction

augroup rust_mappings
  autocmd!
  autocmd FileType rust,toml call SetRustMappings()
augroup end
