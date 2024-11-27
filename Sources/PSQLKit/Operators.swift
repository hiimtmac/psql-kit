// Operators.swift
// Copyright (c) 2024 hiimtmac inc.

postfix operator .*
infix operator ...: LogicalConjunctionPrecedence
infix operator ><: ComparisonPrecedence
infix operator <>: ComparisonPrecedence
infix operator ~~: ComparisonPrecedence
infix operator !~~: ComparisonPrecedence
infix operator ~~*: ComparisonPrecedence
infix operator !~~*: ComparisonPrecedence
infix operator =>: ComparisonPrecedence

precedencegroup JsonTextAccessorPrecedence {
    associativity: left
    higherThan: ComparisonPrecedence
}

precedencegroup JsonAccessorPrecedence {
    associativity: left
    higherThan: JsonTextAccessorPrecedence
}

infix operator -->: JsonAccessorPrecedence
infix operator -->>: JsonTextAccessorPrecedence

