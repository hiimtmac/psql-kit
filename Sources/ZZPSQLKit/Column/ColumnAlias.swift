import Foundation
import SQLKit

struct ColumnAlias<T> where T: PKExpressible {
    let column: ColumnExpression<T>
    let alias: String
}

extension ColumnAlias: SelectSQLExpressible {
    var selectSqlExpression: Select {
        .init(
            aliasName: column.aliasName,
            pathName: column.pathName,
            schemaName: column.schemaName,
            columnName: column.columnName,
            columnType: T.postgresColumnType,
            columnAlias: alias
        )
    }
    
    struct Select: SQLExpression {
        let aliasName: String?
        let pathName: String?
        let schemaName: String?
        let columnName: String
        let columnType: SQLExpression
        let columnAlias: String
        
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
            
            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()
            
            serializer.writeQuote()
            serializer.write(columnAlias)
            serializer.writeQuote()
        }
    }
}
