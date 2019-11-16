" Vim syntax file
" Language:	JCON
" Maintainer:	Lasana Murray <metasansana@gmail.com> https://trinistorm.org
" Descrption:  JCON is a small JSON-like DSL for configuration options. 

" This line is supposed to prevent the syntax from loading > 1
if exists("b:current_syntax")
  finish
endif

" Note: The precendence of the rules specified here are bottom up.
"       That is, the later rules are matched before the ones before it.

"" Keywords 
syntax keyword jconInclude include
syntax keyword jconBoolean true false contained

" These are basic punctuations and operators used. Match will simply try to
" satisfy our regexes.
syntax match jconAssigner "="
syntax match jconComma "," contained
syntax match jconDot "\v[.]" contained

" Comments (single line only)
syntax match jconComment "\v--(.*)$"

" Various supported number syntaxes.
syntax match jconNumber 
      \ "\v([-]?[-]?([0]|([1-9]([0-9]+)*))\.([0-9]+)*)|(\.[0-9]+)|([-]?([0]|[1-9]([0-9]+)*))" 
      \ contained

" Strings, only double quotes are supported. 
syntax region jconString 
      \ start=/"/ 
      \ skip=/\\"/ 
      \ end=/"/
      \ contains=jconUnicodeEscape,jconCharEscape,jconLineContinuation,
      \ jconLineContinuationError

syntax match jconUnicodeEscape "\v\\u[0-9a-fA-F]{4}" contained
syntax match jconCharEscape "\v\\["\\bfnrtv]" contained 
syntax match jconLineContinuation +\v[\\]\n[^"]*+ contained 
syntax match jconLineContinuationError +\v\n[^"]*+ contained 

" Dict (Record)
" This is a region so any text between 'start' and 'end' will be higlighted.
" To prevent the whole structure from being one color, we specify the other
" expected patterns in 'contains'
syntax region jconDict 
      \ start="\v\{"
      \ end="\v\}"
      \ contains=@jconValue,jconAssignment
      \ contained

" Arrays
syntax region jconArray 
      \ start="\v\["
      \ end="\v\]" 
      \ contains=@jconValue
      \ contained

" Imports
syntax region jconArgs 
      \ start="\v\("
      \ end="\v\)"
      \ contains=@jconValue
      \ contained

syntax match jconMember "\v[a-zA-Z_$][a-zA-Z_$-0-9]*" 
      \ contains=jconArgs 
      \ nextgroup=jconArgs
      \ skipwhite 
      \ contained

syntax region jconImport 
      \ matchgroup=jconModule 
      \ start="\v[.$/a-zA-Z@][.$/0-9a-zA-Z-@_-]*" 
      \ matchgroup=jconHash 
      \ end="#"
      \ nextgroup=jconMember 
      \ skipwhite
      \ contained

syntax match jconIdentifier "\v[a-zA-Z_][a-zA-Z_$0-9-]*" contained

syntax region jconVariable 
      \ start="\v\$\(" 
      \ end=")"
      \ contains=jconIdentifier
      \ contained

" Environment variables.
syntax region jconEnvvar start="${" end="}" contains=jconIdentifier contained

" This is the top level match for the syntax, though it can be found nested
" in dicts too. Matchgroup is used to give color to the '=' sign.
syntax region jconAssignment
      \ start="\v[a-zA-Z_$][a-zA-Z_$0-9-]*" 
      \ matchgroup=jconAssigner
      \ end="=" 
      \ contains=jconDot
      \ nextgroup=@jconValue
      \ skipwhite 
      \ skipnl 

" This groups the value syntax together so they can be re-used.
syntax cluster jconValue 
      \ contains=jconNumber,jconBoolean,jconString,jconVariable,jconEnvvar,
      \ jconImport,jconArray,jconDict

" Below actually does the higlighting.
highlight default link jconDot Delimiter
highlight default link jconAssignment Type
highlight default link jconAssigner Operator
highlight default link jconBoolean Boolean
highlight default link jconNumber Number
highlight default link jconString String
highlight default link jconUnicodeEscape Delimiter
highlight default link jconCharEscape Delimiter
highlight default link jconLineContinuation String
highlight default link jconLineContinuationError Error
highlight default link jconEnvvar Delimiter
highlight default link jconVariable Delimiter
highlight default link jconIdentifier Macro
highlight default link jconArray Delimiter
highlight default link jconDict Delimiter
highlight default link jconComma Statement
highlight default link jconModule Constant
highlight default link jconMember Identifier
highlight default link jconArgs Operator
highlight default link jconHash Comment
highlight default link jconInclude Include
highlight default link jconComment Comment
