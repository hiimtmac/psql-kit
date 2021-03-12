import Foundation
import SQLKit
import PostgresKit

public protocol Coalescable: BaseSQLExpression {}

// MARK: CoalesceExpression
public struct CoalesceExpression<T> where
    T: TypeEquatable
{
    let values: [SQLExpression]
    
    public init<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) where
        T0: Coalescable & TypeEquatable,
        T1: Coalescable & TypeEquatable,
        T.CompareType == T0.CompareType,
        T0.CompareType == T1.CompareType
    {
        self.values = [
            t0.baseSqlExpression,
            t1.baseSqlExpression
        ]
    }
    
    public init<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) where
        T0: Coalescable & TypeEquatable,
        T1: Coalescable & TypeEquatable,
        T2: Coalescable & TypeEquatable,
        T.CompareType == T0.CompareType,
        T0.CompareType == T1.CompareType,
        T1.CompareType == T2.CompareType
    {
        self.values = [
            t0.baseSqlExpression,
            t1.baseSqlExpression,
            t2.baseSqlExpression
        ]
    }
    
    public init<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) where
        T0: Coalescable & TypeEquatable,
        T1: Coalescable & TypeEquatable,
        T2: Coalescable & TypeEquatable,
        T3: Coalescable & TypeEquatable,
        T.CompareType == T0.CompareType,
        T0.CompareType == T1.CompareType,
        T1.CompareType == T2.CompareType,
        T2.CompareType == T3.CompareType
    {
        self.values = [
            t0.baseSqlExpression,
            t1.baseSqlExpression,
            t2.baseSqlExpression,
            t3.baseSqlExpression
        ]
    }
    
    public init<T0, T1, T2, T3, T4>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) where
        T0: Coalescable & TypeEquatable,
        T1: Coalescable & TypeEquatable,
        T2: Coalescable & TypeEquatable,
        T3: Coalescable & TypeEquatable,
        T4: Coalescable & TypeEquatable,
        T.CompareType == T0.CompareType,
        T0.CompareType == T1.CompareType,
        T1.CompareType == T2.CompareType,
        T2.CompareType == T3.CompareType,
        T3.CompareType == T4.CompareType
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

extension CoalesceExpression: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension CoalesceExpression: Coalescable {}

extension CoalesceExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        _Base(values: values)
    }
    
    private struct _Base: SQLExpression {
        let values: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("COALESCE")
            serializer.write("(")
            SQLList(values).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension CoalesceExpression: SelectSQLExpression where
    T: SelectSQLExpression & PSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(values: values)
    }
    
    private struct _Select: SQLExpression {
        let values: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("COALESCE")
            serializer.write("(")
            SQLList(values).serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            T.postgresColumnType.serialize(to: &serializer)
        }
    }
}

extension CoalesceExpression: CompareSQLExpression where
    T: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Base(values: values)
    }
}

extension CoalesceExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<CoalesceExpression<T>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
