if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.osd  setfiletype ops
    au! BufRead,BufNewFile *.ops  setfiletype ops
    au! BufRead,BufNewFile *.nxc  setfiletype nxc
    au! BufRead,BufNewFile *.tex  set spell
    au! BufRead,BufNewFile *.dae  setfiletype xml
    au! BufRead,BufNewFile *.urdf  setfiletype xml
    au! BufRead,BufNewFile *.URDF  setfiletype xml
    au! BufRead,BufNewFile *.m,*.oct setfiletype octave 
    au! BufRead,BufNewFile *.m1s  setfiletype vbnet
augroup END
