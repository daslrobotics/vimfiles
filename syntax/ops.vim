" Vim syntax file
" Language:	C
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	1999 Dec 02, 2004 Feb 04
" Updated by Robert Ellenberg, 2011 for OPS files
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
" TODO: Highlight script errors:
"   Missing "then" after if
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
"hi clear

syn match       cName		"\<[a-zA-Z_][a-zA-Z_0-9]*\>"
"syn match       cConstant	"\<[A-Z_][A-Z_0-9]\{2,}[A-Za-z_0-9]*\>[^(:]"me=e-1
"syn match       cConstant	"\<[A-Z_][A-Z_0-9]\{2,}[A-Za-z_0-9]*\>$"
"syn match       cConstant	"\<_[_0-9]\{1,}\>[^(:]"
syn match	cFunction	"\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
"syn match	cFunction	"\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*)("me=e-2
syn match	cFunction	"\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1
syn match	cBraces		"[{}]"

syn keyword cMC			__DI __EI __asm __set_il
syn keyword cMC			__wait_nop __mul __div __mod __mulu __divu __modu
syn keyword cAnsiFunction	open close read write lseek dup dup2
syn keyword cName   StateMachine program

syn keyword	cMC		__interrupt __nosavereg
syn keyword	cAnsiName	STDC FP_CONTRACT

syn keyword	cAnsiName	and bitor not_eq xor
syn keyword	cAnsiName	and_eq compl or xor_eq
syn keyword	cAnsiName	bitand not or_eq

" A bunch of useful C keywords
syn keyword cStatement  entry exit handle transition
syn keyword	cStatement	initial state final function param var select
syn keyword	cLabel		default
syn keyword	cLabel		case
syn keyword	cConditional	if else switch then
syn keyword	cRepeat		while for do

syn keyword	cTodo		contained TODO FIXME XXX
syn match	cTodo		contained "///[A-Z]!*"

" cCommentGroup allows adding matches for special things in comments
syn cluster	cCommentGroup	contains=cTodo

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match	cSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
if !exists("c_no_utf")
  syn match	cSpecial	display contained "\\\(u\x\{4}\|U\x\{8}\)"
endif
if exists("c_no_cformat")
  syn region	cString		start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=cSpecial,@Spell
  " cCppString: same as cString, but ends at end of line
  syn region	cCppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=cSpecial,@Spell
else
  syn match	cFormat		display "%\(\d\+\$\)\=[-+' #0*,]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjztF]\|ll\|hh\)\=\([bdiuoxXDOUfeEgGcCsSpnAaK]\|\[\^\=.[^]]*\]\)" contained
  syn match	cFormat		display "%%" contained
  syn region	cString		start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=cSpecial,cFormat,@Spell
  " cCppString: same as cString, but ends at end of line
  syn region	cCppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=cSpecial,cFormat
  hi link cFormat cSpecial
endif
hi link cCppString cString

syn match	cCharacter	"L\='[^\\]'"
syn match	cCharacter	"L'[^']*'" contains=cSpecial
if exists("c_gnu")
  syn match	cSpecialError	"L\='\\[^'\"?\\abefnrtv]'"
  syn match	cSpecialCharacter "L\='\\['\"?\\abefnrtv]'"
else
  syn match	cSpecialError	"L\='\\[^'\"?\\abfnrtv]'"
  syn match	cSpecialCharacter "L\='\\['\"?\\abfnrtv]'"
endif
syn match	cSpecialCharacter display "L\='\\\o\{1,3}'"
syn match	cSpecialCharacter display "'\\x\x\{1,2}'"
syn match	cSpecialCharacter display "L'\\x\x\+'"

"when wanted, highlight trailing white space
if exists("c_space_errors")
  if !exists("c_no_trail_space_error")
    syn match	cSpaceError	display excludenl "\s\+$"
  endif
  if !exists("c_no_tab_space_error")
    syn match	cSpaceError	display " \+\t"me=e-1
  endif
endif

"catch errors caused by wrong parenthesis and brackets
" also accept <% for {, %> for }, <: for [ and :> for ] (C99)
syn cluster	cParenGroup	contains=cParenError,cIncluded,cSpecial,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cUserCont,cUserLabel,cUserLabel2,cGotoLabel,cBitField,cCommentSkip,cOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom
if exists("c_no_bracket_error")
  syn region	cParen		transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cCppString,@Spell
  " cCppParen: same as cParen but ends at end-of-line; used in cDefine
  syn region	cCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cParen,cString,@Spell
  syn match	cParenError	display ")"
" syn match	cErrInParen	display contained "[{}]\|<%\|%>"
  syn match	cErrInParen	display contained "[]\|<%\|%>"
else
  syn region	cParen		transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cErrInBracket,cCppBracket,cCppString,@Spell
  " cCppParen: same as cParen but ends at end-of-line; used in cDefine
  syn region	cCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cErrInBracket,cParen,cBracket,cString,@Spell
  syn match	cParenError	display "[\])]"
" syn match	cErrInParen	display contained "[\]{}]\|<%\|%>"
  syn match	cErrInParen	display contained "[\]]\|<%\|%>"
  syn region	cBracket	transparent start='\[\|<::\@!' end=']\|:>' contains=ALLBUT,@cParenGroup,cErrInParen,cCppParen,cCppBracket,cCppString,@Spell
  " cCppBracket: same as cParen but ends at end-of-line; used in cDefine
  syn region	cCppBracket	transparent start='\[\|<::\@!' skip='\\$' excludenl end=']\|:>' end='$' contained contains=ALLBUT,@cParenGroup,cErrInParen,cParen,cBracket,cString,@Spell
  syn match	cErrInBracket	display contained "[);{}]\|<%\|%>"
  "syn region	cBlock		transparent matchgroup=cBraces start='{' end='}' contains=ALLBUT,@cParenGroup,cCppParen,cCppBracket,cCppString,cBraceError,cErrInBracket
  "syn match	cBraceError	"}"
