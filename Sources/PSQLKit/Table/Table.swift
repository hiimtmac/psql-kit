import Foundation
import FluentKit
import SQLKit

@dynamicMemberLookup
public protocol Table: FromSQLExpressible {
    init()
    /// fluent `table`
    static var schema: String { get }
    /// psql `schema`
    static var path: String? { get }
}

extension Table {
    public typealias Column<Value: PSQLExpressible> = ColumnProperty<Self, Value>
    
    /// fluent `table`
    public static var schema: String { "\(Self.self)" }
    /// psql `schema`
    public static var path: String? { nil }
    
    public static subscript<T: PSQLExpressible>(dynamicMember keyPath: KeyPath<Self, Column<T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key
        )
    }
}

extension Table {
    public static func `as`(_ alias: String) -> TableAlias<Self> {
        .init(path: path, alias: alias)
    }
    
    public func `as`(_ alias: String) -> TableAlias<Self> {
        .init(path: Self.path, alias: alias)
    }
}

extension Table where Self: Model {
    // MARK: - FieldProperty
    public static subscript<T: PSQLExpressible>(dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - OptionalFieldProperty
    public static subscript<T: PSQLExpressible>(dynamicMember keyPath: KeyPath<Self, OptionalFieldProperty<Self, T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - IDProperty
    public static subscript<T: PSQLExpressible>(dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - ParentProperty
    public static subscript<T: PSQLExpressible>(dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.$id.key.description
        )
    }
}

extension Table {
    public var fromSqlExpression: some SQLExpression {
        _From(
            pathName: Self.path,
            schemaName: Self.schema
        )
    }
    
    public static var table: Self { Self() }
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
