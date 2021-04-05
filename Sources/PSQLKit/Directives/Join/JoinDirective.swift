import Foundation
import SQLKit

public struct JoinDirective<Table, Content>: SQLExpression where Table: FromSQLExpression, Content: JoinSQLExpression {
    let table: Table
    let method: SQLJoinMethod
    let content: Content
    
    public init(_ table: Table, method: SQLJoinMethod = .inner, @JoinBuilder builder: () -> Content) {
        self.table = table
        self.method = method
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        method.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("JOIN")
        serializer.writeSpace()
        table.fromSqlExpression.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("ON")
        serializer.writeSpace()
        content.joinSqlExpression.serialize(to: &serializer)
    }
}

extension JoinDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
