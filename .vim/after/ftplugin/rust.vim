set nospell
set nowrap
set textwidth=99
set makeprg=cargo

nmap <Leader>c :!clear; cargo check<CR>
nmap <Leader>x :!clear; cargo run<CR>

ia pp println!("{:?}",);<Left><Left>
