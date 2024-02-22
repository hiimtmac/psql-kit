//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2024-02-22.
//

import PostgresNIO
import SQLKit

extension PostgresDataType: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        guard let knownSQLName else { return }
        serializer.write("::")
        serializer.write(knownSQLName)
    }
}
