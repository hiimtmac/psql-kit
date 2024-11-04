// EmptyExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct EmptyExpression: Sendable {
    struct _Empty: SQLExpression {
        func serialize(to serializer: inout SQLSerializer) {
            fatalError("Should not be serialized")
        }
    }
}
