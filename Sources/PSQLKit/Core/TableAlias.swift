import Foundation
import FluentKit

@dynamicMemberLookup
struct TableAlias<T: Table> {
    let path: String?
    let alias: String
    
    init(path: String?, alias: String) {
        self.alias = alias
        self.path = path ?? T.path
    }
    
    var table: PSQLFromExpression {
        let table = PSQLTableExpression(path: path, schema: T.schema)
        return .init(table: table, alias: alias)
    }
}

extension TableAlias {
    func schema(_ schema: String) -> Self {
        .init(path: schema, alias: alias)
    }
    
    func column(key: String) -> PSQLPathColumnExpression {
        .init(
           alias: alias,
           path: path,
           schema: T.schema,
           column: key
       )
    }
    
    // MARK: - FieldProperty
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>) -> PSQLTypedColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>) -> PSQLOrderByExpression {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>) -> PSQLGroupByExpression {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>) -> PSQLSelectExpression {
        let field = T()[keyPath: keyPath]
        return .init(selection: column(key: field.key), type: U.psqlType, alias: nil)
    }
}

extension TableAlias: ExpressibleAsFrom {
    var from: PSQLExpression {
        let table = PSQLTableExpression(path: path, schema: T.schema)
        return PSQLFromExpression(table: table, alias: alias)
    }
}

extension TableAlias where T: Model {
    func column(key: FieldKey) -> PSQLPathColumnExpression {
        .init(
           alias: alias,
           path: path,
           schema: T.schema,
           column: key.description
       )
    }
    
    // MARK: - FieldProperty
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>) -> PSQLTypedColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>) -> PSQLOrderByExpression {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>) -> PSQLGroupByExpression {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>) -> PSQLSelectExpression {
        let field = T()[keyPath: keyPath]
        return .init(selection: column(key: field.key), type: U.psqlType, alias: nil)
    }
    
    // MARK: - IDProperty
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>) -> PSQLTypedColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>) -> PSQLOrderByExpression {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>) -> PSQLGroupByExpression {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>) -> PSQLSelectExpression {
        let field = T()[keyPath: keyPath]
        return .init(selection: column(key: field.key), type: U.psqlType, alias: nil)
    }
    
    // MARK: - ParentProperty
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>) -> PSQLTypedColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.$id.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>) -> PSQLOrderByExpression {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.$id.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>) -> PSQLGroupByExpression {
        let field = T()[keyPath: keyPath]
        return .init(column: column(key: field.$id.key))
    }
    
    subscript<U: PSQLable>(dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>) -> PSQLSelectExpression {
        let field = T()[keyPath: keyPath]
        return .init(selection: column(key: field.$id.key), type: U.psqlType, alias: nil)
    }
}
