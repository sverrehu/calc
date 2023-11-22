module stack_calculator;

import std.stdio;
import std.algorithm;
import std.math;
import std.math.algebraic;
import std.math.trigonometry;
import std.math.rounding;
import std.math.exponential;
import token;

class StackCalculator {

    private double[] stack;
    private Token[] tokens;

    this(Token[] tokens) {
        this.tokens = tokens;
    }

    private void push(double d) {
        stack ~= d;
    }

    private double pop() {
        if (stack.length == 0) {
            throw new Exception("pop called with empty stack");
        }
        double value = stack[$ - 1];
        --stack.length;
        return value;
    }

    private double popLast() {
        double value = pop();
        if (stack.length != 0) {
            throw new Exception("Stack is not empty when it should be. Too many values, too few operators.");
        }
        return value;
    }

    private void negate() {
        double operand1 = pop();
        push(-operand1);
    }

    private void add() {
        double operand2 = pop();
        double operand1 = pop();
        push(operand1 + operand2);
    }

    private void subtract() {
        double operand2 = pop();
        double operand1 = pop();
        push(operand1 - operand2);
    }

    private void multiply() {
        double operand2 = pop();
        double operand1 = pop();
        push(operand1 * operand2);
    }

    private void divide() {
        double operand2 = pop();
        double operand1 = pop();
        push(operand1 / operand2);
    }

    private void modulus() {
        double operand2 = pop();
        double operand1 = pop();
        push(operand1 % operand2);
    }

    private void exponentiate() {
        double operand2 = pop();
        double operand1 = pop();
        push(pow(operand1, operand2));
    }

    double calculate() {
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

}

unittest {
    StackCalculator sc = new StackCalculator(null);

    sc.push(1);
    sc.push(2);
    assert(sc.pop() == 2);
    assert(sc.pop() == 1);
    assert(sc.stack.length == 0);

    sc.push(1);
    sc.negate();
    assert(sc.pop() == -1);

    sc.push(2);
    sc.push(3);
    sc.add();
    assert(sc.pop() == 2 + 3);

    sc.push(2);
    sc.push(3);
    sc.subtract();
    assert(sc.pop() == 2 - 3);

    sc.push(2);
    sc.push(3);
    sc.multiply();
    assert(sc.pop() == 2 * 3);

    sc.push(16);
    sc.push(4);
    sc.divide();
    assert(sc.pop() == 16 / 4);

    sc.push(10);
    sc.push(3);
    sc.modulus();
    assert(sc.pop() == 10 % 3);

    sc.push(10);
    sc.push(3);
    sc.exponentiate();
    assert(sc.pop() == pow(10, 3));
}
