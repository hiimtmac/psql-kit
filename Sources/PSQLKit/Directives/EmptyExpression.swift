import Foundation
import SQLKit

public struct EmptyExpression: SQLExpression {
    
    public func serialize(to serializer: inout SQLSerializer) {}
}

extension EmptyExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension EmptyExpression: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression { self }
}

extension EmptyExpression: WhereSQLExpression {
    public var whereSqlExpression: some SQLExpression { self }
}

extension EmptyExpression: WithSQLExpression {
    public var withSqlExpression: some SQLExpression { self }
}

extension EmptyExpression: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}

extension EmptyExpression: OrderBySQLExpression {
    public var orderBySqlExpression: some SQLExpression { self }
}

extension EmptyExpression: JoinSQLExpression {
    public var joinSqlExpression: some SQLExpression { self }
}

extension EmptyExpression: HavingSQLExpression {
    public var havingSqlExpression: some SQLExpression { self }
}

extension EmptyExpression: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression { self }
}

extension EmptyExpression: InsertSQLExpression {
    public var insertColumnSqlExpression: some SQLExpression { self }
    public var insertValueSqlExpression: some SQLExpression { self }
}

extension EmptyExpression: UpdateSQLExpression {
    public var updateSqlExpression: some SQLExpression { self }
}
