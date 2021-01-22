import Foundation
import SQLKit

// MARK: ConcatenateExpression
public struct ConcatenateExpression<T0, T1> where
    T0: TypeEquatable,
    T1: TypeEquatable,
    T0.CompareType == T1.CompareType
{
    let t0: T0
    let t1: T1
    
    public init(
        _ t0: T0,
        _ t1: T1
    ) {
        self.t0 = t0
        self.t1 = t1
    }
}

extension ConcatenateExpression: TypeEquatable {
    public typealias CompareType = T0.CompareType
}

extension ConcatenateExpression: SelectSQLExpression where
    T0: SelectSQLExpression,
    T1: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(t0: t0, t1: t1)
    }
    
    private struct _Select: SQLExpression {
        let t0: T0
        let t1: T1
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.selectSqlExpression,
                t1.selectSqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression: GroupBySQLExpression where
    T0: GroupBySQLExpression,
    T1: GroupBySQLExpression
{
    public var groupBySqlExpression: some SQLExpression {
        _GroupBy(t0: t0, t1: t1)
    }
    
    private struct _GroupBy: SQLExpression {
        let t0: T0
        let t1: T1
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.groupBySqlExpression,
                t1.groupBySqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression: CompareSQLExpression where
    T0: CompareSQLExpression,
    T1: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(t0: t0, t1: t1)
    }
    
    private struct _Compare: SQLExpression {
        let t0: T0
        let t1: T1
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.compareSqlExpression,
                t1.compareSqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ConcatenateExpression<T0, T1>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

// MARK: ConcatenateExpression3
public struct ConcatenateExpression3<T0, T1, T2> where
    T0: TypeEquatable,
    T1: TypeEquatable,
    T2: TypeEquatable,
    T0.CompareType == T1.CompareType,
    T1.CompareType == T2.CompareType
{
    let t0: T0
    let t1: T1
    let t2: T2
    
    public init(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
    }
}

extension ConcatenateExpression3: TypeEquatable {
    public typealias CompareType = T0.CompareType
}

extension ConcatenateExpression3: SelectSQLExpression where
    T0: SelectSQLExpression,
    T1: SelectSQLExpression,
    T2: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(t0: t0, t1: t1, t2: t2)
    }
    
    private struct _Select: SQLExpression {
        let t0: T0
        let t1: T1
        let t2: T2
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.selectSqlExpression,
                t1.selectSqlExpression,
                t2.selectSqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression3: GroupBySQLExpression where
    T0: GroupBySQLExpression,
    T1: GroupBySQLExpression,
    T2: GroupBySQLExpression
{
    public var groupBySqlExpression: some SQLExpression {
        _GroupBy(t0: t0, t1: t1, t2: t2)
    }
    
    private struct _GroupBy: SQLExpression {
        let t0: T0
        let t1: T1
        let t2: T2
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.groupBySqlExpression,
                t1.groupBySqlExpression,
                t2.groupBySqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression3: CompareSQLExpression where
    T0: CompareSQLExpression,
    T1: CompareSQLExpression,
    T2: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(t0: t0, t1: t1, t2: t2)
    }
    
    private struct _Compare: SQLExpression {
        let t0: T0
        let t1: T1
        let t2: T2
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.compareSqlExpression,
                t1.compareSqlExpression,
                t2.compareSqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression3 {
    public func `as`(_ alias: String) -> ExpressionAlias<ConcatenateExpression3<T0, T1, T2>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

// MARK: ConcatenateExpression4
public struct ConcatenateExpression4<T0, T1, T2, T3> where
    T0: TypeEquatable,
    T1: TypeEquatable,
    T2: TypeEquatable,
    T3: TypeEquatable,
    T0.CompareType == T1.CompareType,
    T1.CompareType == T2.CompareType,
    T2.CompareType == T3.CompareType
{
    let t0: T0
    let t1: T1
    let t2: T2
    let t3: T3
    
    public init(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
    }
}

extension ConcatenateExpression4: TypeEquatable {
    public typealias CompareType = T0.CompareType
}

extension ConcatenateExpression4: SelectSQLExpression where
    T0: SelectSQLExpression,
    T1: SelectSQLExpression,
    T2: SelectSQLExpression,
    T3: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(t0: t0, t1: t1, t2: t2, t3: t3)
    }
    
    private struct _Select: SQLExpression {
        let t0: T0
        let t1: T1
        let t2: T2
        let t3: T3
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.selectSqlExpression,
                t1.selectSqlExpression,
                t2.selectSqlExpression,
                t3.selectSqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression4: GroupBySQLExpression where
    T0: GroupBySQLExpression,
    T1: GroupBySQLExpression,
    T2: GroupBySQLExpression,
    T3: GroupBySQLExpression
{
    public var groupBySqlExpression: some SQLExpression {
        _GroupBy(t0: t0, t1: t1, t2: t2, t3: t3)
    }
    
    private struct _GroupBy: SQLExpression {
        let t0: T0
        let t1: T1
        let t2: T2
        let t3: T3
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.groupBySqlExpression,
                t1.groupBySqlExpression,
                t2.groupBySqlExpression,
                t3.groupBySqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression4: CompareSQLExpression where
    T0: CompareSQLExpression,
    T1: CompareSQLExpression,
    T2: CompareSQLExpression,
    T3: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(t0: t0, t1: t1, t2: t2, t3: t3)
    }
    
    private struct _Compare: SQLExpression {
        let t0: T0
        let t1: T1
        let t2: T2
        let t3: T3
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.compareSqlExpression,
                t1.compareSqlExpression,
                t2.compareSqlExpression,
                t3.compareSqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression4 {
    public func `as`(_ alias: String) -> ExpressionAlias<ConcatenateExpression4<T0, T1, T2, T3>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

// MARK: ConcatenateExpression5
public struct ConcatenateExpression5<T0, T1, T2, T3, T4> where
    T0: TypeEquatable,
    T1: TypeEquatable,
    T2: TypeEquatable,
    T3: TypeEquatable,
    T4: TypeEquatable,
    T0.CompareType == T1.CompareType,
    T1.CompareType == T2.CompareType,
    T2.CompareType == T3.CompareType,
    T3.CompareType == T4.CompareType
{
    let t0: T0
    let t1: T1
    let t2: T2
    let t3: T3
    let t4: T4
    
    public init(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
    }
}

extension ConcatenateExpression5: TypeEquatable {
    public typealias CompareType = T0.CompareType
}

extension ConcatenateExpression5: SelectSQLExpression where
    T0: SelectSQLExpression,
    T1: SelectSQLExpression,
    T2: SelectSQLExpression,
    T3: SelectSQLExpression,
    T4: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(t0: t0, t1: t1, t2: t2, t3: t3, t4: t4)
    }
    
    private struct _Select: SQLExpression {
        let t0: T0
        let t1: T1
        let t2: T2
        let t3: T3
        let t4: T4
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.selectSqlExpression,
                t1.selectSqlExpression,
                t2.selectSqlExpression,
                t3.selectSqlExpression,
                t4.selectSqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression5: GroupBySQLExpression where
    T0: GroupBySQLExpression,
    T1: GroupBySQLExpression,
    T2: GroupBySQLExpression,
    T3: GroupBySQLExpression,
    T4: GroupBySQLExpression
{
    public var groupBySqlExpression: some SQLExpression {
        _GroupBy(t0: t0, t1: t1, t2: t2, t3: t3, t4: t4)
    }
    
    private struct _GroupBy: SQLExpression {
        let t0: T0
        let t1: T1
        let t2: T2
        let t3: T3
        let t4: T4
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.groupBySqlExpression,
                t1.groupBySqlExpression,
                t2.groupBySqlExpression,
                t3.groupBySqlExpression,
                t4.groupBySqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression5: CompareSQLExpression where
    T0: CompareSQLExpression,
    T1: CompareSQLExpression,
    T2: CompareSQLExpression,
    T3: CompareSQLExpression,
    T4: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(t0: t0, t1: t1, t2: t2, t3: t3, t4: t4)
    }
    
    private struct _Compare: SQLExpression {
        let t0: T0
        let t1: T1
        let t2: T2
        let t3: T3
        let t4: T4
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList([
                t0.compareSqlExpression,
                t1.compareSqlExpression,
                t2.compareSqlExpression,
                t3.compareSqlExpression,
                t4.compareSqlExpression
            ]).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression5 {
    public func `as`(_ alias: String) -> ExpressionAlias<ConcatenateExpression5<T0, T1, T2, T3, T4>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
