import Foundation

@_functionBuilder
public struct WhereBuilder {
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: WhereSQLExpressible {
        content
    }
    
    public static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> WhereTouple<(T0, T1)> where
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible
    {
        .init((t0, t1))
    }
    
    public static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> WhereTouple<(T0, T1, T2)> where
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible
    {
        .init((t0, t1, t2))
    }
    
    public static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> WhereTouple<(T0, T1, T2, T3)> where
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible,
        T3: WhereSQLExpressible
    {
        .init((t0, t1, t2, t3))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) -> WhereTouple<(T0, T1, T2, T3, T4)> where
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible,
        T3: WhereSQLExpressible,
        T4: WhereSQLExpressible
    {
        .init((t0, t1, t2, t3, t4))
    }
}
