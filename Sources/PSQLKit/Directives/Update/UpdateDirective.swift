import Foundation
import SQLKit

public struct UpdateDirective<Table, Content>: SQLExpression where Table: FromSQLExpression, Content: UpdateSQLExpression {
    let table: Table
    let content: Content
    
    public init(_ table: Table, @UpdateBuilder builder: () -> Content) {
        self.table = table
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("UPDATE")
        serializer.writeSpace()
        table.fromSqlExpression.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("SET")
        serializer.writeSpace()
        content.updateSqlExpression.serialize(to: &serializer)
    }
}

extension UpdateDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
