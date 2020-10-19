import Foundation
import SQLKit

extension Array: CompareSQLExpressible where Element: PKExpressible {
    struct Compare: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("(")
            SQLList(expressions).serialize(to: &serializer)
            serializer.write(")")
        }
    }
    
    var compareSqlExpression: Compare {
        .init(expressions: self)
    }
}
