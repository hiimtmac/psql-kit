//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-28.
//

import PostgresNIO
import SQLKit

public struct JSONPair<Key, Value>: Sendable, SQLExpression where Key: Sendable & BaseSQLExpression, Value: Sendable & BaseSQLExpression {
    let key: Key
    let value: Value
    
    init(_ tuple: (Key, Value)) {
        self.key = tuple.0
        self.value = tuple.1
    }
    
    init(_ tuple: (Key, Value)) where Key == ColumnExpression<String> {
        self.key = tuple.0
        self.value = tuple.1
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        key.baseSqlExpression.serialize(to: &serializer)
        serializer.writeComma()
        serializer.writeSpace()
        value.baseSqlExpression.serialize(to: &serializer)
    }
}

public struct JsonBuildObjectExpression<Content>: Sendable {
    let content: _JsonBuildObjectExpression
    
    public init<each T, each U>(_ pairs: repeat (each T, each U), as _: Content.Type) where
        repeat each T: Sendable & BaseSQLExpression,
        repeat each U: Sendable & BaseSQLExpression
    {
        self.content = _JsonBuildObjectExpression(
            variant: .json,
            pairs: repeat JSONPair(each pairs)
        )
    }
    
    public init<each T, each U>(_ pairs: repeat (each T, each U)) where
        repeat each T: Sendable & BaseSQLExpression,
        repeat each U: Sendable & BaseSQLExpression,
        Content == Never
    {
        self.content = _JsonBuildObjectExpression(
            variant: .json,
            pairs: repeat JSONPair(each pairs)
        )
    }
}

public struct JsonbBuildObjectExpression<Content>: Sendable {
    let content: _JsonBuildObjectExpression
    
    public init<each T, each U>(_ pairs: repeat (each T, each U), as _: Content.Type) where
        repeat each T: Sendable & BaseSQLExpression,
        repeat each U: Sendable & BaseSQLExpression
    {
        self.content = _JsonBuildObjectExpression(
            variant: .jsonb,
            pairs: repeat JSONPair(each pairs)
        )
    }
    
    public init<each T, each U>(_ pairs: repeat (each T, each U)) where
        repeat each T: Sendable & BaseSQLExpression,
        repeat each U: Sendable & BaseSQLExpression,
        Content == Never
    {
        self.content = _JsonBuildObjectExpression(
            variant: .jsonb,
            pairs: repeat JSONPair(each pairs)
        )
    }
}

extension JsonBuildObjectExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        content.baseSqlExpression
    }
}

extension JsonbBuildObjectExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        content.baseSqlExpression
    }
}

extension JsonBuildObjectExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        content.selectSqlExpression
    }
}

extension JsonbBuildObjectExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        content.selectSqlExpression
    }
}

extension JsonBuildObjectExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonBuildObjectExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonbBuildObjectExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonbBuildObjectExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonBuildObjectExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Content.CompareType
}

extension JsonbBuildObjectExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Content.CompareType
}

struct _JsonBuildObjectExpression: Sendable {
    let list: SQLList
    let variant: Variant
    
    public init<each T, each U>(variant: Variant, pairs: repeat JSONPair<each T, each U>) where
        repeat each T: BaseSQLExpression,
        repeat each U: BaseSQLExpression
    {
        var collector = [any SQLExpression]()
        for expression in repeat each pairs {
            collector.append(expression)
        }
        self.list = SQLList(collector, separator: SQLRaw(", "))
        self.variant = variant
    }
    
    enum Variant {
        case json
        case jsonb
        
        var name: String {
            switch self {
            case .json: "JSON_BUILD_OBJECT"
            case .jsonb: "JSONB_BUILD_OBJECT"
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

extension _JsonBuildObjectExpression: BaseSQLExpression {
    var baseSqlExpression: some SQLExpression {
        _Base(
            list: self.list,
            variant: self.variant
        )
    }

    struct _Base: SQLExpression {
        let list: SQLList
        let variant: Variant

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write(variant.name)
            serializer.write("(")
            self.list.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension _JsonBuildObjectExpression: SelectSQLExpression {
    var selectSqlExpression: some SQLExpression {
        _Select(
            list: self.list,
            variant: self.variant
        )
    }

    struct _Select: SQLExpression {
        let list: SQLList
        let variant: Variant

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write(variant.name)
            serializer.write("(")
            self.list.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeCast(variant.dataType)
        }
    }
}
