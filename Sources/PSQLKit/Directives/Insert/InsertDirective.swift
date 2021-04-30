import Foundation
import SQLKit

public struct InsertDirective<Table>: SQLExpression where Table: FromSQLExpression {
    let table: Table
    let content: [InsertSQLExpression]
    
    public init(into table: Table, @InsertBuilder builder: () -> [InsertSQLExpression]) {
        self.table = table
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if !content.isEmpty {
            serializer.write("INSERT INTO")
            serializer.writeSpace()
            table.fromSqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            serializer.write("(")
            SQLList(content.map(\.insertColumnSqlExpression))
                .serialize(to: &serializer)
            serializer.write(")")
            serializer.writeSpace()
            serializer.write("VALUES")
            serializer.writeSpace()
            serializer.write("(")
            SQLList(content.map(\.insertValueSqlExpression))
                .serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension InsertDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
