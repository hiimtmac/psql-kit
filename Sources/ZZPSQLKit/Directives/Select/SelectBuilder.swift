import Foundation

@_functionBuilder
struct SelectBuilder {
    static func buildBlock<Content>(_ content: Content) -> Content where Content: SelectSQLExpressible {
        content
    }
    
    static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> SelectTouple<(T0, T1)> where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible
    {
        .init((t0, t1))
    }
    
    static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> SelectTouple<(T0, T1, T2)> where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible,
        T2: SelectSQLExpressible
    {
        .init((t0, t1, t2))
    }
    
    static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> SelectTouple<(T0, T1, T2, T3)> where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible,
        T2: SelectSQLExpressible,
        T3: SelectSQLExpressible
    {
        .init((t0, t1, t2, t3))
    }
    
    static func buildBlock<T0, T1, T2, T3, T4>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) -> SelectTouple<(T0, T1, T2, T3, T4)> where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible,
        T2: SelectSQLExpressible,
        T3: SelectSQLExpressible,
        T4: SelectSQLExpressible
    {
        .init((t0, t1, t2, t3, t4))
    }
}
