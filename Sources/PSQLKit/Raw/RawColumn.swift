import Foundation
import SQLKit
import PostgresKit

public struct RawColumn<T> where T: PSQLExpressible {
    let column: String
    
    public init(_ column: String) {
        self.column = column
    }
}

extension RawColumn {
    public func `as`(_ alias: String) -> RawColumnAlias<T> {
        RawColumnAlias(column: self, alias: alias)
    }
}

extension RawColumn: TypeEquatable {
    public typealias CompareType = T
}

extension RawColumn: SelectSQLExpressible {
    private struct _Select: SQLExpression {
        let column: String
        let type: PostgresColumnType
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(column)
            serializer.writeQuote()
            serializer.write("::")
            type.serialize(to: &serializer)
        }
    }
    
    public var selectSqlExpression: some SQLExpression {
        _Select(column: column, type: T.postgresColumnType)
    }
}

extension RawColumn: GroupBySQLExpressible {
    private struct _GroupBy: SQLExpression {
        let column: String
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(column)
            serializer.writeQuote()
        }
    }
    
    public var groupBySqlExpression: some SQLExpression {
        _GroupBy(column: column)
    }
}

extension RawColumn: OrderBySQLExpressible {
    private struct _OrderBy: SQLExpression {
        let column: String
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(column)
            serializer.writeQuote()
        }
    }
    
    public var orderBySqlExpression: some SQLExpression {
        _OrderBy(column: column)
    }
    
    public func asc() -> OrderByModifier<RawColumn> {
        order(.asc)
    }
    
    public func desc() -> OrderByModifier<RawColumn> {
        order(.desc)
    }
    
    public func order(_ direction: OrderByDirection) -> OrderByModifier<RawColumn> {
        .init(content: self, direction: direction)
    }
}

extension RawColumn: CompareSQLExpressible {
    private struct _Compare: SQLExpression {
        let column: String
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(column)
            serializer.writeQuote()
        }
    }
    
    public var compareSqlExpression: some SQLExpression {
        _Compare(column: column)
    }
}
