if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.osd  setfiletype ops
    au! BufRead,BufNewFile *.ops  setfiletype ops
    au! BufRead,BufNewFile *.nxc  setfiletype nxc
    au! BufRead,BufNewFile *.tex  set spell
augroup END