endif

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match	cNumbers	display transparent "\<\d\|\.\d" contains=cNumber,cFloat,cOctalError,cOctal
" Same, but without octal error (for comments)
syn match	cNumbersCom	display contained transparent "\<\d\|\.\d" contains=cNumber,cFloat,cOctal
syn match	cNumber		display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match	cNumber		display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
syn match	cOctal		display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=cOctalZero
syn match	cOctalZero	display contained "\<0"
syn match	cFloat		display contained "\d\+f"
"floating point number, with dot, optional exponent
syn match	cFloat		display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match	cFloat		display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match	cFloat		display contained "\d\+e[-+]\=\d\+[fl]\=\>"
if !exists("c_no_c99")
  "hexadecimal floating point number, optional leading digits, with dot, with exponent
  syn match	cFloat		display contained "0x\x*\.\x\+p[-+]\=\d\+[fl]\=\>"
  "hexadecimal floating point number, with leading digits, optional dot, with exponent
  syn match	cFloat		display contained "0x\x\+\.\=p[-+]\=\d\+[fl]\=\>"
endif

" flag an octal number with wrong digits
syn match	cOctalError	display contained "0\o*[89]\d*"
syn case match

if exists("xxxc_comment_strings")
  " A comment can contain cString, cCharacter and cNumber.
  " But a "*/" inside a cString in a cComment DOES end the comment!  So we
  " need to use a special type of cString: cCommentString, which also ends on
  " "*/", and sees a "*" at the start of the line as comment again.
  " Unfortunately this doesn't very well work for // type of comments :-(
  syntax match	cCommentSkip	contained "^\s*\*\($\|\s\+\)"
  syntax region cCommentString	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=cSpecial,cCommentSkip
  syntax region cComment2String	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=cSpecial
  syntax region  cCommentL	start="//" skip="\\$" end="$" keepend contains=@cCommentGroup,cComment2String,cCharacter,cNumbersCom,cSpaceError,@Spell
  syntax region cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cCommentString,cCharacter,cNumbersCom,cSpaceError,@Spell
else
  syn region	cCommentL	start="//" skip="\\$" end="$" keepend contains=@cCommentGroup,cSpaceError,@Spell
  syn region	cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cSpaceError,@Spell
endif
" keep a // comment separately, it terminates a preproc. conditional
syntax match	cCommentError	display "\*/"
syntax match	cCommentStartError display "/\*"me=e-1 contained

