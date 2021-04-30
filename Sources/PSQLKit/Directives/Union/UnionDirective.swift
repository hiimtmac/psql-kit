import Foundation
import SQLKit

public struct UnionDirective: SQLExpression {
    let content: [UnionSQLExpression]
    
    public init(@UnionBuilder builder: () -> [UnionSQLExpression]) {
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        if !content.isEmpty {
            SQLList(content.map(\.unionSqlExpression), separator: SQLRaw(" UNION "))
                .serialize(to: &serializer)
        }
    }
}

extension UnionDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
