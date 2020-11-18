import Foundation

@_functionBuilder
public struct WhereBuilder {
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: WhereSQLExpression {
        content
    }
    
    public static func buildEither<Content>(first: Content) -> Content where Content: WhereSQLExpression {
        first
    }

    public static func buildEither<Content>(second: Content) -> Content where Content: WhereSQLExpression {
        second
    }
}

extension WhereBuilder {
    public static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> WhereTouple<(T0, T1)> where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression
    {
        .init((t0, t1))
    }
    
    public static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> WhereTouple<(T0, T1, T2)> where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression
    {
        .init((t0, t1, t2))
    }
    
    public static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> WhereTouple<(T0, T1, T2, T3)> where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression
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
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression
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
    ) -> WhereTouple<(T0, T1, T2, T3, T4, T5)> where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression,
        T5: WhereSQLExpression
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
    ) -> WhereTouple<(T0, T1, T2, T3, T4, T5, T6)> where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression,
        T5: WhereSQLExpression,
        T6: WhereSQLExpression
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
    ) -> WhereTouple<(T0, T1, T2, T3, T4, T5, T6, T7)> where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression,
        T5: WhereSQLExpression,
        T6: WhereSQLExpression,
        T7: WhereSQLExpression
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
    ) -> WhereTouple<(T0, T1, T2, T3, T4, T5, T6, T7, T8)> where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression,
        T5: WhereSQLExpression,
        T6: WhereSQLExpression,
        T7: WhereSQLExpression,
        T8: WhereSQLExpression
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
    ) -> WhereTouple<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)> where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression,
        T5: WhereSQLExpression,
        T6: WhereSQLExpression,
        T7: WhereSQLExpression,
        T8: WhereSQLExpression,
        T9: WhereSQLExpression
    {
        .init((t0, t1, t2, t3, t4, t5, t6, t7, t8, t9))
    }
}
