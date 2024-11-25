// SQLSerializer+Extensions.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
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
    
    mutating func writeIdentifier(_ value: String) {
        self.writeIdentifierQuote()
        self.write(value)
        self.writeIdentifierQuote()
    }
    
    mutating func writeLiteral(_ value: String) {
        self.writeLiteralQuote()
        self.write(value)
        self.writeLiteralQuote()
    }
    
    mutating func writeLiteralQuote() {
        dialect.literalStringQuote.serialize(to: &self)
        if Environment.escapeIdentifiers {
            dialect.literalStringQuote.serialize(to: &self)
        }
    }
    
    mutating func writeIdentifierQuote() {
        dialect.identifierQuote.serialize(to: &self)
    }
    
    mutating func writeCast(_ type: PostgresDataType) {
        guard let knownSQLName = type.knownSQLName else {
            return
        }
        self.write("::")
        self.write(knownSQLName)
    }

    mutating func writePeriod() {
        self.write(".")
    }
    
    mutating func writeNull() {
        self.write("NULL")
    }
}
