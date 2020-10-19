import Foundation

@_functionBuilder
public struct WithBuilder {
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: WithSQLExpressible {
        content
    }
    
    public static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> WithTouple<(T0, T1)> where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible
    {
        .init((t0, t1))
    }
    
    public static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> WithTouple<(T0, T1, T2)> where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible,
        T2: WithSQLExpressible
    {
        .init((t0, t1, t2))
    }
    
    public static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> WithTouple<(T0, T1, T2, T3)> where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible,
        T2: WithSQLExpressible,
        T3: WithSQLExpressible
    {
        .init((t0, t1, t2, t3))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) -> WithTouple<(T0, T1, T2, T3, T4)> where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible,
        T2: WithSQLExpressible,
        T3: WithSQLExpressible,
        T4: WithSQLExpressible
    {
        .init((t0, t1, t2, t3, t4))
    }
}
