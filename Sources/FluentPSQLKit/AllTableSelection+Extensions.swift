//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-08.
//

import SQLKit
import PSQLKit

public struct AllFluentCTESelection<T>: Sendable where T: FluentCTE {
    let cte: T
}

// MARK: Select

extension AllFluentCTESelection: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _AllTableSelect(schemaName: T.space, tableName: T.schema)
    }
}

// MARK: - Alias

extension AllFluentCTESelection {
    public struct Alias: Sendable {
        let cte: FluentCTEAlias<T>
    }
}

extension AllFluentCTESelection.Alias: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _AllTableSelectAlias(aliasName: self.cte.alias)
    }
}

