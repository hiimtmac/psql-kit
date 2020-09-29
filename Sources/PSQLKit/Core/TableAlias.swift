import Foundation
import FluentKit

@dynamicMemberLookup
struct TableAlias<T: Table> {
    /// psql `schema`
    let path: String?
    /// table alias
    let alias: String
    
    init(path: String?, alias: String) {
        self.alias = alias
        self.path = path ?? T.path
    }
    
    var table: PSQLFromExpression {
        let table = PSQLTableExpression(path: path, schema: T.schema)
        return .init(table: table, alias: alias)
    }
    
    var with: Self { self }
}

extension TableAlias {
    func schema(_ schema: String) -> Self {
        .init(path: schema, alias: alias)
    }
    
    // MARK: - FieldProperty
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>) -> Column<U> {
        let field = T()[keyPath: keyPath]
        return Column(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.key
        )
    }
    
    @_disfavoredOverload
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>) -> PSQLOrderByExpression {
//        let field = T()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>) -> PSQLGroupByExpression {
//        let field = T()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>) -> PSQLSelectExpression {
//        let field = T()[keyPath: keyPath]
//        return .init(selection: column(key: field.key), type: U.psqlType, alias: nil)
        fatalError()
    }
}

extension TableAlias: ExpressibleAsFrom {
    var from: PSQLExpression {
        let table = PSQLTableExpression(path: path, schema: T.schema)
        return PSQLFromExpression(table: table, alias: alias)
    }
}

extension TableAlias where T: Model {
    // MARK: - FieldProperty
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>) -> Column<U> {
        let field = T()[keyPath: keyPath]
        return Column(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }
    
    @_disfavoredOverload
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>) -> PSQLOrderByExpression {
//        let field = T()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>) -> PSQLGroupByExpression {
//        let field = T()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>) -> PSQLSelectExpression {
//        let field = T()[keyPath: keyPath]
//        return .init(selection: column(key: field.key), type: U.psqlType, alias: nil)
        fatalError()
    }
    
    // MARK: - IDProperty
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>) -> Column<U> {
        let field = T()[keyPath: keyPath]
        return Column(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }
    
    @_disfavoredOverload
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>) -> PSQLOrderByExpression {
//        let field = T()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>) -> PSQLGroupByExpression {
//        let field = T()[keyPath: keyPath]
//        return .init(column: column(key: field.key))
        fatalError()
    }
    
    @_disfavoredOverload
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>) -> PSQLSelectExpression {
//        let field = T()[keyPath: keyPath]
//        return .init(selection: column(key: field.key), type: U.psqlType, alias: nil)
        fatalError()
    }
    
    // MARK: - ParentProperty
    subscript<U, V: PSQLable>(dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>) -> Column<V> {
        let field = T()[keyPath: keyPath]
        return Column(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.$id.key.description
        )
    }
    
    @_disfavoredOverload
    subscript<U>(dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>) -> PSQLOrderByExpression {
//        let field = T()[keyPath: keyPath]
//        return .init(column: column(key: field.$id.key))
        fatalError()
    }
    
    @_disfavoredOverload
    subscript<U>(dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>) -> PSQLGroupByExpression {
//        let field = T()[keyPath: keyPath]
//        return .init(column: column(key: field.$id.key))
        fatalError()
    }
    
    @_disfavoredOverload
    subscript<U>(dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>) -> PSQLSelectExpression where U.IDValue: PSQLable {
//        let field = T()[keyPath: keyPath]
//        return .init(selection: column(key: field.$id.key), type: U.IDValue.psqlType, alias: nil)
        fatalError()
    }
}