syn keyword	cOperator	sizeof
syn keyword	cType		int long short char bool
syn keyword	cType		signed unsigned float double
if !exists("c_no_ansi") || exists("c_ansi_typedefs")
  syn keyword   cType		size_t ssize_t wchar_t ptrdiff_t sig_atomic_t fpos_t
  syn keyword   cType		clock_t time_t va_list jmp_buf FILE DIR div_t ldiv_t
  syn keyword   cType		mbstate_t wctrans_t wint_t wctype_t
  syn keyword   cType		lldiv_t float_t double_t fenv_t fexcept_t
endif
if !exists("c_no_c99") " ISO C99
  syn keyword	cType		bool complex imaginary
  syn keyword	cType		int8_t int16_t int32_t int64_t
  syn keyword	cType		uint8_t uint16_t uint32_t uint64_t
  syn keyword	cType		int_least8_t int_least16_t int_least32_t int_least64_t
  syn keyword	cType		uint_least8_t uint_least16_t uint_least32_t uint_least64_t
  syn keyword	cType		int_fast8_t int_fast16_t int_fast32_t int_fast64_t
  syn keyword	cType		uint_fast8_t uint_fast16_t uint_fast32_t uint_fast64_t
  syn keyword	cType		intptr_t uintptr_t
  syn keyword	cType		intmax_t uintmax_t
endif
if exists("c_gnu")
  syn keyword	cType		__label__ __complex__ __volatile__
endif

syn keyword	cStructure	struct union enum typedef
syn keyword	cStorageClass	static register auto volatile extern const VOL
if exists("c_gnu")
  syn keyword	cStorageClass	inline __attribute__
endif
if !exists("c_no_c99")
  syn keyword	cStorageClass	inline restrict
endif

if !exists("c_no_ansi") || exists("c_ansi_constants") || exists("c_gnu")
  if exists("c_gnu")
    syn keyword cConstant __GNUC__ __FUNCTION__ __PRETTY_FUNCTION__
  endif
  syn keyword cConstant __LINE__ __FILE__ __DATE__ __TIME__ __STDC__ __func__
  syn keyword cConstant __STDC_VERSION__
  syn keyword cConstant CHAR_BIT MB_LEN_MAX MB_CUR_MAX
  syn keyword cConstant UCHAR_MAX UINT_MAX ULONG_MAX USHRT_MAX
  syn keyword cConstant CHAR_MIN INT_MIN LONG_MIN SHRT_MIN
  syn keyword cConstant CHAR_MAX INT_MAX LONG_MAX SHRT_MAX
  syn keyword cConstant SCHAR_MIN SINT_MIN SLONG_MIN SSHRT_MIN
  syn keyword cConstant SCHAR_MAX SINT_MAX SLONG_MAX SSHRT_MAX
  if !exists("c_no_c99")
    syn keyword cConstant LLONG_MIN LLONG_MAX ULLONG_MAX
    syn keyword cConstant INT8_MIN INT16_MIN INT32_MIN INT64_MIN
    syn keyword cConstant INT8_MAX INT16_MAX INT32_MAX INT64_MAX
    syn keyword cConstant UINT8_MAX UINT16_MAX UINT32_MAX UINT64_MAX
    syn keyword cConstant INT_LEAST8_MIN INT_LEAST16_MIN INT_LEAST32_MIN INT_LEAST64_MIN
    syn keyword cConstant INT_LEAST8_MAX INT_LEAST16_MAX INT_LEAST32_MAX INT_LEAST64_MAX
    syn keyword cConstant UINT_LEAST8_MAX UINT_LEAST16_MAX UINT_LEAST32_MAX UINT_LEAST64_MAX
    syn keyword cConstant INT_FAST8_MIN INT_FAST16_MIN INT_FAST32_MIN INT_FAST64_MIN
    syn keyword cConstant INT_FAST8_MAX INT_FAST16_MAX INT_FAST32_MAX INT_FAST64_MAX
    syn keyword cConstant UINT_FAST8_MAX UINT_FAST16_MAX UINT_FAST32_MAX UINT_FAST64_MAX
    syn keyword cConstant INTPTR_MIN INTPTR_MAX UINTPTR_MAX
    syn keyword cConstant INTMAX_MIN INTMAX_MAX UINTMAX_MAX
    syn keyword cConstant PTRDIFF_MIN PTRDIFF_MAX SIG_ATOMIC_MIN SIG_ATOMIC_MAX
    syn keyword cConstant SIZE_MAX WCHAR_MIN WCHAR_MAX WINT_MIN WINT_MAX
  endif
  syn keyword cConstant FLT_RADIX FLT_ROUNDS
  syn keyword cConstant FLT_DIG FLT_MANT_DIG FLT_EPSILON
  syn keyword cConstant DBL_DIG DBL_MANT_DIG DBL_EPSILON
  syn keyword cConstant LDBL_DIG LDBL_MANT_DIG LDBL_EPSILON
  syn keyword cConstant FLT_MIN FLT_MAX FLT_MIN_EXP FLT_MAX_EXP
  syn keyword cConstant FLT_MIN_10_EXP FLT_MAX_10_EXP
  syn keyword cConstant DBL_MIN DBL_MAX DBL_MIN_EXP DBL_MAX_EXP
  syn keyword cConstant DBL_MIN_10_EXP DBL_MAX_10_EXP
  syn keyword cConstant LDBL_MIN LDBL_MAX LDBL_MIN_EXP LDBL_MAX_EXP
  syn keyword cConstant LDBL_MIN_10_EXP LDBL_MAX_10_EXP
  syn keyword cConstant HUGE_VAL CLOCKS_PER_SEC NULL _NO_LEAP_SECONDS _LOCALTIME
  syn keyword cConstant LC_ALL LC_COLLATE LC_CTYPE LC_MONETARY
  syn keyword cConstant LC_NUMERIC LC_TIME
