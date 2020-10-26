import Foundation
import SQLKit

// MARK: CoalesceExpression
public struct CoalesceExpression<T0, T1>: SQLExpression where
    T0: SelectSQLExpression & TypeEquatable,
    T1: SelectSQLExpression & TypeEquatable,
    T0.CompareType == T1.CompareType
{
    let t0: T0
    let t1: T1
    
    public init(_ t0: T0, _ t1: T1) {
        self.t0 = t0
        self.t1 = t1
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("COALESCE")
        serializer.write("(")
        SQLList([
            t0.selectSqlExpression,
            t1.selectSqlExpression
        ]).serialize(to: &serializer)
        serializer.write(")")
    }
}

extension CoalesceExpression: TypeEquatable {
    public typealias CompareType = T0.CompareType
}

extension CoalesceExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension CoalesceExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<CoalesceExpression<T0, T1>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

// MARK: CoalesceExpression3
public struct CoalesceExpression3<T0, T1, T2>: SQLExpression where
    T0: SelectSQLExpression & TypeEquatable,
    T1: SelectSQLExpression & TypeEquatable,
    T2: SelectSQLExpression & TypeEquatable,
    T0.CompareType == T1.CompareType,
    T1.CompareType == T2.CompareType
{
    let t0: T0
    let t1: T1
    let t2: T2
    
    public init(_ t0: T0, _ t1: T1, _ t2: T2) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("COALESCE")
        serializer.write("(")
        SQLList([
            t0.selectSqlExpression,
            t1.selectSqlExpression,
            t2.selectSqlExpression
        ]).serialize(to: &serializer)
        serializer.write(")")
    }
}

extension CoalesceExpression3: TypeEquatable {
    public typealias CompareType = T0.CompareType
}

extension CoalesceExpression3: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension CoalesceExpression3 {
    public func `as`(_ alias: String) -> ExpressionAlias<CoalesceExpression3<T0, T1, T2>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

// MARK: CoalesceExpression4
public struct CoalesceExpression4<T0, T1, T2, T3>: SQLExpression where
    T0: SelectSQLExpression & TypeEquatable,
    T1: SelectSQLExpression & TypeEquatable,
    T2: SelectSQLExpression & TypeEquatable,
    T3: SelectSQLExpression & TypeEquatable,
    T0.CompareType == T1.CompareType,
    T1.CompareType == T2.CompareType,
    T2.CompareType == T3.CompareType
{
    let t0: T0
    let t1: T1
    let t2: T2
    let t3: T3
    
    public init(_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("COALESCE")
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

extension CoalesceExpression4: TypeEquatable {
    public typealias CompareType = T0.CompareType
}

extension CoalesceExpression4: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension CoalesceExpression4 {
    public func `as`(_ alias: String) -> ExpressionAlias<CoalesceExpression4<T0, T1, T2, T3>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

// MARK: CoalesceExpression5
public struct CoalesceExpression5<T0, T1, T2, T3, T4>: SQLExpression where
    T0: SelectSQLExpression & TypeEquatable,
    T1: SelectSQLExpression & TypeEquatable,
    T2: SelectSQLExpression & TypeEquatable,
    T3: SelectSQLExpression & TypeEquatable,
    T4: SelectSQLExpression & TypeEquatable,
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
    
    public init(_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("COALESCE")
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

extension CoalesceExpression5: TypeEquatable {
    public typealias CompareType = T0.CompareType
}

extension CoalesceExpression5: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension CoalesceExpression5 {
    public func `as`(_ alias: String) -> ExpressionAlias<CoalesceExpression5<T0, T1, T2, T3, T4>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
