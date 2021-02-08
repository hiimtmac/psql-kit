import Foundation
import SQLKit
import FluentKit

public struct JsonbExtractPathTextExpression<Content>: SQLExpression where Content: SelectSQLExpression {
    let content: Content
    let pathElements: [String]
    
    public init(_ content: Content, _ paths: String...) {
        self.content = content
        self.pathElements = paths
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("JSONB_EXTRACT_PATH_TEXT")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        SQLList(pathElements).serialize(to: &serializer)
        serializer.write(")")
    }
}

extension JsonbExtractPathTextExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension JsonbExtractPathTextExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonbExtractPathTextExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonbExtractPathTextExpression: TypeEquatable {
    public typealias CompareType = Self
}

// MARK: Fluent
extension JsonbExtractPathTextExpression {
    public init<T, U>(
        _ group: Content,
        _ keyPath: KeyPath<T, FieldProperty<T, U>>
    ) where Content == ColumnExpression<T> {
        self.content = group
        self.pathElements = [T()[keyPath: keyPath].key.description]
    }
    
    public init<T, U>(
        _ group: Content,
        _ keyPath: KeyPath<T, OptionalFieldProperty<T, U>>
    ) where Content == ColumnExpression<T> {
        self.content = group
        self.pathElements = [T()[keyPath: keyPath].key.description]
    }
    
    public init<T, U>(
        _ group: Content,
        _ keyPath: KeyPath<T, TimestampProperty<T, U>>
    ) where Content == ColumnExpression<T> {
        self.content = group
        self.pathElements = [T()[keyPath: keyPath].$timestamp.key.description]
    }
    
    public init<T, U>(
        _ group: Content,
        _ keyPath: KeyPath<T, IDProperty<T, U>>
    ) where Content == ColumnExpression<T> {
        self.content = group
        self.pathElements = [T()[keyPath: keyPath].key.description]
    }
    
    public init<T, U, V>(
        _ group: Content,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, FieldProperty<U, V>>
    ) where Content == ColumnExpression<T> {
        self.content = group
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].key.description]
    }
    
    public init<T, U, V>(
        _ group: Content,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, OptionalFieldProperty<U, V>>
    ) where Content == ColumnExpression<T> {
        self.content = group
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].key.description]
    }
    
    public init<T, U, V>(
        _ group: Content,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, TimestampProperty<U, V>>
    ) where Content == ColumnExpression<T> {
        self.content = group
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].$timestamp.key.description]
    }
    
    public init<T, U, V>(
        _ group: Content,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, IDProperty<U, V>>
    ) where Content == ColumnExpression<T> {
        self.content = group
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].key.description]
    }
}

// MARK: PSQLKit
extension JsonbExtractPathTextExpression {
    public init<T, U>(
        _ group: Content,
        _ keyPath: KeyPath<T, ColumnProperty<T, U>>
    ) where Content == ColumnExpression<T>, T: TableObject {
        self.content = group
        self.pathElements = [T()[keyPath: keyPath].key.description]
    }
    
    public init<T, U>(
        _ group: Content,
        _ keyPath: KeyPath<T, OptionalColumnProperty<T, U>>
    ) where Content == ColumnExpression<T>, T: TableObject {
        self.content = group
        self.pathElements = [T()[keyPath: keyPath].key.description]
    }
    
    public init<T, U, V>(
        _ group: Content,
        _ first: KeyPath<T, NestedObjectProperty<T, U>>,
        _ second: KeyPath<U, ColumnProperty<U, V>>
    ) where Content == ColumnExpression<T>, T: TableObject, U: TableObject {
        self.content = group
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].key.description]
    }
    
    public init<T, U, V>(
        _ group: Content,
        _ first: KeyPath<T, NestedObjectProperty<T, U>>,
        _ second: KeyPath<U, OptionalColumnProperty<U, V>>
    ) where Content == ColumnExpression<T>, T: TableObject, U: TableObject {
        self.content = group
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].key.description]
    }
}