" syn keyword cConstant SIG_DFL SIG_ERR SIG_IGN
  syn keyword cAnsiFuncPtr SIG_DFL SIG_ERR SIG_IGN
  syn keyword cConstant SIGABRT SIGFPE SIGILL SIGHUP SIGINT SIGSEGV SIGTERM
  syn keyword cConstant INFINITY     FP_SUBNORMAL FP_ILOGB0
  syn keyword cConstant NAN          FP_ZERO      FP_ILOGBNAN
  syn keyword cConstant FP_INFINITE  FP_FAST_FMA
  syn keyword cConstant HUGE_VALF    FP_NAN       FP_FAST_FMAF
  syn keyword cConstant HUGE_VALL    FP_NORMAL    FP_FAST_FMAL
  syn keyword cConstant FE_OVERFLOW      FE_TOWARDZERO
  syn keyword cConstant FE_UNDERFLOW     FE_UPWARD
  syn keyword cConstant FE_DIVBYZERO     FE_ALL_EXCEPT    FE_DFL_ENV
  syn keyword cConstant FE_INEXACT       FE_DOWNWARD
  syn keyword cConstant FE_INVALID       FE_TONEAREST
  syn keyword cConstant	_Complex_I _Imaginary_I 
  " Add POSIX signals as well...
  syn keyword cConstant SIGABRT SIGALRM SIGCHLD SIGCONT SIGFPE SIGHUP
  syn keyword cConstant SIGILL SIGINT SIGKILL SIGPIPE SIGQUIT SIGSEGV
  syn keyword cConstant SIGSTOP SIGTERM SIGTRAP SIGTSTP SIGTTIN SIGTTOU
  syn keyword cConstant SIGUSR1 SIGUSR2
  syn keyword cConstant _IOFBF _IOLBF _IONBF BUFSIZ EOF WEOF
  syn keyword cConstant FOPEN_MAX FILENAME_MAX L_tmpnam
  syn keyword cConstant SEEK_CUR SEEK_END SEEK_SET
  syn keyword cConstant TMP_MAX stderr stdin stdout
  syn keyword cConstant EXIT_FAILURE EXIT_SUCCESS RAND_MAX
  " Add POSIX errors as well
  syn keyword cConstant E2BIG EACCES EAGAIN EBADF EBADMSG EBUSY
  syn keyword cConstant ECANCELED ECHILD EDEADLK EDOM EEXIST EFAULT
  syn keyword cConstant EFBIG EILSEQ EINPROGRESS EINTR EINVAL EIO EISDIR
  syn keyword cConstant EMFILE EMLINK EMSGSIZE ENAMETOOLONG ENFILE ENODEV
  syn keyword cConstant ENOENT ENOEXEC ENOLCK ENOMEM ENOSPC ENOSYS
  syn keyword cConstant ENOTDIR ENOTEMPTY ENOTSUP ENOTTY ENXIO EPERM
  syn keyword cConstant EPIPE ERANGE EROFS ESPIPE ESRCH ETIMEDOUT EXDEV
  " math.h
  syn keyword cConstant M_E M_LOG2E M_LOG10E M_LN2 M_LN10 M_PI M_PI_2 M_PI_4
  syn keyword cConstant M_1_PI M_2_PI M_2_SQRTPI M_SQRT2 M_SQRT1_2
