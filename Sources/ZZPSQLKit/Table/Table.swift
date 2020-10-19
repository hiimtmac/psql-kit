import Foundation
import FluentKit
import SQLKit

@dynamicMemberLookup
protocol Table: FromSQLExpressible {
    init()
    /// fluent `table`
    static var schema: String { get }
    /// psql `schema`
    static var path: String? { get }
}

extension Table {
    typealias Column<Value: PKExpressible> = ColumnProperty<Self, Value>
    
    /// fluent `table`
    static var schema: String { "\(Self.self)" }
    /// psql `schema`
    static var path: String? { nil }
    
    static subscript<T: PKExpressible>(dynamicMember keyPath: KeyPath<Self, Column<T>>) -> ColumnExpression<T> {
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
    static func `as`(_ alias: String) -> TableAlias<Self> {
        .init(path: path, alias: alias)
    }
    
    func `as`(_ alias: String) -> TableAlias<Self> {
        .init(path: Self.path, alias: alias)
    }
}

extension Table where Self: Model {
    // MARK: - FieldProperty
    static subscript<T: PKExpressible>(dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - OptionalFieldProperty
    static subscript<T: PKExpressible>(dynamicMember keyPath: KeyPath<Self, OptionalFieldProperty<Self, T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - IDProperty
    static subscript<T: PKExpressible>(dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - ParentProperty
    static subscript<T: PKExpressible>(dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>) -> ColumnExpression<T> {
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
    var fromSqlExpression: _From {
        .init(
            pathName: Self.path,
            schemaName: Self.schema
        )
    }
    
    static var table: Self { Self() }
}

struct _From: SQLExpression {
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
