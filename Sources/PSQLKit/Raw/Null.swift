//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-14.
//

import SQLKit

public struct Null: Sendable, SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.writeNull()
    }
}

extension Null: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        self
    }
}

extension Null: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression {
        self
    }
}

extension Null: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = Null()
    }
}
