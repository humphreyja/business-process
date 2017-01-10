Nonterminals
  grammar line function_call variable list static_value comma_list number
  .

Terminals
  '(' ')' '[' ']' ',' integer

  'true' 'false' '-' string symbol

  '.' identifier
  .


Rootsymbol grammar.

grammar -> line : '$1'.

line -> function_call : '$1'.
line -> variable : '$1'.
line -> list : '$1'.
line -> static_value : '$1'.


function_call -> identifier '(' comma_list ')' : #{type => 'function', name => extract_token('$1'), params => '$3'}.
function_call -> identifier '(' ')' : #{type => 'function', name => extract_token('$1'), params => []}.

comma_list -> line : ['$1'].
comma_list -> line ',' comma_list : ['$1'|'$3'].


variable -> identifier : #{type => 'variable', name => extract_token('$1')}.
variable -> identifier '.' variable : #{type => 'variable', name => extract_token('$1'), nested => '$3'}.

list -> '[' ']' : #{type => 'list', values => []}.
list -> '[' comma_list ']' : #{type => 'list', values => '$2'}.

static_value -> string : #{type => 'string', value => extract_token('$1')}.
static_value -> symbol : #{type => 'symbol', value => extract_token('$1')}.
static_value -> 'true' : #{type => 'boolean', value => 'true'}.
static_value -> 'false' : #{type => 'boolean', value => 'false'}.
static_value -> number : '$1'.

number -> integer : #{type => 'integer', value => extract_token('$1')}.
number -> integer '.' integer : #{type => 'float', integer => extract_token('$1'), decimal => extract_token('$3')}.
number -> '-' integer : #{type => 'integer', value => "-" ++ extract_token('$2')}.
number -> '-' integer '.' integer : #{type => 'float', integer => "-" ++ extract_token('$2'), decimal => extract_token('$4')}.

Erlang code.
  extract_token({_Token, _Line, Value}) -> Value.
  extract_line({_Token, Line, _Value}) -> Line.
  extract_min_line({_Token, Line}) -> Line.
