"use strict"

function generalFactory(constructorName, evaluateValue, toStringValue, diffValue){
  constructorName.prototype.evaluate = evaluateValue;
  constructorName.prototype.diff = diffValue;
  constructorName.prototype.toString = toStringValue;
}

// for constants
function Const(constName) {
  this.value = constName;
}

const zerofication = new Const(0);
const one = new Const(1);
const two = new Const(2);

const signConsts = {
  "zero": zerofication,
  "one": one,
  "two": two
}

generalFactory(Const,
  function(...vars) { return this.value},
  function() { return this.value + ""},
  function(varForDiff) { return zerofication}
);

// for variables
const signVariables = {
  "x" : 0,
  "y" : 1,
  "z" : 2
}

generalFactory(Variable,
  function(...vars) {
    return vars[this.valueInd]
  },
  function() {
    return this.name
  },
  function(varForDiff) {
      return this.name === varForDiff ? one : zerofication
  }
);

function Variable(varName) {
  this.name = varName;
  this.valueInd = signVariables[varName];
}

//for Operations
function Operation(...args) {
  this.args = args;
}

generalFactory(Operation,
  function(...vars) {
    return this.operation(...this.args.map(f => f.evaluate(...vars)));
  },
  function() {
    return this.args.join(" ") + " " + this.sign;
  },
  function(varForDiff) {
    return this.diffForFunc(varForDiff, ...this.args);
  }
);

const operationFactory = function(sign, operation, differential){
  // :NOTE: const
  let object = function (...params) {
    Operation.call(this, ...params);
  }
  object.prototype = Object.create(Operation.prototype);
  object.count = operation.length;
  object.prototype.sign = sign;
  object.prototype.operation = operation;
  object.prototype.diffForFunc = differential;
  return object;
}

const Negate = operationFactory("negate",
  x => -x,
  (varForDiff, x) => new Negate(x.diff(varForDiff)));

const Add = operationFactory("+",
  (x, y) => (x + y),
  (varForDiff, x, y) => new Add(x.diff(varForDiff), y.diff(varForDiff))
);

const Subtract = operationFactory("-",
  (x, y) => (x - y),
  (varForDiff, x, y) => new Subtract(x.diff(varForDiff), y.diff(varForDiff))
);

const Multiply = operationFactory("*",
  (x, y) => (x * y),
  (varForDiff, x, y) => new Add(new Multiply(x.diff(varForDiff), y),
                                          new Multiply(y.diff(varForDiff), x))
);

const Sqr = operationFactory("unused",
  x => (x * x),
  (varForDiff, x) => new Multiply(x.diff(varForDiff), x)
);

const Divide = operationFactory("/",
  (x, y) => (x / y),
  (varForDiff, x, y) => new Divide(
                                  new Subtract(new Multiply(x.diff(varForDiff), y), new Multiply(y.diff(varForDiff), x)),
                                  new Sqr(y))
);

const Hypot = operationFactory("hypot",
  (x, y) => (x * x + y * y),
  (varForDiff, x, y) => new Multiply (two, new Add(new Multiply(x.diff(varForDiff), x),
    new Multiply(y.diff(varForDiff), y)))
);

const HMean = operationFactory("hmean",
  (x, y) => (2 / (1 / x + 1 / y)),
  (varForDiff, x, y) => new Multiply(two, new Divide (
      new Subtract(
        new Multiply(new Add(new Multiply(x.diff(varForDiff), y), new Multiply(y.diff(varForDiff), x)), new Add(x, y)),
        new Multiply(new Multiply(x, y), new Add(x.diff(varForDiff), y.diff(varForDiff)))
      ),
      new Sqr(new Add(x, y))
    )
  )
);

const signOperation = {
  "negate": Negate,
  "+": Add,
  "-": Subtract,
  "*": Multiply,
  "/": Divide,
  "hypot": Hypot,
  "hmean": HMean,
  "unused": Sqr
};


//parser
function parse(expression) {
  let stack = [];
  expression.split(/\s+/).filter(x => x.length > 0).forEach(t => {
    if (t in signOperation) {
      const operand = signOperation[t];
      let last = new operand(...stack.splice(-operand.count));
      stack.push(last);
    } else if (t in signConsts) {
      stack.push(new Const(signConsts[t]));
    } else if (t in signVariables) {
      stack.push(new Variable(t));
    } else {
      stack.push(new Const(+t));
    }
  });
  return stack.pop();
}
