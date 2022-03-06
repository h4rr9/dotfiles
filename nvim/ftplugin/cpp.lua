vim.keymap.set('n', '<F8>', '<cmd>w <bar> !g++ -std=c++17 -Wall -O2 % -o %:r -D _STACK<cr>')
vim.keymap.set('n', '<F9>',
               '<cmd>w <bar> !g++ -std=c++17 -Wall -Wextra -Wno-unused-result % -o %:r -g -fsanitize=address -fsanitize=undefined -D _DEBUG -D _STACK<cr>')
