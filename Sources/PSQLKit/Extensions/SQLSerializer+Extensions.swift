// SQLSerializer+Extensions.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

extension SQLSerializer {
    mutating func writeComma() {
        self.write(",")
    }

    mutating func writeSpace() {
        self.write(" ")
    }
    
    mutating func writeSpaced(_ value: String) {
        self.write(" ")
        self.write(value)
        self.write(" ")
    }
    
    mutating func writeQuoted(_ value: String) {
        dialect.identifierQuote.serialize(to: &self)
        self.write(value)
        dialect.identifierQuote.serialize(to: &self)
    }
    
    mutating func writeSingleQuoted(_ value: String) {
        dialect.literalStringQuote.serialize(to: &self)
        self.write(value)
        dialect.literalStringQuote.serialize(to: &self)
    }

    mutating func writePeriod() {
        self.write(".")
    }
}
