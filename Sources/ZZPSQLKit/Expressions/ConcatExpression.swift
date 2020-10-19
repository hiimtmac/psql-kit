import Foundation
import SQLKit

struct ConcatExpression<T0, T1>: SQLExpression where
T0: SelectSQLExpressible,
T1: SelectSQLExpressible
{
    let t0: T0
    let t1: T1
    
    init(
        _ t0: T0,
        _ t1: T1
    ) {
        self.t0 = t0
        self.t1 = t1
    }
    
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

extension ConcatExpression: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

extension ConcatExpression {
    func `as`(_ alias: String) -> ExpressionAlias<ConcatExpression<T0, T1>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

struct ConcatExpression3<T0, T1, T2>: SQLExpression where
T0: SelectSQLExpressible,
T1: SelectSQLExpressible,
T2: SelectSQLExpressible
{
    let t0: T0
    let t1: T1
    let t2: T2
    
    init(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
    }
    
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

extension ConcatExpression3: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

extension ConcatExpression3 {
    func `as`(_ alias: String) -> ExpressionAlias<ConcatExpression3<T0, T1, T2>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

struct ConcatExpression4<T0, T1, T2, T3>: SQLExpression where
T0: SelectSQLExpressible,
T1: SelectSQLExpressible,
T2: SelectSQLExpressible,
T3: SelectSQLExpressible
{
    let t0: T0
    let t1: T1
    let t2: T2
    let t3: T3
    
    init(
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

extension ConcatExpression4: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

extension ConcatExpression4 {
    func `as`(_ alias: String) -> ExpressionAlias<ConcatExpression4<T0, T1, T2, T3>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

struct ConcatExpression5<T0, T1, T2, T3, T4>: SQLExpression where
T0: SelectSQLExpressible,
T1: SelectSQLExpressible,
T2: SelectSQLExpressible,
T3: SelectSQLExpressible,
T4: SelectSQLExpressible
{
    let t0: T0
    let t1: T1
    let t2: T2
    let t3: T3
    let t4: T4
    
    init(
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

extension ConcatExpression5: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

extension ConcatExpression5 {
    func `as`(_ alias: String) -> ExpressionAlias<ConcatExpression5<T0, T1, T2, T3, T4>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
