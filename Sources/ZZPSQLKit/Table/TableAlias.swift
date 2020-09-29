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
}

extension TableAlias {
    func schema(_ schema: String) -> Self {
        .init(path: schema, alias: alias)
    }
    
    // MARK: - FieldProperty
    subscript<U: PKExpressible>(dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>) -> ColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.key
        )
    }
    
//    @_disfavoredOverload
//    subscript<U: PKExpressible>(dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>) -> PSQLOrderByExpression {
////        let field = T()[keyPath: keyPath]
////        return .init(column: column(key: field.key))
//        fatalError()
//    }
}

extension TableAlias where T: Model {
    // MARK: - FieldProperty
    subscript<U: PKExpressible>(dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>) -> ColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }
    
//    @_disfavoredOverload
//    subscript<U: PKExpressible>(dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>) -> PSQLOrderByExpression {
////        let field = T()[keyPath: keyPath]
////        return .init(column: column(key: field.key))
//        fatalError()
//    }
    
    // MARK: - IDProperty
    subscript<U: PKExpressible>(dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>) -> ColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }
    
//    @_disfavoredOverload
//    subscript<U: PKExpressible>(dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>) -> PSQLOrderByExpression {
////        let field = T()[keyPath: keyPath]
////        return .init(column: column(key: field.key))
//        fatalError()
//    }
    
    // MARK: - ParentProperty
    subscript<U, V: PKExpressible>(dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>) -> ColumnExpression<V> {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.$id.key.description
        )
    }
    
//    @_disfavoredOverload
//    subscript<U>(dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>) -> PSQLOrderByExpression {
////        let field = T()[keyPath: keyPath]
////        return .init(column: column(key: field.$id.key))
//        fatalError()
//    }
}