endif
if !exists("c_no_c99") " ISO C99
  syn keyword cConstant true false __bool_true_false_are_defined
endif

" Accept %: for # (C99)
syn region	cPreCondit	start="^\s*\(%:\|#\)\s*\(ifdef\|ifndef\)\>" skip="\\$" end="$" end="//"me=s-1 contains=cComment,cCppString,cCharacter,cCppParen,cParenError,cNumbers,cCommentError,cSpaceError
syn keyword	cDefined	defined contained
"syn match	cDefined	display contained "\<defined(\w\+)" contains=cName,cAnsiName
syn region	cPreConditIf	start="^\s*\(%:\|#\)\s*\(if\|elif\)\>" skip="\\$" end="$" end="//"me=s-1 contains=cDefined,cComment,cCppString,cCharacter,cCppParen,cParenError,cNumbers,cCommentError,cSpaceError
syn match	cPreCondit	display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
if !exists("c_no_if0")
  syn region	cCppOut		start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=cCppOut2
  syn region	cCppOut2	contained start="0" end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=cSpaceError,cCppSkip
  syn region	cCppSkip	contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=cSpaceError,cCppSkip
endif
syn region	cIncluded	display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	cIncluded	display contained "<[^>]*>"
syn match	cInclude	display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=cIncluded
syn match cLineSkip	"\\$"
syn cluster	cPreProcGroup	contains=cPreConditIf,cPreCondit,cIncluded,cInclude,cDefined,cDefine,cErrInParen,cErrInBracket,cUserLabel,cUserLabel2,cGotoLabel,cSpecial,cOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom,cString,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cParen,cBracket,cMulti
"syn region	cDefine		start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" end="//"me=s-1 contains=ALLBUT,@cPreProcGroup,@Spell
syn region	cDefine		start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" end="//"me=s-1 contains=ALLBUT,@cPreProcGroup,cName,cFunction,cAnsiFunction,@Spell
syn region	cPreProc	start="^\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@cPreProcGroup,@Spell

" Highlight User Labels
syn cluster	cMultiGroup	contains=cIncluded,cSpecial,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cUserCont,cUserLabel,cUserLabel2,cGotoLabel,cBitField,cOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom,cCppParen,cCppBracket,cCppString
syn region	cMulti		transparent start='?' skip='::' end=':' contains=ALLBUT,@cMultiGroup,@Spell
" Avoid matching foo::bar() in C++ by requiring that the next char is not ':'
syn cluster	cLabelGroup	contains=cUserLabel
syn match	cUserCont	display "^\s*\I\i*\s*:$" contains=@cLabelGroup
syn match	cUserCont	display ";\s*\I\i*\s*:$" contains=@cLabelGroup
syn match	cUserCont	display "^\s*\I\i*\s*:[^:]"me=e-1 contains=@cLabelGroup
syn match	cUserCont	display ";\s*\I\i*\s*:[^:]"me=e-1 contains=@cLabelGroup

syn match	cUserLabel	display "\I\i*" contained
syn match	cUserLabel2	display "\I\i*:;\+"me=e-2
syn match	cGotoLabel	display "\<goto\s\+\I\i*;"me=e-1,hs=s+5 contains=cGoto
syn keyword	cGoto		contained goto

" Avoid recognizing most bitfields as labels
syn match	cBitField	display "^\s*\I\i*\s*:\s*[1-9]"me=e-1
syn match	cBitField	display ";\s*\I\i*\s*:\s*[1-9]"me=e-1

