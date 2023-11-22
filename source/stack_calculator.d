module stack_calculator;

import std.stdio;
import std.algorithm;
import std.math;
import std.math.algebraic;
import std.math.trigonometry;
import std.math.rounding;
import std.math.exponential;
import token;

double[] stack;

void push(double d) {
    stack ~= d;
}

double pop() {
    if (stack.length == 0) {
        throw new Exception("pop called with empty stack");
    }
    double value = stack[$ - 1];
    --stack.length;
    return value;
}

double popLast() {
    double value = pop();
    if (stack.length != 0) {
        throw new Exception("Stack is not empty when it should be. Too many values, too few operators.");
    }
    return value;
}

void negate() {
    double operand1 = pop();
    push(-operand1);
}

void add() {
    double operand2 = pop();
    double operand1 = pop();
    push(operand1 + operand2);
}

void subtract() {
    double operand2 = pop();
    double operand1 = pop();
    push(operand1 - operand2);
}

void multiply() {
    double operand2 = pop();
    double operand1 = pop();
    push(operand1 * operand2);
}

void divide() {
    double operand2 = pop();
    double operand1 = pop();
    push(operand1 / operand2);
}

void modulus() {
    double operand2 = pop();
    double operand1 = pop();
    push(operand1 % operand2);
}

void exponentiate() {
    double operand2 = pop();
    double operand1 = pop();
    push(pow(operand1, operand2));
}

double calculate(Token[] tokens) {
    stack.length = 0;
    foreach (Token token; tokens) {
        if (cast(ValueToken) token) {
            push((cast(ValueToken) token).value);
        } else if (cast(OperatorToken) token) {
            Operator operator = (cast(OperatorToken) token).operator;
            switch (operator) {
                case Operator.ADDITION:
                    add();
                    break;
                case Operator.SUBTRACTION:
                    subtract();
                    break;
                case Operator.MULTIPLICATION:
                    multiply();
                    break;
                case Operator.DIVISION:
                    divide();
                    break;
                case Operator.MODULUS:
                    modulus();
                    break;
                case Operator.NEGATION:
                    negate();
                    break;
                case Operator.EXPONENTIATION:
                    exponentiate();
                    break;
                default:
                    throw new Exception("Unhandled Operator");
            }
        } else if (cast(FunctionToken) token) {
            Function func = (cast(FunctionToken) token).func;
            switch (func) {
                case Function.ABS:
                    push(fabs(pop()));
                    break;
                case Function.ACOS:
                    push(acos(pop()));
                    break;
                case Function.ASIN:
                    push(asin(pop()));
                    break;
                case Function.ATAN:
                    push(atan(pop()));
                    break;
                case Function.COS:
                    push(cos(pop()));
                    break;
                case Function.COSH:
                    push(cosh(pop()));
                    break;
                case Function.EXP:
                    push(exp(pop()));
                    break;
                case Function.LN:
                    push(log(pop()));
                    break;
                case Function.LOG:
                    push(log10(pop()));
                    break;
                case Function.ROUND:
                    push(round(pop()));
                    break;
                case Function.SIN:
                    push(sin(pop()));
                    break;
                case Function.SINH:
                    push(sinh(pop()));
                    break;
                case Function.SQRT:
                    push(sqrt(pop()));
                    break;
                case Function.TAN:
                    push(tan(pop()));
                    break;
                case Function.TANH:
                    push(tanh(pop()));
                    break;
                case Function.TRUNC:
                    push(trunc(pop()));
                    break;
                case Function.NEG:
                    push(-pop());
                    break;
                default:
                    throw new Exception("Unhandled Function");
            }
        } else if (cast(ConstantToken) token) {
            Constant constant = (cast(ConstantToken) token).constant;
            switch (constant) {
                case Constant.E:
                    push(E);
                    break;
                case Constant.PI:
                    push(PI);
                    break;
                default:
                    throw new Exception("Unhandled Constant");
            }
        } else {
            throw new Exception("Unexpected Token class");
        }
    }
    return popLast();
}

unittest {
    push(1);
    push(2);
    assert(pop() == 2);
    assert(pop() == 1);
    assert(stack.length == 0);

    push(1);
    negate();
    assert(pop() == -1);

    push(2);
    push(3);
    add();
    assert(pop() == 2 + 3);

    push(2);
    push(3);
    subtract();
    assert(pop() == 2 - 3);

    push(2);
    push(3);
    multiply();
    assert(pop() == 2 * 3);

    push(16);
    push(4);
    divide();
    assert(pop() == 16 / 4);

    push(10);
    push(3);
    modulus();
    assert(pop() == 10 % 3);

    push(10);
    push(3);
    exponentiate();
    assert(pop() == pow(10, 3));
}
