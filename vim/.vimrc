call pathogen#infect()

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

" Delete comment character when joining commented lines
set formatoptions+=j

behave mswin
syntax on
set background=light
colorscheme solarized
let g:EasyMotion_leader_key = '<Leader>'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,app/assets/images/*
let g:agprg="/usr/local/bin/ag --column"
let g:aghighlight=1
let g:rspec_command='call Send_to_Tmux("bin/rspec {spec}\n")'

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

function! ResetTSlimeVars()
  execute "normal <Plug>SetTmuxVars"
endfunction

function! ResetTSlimePaneNumber()
  let g:tslime['pane'] = input("pane number: ", "", "custom,Tmux_Pane_Numbers")
endfunction

function! SetRspecCommand()
  let l:cmd = input("command: ")
  let g:rspec_command='call Send_to_Tmux("' . l:cmd . ' {spec}\n")'
endfunction

nmap <F9> :call FormatXmlFast()<CR>
nmap <F3> :silent! !`/usr/local/bin/brew --prefix`/bin/ctags -R *<CR> :redraw!<CR>
nmap <C-f> :Ag 
nmap <Leader><Space> :Ag<CR>
nmap <C-b> :CtrlPBuffer<CR>
nnoremap <S-l> gt
nnoremap <S-h> gT

noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR><ESC>
inoremap <silent> <C-S>         <C-O>:update<CR><ESC>

nmap <Leader><Leader> :nohlsearch<CR>

nmap <Leader>f :call RunCurrentSpecFile()<CR>
nmap <Leader>s :call RunNearestSpec()<CR>
nmap <Leader>l :call RunLastSpec()<CR>
nmap <Leader>a :call RunAllSpecs()<CR>

nmap <Leader>v ysiw}i#cs'"
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>q :cclose<CR>
nnoremap <Leader>rs :source $MYVIMRC<CR>
