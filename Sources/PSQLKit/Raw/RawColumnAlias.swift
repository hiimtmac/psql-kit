import Foundation
import SQLKit
import PostgresKit

public struct RawColumnAlias<T> where T: PSQLExpressible {
    let column: RawColumn<T>
    let alias: String
    
    public init(column: RawColumn<T>, alias: String) {
        self.column = column
        self.alias = alias
    }
}

extension RawColumnAlias: SelectSQLExpressible {
    private struct _Select: SQLExpression {
        let column: RawColumn<T>
        let alias: String
        
        func serialize(to serializer: inout SQLSerializer) {
            column.selectSqlExpression.serialize(to: &serializer)
            
            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()
            
            serializer.writeQuote()
            serializer.write(alias)
            serializer.writeQuote()
        }
    }
    
    public var selectSqlExpression: some SQLExpression {
        _Select(column: column, alias: alias)
    }
}
