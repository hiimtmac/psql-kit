import Foundation
import SQLKit

public struct AllTableSelection<T> where T: Table {
    let table: T
}

extension AllTableSelection: SelectSQLExpressible {
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
    
    public var selectSqlExpression: some SQLExpression {
        _Select(pathName: T.path, schemaName: T.schema)
    }
}

public struct AllTableAliasSelection<T> where T: Table {
    let tableAlias: TableAlias<T>
}

extension AllTableAliasSelection: SelectSQLExpressible {
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
    
    public var selectSqlExpression: some SQLExpression {
        _Select(aliasName: tableAlias.alias)
    }
}
