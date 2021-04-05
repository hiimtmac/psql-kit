import Foundation
import SQLKit

public struct AllTableSelection<T> where T: Table {
    let table: T
}

// MARK: Select
extension AllTableSelection: SelectSQLExpression {
    private struct _Select: SQLExpression {
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
            serializer.writePeriod()
            serializer.write("*")
        }
    }
    
    public var selectSqlExpression: SQLExpression {
        _Select(pathName: T.path, schemaName: T.schema)
    }
}

// MARK: - Alias
extension AllTableSelection {
    public struct Alias {
        let table: TableAlias<T>
    }
}

extension AllTableSelection.Alias: SelectSQLExpression {
    private struct _Select: SQLExpression {
        let aliasName: String
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(aliasName)
            serializer.writeQuote()
            serializer.writePeriod()
            serializer.write("*")
        }
    }
    
    public var selectSqlExpression: SQLExpression {
        _Select(aliasName: table.alias)
    }
}
