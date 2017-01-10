Definitions.

R_PAREN    = \)
L_PAREN    = \(
R_BRACKET    = \]
L_BRACKET    = \[
COMMA      = ,
INT   = [0-9]+
STRING = \".*\"

KEYWORD_TRUE = true
KEYWORD_FALSE = false

OP_SUB = \-
OP_DOT = \.


WHITESPACE = [\s\t\r]
SYMBOL = \:[a-zA-Z_][a-zA-Z0-9_]*
IDENTIFIER = [a-zA-Z_][a-zA-Z0-9_]*


Rules.

{R_PAREN}   : {token, {')', TokenLine}}.
{L_PAREN}   : {token, {'(', TokenLine}}.
{R_BRACKET}   : {token, {']', TokenLine}}.
{L_BRACKET}   : {token, {'[', TokenLine}}.
{COMMA}     : {token, {',', TokenLine}}.
{INT}   : {token, {integer, TokenLine, TokenChars}}.
{STRING}   : {token, {string, TokenLine, TokenChars}}.

{KEYWORD_TRUE} : {token, {'true', TokenLine}}.
{KEYWORD_FALSE} : {token, {'false', TokenLine}}.

{OP_SUB} : {token, {'-', TokenLine}}.
{OP_DOT} : {token, {'.', TokenLine}}.

{WHITESPACE}+ : skip_token.

{IDENTIFIER}   : {token, {identifier, TokenLine, TokenChars}}.
{SYMBOL}   : {token, {symbol, TokenLine, TokenChars}}.

Erlang code.
