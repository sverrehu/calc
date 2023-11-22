module tokenizer;

import std.uni;
import std.encoding;
import std.format;
import std.math.exponential;
import token;

class Tokenizer {

    private enum EOF = 0;
    private dchar[] input;
    private int index;

    this(string input) {
        foreach (c; codePoints(input)) {
            this.input ~= c;
        }
    }

    Token[] tokenize() {
        Token[] tokens;
        for (;; ) {
            Token token = nextToken();
            if (token is null) {
                break;
            }
            tokens ~= token;
        }
        return tokens;
    }

    private Token nextToken() {
        skipWhiteSpace();
        dchar c = currChar();
        if (c == EOF) {
            return null;
        }
        if (c == '.' || c >= '0' && c <= '9') {
            return new ValueToken(scanNumber());
        } else if (c == '_' || c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z') {
            return functionOrConstantToken(scanIdentifier());
        }
        nextChar();
        if (c == '+') {
            return new OperatorToken(Operator.ADDITION);
        } else if (c == '-') {
            return new OperatorToken(Operator.SUBTRACTION);
        } else if (c == '*') {
            return new OperatorToken(Operator.MULTIPLICATION);
        } else if (c == '/') {
            return new OperatorToken(Operator.DIVISION);
        } else if (c == '%') {
            return new OperatorToken(Operator.MODULUS);
        } else if (c == '^') {
            return new OperatorToken(Operator.EXPONENTIATION);
        } else if (c == '(') {
            return new OperatorToken(Operator.LEFT_PAREN);
        } else if (c == ')') {
            return new OperatorToken(Operator.RIGHT_PAREN);
        } else if (c == ',') {
            return new OperatorToken(Operator.COMMA);
        }
        throw new Exception(format("Unexpected character %s", c));
    }

    private void skipWhiteSpace() {
        for (;; ) {
            dchar c = currChar();
            if (!isWhite(c)) {
                break;
            }
            nextChar();
        }
    }

    private double scanNumber() {
        double number = 0.0;
        double divider = 0.1;
        bool dotSeen = false;
        dchar c;
        while ((c = currChar()) != EOF) {
            if (c == '.') {
                dotSeen = true;
            } else if (c == 'e' || c == 'E') {
                c = nextChar();
                if (c == EOF) {
                    error("Expected something after the exponent sign");
                }
                double sign = 1.0;
                if (c == '-') {
                    sign = -1.0;
                    c = nextChar();
                    if (c == EOF) {
                        error("Expected something after the exponent - sign");
                    }
                } else if (c == '+') {
                    c = nextChar();
                    if (c == EOF) {
                        error("Expected something after the exponent + sign");
                    }
                }
                double exp = scanNumber();
                number = number * pow(10.0, sign * exp);
                break;
            } else if (c >= '0' && c <= '9') {
                double digit = c - '0';
                if (dotSeen) {
                    number += digit * divider;
                    divider /= 10.0;
                } else {
                    number = number * 10.0 + digit;
                }
            } else {
                break;
            }
            nextChar();
        }
        return number;
    }

    private Token functionOrConstantToken(string identifier) {
        switch (identifier.toUpper) {
            case "ABS":
                return new FunctionToken(Function.ABS);
            case "ACOS":
                return new FunctionToken(Function.ACOS);
            case "ASIN":
                return new FunctionToken(Function.ASIN);
            case "ATAN":
                return new FunctionToken(Function.ATAN);
            case "COS":
                return new FunctionToken(Function.COS);
            case "COSH":
                return new FunctionToken(Function.COSH);
            case "EXP":
                return new FunctionToken(Function.EXP);
            case "LN":
                return new FunctionToken(Function.LN);
            case "LOG":
                return new FunctionToken(Function.LOG);
            case "ROUND":
                return new FunctionToken(Function.ROUND);
            case "SIN":
                return new FunctionToken(Function.SIN);
            case "SINH":
                return new FunctionToken(Function.SINH);
            case "SQRT":
                return new FunctionToken(Function.SQRT);
            case "TAN":
                return new FunctionToken(Function.TAN);
            case "TANH":
                return new FunctionToken(Function.TANH);
            case "TRUNC":
                return new FunctionToken(Function.TRUNC);
            case "NEG":
                return new FunctionToken(Function.NEG);
            case "E":
                return new ConstantToken(Constant.E);
            case "PI":
                return new ConstantToken(Constant.PI);
            default:
                error("Unknown function or constant " ~ identifier);
        }
        return null;
    }

    private string scanIdentifier() {
        string identifier;
        dchar c = currChar();
        while (c != EOF && (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z')) {
            identifier ~= c;
            c = nextChar();
        }
        return identifier;
    }

    private dchar currChar() {
        if (index >= input.length) {
            return EOF;
        }
        return input[index];
    }

    private dchar nextChar() {
        if (index >= input.length - 1) {
            ++index;
            return EOF;
        }
        return input[++index];
    }

    private dchar peekNextChar() {
        if (index >= input.length - 1) {
            return EOF;
        }
        return input[index + 1];
    }

    private void error(string message) {
        throw new Exception(message);
    }

}

unittest {
    Token[] tokens = new Tokenizer("2.0e-1*SIN(PI)").tokenize();
    assert(tokens.length == 6);
    assert(cast(ValueToken) tokens[0]);
    assert((cast(ValueToken) tokens[0]).value == 0.2);
    assert(cast(OperatorToken) tokens[1]);
    assert((cast(OperatorToken) tokens[1]).operator == Operator.MULTIPLICATION);
    assert(cast(FunctionToken) tokens[2]);
    assert((cast(FunctionToken) tokens[2]).func == Function.SIN);
    assert(cast(OperatorToken) tokens[3]);
    assert((cast(OperatorToken) tokens[3]).operator == Operator.LEFT_PAREN);
    assert(cast(ConstantToken) tokens[4]);
    assert((cast(ConstantToken) tokens[4]).constant == Constant.PI);
    assert(cast(OperatorToken) tokens[5]);
    assert((cast(OperatorToken) tokens[5]).operator == Operator.RIGHT_PAREN);
}
