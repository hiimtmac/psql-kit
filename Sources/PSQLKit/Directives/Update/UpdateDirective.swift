import Foundation
import SQLKit

public struct UpdateDirective<Table>: SQLExpression where Table: FromSQLExpression {
    let table: Table
    let content: [UpdateSQLExpression]
    
    public init(_ table: Table, @UpdateBuilder builder: () -> [UpdateSQLExpression]) {
        self.table = table
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if !content.isEmpty {
            serializer.write("UPDATE")
            serializer.writeSpace()
            table.fromSqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            serializer.write("SET")
            serializer.writeSpace()
            SQLList(content.map(\.updateSqlExpression))
                .serialize(to: &serializer)
        }
    }
}

extension UpdateDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
