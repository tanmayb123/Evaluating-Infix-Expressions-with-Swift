//: Playground - noun: a place where people can play

import UIKit

class Stack {
    
    var selfvalue: [String] = []
    var peek: String {
        get {
            if selfvalue.count != 0 {
                return selfvalue[selfvalue.count-1]
            } else {
                return ""
            }
        }
    }
    var empty: Bool {
        get {
            return selfvalue.count == 0
        }
    }
    
    func push(value: String) {
        selfvalue.append(value)
    }
    
    func pop() -> String {
        var temp = String()
        if selfvalue.count != 0 {
            temp = selfvalue[selfvalue.count-1]
            selfvalue.removeAtIndex(selfvalue.count-1)
        } else if selfvalue.count == 0 {
            temp = ""
        }
        return temp
    }
    
}

extension String {
    
    var precedence: Int {
        get {
            switch self {
                case "+":
                return 1
                case "-":
                return 1
                case "*":
                return 0
                case "/":
                return 0
            default:
                return 100
            }
        }
    }
    
    var isOperator: Bool {
        get {
            return ("+-*/" as NSString).containsString(self)
        }
    }
    
    var isNumber: Bool {
        get {
            return !isOperator && self != "(" && self != ")"
        }
    }
    
}

//THIS EXTENSION IS BY ALECLARSON (http://stackoverflow.com/a/24144365) ON STACKOVERFLOW!
extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}

//THIS EXTENSION IS BY ALEX WAYNE (http://stackoverflow.com/a/25330930) ON STACKOVERFLOW!
extension Array {
    
    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func get(index: Int) -> T? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}

class infixparser {
    
    func bracketEngine(expression: String) -> String {
        
        //PARSE, THEN SOLVE.
        
        func bracketParsing(exp: String) -> [String] {
            var finalStrings = [""]
            for (ind, tok) in exp.characters.enumerate() {
                var tokAsString = "\(tok)"
                if tokAsString == "(" {
                    finalStrings.append(tokAsString)
                } else if !finalStrings[finalStrings.count-1].characters.contains(")") && finalStrings[finalStrings.count-1].characters.contains("(") {
                    finalStrings[finalStrings.count-1] += tokAsString
                }
            }
            finalStrings.removeAtIndex(0)
            return finalStrings
        }
        
        func bracketSolving(brackets: [String]) -> String {
            var finalString = expression
            for i in brackets {
                var result = solve(i.stringByReplacingOccurrencesOfString("(", withString: "").stringByReplacingOccurrencesOfString(")", withString: ""))
                finalString = finalString.stringByReplacingOccurrencesOfString(i, withString: "\(result)")
            }
            return finalString
        }
        
        return bracketSolving(bracketParsing(expression))
        
    }
    
    func solve(var expression: String) -> Int {
        
        expression = expression.characters.contains("(") ? bracketEngine(expression) : expression
        var operatorStack = Stack()
        var operandStack = Stack()
        var tokens = expression.componentsSeparatedByString(" ")
        
        for (index, token) in tokens.enumerate() {
            
            "\(token) at \(index)"
            
            if token.isNumber {
                operandStack.push(token)
            }
            
            if token.isOperator {
                while operatorStack.peek.precedence <= token.precedence {
                    if !operatorStack.empty {
                        var res = 0
                        switch operatorStack.peek {
                        case "+":
                            res = Int(operandStack.pop())! + Int(operandStack.pop())!
                        case "-":
                            res = Int(operandStack.selfvalue[operandStack.selfvalue.count-2])! - Int(operandStack.pop())!
                            operandStack.pop()
                        case "*":
                            res = Int(operandStack.pop())! * Int(operandStack.pop())!
                        case "/":
                            res = Int(operandStack.selfvalue[operandStack.selfvalue.count-2])! / Int(operandStack.pop())!
                            operandStack.pop()
                        default:
                            res = 0
                        }
                        "\(res) at \(index)"
                        operatorStack.pop()
                        operandStack.push("\(res)")
                    }
                }
                operatorStack.push(token)
            }
            
        }
        
        while !operatorStack.empty {
            var res = 0
            switch operatorStack.peek {
            case "+":
                res = Int(operandStack.pop())! + Int(operandStack.pop())!
            case "-":
                res = Int(operandStack.selfvalue[operandStack.selfvalue.count-2])! - Int(operandStack.pop())!
                operandStack.pop()
            case "*":
                res = Int(operandStack.pop())! * Int(operandStack.pop())!
            case "/":
                res = Int(operandStack.selfvalue[operandStack.selfvalue.count-2])! / Int(operandStack.pop())!
                operandStack.pop()
            default:
                res = 0
            }
            operatorStack.pop()
            operandStack.push("\(res)")
        }
        
        
        return Int(operandStack.pop())!
        
    }
    
}

var parser = infixparser()
parser.solve("2 + 4 * 9 / 4 * 9 + 2 - 4")
