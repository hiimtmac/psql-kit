// SQLSerializer+Extensions.swift
// Copyright (c) 2024 hiimtmac inc.

import struct SQLKit.SQLSerializer

extension SQLSerializer {
    mutating func writeComma() {
        self.write(",")
    }

    mutating func writeSpace() {
        self.write(" ")
    }

    mutating func writeQuote() {
        self.write("\"")
    }

    mutating func writePeriod() {
        self.write(".")
    }
}
