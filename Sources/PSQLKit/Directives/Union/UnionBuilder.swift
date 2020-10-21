import Foundation

@_functionBuilder
public struct UnionBuilder {
    public static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> UnionTouple<(T0, T1)> where
        T0: UnionSQLExpressible,
        T1: UnionSQLExpressible
    {
        .init((t0, t1))
    }
    
    public static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> UnionTouple<(T0, T1, T2)> where
        T0: UnionSQLExpressible,
        T1: UnionSQLExpressible,
        T2: UnionSQLExpressible
    {
        .init((t0, t1, t2))
    }
    
    public static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> UnionTouple<(T0, T1, T2, T3)> where
        T0: UnionSQLExpressible,
        T1: UnionSQLExpressible,
        T2: UnionSQLExpressible,
        T3: UnionSQLExpressible
    {
        .init((t0, t1, t2, t3))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) -> UnionTouple<(T0, T1, T2, T3, T4)> where
        T0: UnionSQLExpressible,
        T1: UnionSQLExpressible,
        T2: UnionSQLExpressible,
        T3: UnionSQLExpressible,
        T4: UnionSQLExpressible
    {
        .init((t0, t1, t2, t3, t4))
    }
}
