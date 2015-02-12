//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Tikhon Belousko on 07/02/15.
//  Copyright (c) 2015 Tikhon Belousko. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable {
        case Operand(Double)
        case Variable(String)
        case Constant(String, Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Constant(let symbol, _):
                    return "\(symbol)"
                case .Variable(let symbol):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    var variableValues = [String:Double]()
    
    private func description(ops: [Op], printComma: Bool) -> (result: String, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
//            switch op {
//            case .Variable(let symbol):
//                if printComma {
//                    let (res, ops1) = description(remainingOps, false)
//                    return (symbol+",", description(remainingOps, false))
//                } else {
//                    return (symbol+",", description(remainingOps, false))
//                }
//                
//            case .Operand(let operand):
//                return ("\(operand)", remainingOps)
//            case .UnaryOperation(let operation, _):
//                return ("\(operation)(\(description(remainingOps)))", remainingOps)
//            case .BinaryOperation(let operation, _):
//                let op1 = description(remainingOps)
//                let op2 = description(op1.remainingOps)
//                return ("\(op1.result)\(operation)\(op2.result)", op2.remainingOps)
//            }
        }
        return ("", ops)
    }
    
    var description: String {
        get {
//            return description(opStack).result
            return opStack.description
        }
    }
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["π"] = Op.Constant("π", M_PI)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Variable(let symbol):
                return (variableValues[symbol], remainingOps)
            case .Constant(_, let constant):
                return (constant, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let op1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let op2 = op2Evaluation.result {
                        return (operation(op1, op2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        return evaluate(opStack).result
    }
    
    func pushVariable(symbol: String) -> Double? {
        opStack.append(.Variable(symbol))
        return evaluate()
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear() {
        opStack.removeAll()
    }
    
}