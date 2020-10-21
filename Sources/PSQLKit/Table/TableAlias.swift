import Foundation
import FluentKit
import SQLKit

@dynamicMemberLookup
public struct TableAlias<T: Table> {
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
    
    public var table: TableAlias { self }
    
    public static postfix func .*(_ alias: Self) -> AllTableAliasSelection<T> {
        .init(tableAlias: alias)
    }
    
    // MARK: - ColumnProperty
    public subscript<U: PSQLExpressible>(dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>) -> ColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.key
        )
    }
    
    // MARK: - OptionalColumnProperty
    public subscript<U: PSQLExpressible>(dynamicMember keyPath: KeyPath<T, OptionalColumnProperty<T, U>>) -> ColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.key
        )
    }
}

extension TableAlias where T: Model {
    // MARK: - FieldProperty
    public subscript<U>(dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>) -> ColumnExpression<U> where U: PSQLExpressible {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - OptionalFieldProperty
    public subscript<U>(dynamicMember keyPath: KeyPath<T, OptionalFieldProperty<T, U>>) -> ColumnExpression<U> where U: PSQLExpressible {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - IDProperty
    public subscript<U>(dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>) -> ColumnExpression<U> where U: PSQLExpressible {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }
    
    // MARK: - ParentProperty
    public subscript<U>(dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>) -> ColumnExpression<U.IDValue> where U: Model, U.IDValue: PSQLExpressible {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.$id.key.description
        )
    }
    
    // MARK: - OptionalParentProperty
    public subscript<U>(dynamicMember keyPath: KeyPath<T, OptionalParentProperty<T, U>>) -> ColumnExpression<U.IDValue> where T: Model, U.IDValue: PSQLExpressible {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: alias,
            pathName: path,
            schemaName: T.schema,
            columnName: field.$id.key.description
        )
    }
}

extension TableAlias: FromSQLExpressible {
    public var fromSqlExpression: some SQLExpression {
        _From(
            aliasName: alias,
            pathName: T.path,
            schemaName: T.schema
        )
    }
    
    private struct _From: SQLExpression {
        let aliasName: String
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
            
            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()
            
            serializer.writeQuote()
            serializer.write(aliasName)
            serializer.writeQuote()
        }
    }
}
