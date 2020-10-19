import Foundation

@_functionBuilder
public struct HavingBuilder {
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: HavingSQLExpressible {
        content
    }
    
    public static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> HavingTouple<(T0, T1)> where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible
    {
        .init((t0, t1))
    }
    
    public static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> HavingTouple<(T0, T1, T2)> where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible
    {
        .init((t0, t1, t2))
    }
    
    public static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> HavingTouple<(T0, T1, T2, T3)> where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible,
        T3: HavingSQLExpressible
    {
        .init((t0, t1, t2, t3))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) -> HavingTouple<(T0, T1, T2, T3, T4)> where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible,
        T3: HavingSQLExpressible,
        T4: HavingSQLExpressible
    {
        .init((t0, t1, t2, t3, t4))
    }
}
