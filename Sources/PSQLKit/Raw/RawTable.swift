import Foundation
import SQLKit

public struct RawTable: SQLExpression {
    let table: String
    
    public init(_ table: String) {
        self.table = table
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.writeQuote()
        serializer.write(table)
        serializer.writeQuote()
    }
}

extension RawTable: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression { self }
}
