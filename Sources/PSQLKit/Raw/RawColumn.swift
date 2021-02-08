import Foundation
import SQLKit
import PostgresKit

public struct RawColumn<T> where T: PSQLExpression {
    let column: String
    
    public init(_ column: String) {
        self.column = column
    }
}

extension RawColumn {
    public func `as`(_ alias: String) -> RawColumn<T>.Alias {
        Alias(column: self, alias: alias)
    }
}

extension RawColumn: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension RawColumn: SelectSQLExpression {
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

extension RawColumn: GroupBySQLExpression {
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

extension RawColumn: OrderBySQLExpression {
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

extension RawColumn: CompareSQLExpression {
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

// MARK: - Alias
extension RawColumn {
    public struct Alias {
        let column: RawColumn<T>
        let alias: String
        
        public init(column: RawColumn<T>, alias: String) {
            self.column = column
            self.alias = alias
        }
    }
}


extension RawColumn.Alias: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension RawColumn.Alias: SelectSQLExpression {
    private struct _Select: SQLExpression {
        let column: RawColumn<T>
        let alias: String
        
        func serialize(to serializer: inout SQLSerializer) {
            column.selectSqlExpression.serialize(to: &serializer)
            
            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()
            
            serializer.writeQuote()
            serializer.write(alias)
            serializer.writeQuote()
        }
    }
    
    public var selectSqlExpression: some SQLExpression {
        _Select(column: column, alias: alias)
    }
}
