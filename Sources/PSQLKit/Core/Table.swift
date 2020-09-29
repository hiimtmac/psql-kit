import Foundation
import FluentKit

@dynamicMemberLookup
protocol Table: ExpressibleAsFrom {
    init()
    /// fluent `table`
    static var schema: String { get }
    /// psql `schema`
    static var path: String? { get }
}

extension Table {
    typealias Column<Value: PSQLable> = ColumnProperty<Self, Value>
    
    static var schema: String { "\(Self.self)" }
    
    static var with: Self.Type { Self.self }
    
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, Column<T>>) -> PSQLKit.Column<T> {
        let field = Self()[keyPath: keyPath]
        return PSQLKit.Column(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key
        )
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, Column<T>>) -> PSQLOrderByExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, Column<T>>) -> PSQLGroupByExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, Column<T>>) -> PSQLSelectExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(selection: column(key: field.key), type: T.psqlType, alias: nil)
        fatalError()
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
    // MARK: - FieldProperty
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>) -> PSQLKit.Column<T> {
        let field = Self()[keyPath: keyPath]
        return PSQLKit.Column(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>) -> PSQLOrderByExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>) -> PSQLGroupByExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>) -> PSQLSelectExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(selection: column(key: field.key), type: T.psqlType, alias: nil)
        fatalError()
    }
    
    // MARK: - IDProperty
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>) -> PSQLKit.Column<T> {
        let field = Self()[keyPath: keyPath]
        return PSQLKit.Column(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>) -> PSQLOrderByExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>) -> PSQLGroupByExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>) -> PSQLSelectExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(selection: column(key: field.key), type: T.psqlType, alias: nil)
        fatalError()
    }
    
    // MARK: - ParentProperty
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>) -> PSQLKit.Column<T> {
        let field = Self()[keyPath: keyPath]
        return PSQLKit.Column(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.$id.key.description
        )
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>) -> PSQLOrderByExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(column: column(key: field.$id.key))
        fatalError()
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>) -> PSQLGroupByExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(column: column(key: field.$id.key))
        fatalError()
    }
    
    @_disfavoredOverload
    static subscript<T: PSQLable>(dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>) -> PSQLSelectExpression {
//        let field = Self()[keyPath: keyPath]
//        return .init(selection: column(key: field.$id.key), type: T.psqlType, alias: nil)
        fatalError()
    }
}
