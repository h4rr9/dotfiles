lua << EOF

require('bufdel').setup {
  next = 'alternate' 
}


require('nvim-autopairs').setup()
EOF


let g:UltiSnipsExpandTrigger = '<c-j>'

augroup lightbulb
autocmd!
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
augroup END
