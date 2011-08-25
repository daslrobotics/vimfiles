if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.osd  setfiletype ops
    au! BufRead,BufNewFile *.ops  setfiletype ops
augroup END

