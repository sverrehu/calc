module token;

enum Operator {
    ADDITION, SUBTRACTION, MULTIPLICATION, DIVISION, MODULUS, NEGATION, EXPONENTIATION, LEFT_PAREN,RIGHT_PAREN, COMMA
}

enum Function {
    ABS, ACOS, ASIN, ATAN, COS, COSH, EXP, LN, LOG, ROUND, SIN, SINH, SQRT, TAN, TANH, TRUNC, NEG
}

enum Constant {
    E, PI
}

class Token {
}

class ValueToken : Token {
    double value;

    this(double value) {
        this.value = value;
    }
}

class OperatorToken : Token {
    Operator operator;

    this(Operator operator) {
        this.operator = operator;
    }
}

class FunctionToken : Token {
    Function func;

    this(Function func) {
        this.func = func;
    }
}

class ConstantToken : Token {
    Constant constant;

    this(Constant constant) {
        this.constant = constant;
    }
}
