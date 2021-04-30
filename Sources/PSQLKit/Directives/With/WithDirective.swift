import Foundation
import SQLKit

public struct WithDirective: SQLExpression {
    let content: [WithSQLExpression]
    
    public init(@WithBuilder builder: () -> [WithSQLExpression]) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if !content.isEmpty {
            serializer.write("WITH")
            serializer.writeSpace()
            SQLList(content.map(\.withSqlExpression))
                .serialize(to: &serializer)
        }
    }
}

extension WithDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression{ self }
}
