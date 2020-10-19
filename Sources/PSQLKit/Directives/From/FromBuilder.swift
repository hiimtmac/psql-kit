import Foundation

@_functionBuilder
public struct FromBuilder {
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: FromSQLExpressible {
        content
    }
    
    public static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> FromTouple<(T0, T1)> where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible
    {
        .init((t0, t1))
    }
    
    public static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> FromTouple<(T0, T1, T2)> where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible,
        T2: FromSQLExpressible
    {
        .init((t0, t1, t2))
    }
    
    public static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> FromTouple<(T0, T1, T2, T3)> where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible,
        T2: FromSQLExpressible,
        T3: FromSQLExpressible
    {
        .init((t0, t1, t2, t3))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) -> FromTouple<(T0, T1, T2, T3, T4)> where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible,
        T2: FromSQLExpressible,
        T3: FromSQLExpressible,
        T4: FromSQLExpressible
    {
        .init((t0, t1, t2, t3, t4))
    }
}
