import Foundation

@_functionBuilder
public struct OrderByBuilder {
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: OrderBySQLExpressible {
        content
    }
    
    public static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> OrderByTouple<(T0, T1)> where
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible
    {
        .init((t0, t1))
    }
    
    public static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> OrderByTouple<(T0, T1, T2)> where
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible,
        T2: OrderBySQLExpressible
    {
        .init((t0, t1, t2))
    }
    
    public static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> OrderByTouple<(T0, T1, T2, T3)> where
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible,
        T2: OrderBySQLExpressible,
        T3: OrderBySQLExpressible
    {
        .init((t0, t1, t2, t3))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) -> OrderByTouple<(T0, T1, T2, T3, T4)> where
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible,
        T2: OrderBySQLExpressible,
        T3: OrderBySQLExpressible,
        T4: OrderBySQLExpressible
    {
        .init((t0, t1, t2, t3, t4))
    }
}
