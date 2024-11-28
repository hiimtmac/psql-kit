// JsonbExtractPathText.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct JsonExtractPathTextExpression: Sendable {
    let content: _JsonExtractPathTextExpression

    public init<T>(_ content: T, _ paths: String...) where T: SelectSQLExpression {
        self.content = _JsonExtractPathTextExpression(
            variant: .json,
            content: content,
            paths: paths
        )
    }
}

public struct JsonbExtractPathTextExpression: Sendable {
    let content: _JsonExtractPathTextExpression

    public init<T>(_ content: T, _ paths: String...) where T: SelectSQLExpression {
        self.content = _JsonExtractPathTextExpression(
            variant: .jsonb,
            content: content,
            paths: paths
        )
    }
}

extension JsonExtractPathTextExpression: Coalescable {}
extension JsonbExtractPathTextExpression: Coalescable {}

extension JsonExtractPathTextExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        content.baseSqlExpression
    }
}

extension JsonbExtractPathTextExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        content.baseSqlExpression
    }
}

extension JsonExtractPathTextExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        content.selectSqlExpression
    }
}

extension JsonbExtractPathTextExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        content.selectSqlExpression
    }
}

extension JsonExtractPathTextExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonExtractPathTextExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonbExtractPathTextExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonbExtractPathTextExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonExtractPathTextExpression: TypeEquatable {
    public typealias CompareType = String
}

extension JsonbExtractPathTextExpression: TypeEquatable {
    public typealias CompareType = String
}

extension JsonExtractPathTextExpression {
    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T.QueryContainer, ColumnAccessor<U>>
    ) where T: Table & JSONBCol {
        let accessor = T.queryContainer[keyPath: keyPath]
        
        self.init(
            group,
            accessor.column
        )
    }

    public init<T, U, V>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<V>>
    ) where T: Table & JSONBCol, U: Table & JSONBCol {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        
        self.init(
            group,
            accessor1.column, accessor2.column
        )
    }
    
    public init<T, U, V, W>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<V>>,
        _ third: KeyPath<V.QueryContainer, ColumnAccessor<W>>
    ) where T: Table & JSONBCol, U: Table & JSONBCol, V: Table & JSONBCol {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        let accessor3 = V.queryContainer[keyPath: third]
        
        self.init(
            group,
            accessor1.column, accessor2.column, accessor3.column
        )
    }
}

extension JsonbExtractPathTextExpression {
    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T.QueryContainer, ColumnAccessor<U>>
    ) where T: Table {
        let accessor = T.queryContainer[keyPath: keyPath]
        
        self.init(
            group,
            accessor.column
        )
    }

    public init<T, U, V>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<V>>
    ) where T: Table, U: Table {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        
        self.init(
            group,
            accessor1.column, accessor2.column
        )
    }
    
    public init<T, U, V, W>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<V>>,
        _ third: KeyPath<V.QueryContainer, ColumnAccessor<W>>
    ) where T: Table, U: Table, V: Table {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        let accessor3 = V.queryContainer[keyPath: third]
        
        self.init(
            group,
            accessor1.column, accessor2.column, accessor3.column
        )
    }
}

struct _JsonExtractPathTextExpression: Sendable {
    let content: any SQLExpression
    let elements: SQLList
    let variant: Variant

    init<T>(
        variant: Variant,
        content: T,
        paths: [String]
    ) where T: SelectSQLExpression {
        self.content = content.selectSqlExpression
        self.elements = SQLList(paths)
        self.variant = variant
    }
    
    enum Variant {
        case json
        case jsonb
        
        var name: String {
            switch self {
            case .json: "JSON_EXTRACT_PATH_TEXT"
            case .jsonb: "JSONB_EXTRACT_PATH_TEXT"
            }
        }
    }
}

extension _JsonExtractPathTextExpression: BaseSQLExpression {
    var baseSqlExpression: some SQLExpression {
        _Base(
            content: self.content,
            elements: self.elements,
            variant: self.variant
        )
    }

    struct _Base: SQLExpression {
        let content: any SQLExpression
        let elements: SQLList
        let variant: Variant

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write(variant.name)
            serializer.write("(")
            self.content.serialize(to: &serializer)
            serializer.write(",")
            serializer.writeSpace()
            self.elements.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension _JsonExtractPathTextExpression: SelectSQLExpression {
    var selectSqlExpression: some SQLExpression {
        _Select(
            content: self.content,
            elements: self.elements,
            variant: self.variant
        )
    }

    struct _Select: SQLExpression {
        let content: any SQLExpression
        let elements: SQLList
        let variant: Variant

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write(variant.name)
            serializer.write("(")
            self.content.serialize(to: &serializer)
            serializer.write(",")
            serializer.writeSpace()
            self.elements.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeCast(.text)
        }
    }
}
