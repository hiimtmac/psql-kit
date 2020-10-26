import Foundation
import FluentKit
import SQLKit

@dynamicMemberLookup
public protocol Table: FromSQLExpression {
    init()
    /// fluent `table`
    static var schema: String { get }
    /// psql `schema`
    static var path: String? { get }
}

extension Table {
    public typealias Column<Value: PSQLExpression> = ColumnProperty<Self, Value>
    public typealias OptionalColumn<Value: PSQLExpression> = OptionalColumnProperty<Self, Value>
    public typealias NestedColumn<Value: TableObject> = NestedObjectProperty<Self, Value>
    
    /// fluent `table`
    public static var schema: String { "\(Self.self)" }
    /// psql `schema`
    public static var path: String? { nil }

    public static func `as`(_ alias: String) -> TableAlias<Self> {
        .init(path: path, alias: alias)
    }
    
    public func `as`(_ alias: String) -> TableAlias<Self> {
        .init(path: Self.path, alias: alias)
    }

    public static var table: Self { Self() }
    
    public static postfix func .*(table: Self) -> AllTableSelection<Self> {
        .init(table: table)
    }
    
    public var fromSqlExpression: some SQLExpression {
        _From(
            pathName: Self.path,
            schemaName: Self.schema
        )
    }
    
    // MARK: - ColumnProperty
    public static subscript<T>(dynamicMember keyPath: KeyPath<Self, Column<T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key
        )
    }
    
    // MARK: - OptionalColumnProperty
    public static subscript<T>(dynamicMember keyPath: KeyPath<Self, OptionalColumn<T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key
        )
    }
}

extension Table where Self: Model {
    // MARK: - FieldProperty
    public static subscript<T>(dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - OptionalFieldProperty
    public static subscript<T>(dynamicMember keyPath: KeyPath<Self, OptionalFieldProperty<Self, T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - IDProperty
    public static subscript<T>(dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - ParentProperty
    public static subscript<T>(dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>) -> ColumnExpression<T.IDValue> where T: Model {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.$id.key.description
        )
    }
    
    // MARK: - OptionalParentProperty
    public static subscript<T>(dynamicMember keyPath: KeyPath<Self, OptionalParentProperty<Self, T>>) -> ColumnExpression<T.IDValue> where T: Model {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.$id.key.description
        )
    }
    
    // MARK: - TimestampProperty
    public static subscript<T>(dynamicMember keyPath: KeyPath<Self, TimestampProperty<Self, T>>) -> ColumnExpression<T.Value> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.$timestamp.key.description
        )
    }
    
    // MARK: - GroupProperty
    public static subscript<T>(dynamicMember keyPath: KeyPath<Self, GroupProperty<Self, T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
}

private struct _From: SQLExpression {
    let pathName: String?
    let schemaName: String
    
    func serialize(to serializer: inout SQLSerializer) {
        if let path = pathName {
            serializer.writeQuote()
            serializer.write(path)
            serializer.writeQuote()
            serializer.writePeriod()
        }
        
        serializer.writeQuote()
        serializer.write(schemaName)
        serializer.writeQuote()
    }
}
