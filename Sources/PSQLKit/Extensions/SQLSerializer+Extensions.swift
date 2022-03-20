// SQLSerializer+Extensions.swift
// Copyright © 2022 hiimtmac

import SQLKit

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
