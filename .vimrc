:syntax enable
:set tabstop=4
:set shiftwidth=4
:set softtabstop=4
:set bg=dark
:set nu

:set tags=./tags;

inoremap uu u

colorscheme default

if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  " ...
  autocmd FileType haskell setlocal expandtab tags=~/symbolic-trace/tags
  autocmd FileType python setlocal expandtab
  autocmd FileType sh setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType html setlocal ts=2 sw=2 sts=2
  autocmd FileType java setlocal expandtab
  autocmd FileType asm setlocal ts=8 sw=8 sts=8
  autocmd FileType xml setlocal ts=1 sw=1 sts=1
  autocmd FileType scheme setlocal ts=2 sw=2 sts=2 expandtab
  autocmd FileType cpp setlocal expandtab
  autocmd FileType c setlocal expandtab
endif

:set smartindent

au BufNewFile,BufRead *.c call CheckForCustomConfiguration()
au BufNewFile,BufRead *.ll setlocal filetype=llvm

function! CheckForCustomConfiguration()
    " Check for .vim.custom in the directory containing the newly opened file
    let custom_config_file = expand('%:p:h') . '/.vim.custom'
    if filereadable(custom_config_file)
        exe 'source' custom_config_file
    endif
endfunction