"syn match cOperator	"\(<<\|>>\|[-+*/%&^|<>!=]\)="
"syn match cOperator	"<<\|>>\|&&\|||\|++\|--\|->"
"syn match cOperator	"[.!~*&%<>^|=,+-]"
"syn match cOperator	"/[^/*=]"me=e-1
"syn match cOperator	"/$"
"syn match cOperator	"[][(){};\\]"
"syn match cOperatorBold	"&&\|||"
syn keyword	cType		CHAR byte BYTE uchar ushort uint ulong
syn keyword	cType		WORD DWORD QWORD INT INT2 INT4 UNS UNS2 UNS4 INT8 UNS8
syn keyword	cType		CFG_t cfap_t cBYTE cvoid
syn keyword	cType		_Bool _Complex _Imaginary __int64
if !exists("c_no_ansi") || exists("c_ansi_typedefs")
  syn keyword   cMC	__near __far FAR __io __direct DIR
endif

if exists("c_minlines")
  let b:c_minlines = c_minlines
else
  if !exists("c_no_if0")
    let b:c_minlines = 50	" #if 0 constructs can be long
  else
    let b:c_minlines = 15	" mostly for () constructs
  endif
endif
exec "syn sync ccomment cComment minlines=" . b:c_minlines

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_c_syn_inits")
  if version < 508
    let did_c_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cFormat	cSpecial
  HiLink cCppString	cString
  HiLink cCommentL	cComment
  HiLink cCommentStart	cComment
  HiLink cLabel		Label
" HiLink cUserLabel	Label
  HiLink cUserLabel	UserLabel2
  HiLink cUserLabel2	UserLabel2
  HiLink cGotoLabel	UserLabel2
  HiLink cGoto		Statement
  HiLink cConditional	Conditional
  HiLink cRepeat	Repeat
  HiLink cCharacter	Character
  HiLink cSpecialCharacter cSpecial
  HiLink cNumber	Number
  HiLink cOctal		Number
  HiLink cOctalZero	PreProc		" link this to Error if you want
  HiLink cFloat		Float
  HiLink cOctalError	cError
  HiLink cParenError	cError
  HiLink cErrInParen	cError
  HiLink cErrInBracket	cError
  HiLink cCommentError	cError
  HiLink cCommentStartError	cError
  HiLink cSpaceError	cError
  HiLink cSpecialError	cError
  HiLink cOperator	Operator
  HiLink cOperatorBold	OperatorBold
  HiLink cStructure	Structure
  HiLink cStorageClass	StorageClass
  HiLink cInclude	Include
  HiLink cPreProc	PreProc
  HiLink cDefine	Macro
  HiLink cDefined	PreCondit
  HiLink cIncluded	cString
  HiLink cError		Error
  HiLink cStatement	Statement
  HiLink cPreCondit	PreCondit
  HiLink cPreConditIf	PreCondit
  HiLink cType		Type
  HiLink cConstant	Constant
  HiLink cCommentString cString
  HiLink cComment2String cString
  HiLink cCommentSkip	cComment
  HiLink cString	String
  HiLink cComment	Comment
  HiLink cSpecial	SpecialChar
  HiLink cTodo		Todo
  HiLink cCppSkip	cCppOut
  HiLink cCppOut2	cCppOut
  HiLink cCppOut	Comment
  HiLink cMulti		Operator
  HiLink cMultiMG	Operator
  HiLink cFunction	Function
  HiLink cAnsiFunction	StdFunction
  HiLink cName		Name
  HiLink cBitField	Name
  HiLink cAnsiName	StdName
  "HiLink cBlock	BlockBraces
  HiLink cBraces	BlockBraces
  "HiLink cBraceError	Error
  HiLink cMC		MicroController
  HiLink cAnsiFuncPtr	AnsiFuncPtr

  hi Function		gui=NONE guifg=#e86f00
  "hi StdFunction	gui=bold guifg=#ee0040
  hi StdFunction	gui=bold guifg=#e86f00
  hi Statement		gui=bold guifg=#a06129
  hi UserLabel2		gui=bold guifg=#c96129
  hi Operator		gui=NONE guifg=#000000
  hi OperatorBold	gui=bold guifg=#000000
  hi StdName		gui=bold guifg=#5276e6
  hi Name		gui=NONE guifg=#5276e6
  hi BlockBraces	gui=bold guifg=#000000
  hi Special		gui=NONE guifg=#a000a0
  hi Comment		gui=NONE guifg=grey62
  hi MicroController	gui=bold guifg=#d00000
  hi AnsiFuncPtr	gui=NONE guifg=#ff0000
" hi PreProc        	gui=NONE guifg=#6a5acd
  hi PreCondit      	gui=NONE guifg=#6a5acd
" hi Macro          	gui=NONE guifg=#0000ff

  delcommand HiLink
endif
hi Normal		gui=NONE guifg=#000000 guibg=Ivory1

let b:current_syntax = "c"

" vim: ts=8
