import Foundation
import SQLKit

struct ColumnExpression<T> where T: PKExpressible {
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
    var selectSqlExpression: Select {
        .init(
            aliasName: aliasName,
            pathName: pathName,
            schemaName: schemaName,
            columnName: columnName,
            columnType: T.postgresColumnType
        )
    }
    
    struct Select: SQLExpression {
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
    func `as`(_ alias: String) -> ColumnAlias<T> {
        ColumnAlias(column: self, alias: alias)
    }
}
