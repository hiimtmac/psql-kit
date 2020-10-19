import Foundation
import SQLKit
import PostgresKit

struct RawColumn<T> where T: PSQLExpressible {
    let column: String
    
    init(_ column: String) {
        self.column = column
    }
}

extension RawColumn: TypeEquatable {
    typealias CompareType = T
}

extension RawColumn: SelectSQLExpressible {
    struct Select: SQLExpression {
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
    
    var selectSqlExpression: Select { .init(column: column, type: T.postgresColumnType) }
}

extension RawColumn: GroupBySQLExpressible {
    struct GroupBy: SQLExpression {
        let column: String
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(column)
            serializer.writeQuote()
        }
    }
    
    var groupBySqlExpression: GroupBy { .init(column: column) }
}

extension RawColumn: OrderBySQLExpressible {
    struct OrderBy: SQLExpression {
        let column: String
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(column)
            serializer.writeQuote()
        }
    }
    
    var orderBySqlExpression: OrderBy { .init(column: column) }
    
    func asc() -> OrderByModifier<RawColumn> {
        order(.asc)
    }
    
    func desc() -> OrderByModifier<RawColumn> {
        order(.desc)
    }
    
    func order(_ direction: OrderByDirection) -> OrderByModifier<RawColumn> {
        .init(content: self, direction: direction)
    }
}

extension RawColumn: CompareSQLExpressible {
    struct Compare: SQLExpression {
        let column: String
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(column)
            serializer.writeQuote()
        }
    }
    
    var compareSqlExpression: Compare { .init(column: column) }
}
