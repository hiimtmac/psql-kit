import Foundation

@_functionBuilder
public struct GroupByBuilder {
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: GroupBySQLExpression {
        content
    }
    
    public static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> GroupByTouple<(T0, T1)> where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression
    {
        .init((t0, t1))
    }
    
    public static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> GroupByTouple<(T0, T1, T2)> where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression
    {
        .init((t0, t1, t2))
    }
    
    public static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> GroupByTouple<(T0, T1, T2, T3)> where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression
    {
        .init((t0, t1, t2, t3))
    }
    
    public static func buildBlock<T0, T1, T2, T3, T4>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) -> GroupByTouple<(T0, T1, T2, T3, T4)> where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression
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
    ) -> GroupByTouple<(T0, T1, T2, T3, T4, T5)> where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression,
        T5: GroupBySQLExpression
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
    ) -> GroupByTouple<(T0, T1, T2, T3, T4, T5, T6)> where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression,
        T5: GroupBySQLExpression,
        T6: GroupBySQLExpression
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
    ) -> GroupByTouple<(T0, T1, T2, T3, T4, T5, T6, T7)> where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression,
        T5: GroupBySQLExpression,
        T6: GroupBySQLExpression,
        T7: GroupBySQLExpression
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
    ) -> GroupByTouple<(T0, T1, T2, T3, T4, T5, T6, T7, T8)> where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression,
        T5: GroupBySQLExpression,
        T6: GroupBySQLExpression,
        T7: GroupBySQLExpression,
        T8: GroupBySQLExpression
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
    ) -> GroupByTouple<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)> where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression,
        T5: GroupBySQLExpression,
        T6: GroupBySQLExpression,
        T7: GroupBySQLExpression,
        T8: GroupBySQLExpression,
        T9: GroupBySQLExpression
    {
        .init((t0, t1, t2, t3, t4, t5, t6, t7, t8, t9))
    }
}
