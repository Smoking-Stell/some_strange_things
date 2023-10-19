"use strict"

const cnst = value => () => value;

const one = cnst(1);
const two = cnst(2);

const signVariables = {
  "x" : 0,
  "y" : 1,
  "z" : 2
}

const signConsts = {
  "one": one,
  "two": two
}

const variable = (varName) => {
  let index = signVariables[varName];
  return (...args) => args[index];
}

const operation = (operand) => {
  let func = (...args) => (...vars) => operand(...args.map(f => f(...vars)));
  func.count = operand.length;
  return func;
}

const negate = operation((x) => -x);
const add = operation((x, y) => x + y);
const subtract = operation((x, y) => x - y);
const multiply = operation((x, y) => x * y);
const divide = operation((x, y) => x / y);
const madd = operation((x, y, z) => (x * y + z));
const floor = operation(Math.floor);
const ceil = operation(Math.ceil);

const signOperation = {
  "negate": negate,
  "madd": madd,
  "floor": floor,
  "ceil": ceil,
  "*+": madd,
  "+": add,
  "-": subtract,
  "*": multiply,
  "/": divide,
  "_": floor,
  "^": ceil
};

function parse(expression) {
  let stack = [];
  expression.split(/\s+/).filter(x => x.length > 0).forEach(t => {
    if (t in signOperation) {
      const operand = signOperation[t];
      stack.push(operand(...stack.splice(-operand.count)));
    } else if (t in signConsts) {
      stack.push(signConsts[t]);
    } else if (t in signVariables) {
      stack.push(variable(t));
    } else {
      stack.push(cnst(+t));
    }
  });
  return stack.pop();
}

