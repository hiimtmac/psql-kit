// QueryTuple.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct QueryTuple<each T>: Sendable where repeat each T: Sendable {
    let content: (repeat each T)

    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
}

extension QueryTuple: FromSQLExpression where repeat each T: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        SQLList(fromSQLExpressions: repeat each content)
    }
}

extension QueryTuple: GroupBySQLExpression where repeat each T: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression {
        SQLList(groupBySQLExpressions: repeat each content)
    }
}

extension QueryTuple: HavingSQLExpression where repeat each T: HavingSQLExpression {
    public var havingSqlExpression: some SQLExpression {
        SQLList(havingSQLExpressions: repeat each content)
    }
}

extension QueryTuple: InsertSQLExpression where repeat each T: InsertSQLExpression {
    public var insertColumnSqlExpression: some SQLExpression {
        SQLList(insertColumnSQLExpressions: repeat each content)
    }
    
    public var insertValueSqlExpression: some SQLExpression {
        SQLList(insertValueSQLExpressions: repeat each content)
    }
}

extension QueryTuple: JoinSQLExpression where repeat each T: JoinSQLExpression {
    public var joinSqlExpression: some SQLExpression {
        SQLList(joinSQLExpressions: repeat each content)
    }
}

extension QueryTuple: OrderBySQLExpression where repeat each T: OrderBySQLExpression {
    public var orderBySqlExpression: some SQLExpression {
        SQLList(orderBySQLExpressions: repeat each content)
    }
}

extension QueryTuple: QuerySQLExpression where repeat each T: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression {
        SQLList(querySQLExpressions: repeat each content)
    }
}

extension QueryTuple: SelectSQLExpression where repeat each T: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        SQLList(selectSQLExpressions: repeat each content)
    }
}

extension QueryTuple: UnionSQLExpression where repeat each T: UnionSQLExpression {
    public var unionSqlExpression: some SQLExpression {
        SQLList(unionSQLExpressions: repeat each content)
    }
}

extension QueryTuple: UpdateSQLExpression where repeat each T: UpdateSQLExpression {
    public var updateSqlExpression: some SQLExpression {
        SQLList(updateSQLExpressions: repeat each content)
    }
}

extension QueryTuple: WhereSQLExpression where repeat each T: WhereSQLExpression {
    public var whereSqlExpression: some SQLExpression {
        SQLList(whereSQLExpressions: repeat each content)
    }
}

extension QueryTuple: WithSQLExpression where repeat each T: WithSQLExpression {
    public var withSqlExpression: some SQLExpression {
        SQLList(withSQLExpressions: repeat each content)
    }
}
