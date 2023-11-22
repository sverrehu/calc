import std.stdio;
import token;
import tokenizer;
import parser;
import stack_calculator;

void main(string[] args) {
    bool rpn;
    string expression = "";
    for (int q = 1; q < args.length; q++) {
        if (args[q] == "-r" || args[q] == "--rpn") {
            rpn = true;
        } else {
            expression ~= " ";
            expression ~= args[q];
        }
    }
    Token[] tokens = new Tokenizer(expression).tokenize();
    if (!rpn) {
        tokens = new Parser(tokens).parse();
    }
    writeln(new StackCalculator(tokens).calculate());
}
