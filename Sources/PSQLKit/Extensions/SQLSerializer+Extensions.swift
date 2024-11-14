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
        self.writeSpace()
        self.write(value)
        self.writeSpace()
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
    
    mutating func writeNull() {
        self.write("NULL")
    }
}
