import Foundation

@_functionBuilder
public struct QueryBuilder {
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: QuerySQLExpressible {
        content
    }
    
    public static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> QueryTouple<(T0, T1)> where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible
    {
        .init((t0, t1))
    }
    
    public static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> QueryTouple<(T0, T1, T2)> where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible,
        T2: QuerySQLExpressible
    {
        .init((t0, t1, t2))
    }
    
    public static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> QueryTouple<(T0, T1, T2, T3)> where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible,
        T2: QuerySQLExpressible,
        T3: QuerySQLExpressible
    {
        .init((t0, t1, t2, t3))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) -> QueryTouple<(T0, T1, T2, T3, T4)> where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible,
        T2: QuerySQLExpressible,
        T3: QuerySQLExpressible,
        T4: QuerySQLExpressible
    {
        .init((t0, t1, t2, t3, t4))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4, T5>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4,
        _ t5: T5
    ) -> QueryTouple<(T0, T1, T2, T3, T4, T5)> where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible,
        T2: QuerySQLExpressible,
        T3: QuerySQLExpressible,
        T4: QuerySQLExpressible,
        T5: QuerySQLExpressible
    {
        .init((t0, t1, t2, t3, t4, t5))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4, T5, T6>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4,
        _ t5: T5,
        _ t6: T6
    ) -> QueryTouple<(T0, T1, T2, T3, T4, T5, T6)> where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible,
        T2: QuerySQLExpressible,
        T3: QuerySQLExpressible,
        T4: QuerySQLExpressible,
        T5: QuerySQLExpressible,
        T6: QuerySQLExpressible
    {
        .init((t0, t1, t2, t3, t4, t5, t6))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4,
        _ t5: T5,
        _ t6: T6,
        _ t7: T7
    ) -> QueryTouple<(T0, T1, T2, T3, T4, T5, T6, T7)> where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible,
        T2: QuerySQLExpressible,
        T3: QuerySQLExpressible,
        T4: QuerySQLExpressible,
        T5: QuerySQLExpressible,
        T6: QuerySQLExpressible,
        T7: QuerySQLExpressible
    {
        .init((t0, t1, t2, t3, t4, t5, t6, t7))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7, T8>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4,
        _ t5: T5,
        _ t6: T6,
        _ t7: T7,
        _ t8: T8
    ) -> QueryTouple<(T0, T1, T2, T3, T4, T5, T6, T7, T8)> where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible,
        T2: QuerySQLExpressible,
        T3: QuerySQLExpressible,
        T4: QuerySQLExpressible,
        T5: QuerySQLExpressible,
        T6: QuerySQLExpressible,
        T7: QuerySQLExpressible,
        T8: QuerySQLExpressible
    {
        .init((t0, t1, t2, t3, t4, t5, t6, t7, t8))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4,
        _ t5: T5,
        _ t6: T6,
        _ t7: T7,
        _ t8: T8,
        _ t9: T9
    ) -> QueryTouple<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)> where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible,
        T2: QuerySQLExpressible,
        T3: QuerySQLExpressible,
        T4: QuerySQLExpressible,
        T5: QuerySQLExpressible,
        T6: QuerySQLExpressible,
        T7: QuerySQLExpressible,
        T8: QuerySQLExpressible,
        T9: QuerySQLExpressible
    {
        .init((t0, t1, t2, t3, t4, t5, t6, t7, t8, t9))
    }
}