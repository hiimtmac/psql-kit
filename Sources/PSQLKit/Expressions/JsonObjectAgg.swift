//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-28.
//

import PostgresNIO
import SQLKit

public struct JsonObjectAggExpression<Value>: Sendable {
    let content: _JsonObjectAggExpression
    
    public init<T, U>(_ key: T, _ value: U, as _: Value.Type) where T: SelectSQLExpression, U: SelectSQLExpression {
        self.content = _JsonObjectAggExpression(
            variant: .json,
            key: key.selectSqlExpression,
            value: value.selectSqlExpression
        )
    }
    
    public init<T, U>(_ key: T, _ value: U) where T: SelectSQLExpression, U: SelectSQLExpression, Value == Never {
        self.content = _JsonObjectAggExpression(
            variant: .json,
            key: key.selectSqlExpression,
            value: value.selectSqlExpression
        )
    }
}

public struct JsonbObjectAggExpression<Value>: Sendable {
    let content: _JsonObjectAggExpression
    
    public init<T, U>(_ key: T, _ value: U, as _: Value.Type) where T: SelectSQLExpression, U: SelectSQLExpression {
        self.content = _JsonObjectAggExpression(
            variant: .jsonb,
            key: key.selectSqlExpression,
            value: value.selectSqlExpression
        )
    }
    
    public init<T, U>(_ key: T, _ value: U) where T: SelectSQLExpression, U: SelectSQLExpression, Value == Never {
        self.content = _JsonObjectAggExpression(
            variant: .jsonb,
            key: key.selectSqlExpression,
            value: value.selectSqlExpression
        )
    }
}

extension JsonObjectAggExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        content.baseSqlExpression
    }
}

extension JsonbObjectAggExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        content.baseSqlExpression
    }
}

extension JsonObjectAggExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        content.selectSqlExpression
    }
}

extension JsonbObjectAggExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        content.selectSqlExpression
    }
}

extension JsonObjectAggExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonObjectAggExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonbObjectAggExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonbObjectAggExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonObjectAggExpression: TypeEquatable where Value: TypeEquatable {
    public typealias CompareType = Value.CompareType
}

extension JsonbObjectAggExpression: TypeEquatable where Value: TypeEquatable {
    public typealias CompareType = Value.CompareType
}

extension JsonObjectAggExpression {
    public init(
        _ key: ColumnExpression<String>,
        _ value: ColumnExpression<Value>
    ) where Value: PSQLExpression {
        self.init(
            key,
            value,
            as: Value.self
        )
    }
}

extension JsonbObjectAggExpression {
    public init(
        _ key: ColumnExpression<String>,
        _ value: ColumnExpression<Value>
    ) where Value: PSQLExpression {
        self.init(
            key,
            value,
            as: Value.self
        )
    }
}

struct _JsonObjectAggExpression: Sendable {
    let variant: Variant
    let key: any SQLExpression
    let value: any SQLExpression
    
    enum Variant {
        case json
        case jsonb
        
        var name: String {
            switch self {
            case .json: "JSON_OBJECT_AGG"
            case .jsonb: "JSONB_OBJECT_AGG"
            }
        }
        
        var dataType: PostgresDataType {
            switch self {
            case .json: .json
            case .jsonb: .jsonb
            }
        }
    }
}

extension _JsonObjectAggExpression: BaseSQLExpression {
    var baseSqlExpression: some SQLExpression {
        _Base(
            key: self.key,
            value: self.value,
            variant: self.variant
        )
    }

    struct _Base: SQLExpression {
        let key: any SQLExpression
        let value: any SQLExpression
        let variant: Variant

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write(variant.name)
            serializer.write("(")
            self.key.serialize(to: &serializer)
            serializer.write(",")
            serializer.writeSpace()
            self.value.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension _JsonObjectAggExpression: SelectSQLExpression {
    var selectSqlExpression: some SQLExpression {
        _Select(
            key: self.key,
            value: self.value,
            variant: self.variant
        )
    }

    struct _Select: SQLExpression {
        let key: any SQLExpression
        let value: any SQLExpression
        let variant: Variant

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write(variant.name)
            serializer.write("(")
            self.key.serialize(to: &serializer)
            serializer.write(",")
            serializer.writeSpace()
            self.value.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeCast(variant.dataType)
        }
    }
}
