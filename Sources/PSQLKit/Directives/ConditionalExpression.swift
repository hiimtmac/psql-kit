import Foundation
import SQLKit

public struct _ConditionalExpression<TrueContent, FalseContent> {
    enum Content {
        case first(TrueContent)
        case second(FalseContent)
    }
    
    let content: Content
    
    init(first: TrueContent) {
        content = .first(first)
    }
    
    init(second: FalseContent) {
        content = .second(second)
    }
}

extension _ConditionalExpression: SelectSQLExpression where TrueContent: SelectSQLExpression, FalseContent: SelectSQLExpression {
    private struct _Select: SQLExpression {
        let content: _ConditionalExpression.Content
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .first(let select):
                select.selectSqlExpression.serialize(to: &serializer)
            case .second(let select):
                select.selectSqlExpression.serialize(to: &serializer)
            }
        }
    }
    
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content)
    }
}

extension _ConditionalExpression: FromSQLExpression where TrueContent: FromSQLExpression, FalseContent: FromSQLExpression {
    private struct _From: SQLExpression {
        let content: _ConditionalExpression.Content
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .first(let select):
                select.fromSqlExpression.serialize(to: &serializer)
            case .second(let select):
                select.fromSqlExpression.serialize(to: &serializer)
            }
        }
    }
    
    public var fromSqlExpression: some SQLExpression {
        _From(content: content)
    }
}

extension _ConditionalExpression: GroupBySQLExpression where TrueContent: GroupBySQLExpression, FalseContent: GroupBySQLExpression {
    private struct _GroupBy: SQLExpression {
        let content: _ConditionalExpression.Content
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .first(let select):
                select.groupBySqlExpression.serialize(to: &serializer)
            case .second(let select):
                select.groupBySqlExpression.serialize(to: &serializer)
            }
        }
    }
    
    public var groupBySqlExpression: some SQLExpression {
        _GroupBy(content: content)
    }
}

extension _ConditionalExpression: HavingSQLExpression where TrueContent: HavingSQLExpression, FalseContent: HavingSQLExpression {
    private struct _Having: SQLExpression {
        let content: _ConditionalExpression.Content
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .first(let select):
                select.havingSqlExpression.serialize(to: &serializer)
            case .second(let select):
                select.havingSqlExpression.serialize(to: &serializer)
            }
        }
    }
    
    public var havingSqlExpression: some SQLExpression {
        _Having(content: content)
    }
}

extension _ConditionalExpression: JoinSQLExpression where TrueContent: JoinSQLExpression, FalseContent: JoinSQLExpression {
    private struct _Join: SQLExpression {
        let content: _ConditionalExpression.Content
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .first(let select):
                select.joinSqlExpression.serialize(to: &serializer)
            case .second(let select):
                select.joinSqlExpression.serialize(to: &serializer)
            }
        }
    }
    
    public var joinSqlExpression: some SQLExpression {
        _Join(content: content)
    }
}

extension _ConditionalExpression: OrderBySQLExpression where TrueContent: OrderBySQLExpression, FalseContent: OrderBySQLExpression {
    private struct _OrderBy: SQLExpression {
        let content: _ConditionalExpression.Content
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .first(let select):
                select.orderBySqlExpression.serialize(to: &serializer)
            case .second(let select):
                select.orderBySqlExpression.serialize(to: &serializer)
            }
        }
    }
    
    public var orderBySqlExpression: some SQLExpression {
        _OrderBy(content: content)
    }
}

extension _ConditionalExpression: QuerySQLExpression where TrueContent: QuerySQLExpression, FalseContent: QuerySQLExpression {
    private struct _Query: SQLExpression {
        let content: _ConditionalExpression.Content
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .first(let select):
                select.querySqlExpression.serialize(to: &serializer)
            case .second(let select):
                select.querySqlExpression.serialize(to: &serializer)
            }
        }
    }
    
    public var querySqlExpression: some SQLExpression {
        _Query(content: content)
    }
}

extension _ConditionalExpression: WhereSQLExpression where TrueContent: WhereSQLExpression, FalseContent: WhereSQLExpression {
    private struct _Where: SQLExpression {
        let content: _ConditionalExpression.Content
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .first(let select):
                select.whereSqlExpression.serialize(to: &serializer)
            case .second(let select):
                select.whereSqlExpression.serialize(to: &serializer)
            }
        }
    }
    
    public var whereSqlExpression: some SQLExpression {
        _Where(content: content)
    }
}

extension _ConditionalExpression: WithSQLExpression where TrueContent: WithSQLExpression, FalseContent: WithSQLExpression {
    private struct _With: SQLExpression {
        let content: _ConditionalExpression.Content
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .first(let select):
                select.withSqlExpression.serialize(to: &serializer)
            case .second(let select):
                select.withSqlExpression.serialize(to: &serializer)
            }
        }
    }
    
    public var withSqlExpression: some SQLExpression {
        _With(content: content)
    }
}
