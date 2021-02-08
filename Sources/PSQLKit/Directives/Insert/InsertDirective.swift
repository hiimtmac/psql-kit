import Foundation
import SQLKit

public struct InsertDirective<Table, Content>: SQLExpression where Table: FromSQLExpression, Content: InsertSQLExpression {
    let table: Table
    let content: Content
    
    public init(into table: Table, @InsertBuilder builder: () -> Content) {
        self.table = table
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("INSERT INTO")
        serializer.writeSpace()
        table.fromSqlExpression.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("(")
        content.insertColumnSqlExpression.serialize(to: &serializer)
        serializer.write(")")
        serializer.writeSpace()
        serializer.write("VALUES")
        serializer.writeSpace()
        serializer.write("(")
        content.insertValueSqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension InsertDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
