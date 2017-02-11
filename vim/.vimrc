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
set laststatus=2
set cmdheight=1
set list

syntax on
set background=dark
colorscheme solarized
let g:EasyMotion_leader_key = '<Leader>'

set wildignore+=*.so,*.swp,*.zip,app/assets/images/*
let g:ctrlp_custom_ignore={
      \ 'dir': 'public\/assets$'
      \}
let g:agprg="/usr/local/bin/ag --column"
let g:aghighlight=1
let g:rspec_command='Dispatch bin/rspec {spec}'

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
  :silent! %!python3 -m json.tool
  set filetype=json
endfunction

function! FormatJSON()
  set filetype=json
  :silent! %!python -m json.tool
endfunction

function! ResetTSlimePaneNumber()
  let g:tslime['pane'] = input("pane number: ", "", "custom,Tmux_Pane_Numbers")
endfunction

function! SetRspecCommand()
  let l:cmd = input("command: ")
  let g:rspec_command='call Send_to_Tmux("' . l:cmd . ' {spec}\n")'
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

nnoremap <F9> :call FormatXmlFast()<CR>
nnoremap <F3> :silent! !`/usr/local/bin/brew --prefix`/bin/ctags -R *<CR> :redraw!<CR>
nnoremap <C-f> :Ag 
nnoremap <Leader><Space> :Ag<CR>
nnoremap <C-b> :CtrlPBuffer<CR>
nnoremap <S-l> gt
nnoremap <S-h> gT

nnoremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR><ESC>
inoremap <silent> <C-S>         <C-O>:update<CR><ESC>

nnoremap <Leader><Leader> :nohlsearch<CR>

nnoremap <Leader>f :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>
nnoremap <Leader>L :call DispatchLastSpecsInSeparateWindow()<CR>
nnoremap <Leader>a :call RunAllSpecs()<CR>
nnoremap <Leader>c :Start bin/rails c<CR>

nnoremap <Leader>v ysiw}i#cs'"
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>q :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <Leader>rs :source $MYVIMRC<CR>
nnoremap <Leader>tmux <Plug>SetTmuxVars
nnoremap <Leader>m :Dispatch<CR>
nnoremap <Leader>x :Start build/ptts<CR>
nnoremap <Leader>z :tabclose<CR>

nnoremap <Leader>1 :.!python -m json.tool<CR>
vnoremap <Leader>1 :!python -m json.tool<CR>
nnoremap <Leader>2 :.!ruby_hash.rb<CR>
vnoremap <Leader>2 :!ruby_hash.rb<CR>
