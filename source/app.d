import std.stdio;
import std.format;
import token;
import tokenizer;
import parser;
import stack_calculator;

private void help() {
    writeln(
        "\n"
        ~ "calc -- a simple command-line calculator\n"
        ~ "\n"
        ~ "usage: calc [options] expression\n"
        ~ "\n"
        ~ "Options:\n"
        ~ "\n"
        ~ "  -h, --help  show this help\n"
        ~ "  -r, --rpn   use \"Reverse Polish Notation\" (postfix)\n"
        ~ "\n"
        ~ "Operators: + - * / % ^\n"
        ~ "Functions: abs, acos, asin, atan, cos, cosh, exp, ln, log, neg,\n"
        ~ "           round, sin, sinh, sqrt, tan, tanh, trunc\n"
        ~ "Constants: e, pi\n"
        ~ "\n"
        ~ "For default infix expressions, function arguments must be given\n"
        ~ "in parenthesis. For RPN, parenthesis are illegal.\n"
        ~ "\n"
        ~ "Examples:\n"
        ~ "  calc \"sin(3.1415926)\"\n"
        ~ "  calc \"(5 + 3) * 7\"\n"
        ~ "  calc \"2^3\"\n"
        ~ "  calc -r \"pi sin\"\n"
        ~ "  calc -r \"5 3 + 7 *\"\n"
        ~ "  calc -r \"2 3 ^\"\n"
        ~ "  for Unix sh: A=`calc \"3+1\"`; B=`calc \"$A*4\"`\n"
    );
}

void calculate(string expression, bool rpn) {
    Token[] tokens = new Tokenizer(expression).tokenize();
    if (!rpn) {
        tokens = new Parser(tokens).parse();
    }
    writeln(format("%.15G", new StackCalculator(tokens).calculate()));
}

string readStdin() {
    string input = "";
    string line;
    while ((line = stdin.readln()) !is null) {
        input ~= line;
    }
    return input;
}

int main(string[] args) {
    bool rpn;
    string expression = "";
    for (int q = 1; q < args.length; q++) {
        if (args[q] == "-r" || args[q] == "--rpn") {
            rpn = true;
        } else if (args[q] == "-h" || args[q] == "--help") {
            help();
            return 0;
        } else {
            expression ~= " ";
            expression ~= args[q];
        }
    }
    if (expression.length == 0) {
        expression = readStdin();
    }
    try {
        calculate(expression, rpn);
    } catch (Exception e) {
        stderr.writeln("Error: " ~ e.msg);
        return 1;
    }
    return 0;
}
