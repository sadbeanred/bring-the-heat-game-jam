let s:cpo_save=&cpo
set cpo&vim
inoremap <silent> <C-T> <Cmd>ToggleTerm
inoremap <silent> <expr> <BS> v:lua.MiniPairs.bs()
cnoremap <silent> <Plug>(TelescopeFuzzyCommandSearch) e "lua require('telescope.builtin').command_history { default_text = [=[" . escape(getcmdline(), '"') . "]=] }"
inoremap <C-W> u
inoremap <C-U> u
nnoremap <silent>  :TmuxNavigateLeft
nnoremap <silent> <NL> :TmuxNavigateDown
nnoremap <silent>  :TmuxNavigateUp
nnoremap <silent>  :TmuxNavigateRight
nnoremap <silent>  <Cmd>execute v:count . "ToggleTerm"
nnoremap  <Cmd>TmuxNavigateRight
nnoremap <NL> <Cmd>TmuxNavigateDown
nnoremap  <Cmd>TmuxNavigateLeft
nnoremap  <Cmd>TmuxNavigatePrevious
nnoremap  <Cmd>TmuxNavigateUp
nmap  d
nnoremap <silent>  :TmuxNavigatePrevious
vnoremap  rr <Cmd>lua require('telescope').extensions.refactoring.refactors()
omap <silent> % <Plug>(MatchitOperationForward)
xmap <silent> % <Plug>(MatchitVisualForward)
nmap <silent> % <Plug>(MatchitNormalForward)
nnoremap & :&&
nnoremap - <Cmd>Oil
xnoremap <silent> <expr> @ mode() ==# 'V' ? ':normal! @'.getcharstr().'' : '@'
xnoremap <silent> <expr> Q mode() ==# 'V' ? ':normal! @=reg_recorded()' : 'Q'
nnoremap Y y$
omap <silent> [% <Plug>(MatchitOperationMultiBackward)
xmap <silent> [% <Plug>(MatchitVisualMultiBackward)
nmap <silent> [% <Plug>(MatchitNormalMultiBackward)
omap <silent> ]% <Plug>(MatchitOperationMultiForward)
xmap <silent> ]% <Plug>(MatchitVisualMultiForward)
nmap <silent> ]% <Plug>(MatchitNormalMultiForward)
xmap a% <Plug>(MatchitVisualTextObject)
nnoremap <silent> gp `[v`]
omap <silent> g% <Plug>(MatchitOperationBackward)
xmap <silent> g% <Plug>(MatchitVisualBackward)
nmap <silent> g% <Plug>(MatchitNormalBackward)
onoremap <silent> gc <Cmd>lua MiniComment.textobject()
tnoremap <silent> jk 
vnoremap <silent> p "_dP
xnoremap <silent> sa :lua MiniSurround.add('visual')
nnoremap <silent> <C-Bslash> :TmuxNavigatePrevious
nnoremap <silent> <C-J> :TmuxNavigateDown
nnoremap <silent> <C-H> :TmuxNavigateLeft
nnoremap <C-W><C-L> <Cmd>TmuxNavigateRight
nnoremap <C-W><C-J> <Cmd>TmuxNavigateDown
nnoremap <C-W><C-H> <Cmd>TmuxNavigateLeft
nnoremap <C-W><C-Bslash> <Cmd>TmuxNavigatePrevious
nnoremap <C-W><C-K> <Cmd>TmuxNavigateUp
nnoremap <SNR>50_: :=v:count ? v:count : ''
nnoremap <silent> <C-K> :TmuxNavigateUp
xmap <silent> <Plug>(MatchitVisualTextObject) <Plug>(MatchitVisualMultiBackward)o<Plug>(MatchitVisualMultiForward)
onoremap <silent> <Plug>(MatchitOperationMultiForward) :call matchit#MultiMatch("W",  "o")
onoremap <silent> <Plug>(MatchitOperationMultiBackward) :call matchit#MultiMatch("bW", "o")
xnoremap <silent> <Plug>(MatchitVisualMultiForward) :call matchit#MultiMatch("W",  "n")m'gv``
xnoremap <silent> <Plug>(MatchitVisualMultiBackward) :call matchit#MultiMatch("bW", "n")m'gv``
nnoremap <silent> <Plug>(MatchitNormalMultiForward) :call matchit#MultiMatch("W",  "n")
nnoremap <silent> <Plug>(MatchitNormalMultiBackward) :call matchit#MultiMatch("bW", "n")
onoremap <silent> <Plug>(MatchitOperationBackward) :call matchit#Match_wrapper('',0,'o')
onoremap <silent> <Plug>(MatchitOperationForward) :call matchit#Match_wrapper('',1,'o')
xnoremap <silent> <Plug>(MatchitVisualBackward) :call matchit#Match_wrapper('',0,'v')m'gv``
xnoremap <silent> <Plug>(MatchitVisualForward) :call matchit#Match_wrapper('',1,'v'):if col("''") != col("$") | exe ":normal! m'" | endifgv``
nnoremap <silent> <Plug>(MatchitNormalBackward) :call matchit#Match_wrapper('',0,'n')
nnoremap <silent> <Plug>(MatchitNormalForward) :call matchit#Match_wrapper('',1,'n')
nnoremap <silent> <C-T> <Cmd>execute v:count . "ToggleTerm"
nnoremap <Plug>PlenaryTestFile :lua require('plenary.test_harness').test_file(vim.fn.expand("%:p"))
nmap <C-W><C-D> d
nnoremap <silent> <C-L> :TmuxNavigateRight
inoremap <silent> <expr>  v:lua.MiniPairs.cr()
inoremap <silent>  <Cmd>ToggleTerm
inoremap  u
inoremap  u
inoremap <expr> " v:lua.MiniPairs.closeopen('""', "[^\\].")
inoremap <expr> ' v:lua.MiniPairs.closeopen("''", "[^%a\\].")
inoremap <expr> ( v:lua.MiniPairs.open("()", "[^\\].")
inoremap <expr> ) v:lua.MiniPairs.close("()", "[^\\].")
inoremap <expr> [ v:lua.MiniPairs.open("[]", "[^\\].")
inoremap <expr> ] v:lua.MiniPairs.close("[]", "[^\\].")
inoremap <expr> ` v:lua.MiniPairs.closeopen("``", "[^\\].")
inoremap <silent> jk 
inoremap <expr> { v:lua.MiniPairs.open("{}", "[^\\].")
inoremap <expr> } v:lua.MiniPairs.close("{}", "[^\\].")
let &cpo=s:cpo_save
unlet s:cpo_save
set cmdheight=0
set errorformat=Error:\ %f:%l:\ %m
set expandtab
set formatexpr=v:lua.require'conform'.formatexpr()
set grepformat=%f:%l:%c:%m
set grepprg=rg\ --vimgrep\ -uu\ 
set guifont=CaskaydiaCove\ NF,:h12
set helplang=en
set ignorecase
set laststatus=3
set noloadplugins
set makeprg=love\ .
set mouse=a
set omnifunc=syntaxcomplete#Complete
set operatorfunc=v:lua.MiniComment.operator
set packpath=/usr/local/share/nvim/runtime
set runtimepath=~/.config/nvim,~/.local/share/nvim/site,~/.local/share/nvim/lazy/lazy.nvim,~/.local/share/nvim/lazy/markdown-preview.nvim,~/.local/share/nvim/lazy/conform.nvim,~/.local/share/nvim/lazy/vim-tmux-navigator,~/.local/share/nvim/lazy/lazydev.nvim,~/.local/share/nvim/lazy/guihua.lua,~/.local/share/nvim/lazy/go.nvim,~/.local/share/nvim/lazy/vim-fugitive,~/.local/share/nvim/lazy/LuaSnip,~/.local/share/nvim/lazy/neogit,~/.local/share/nvim/lazy/noice.nvim,~/.local/share/nvim/lazy/which-key.nvim,~/.local/share/nvim/lazy/onedark.nvim,~/.local/share/nvim/lazy/lualine.nvim,~/.local/share/nvim/lazy/mini.nvim,~/.local/share/nvim/lazy/render-markdown.nvim,~/.local/share/nvim/lazy/snacks.nvim,~/.local/share/nvim/lazy/nvim-notify,~/.local/share/nvim/lazy/refactoring.nvim,~/.local/share/nvim/lazy/friendly-snippets,~/.local/share/nvim/lazy/blink.cmp,~/.local/share/nvim/lazy/otter.nvim,~/.local/share/nvim/lazy/quarto-nvim,~/.local/share/nvim/lazy/nvim-lspconfig,~/.local/share/nvim/lazy/toggleterm.nvim,~/.local/share/nvim/lazy/mason-lspconfig.nvim,~/.local/share/nvim/lazy/fzf-lua,~/.local/share/nvim/lazy/nui.nvim,~/.local/share/nvim/lazy/nvim-dbee,~/.config/nvim/lua/custom/PyFix,~/.local/share/nvim/lazy/mini.pairs,~/.local/share/nvim/lazy/mason.nvim,~/.local/share/nvim/lazy/mini.surround,~/.local/share/nvim/lazy/mini.ai,~/.local/share/nvim/lazy/nvim-treesitter,~/.local/share/nvim/lazy/playground,~/.local/share/nvim/lazy/mini.comment,~/.local/share/nvim/lazy/oil.nvim,~/.local/share/nvim/lazy/telescope-fzf-native.nvim,~/.local/share/nvim/lazy/nvim-web-devicons,~/.local/share/nvim/lazy/telescope-glyph.nvim,~/.local/share/nvim/lazy/telescope-ui-select.nvim,~/.local/share/nvim/lazy/telescope-smart-history.nvim,~/.local/share/nvim/lazy/telescope-file-browser.nvim,~/.local/share/nvim/lazy/telescope-lsp-handlers,~/.local/share/nvim/lazy/telescope-project.nvim,~/.local/share/nvim/lazy/telescope-picker-list.nvim,~/.local/share/nvim/lazy/ripgrep,~/.local/share/nvim/lazy/plenary.nvim,~/.local/share/nvim/lazy/telescope.nvim,~/.local/share/nvim/lazy/luarocks.nvim,/usr/local/share/nvim/runtime,/usr/local/share/nvim/runtime/pack/dist/opt/matchit,/usr/local/lib/nvim,~/.local/share/nvim/lazy/quarto-nvim/after,~/.local/share/nvim/lazy/mason-lspconfig.nvim/after,~/.local/share/nvim/lazy/playground/after,~/.config/nvim/after,~/.local/state/nvim/lazy/readme
set scrolloff=8
set shiftwidth=4
set noshowmode
set showtabline=2
set smartcase
set smartindent
set statusline=%#lualine_transparent#
set noswapfile
set tabline=%#lualine_a_tabs_active#%1@LualineSwitchTab@\ 1\ menu.lua\ %T%#lualine_transitional_lualine_a_tabs_active_to_lualine_c_normal#%#lualine_c_normal#%=
set tabstop=4
set termguicolors
set winborder=rounded
set window=43
" vim: set ft=vim :
