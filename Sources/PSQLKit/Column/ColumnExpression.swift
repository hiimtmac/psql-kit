import Foundation
import SQLKit

public struct ColumnExpression<T> where T: PSQLExpressible {
    let aliasName: String?
    let pathName: String?
    let schemaName: String?
    let columnName: String
    
    public init(aliasName: String?, pathName: String?, schemaName: String, columnName: String) {
        self.aliasName = aliasName
        self.pathName = pathName
        self.schemaName = schemaName
        self.columnName = columnName
    }
}

extension ColumnExpression: SelectSQLExpressible  {
    public var selectSqlExpression: some SQLExpression {
        _Select(
            aliasName: aliasName,
            pathName: pathName,
            schemaName: schemaName,
            columnName: columnName,
            columnType: T.postgresColumnType
        )
    }
    
    private struct _Select: SQLExpression {
        let aliasName: String?
        let pathName: String?
        let schemaName: String?
        let columnName: String
        let columnType: SQLExpression
        
        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuote()
                serializer.write(alias)
                serializer.writeQuote()
                serializer.writePeriod()
            } else {
                if let path = pathName {
                    serializer.writeQuote()
                    serializer.write(path)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }
                
                if let schema = schemaName {
                    serializer.writeQuote()
                    serializer.write(schema)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }
            }
            
            serializer.writeQuote()
            serializer.write(columnName)
            serializer.writeQuote()
            
            serializer.write("::")
            columnType.serialize(to: &serializer)
        }
    }
}

extension ColumnExpression {
    public func `as`(_ alias: String) -> ColumnAlias<T> {
        ColumnAlias(column: self, alias: alias)
    }
}

extension ColumnExpression: GroupBySQLExpressible {
    public var groupBySqlExpression: some SQLExpression {
        _GroupBy(
            aliasName: aliasName,
            pathName: pathName,
            schemaName: schemaName,
            columnName: columnName
        )
    }
    
    private struct _GroupBy: SQLExpression {
        let aliasName: String?
        let pathName: String?
        let schemaName: String?
        let columnName: String
        
        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuote()
                serializer.write(alias)
                serializer.writeQuote()
                serializer.writePeriod()
            } else {
                if let path = pathName {
                    serializer.writeQuote()
                    serializer.write(path)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }
                
                if let schema = schemaName {
                    serializer.writeQuote()
                    serializer.write(schema)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }
            }
            
            serializer.writeQuote()
            serializer.write(columnName)
            serializer.writeQuote()
        }
    }
}

extension ColumnExpression {
    func asc() -> OrderByModifier<ColumnExpression<T>> {
        order(.asc)
    }

    func desc() -> OrderByModifier<ColumnExpression<T>> {
        order(.desc)
    }

    func order(_ direction: OrderByDirection) -> OrderByModifier<ColumnExpression<T>> {
        OrderByModifier(content: self, direction: direction)
    }
}

extension ColumnExpression: OrderBySQLExpressible {
    public var orderBySqlExpression: some SQLExpression {
        _OrderBy(
            aliasName: aliasName,
            pathName: pathName,
            schemaName: schemaName,
            columnName: columnName
        )
    }

    private struct _OrderBy: SQLExpression {
        let aliasName: String?
        let pathName: String?
        let schemaName: String?
        let columnName: String

        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuote()
                serializer.write(alias)
                serializer.writeQuote()
                serializer.writePeriod()
            } else {
                if let path = pathName {
                    serializer.writeQuote()
                    serializer.write(path)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }

                if let schema = schemaName {
                    serializer.writeQuote()
                    serializer.write(schema)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }
            }

            serializer.writeQuote()
            serializer.write(columnName)
            serializer.writeQuote()
        }
    }
}

extension ColumnExpression: CompareSQLExpressible {    
    public var compareSqlExpression: some SQLExpression {
        _Compare(
            aliasName: aliasName,
            pathName: pathName,
            schemaName: schemaName,
            columnName: columnName
        )
    }
    
    private struct _Compare: SQLExpression {
        let aliasName: String?
        let pathName: String?
        let schemaName: String?
        let columnName: String
        
        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuote()
                serializer.write(alias)
                serializer.writeQuote()
                serializer.writePeriod()
            } else {
                if let path = pathName {
                    serializer.writeQuote()
                    serializer.write(path)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }
                
                if let schema = schemaName {
                    serializer.writeQuote()
                    serializer.write(schema)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }
            }
            
            serializer.writeQuote()
            serializer.write(columnName)
            serializer.writeQuote()
        }
    }
}

extension ColumnExpression: TypeEquatable {
    public typealias CompareType = T
}
