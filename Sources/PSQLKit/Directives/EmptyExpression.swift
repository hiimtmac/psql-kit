import Foundation
import SQLKit

public struct EmptyExpression: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {}
}

extension EmptyExpression: SelectSQLExpression {
    public var selectSqlExpression: SQLExpression { self }
}

extension EmptyExpression: FromSQLExpression {
    public var fromSqlExpression: SQLExpression { self }
}

extension EmptyExpression: WhereSQLExpression {
    public var whereSqlExpression: SQLExpression { self }
}

extension EmptyExpression: WithSQLExpression {
    public var withSqlExpression: SQLExpression { self }
}

extension EmptyExpression: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}

extension EmptyExpression: OrderBySQLExpression {
    public var orderBySqlExpression: SQLExpression { self }
}

extension EmptyExpression: JoinSQLExpression {
    public var joinSqlExpression: SQLExpression { self }
}

extension EmptyExpression: HavingSQLExpression {
    public var havingSqlExpression: SQLExpression { self }
}

extension EmptyExpression: GroupBySQLExpression {
    public var groupBySqlExpression: SQLExpression { self }
}

extension EmptyExpression: InsertSQLExpression {
    public var insertColumnSqlExpression: SQLExpression { self }
    public var insertValueSqlExpression: SQLExpression { self }
}

extension EmptyExpression: UpdateSQLExpression {
    public var updateSqlExpression: SQLExpression { self }
}
