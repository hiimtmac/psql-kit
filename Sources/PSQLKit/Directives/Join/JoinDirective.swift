import Foundation
import SQLKit

public struct JoinDirective<Table>: SQLExpression where Table: FromSQLExpression {
    let table: Table
    let method: SQLJoinMethod
    let content: [JoinSQLExpression]
    
    public init(_ table: Table, method: SQLJoinMethod = .inner, @JoinBuilder builder: () -> [JoinSQLExpression]) {
        self.table = table
        self.method = method
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if !content.isEmpty {
            method.serialize(to: &serializer)
            serializer.writeSpace()
            serializer.write("JOIN")
            serializer.writeSpace()
            table.fromSqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            serializer.write("ON")
            serializer.writeSpace()
            SQLList(content.map(\.joinSqlExpression), separator: SQLRaw(" AND "))
                .serialize(to: &serializer)
        }
    }
}

extension JoinDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
