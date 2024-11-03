// EmptyExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct EmptyExpression: Sendable {
    struct _Empty: SQLExpression {
        func serialize(to serializer: inout SQLSerializer) {
            fatalError("Should not be serialized")
        }
    }
}
