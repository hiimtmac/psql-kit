// JsonExtractPath.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

public struct JsonExtractPathExpression<Content>: Sendable where Content: PSQLExpression {
    let content: _JsonExtractPathExpression

    public init<T>(_ content: T, _ paths: String..., as _: Content.Type) where T: SelectSQLExpression {
        self.content = _JsonExtractPathExpression(
            variant: .json,
            dataType: Content.postgresDataType,
            content: content,
            paths: paths
        )
    }
}

public struct JsonbExtractPathExpression<Content>: Sendable where Content: PSQLExpression {
    let content: _JsonExtractPathExpression

    public init<T>(_ content: T, _ paths: String..., as _: Content.Type) where T: SelectSQLExpression {
        self.content = _JsonExtractPathExpression(
            variant: .jsonb,
            dataType: Content.postgresDataType,
            content: content,
            paths: paths
        )
    }
}

extension JsonExtractPathExpression: Coalescable {}
extension JsonbExtractPathExpression: Coalescable {}

extension JsonExtractPathExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        content.baseSqlExpression
    }
}

extension JsonbExtractPathExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        content.baseSqlExpression
    }
}

extension JsonExtractPathExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        content.selectSqlExpression
    }
}

extension JsonbExtractPathExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        content.selectSqlExpression
    }
}

extension JsonExtractPathExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonExtractPathExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonbExtractPathExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonbExtractPathExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonExtractPathExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Content.CompareType
}

extension JsonbExtractPathExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Content.CompareType
}

extension JsonExtractPathExpression {
    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T.QueryContainer, ColumnAccessor<Content>>
    ) where T: Table & JSONCol {
        let accessor = T.queryContainer[keyPath: keyPath]
        
        self.init(
            group,
            accessor.column,
            as: Content.self
        )
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<Content>>
    ) where T: Table & JSONCol, U: Table & JSONCol {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        
        self.init(
            group,
            accessor1.column, accessor2.column,
            as: Content.self
        )
    }
    
    public init<T, U, V>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<V>>,
        _ third: KeyPath<V.QueryContainer, ColumnAccessor<Content>>
    ) where T: Table & JSONCol, U: Table & JSONCol, V: Table & JSONCol {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        let accessor3 = V.queryContainer[keyPath: third]
        
        self.init(
            group,
            accessor1.column, accessor2.column, accessor3.column,
            as: Content.self
        )
    }
}

extension JsonbExtractPathExpression {
    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T.QueryContainer, ColumnAccessor<Content>>
    ) where T: Table & JSONBCol {
        let accessor = T.queryContainer[keyPath: keyPath]
        
        self.init(
            group,
            accessor.column,
            as: Content.self
        )
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<Content>>
    ) where T: Table & JSONBCol, U: Table & JSONBCol {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        
        self.init(
            group,
            accessor1.column, accessor2.column,
            as: Content.self
        )
    }
    
    public init<T, U, V>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<V>>,
        _ third: KeyPath<V.QueryContainer, ColumnAccessor<Content>>
    ) where T: Table & JSONBCol, U: Table & JSONBCol, V: Table & JSONBCol {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        let accessor3 = V.queryContainer[keyPath: third]
        
        self.init(
            group,
            accessor1.column, accessor2.column, accessor3.column,
            as: Content.self
        )
    }
}


struct _JsonExtractPathExpression: Sendable {
    let content: any SQLExpression
    let elements: SQLList
    let dataType: PostgresDataType
    let variant: Variant

    init<T>(
        variant: Variant,
        dataType: PostgresDataType,
        content: T,
        paths: [String]
    ) where T: SelectSQLExpression {
        self.content = content.selectSqlExpression
        self.elements = SQLList(paths)
        self.dataType = dataType
        self.variant = variant
    }
    
    enum Variant {
        case json
        case jsonb
        
        var name: String {
            switch self {
            case .json: "JSON_EXTRACT_PATH"
            case .jsonb: "JSONB_EXTRACT_PATH"
            }
        }
    }
}

extension _JsonExtractPathExpression: BaseSQLExpression {
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

extension _JsonExtractPathExpression: SelectSQLExpression {
    var selectSqlExpression: some SQLExpression {
        _Select(
            content: self.content,
            elements: self.elements,
            dataType: self.dataType,
            variant: self.variant
        )
    }

    struct _Select: SQLExpression {
        let content: any SQLExpression
        let elements: SQLList
        let dataType: PostgresDataType
        let variant: Variant

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write(variant.name)
            serializer.write("(")
            self.content.serialize(to: &serializer)
            serializer.write(",")
            serializer.writeSpace()
            self.elements.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeCast(dataType)
        }
    }
}
