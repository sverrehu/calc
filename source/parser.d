module parser;

import token;

class Parser {

    private Token[] inTokens;
    private uint index;
    private Token token;
    private Token[] outTokens;

    this(Token[] inTokens)
    {
        this.inTokens = inTokens;
    }

    private bool eof() {
        return token is null;
    }

    private void next() {
        if (index >= inTokens.length) {
            token = null;
        } else {
            token = inTokens[index++];
        }
    }

    private void nextCheckEof() {
        next();
        if (eof()) {
            error("err.unexpectedEndOfInput");
        }
    }

    private bool isOperatorMatch(Operator ot) {
        if (eof()) {
            return false;
        }
        if (!(cast(const(OperatorToken)) token)) {
            return false;
        }
        return (cast(const(OperatorToken)) token).operator == ot;
    }

    private void parseFunctionExpression() {
        FunctionToken functionToken = cast(FunctionToken) token;
        next();
        if (!isOperatorMatch(Operator.LEFT_PAREN)) {
            error("Missing ( after function name");
        }
        nextCheckEof();
        while (!isOperatorMatch(Operator.RIGHT_PAREN)) {
            parseExpression();
            if (isOperatorMatch(Operator.COMMA)) {
                nextCheckEof();
                if (isOperatorMatch(Operator.RIGHT_PAREN)) {
                    error("Missing function argument after comma");
                }
            }
        }
        next();
        outTokens ~= functionToken;
    }

    private void parsePrimaryExpression() {
        if (cast(const(ValueToken)) token || cast(const(ConstantToken)) token) {
            outTokens ~= token;
            next();
            return;
        }
        if (cast(const(FunctionToken)) token) {
            parseFunctionExpression();
            return;
        }
        if (isOperatorMatch(Operator.LEFT_PAREN)) {
            nextCheckEof();
            parseExpression();
            if (!isOperatorMatch(Operator.RIGHT_PAREN)) {
                error("Unmatched parenthesis");
            }
            next();
            return;
        }
        error("Unexpected operator");
    }

    private void parseUnaryExpression() {
        bool negate = false;
        Operator operatorType;
        if (isOperatorMatch(Operator.SUBTRACTION)) {
            operatorType = Operator.SUBTRACTION;
            negate = true;
            nextCheckEof();
        } else if (isOperatorMatch(Operator.ADDITION)) {
            nextCheckEof();
        }
        parsePrimaryExpression();
        if (negate) {
            outTokens ~= new OperatorToken(Operator.NEGATION);
        }
    }

    private void parseExponentialExpression() {
        parseUnaryExpression();
        int count;
        while (isOperatorMatch(Operator.EXPONENTIATION)) {
            nextCheckEof();
            parseUnaryExpression();
            ++count;
        }
        for (int q = 0; q < count; q++) {
            outTokens ~= new OperatorToken(Operator.EXPONENTIATION);
        }
    }

    private void parseMultiplicativeExpression() {
        parseExponentialExpression();
        while (isOperatorMatch(Operator.MULTIPLICATION) || isOperatorMatch(Operator.DIVISION) || isOperatorMatch(Operator.MODULUS)) {
            Token operatorToken;
            if (isOperatorMatch(Operator.MULTIPLICATION)) {
                operatorToken = new OperatorToken(Operator.MULTIPLICATION);
            } else if (isOperatorMatch(Operator.DIVISION)) {
                operatorToken = new OperatorToken(Operator.DIVISION);
            } else {
                operatorToken = new OperatorToken(Operator.MODULUS);
            }
            nextCheckEof();
            parseExponentialExpression();
            outTokens ~= operatorToken;
        }
    }

    private void parseAdditiveExpression() {
        parseMultiplicativeExpression();
        while (isOperatorMatch(Operator.ADDITION) || isOperatorMatch(Operator.SUBTRACTION)) {
            Token operatorToken;
            if (isOperatorMatch(Operator.ADDITION)) {
                operatorToken = new OperatorToken(Operator.ADDITION);
            } else {
                operatorToken = new OperatorToken(Operator.SUBTRACTION);
            }
            nextCheckEof();
            parseMultiplicativeExpression();
            outTokens ~= operatorToken;
        }
    }

    private void parseExpression() {
        parseAdditiveExpression();
    }

    public Token[] parse() {
        nextCheckEof();
        parseExpression();
        if (!eof()) {
            error("Unexpected text at the end");
        }
        return outTokens;
    }

    private void error(string message) {
        throw new Exception(message);
    }

}
