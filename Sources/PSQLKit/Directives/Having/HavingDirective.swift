import Foundation
import SQLKit

public struct HavingDirective: SQLExpression {
    let content: [HavingSQLExpression]
    
    public init(@HavingBuilder builder: () -> [HavingSQLExpression]) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if !content.isEmpty {
            serializer.write("HAVING")
            serializer.writeSpace()
            SQLList(content.map(\.havingSqlExpression), separator: SQLRaw(" AND "))
                .serialize(to: &serializer)
        }
    }
}

extension HavingDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
