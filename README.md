# calc

Just my first experiments with the D language: A simple command-line
calculator that supports infix and postfix (Reverse Polish Notation)
expressions.

I was just Googling as I moved along to get a workable syntax, so this
is by no means an example of how D should be written.

## Example usage

```text
$ ./calc 1 + 2
3
$ ./calc '1+2*3'
7
$ ./calc '(1 + 2) * 3'
9
$ ./calc '9^2'
81
$ ./calc 'sin(PI / 2)'
1
$ ./calc --rpn '1 2 3 * +'
7
$ ./calc -r '1 2 + 3 *'
9
$ ./calc -r 'PI cos'
-1
$ ./calc -r 81 sqrt
9
$ ./calc -h

calc -- a simple command-line calculator

usage: calc [options] expression

Options:

  -h, --help  show this help
  -r, --rpn   use "Reverse Polish Notation" (postfix)

Operators: + - * / % ^
Functions: abs, acos, asin, atan, cos, cosh, exp, ln, log, neg,
           round, sin, sinh, sqrt, tan, tanh, trunc
Constants: e, pi

For default infix expressions, function arguments must be given
in parenthesis. For RPN, parenthesis are illegal.

Examples:
  calc "sin(3.1415926)"
  calc "(5 + 3) * 7"
  calc "2^3"
  calc -r "pi sin"
  calc -r "5 3 + 7 *"
  calc -r "2 3 ^"
  for Unix sh: A=`calc "3+1"`; B=`calc "$A*4"`
```

Whitespace around operators is optional. Quotes or other escaping is
needed for expressions using shell special characters, like `*` for
multiplication.
