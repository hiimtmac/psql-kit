import Foundation
import SQLKit

public typealias SELECTGROUP = SelectGrouping
public struct SelectGrouping<Content>: SelectSQLExpression where Content: SelectSQLExpression {
    let content: Content
    
    public init(@SelectBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var selectSqlExpression: SQLExpression {
        content.selectSqlExpression
    }
}

public typealias FROMGROUP = FromGrouping
public struct FromGrouping<Content>: FromSQLExpression where Content: FromSQLExpression {
    let content: Content
    
    public init(@FromBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var fromSqlExpression: SQLExpression {
        content.fromSqlExpression
    }
}

public typealias GROUPBYGROUP = GroupByGrouping
public struct GroupByGrouping<Content>: GroupBySQLExpression where Content: GroupBySQLExpression {
    let content: Content
    
    public init(@GroupByBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var groupBySqlExpression: SQLExpression {
        content.groupBySqlExpression
    }
}

public typealias HAVINGGROUP = HavingGrouping
public struct HavingGrouping<Content>: HavingSQLExpression where Content: HavingSQLExpression {
    let content: Content
    
    public init(@HavingBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var havingSqlExpression: SQLExpression {
        content.havingSqlExpression
    }
}

public typealias JOINGROUP = JoinGrouping
public struct JoinGrouping<Content>: JoinSQLExpression where Content: JoinSQLExpression {
    let content: Content
    
    public init(@JoinBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var joinSqlExpression: SQLExpression {
        content.joinSqlExpression
    }
}

public typealias ORDERBYGROUP = OrderByGrouping
public struct OrderByGrouping<Content>: OrderBySQLExpression where Content: OrderBySQLExpression {
    let content: Content
    
    public init(@OrderByBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var orderBySqlExpression: SQLExpression {
        content.orderBySqlExpression
    }
}

public typealias QUERYGROUP = QueryGrouping
public struct QueryGrouping<Content>: QuerySQLExpression where Content: QuerySQLExpression {
    let content: Content
    
    public init(@QueryBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var querySqlExpression: SQLExpression {
        content.querySqlExpression
    }
}

public typealias WHEREGROUP = WhereGrouping
public struct WhereGrouping<Content>: WhereSQLExpression where Content: WhereSQLExpression {
    let content: Content
    
    public init(@WhereBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var whereSqlExpression: SQLExpression {
        content.whereSqlExpression
    }
}

public typealias WITHGROUP = WithGrouping
public struct WithGrouping<Content>: WithSQLExpression where Content: WithSQLExpression {
    let content: Content
    
    public init(@WithBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public var withSqlExpression: SQLExpression {
        content.withSqlExpression
    }
}
