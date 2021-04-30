import Foundation
import SQLKit
import PostgresKit

public protocol Concatenatable: BaseSQLExpression {
    
}

// MARK: ConcatenateExpression
public struct ConcatenateExpression {
    let values: [SQLExpression]
    
    public init<T0, T1>
    (
        _ t0: T0,
        _ t1: T1
    ) where
        T0: Concatenatable,
        T1: Concatenatable
    {
        self.values = [
            t0.baseSqlExpression,
            t1.baseSqlExpression
        ]
    }
    
    public init<T0, T1, T2>
    (
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) where
        T0: Concatenatable,
        T1: Concatenatable,
        T2: Concatenatable
    {
        self.values = [
            t0.baseSqlExpression,
            t1.baseSqlExpression,
            t2.baseSqlExpression
        ]
    }
    
    public init<T0, T1, T2, T3>
    (
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) where
        T0: Concatenatable,
        T1: Concatenatable,
        T2: Concatenatable,
        T3: Concatenatable
    {
        self.values = [
            t0.baseSqlExpression,
            t1.baseSqlExpression,
            t2.baseSqlExpression,
            t3.baseSqlExpression
        ]
    }
    
    public init<T0, T1, T2, T3, T4>
    (
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) where
        T0: Concatenatable,
        T1: Concatenatable,
        T2: Concatenatable,
        T3: Concatenatable,
        T4: Concatenatable
    {
        self.values = [
            t0.baseSqlExpression,
            t1.baseSqlExpression,
            t2.baseSqlExpression,
            t3.baseSqlExpression,
            t4.baseSqlExpression
        ]
    }
}

extension ConcatenateExpression: TypeEquatable {
    public typealias CompareType = String
}

extension ConcatenateExpression: SelectSQLExpression {
    public var selectSqlExpression: SQLExpression {
        _Select(values: values)
    }
    
    private struct _Select: SQLExpression {
        let values: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList(values).serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.text.serialize(to: &serializer)
        }
    }
}

extension ConcatenateExpression: GroupBySQLExpression {
    public var groupBySqlExpression: SQLExpression {
        _GroupBy(values: values)
    }
    
    private struct _GroupBy: SQLExpression {
        let values: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList(values).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression: CompareSQLExpression {
    public var compareSqlExpression: SQLExpression {
        _Compare(values: values)
    }
    
    private struct _Compare: SQLExpression {
        let values: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList(values).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ConcatenateExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
