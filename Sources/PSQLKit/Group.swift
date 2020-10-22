import Foundation
import SQLKit

public typealias SELECTGROUP = SelectGrouping
public struct SelectGrouping<Content>: SelectSQLExpressible where Content: SelectSQLExpressible {
    let content: Content
    
    public init(@SelectBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var selectSqlExpression: some SQLExpression {
        content.selectSqlExpression
    }
}

public typealias FROMGROUP = FromGrouping
public struct FromGrouping<Content>: FromSQLExpressible where Content: FromSQLExpressible {
    let content: Content
    
    public init(@FromBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var fromSqlExpression: some SQLExpression {
        content.fromSqlExpression
    }
}

public typealias GROUPBYGROUP = GroupByGrouping
public struct GroupByGrouping<Content>: GroupBySQLExpressible where Content: GroupBySQLExpressible {
    let content: Content
    
    public init(@GroupByBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var groupBySqlExpression: some SQLExpression {
        content.groupBySqlExpression
    }
}

public typealias HAVINGGROUP = HavingGrouping
public struct HavingGrouping<Content>: HavingSQLExpressible where Content: HavingSQLExpressible {
    let content: Content
    
    public init(@HavingBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var havingSqlExpression: some SQLExpression {
        content.havingSqlExpression
    }
}

public typealias JOINGROUP = JoinGrouping
public struct JoinGrouping<Content>: JoinSQLExpressible where Content: JoinSQLExpressible {
    let content: Content
    
    public init(@JoinBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var joinSqlExpression: some SQLExpression {
        content.joinSqlExpression
    }
}

public typealias ORDERBYGROUP = OrderByGrouping
public struct OrderByGrouping<Content>: OrderBySQLExpressible where Content: OrderBySQLExpressible {
    let content: Content
    
    public init(@OrderByBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var orderBySqlExpression: some SQLExpression {
        content.orderBySqlExpression
    }
}

public typealias QUERYGROUP = QueryGrouping
public struct QueryGrouping<Content>: QuerySQLExpressible where Content: QuerySQLExpressible {
    let content: Content
    
    public init(@QueryBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var querySqlExpression: some SQLExpression {
        content.querySqlExpression
    }
}

public typealias WHEREGROUP = WhereGrouping
public struct WhereGrouping<Content>: WhereSQLExpressible where Content: WhereSQLExpressible {
    let content: Content
    
    public init(@WhereBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var whereSqlExpression: some SQLExpression {
        content.whereSqlExpression
    }
}

public typealias WITHGROUP = WithGrouping
public struct WithGrouping<Content>: WithSQLExpressible where Content: WithSQLExpressible {
    let content: Content
    
    public init(@WithBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var withSqlExpression: some SQLExpression {
        content.withSqlExpression
    }
}
