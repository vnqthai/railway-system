let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Google\ Drive/Source/Ruby/railway-system
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +45 lib/rail.rb
badd +9 lib/rail/services/routes_finder.rb
badd +1 lib/rail/models/network.rb
badd +1 lib/rail/models/line.rb
badd +1 lib/rail/models/line_station.rb
badd +3 lib/rail/models/station.rb
badd +4 lib/rail/models/route.rb
badd +34 bin/rail
badd +0 Exercise/New_Backend_Exercise.md
badd +52 Exercise/StationMap.csv
badd +0 data/StationMap.csv
badd +214 Session.vim
badd +67 README.md
badd +3 Exercise/examples.md
badd +5 lib/rail/services/time_calculator.rb
badd +93 lib/rail/services/data_parser.rb
argglobal
silent! argdel *
edit lib/rail.rb
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
3wincmd k
wincmd w
wincmd w
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 34 + 36) / 73)
exe 'vert 1resize ' . ((&columns * 92 + 139) / 278)
exe '2resize ' . ((&lines * 35 + 36) / 73)
exe 'vert 2resize ' . ((&columns * 92 + 139) / 278)
exe '3resize ' . ((&lines * 34 + 36) / 73)
exe 'vert 3resize ' . ((&columns * 92 + 139) / 278)
exe '4resize ' . ((&lines * 35 + 36) / 73)
exe 'vert 4resize ' . ((&columns * 92 + 139) / 278)
exe '5resize ' . ((&lines * 17 + 36) / 73)
exe 'vert 5resize ' . ((&columns * 92 + 139) / 278)
exe '6resize ' . ((&lines * 17 + 36) / 73)
exe 'vert 6resize ' . ((&columns * 92 + 139) / 278)
exe '7resize ' . ((&lines * 17 + 36) / 73)
exe 'vert 7resize ' . ((&columns * 92 + 139) / 278)
exe '8resize ' . ((&lines * 16 + 36) / 73)
exe 'vert 8resize ' . ((&columns * 92 + 139) / 278)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 21 - ((15 * winheight(0) + 17) / 34)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
21
normal! 0
wincmd w
argglobal
if bufexists('lib/rail/models/station.rb') | buffer lib/rail/models/station.rb | else | edit lib/rail/models/station.rb | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 64 - ((11 * winheight(0) + 17) / 35)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
64
normal! 016|
wincmd w
argglobal
if bufexists('lib/rail/services/routes_finder.rb') | buffer lib/rail/services/routes_finder.rb | else | edit lib/rail/services/routes_finder.rb | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 106 - ((23 * winheight(0) + 17) / 34)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
106
normal! 046|
wincmd w
argglobal
if bufexists('lib/rail/services/time_calculator.rb') | buffer lib/rail/services/time_calculator.rb | else | edit lib/rail/services/time_calculator.rb | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 19 - ((18 * winheight(0) + 17) / 35)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
19
normal! 07|
wincmd w
argglobal
if bufexists('lib/rail/models/network.rb') | buffer lib/rail/models/network.rb | else | edit lib/rail/models/network.rb | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 22 - ((9 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
22
normal! 05|
lcd ~/Google\ Drive/Source/Ruby/railway-system
wincmd w
argglobal
if bufexists('~/Google\ Drive/Source/Ruby/railway-system/lib/rail/models/line.rb') | buffer ~/Google\ Drive/Source/Ruby/railway-system/lib/rail/models/line.rb | else | edit ~/Google\ Drive/Source/Ruby/railway-system/lib/rail/models/line.rb | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 4 - ((3 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4
normal! 0
lcd ~/Google\ Drive/Source/Ruby/railway-system
wincmd w
argglobal
if bufexists('~/Google\ Drive/Source/Ruby/railway-system/lib/rail/models/line_station.rb') | buffer ~/Google\ Drive/Source/Ruby/railway-system/lib/rail/models/line_station.rb | else | edit ~/Google\ Drive/Source/Ruby/railway-system/lib/rail/models/line_station.rb | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 17 - ((13 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
17
normal! 07|
lcd ~/Google\ Drive/Source/Ruby/railway-system
wincmd w
argglobal
if bufexists('~/Google\ Drive/Source/Ruby/railway-system/lib/rail/models/route.rb') | buffer ~/Google\ Drive/Source/Ruby/railway-system/lib/rail/models/route.rb | else | edit ~/Google\ Drive/Source/Ruby/railway-system/lib/rail/models/route.rb | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 9 - ((8 * winheight(0) + 8) / 16)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
9
normal! 036|
lcd ~/Google\ Drive/Source/Ruby/railway-system
wincmd w
7wincmd w
exe '1resize ' . ((&lines * 34 + 36) / 73)
exe 'vert 1resize ' . ((&columns * 92 + 139) / 278)
exe '2resize ' . ((&lines * 35 + 36) / 73)
exe 'vert 2resize ' . ((&columns * 92 + 139) / 278)
exe '3resize ' . ((&lines * 34 + 36) / 73)
exe 'vert 3resize ' . ((&columns * 92 + 139) / 278)
exe '4resize ' . ((&lines * 35 + 36) / 73)
exe 'vert 4resize ' . ((&columns * 92 + 139) / 278)
exe '5resize ' . ((&lines * 17 + 36) / 73)
exe 'vert 5resize ' . ((&columns * 92 + 139) / 278)
exe '6resize ' . ((&lines * 17 + 36) / 73)
exe 'vert 6resize ' . ((&columns * 92 + 139) / 278)
exe '7resize ' . ((&lines * 17 + 36) / 73)
exe 'vert 7resize ' . ((&columns * 92 + 139) / 278)
exe '8resize ' . ((&lines * 16 + 36) / 73)
exe 'vert 8resize ' . ((&columns * 92 + 139) / 278)
tabedit ~/Google\ Drive/Source/Ruby/railway-system/Exercise/New_Backend_Exercise.md
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd w
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 92 + 139) / 278)
exe 'vert 2resize ' . ((&columns * 92 + 139) / 278)
exe 'vert 3resize ' . ((&columns * 92 + 139) / 278)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 56 - ((19 * winheight(0) + 35) / 70)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
56
normal! 026|
wincmd w
argglobal
if bufexists('~/Google\ Drive/Source/Ruby/railway-system/data/StationMap.csv') | buffer ~/Google\ Drive/Source/Ruby/railway-system/data/StationMap.csv | else | edit ~/Google\ Drive/Source/Ruby/railway-system/data/StationMap.csv | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 24 - ((23 * winheight(0) + 35) / 70)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
24
normal! 06|
wincmd w
argglobal
if bufexists('~/Google\ Drive/Source/Ruby/railway-system/Exercise/examples.md') | buffer ~/Google\ Drive/Source/Ruby/railway-system/Exercise/examples.md | else | edit ~/Google\ Drive/Source/Ruby/railway-system/Exercise/examples.md | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 3 - ((2 * winheight(0) + 35) / 70)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
3
normal! 0
wincmd w
exe 'vert 1resize ' . ((&columns * 92 + 139) / 278)
exe 'vert 2resize ' . ((&columns * 92 + 139) / 278)
exe 'vert 3resize ' . ((&columns * 92 + 139) / 278)
tabnext 1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToOFs
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
