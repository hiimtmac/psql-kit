import Foundation
import SQLKit

struct RawTable: SQLExpression {
    let table: String
    
    init(_ table: String) {
        self.table = table
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.writeQuote()
        serializer.write(table)
        serializer.writeQuote()
    }
}

extension RawTable: FromSQLExpressible {
    var fromSqlExpression: Self { self }
}
