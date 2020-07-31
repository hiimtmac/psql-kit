import Foundation
import FluentKit

@dynamicMemberLookup
protocol Table: ExpressibleAsFrom {
    init()
    /// vapor `table`
    static var schema: String { get }
    /// psql `schema`
    static var path: String? { get }
}

extension Table {
    typealias Column<Value: PSQLable> = ColumnProperty<Self, Value>
    
    static func column(key: String) -> PSQLPathColumnExpression {
        .init(
           alias: nil,
           path: Self.path,
           schema: Self.schema,
           column: key
       )
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, Column<T>>) -> PSQLTypedColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, Column<T>>) -> PSQLOrderByExpression {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, Column<T>>) -> PSQLGroupByExpression {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, Column<T>>) -> PSQLSelectExpression {
        let field = Self()[keyPath: keyPath]
        return .init(selection: column(key: field.key), type: T.psqlType, alias: nil)
    }
    
    static var path: String? { nil }
    
    var from: PSQLExpression {
        let table = PSQLTableExpression(path: Self.path, schema: Self.schema)
        return PSQLFromExpression(table: table, alias: nil)
    }
    
    static var table: PSQLFromExpression {
        let table = PSQLTableExpression(path: Self.path, schema: Self.schema)
        return PSQLFromExpression(table: table, alias: nil)
    }
}

extension Table {
    static func `as`(_ alias: String) -> TableAlias<Self> {
        .init(path: path, alias: alias)
    }
}

extension Table where Self: Model {
    static func column(key: FieldKey) -> PSQLPathColumnExpression {
        .init(
           alias: nil,
           path: Self.path,
           schema: Self.schema,
           column: key.description
       )
    }
    
    // MARK: - FieldProperty
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>) -> PSQLTypedColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>) -> PSQLOrderByExpression {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>) -> PSQLGroupByExpression {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>) -> PSQLSelectExpression {
        let field = Self()[keyPath: keyPath]
        return .init(selection: column(key: field.key), type: T.psqlType, alias: nil)
    }
    
    // MARK: - IDProperty
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>) -> PSQLTypedColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>) -> PSQLOrderByExpression {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>) -> PSQLGroupByExpression {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>) -> PSQLSelectExpression {
        let field = Self()[keyPath: keyPath]
        return .init(selection: column(key: field.key), type: T.psqlType, alias: nil)
    }
    
    // MARK: - ParentProperty
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>) -> PSQLTypedColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.$id.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>) -> PSQLOrderByExpression {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.$id.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>) -> PSQLGroupByExpression {
        let field = Self()[keyPath: keyPath]
        return .init(column: column(key: field.$id.key))
    }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>) -> PSQLSelectExpression {
        let field = Self()[keyPath: keyPath]
        return .init(selection: column(key: field.$id.key), type: T.psqlType, alias: nil)
    }
}
