import Foundation

@_functionBuilder
public struct WithBuilder {
    public static func buildBlock() -> EmptyExpression {
        .init()
    }
    
    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where
        Content: WithSQLExpression
    {
        content
    }
    
    public static func buildEither<TrueContent, FalseContent>(
        first: TrueContent
    ) -> _ConditionalExpression<TrueContent, FalseContent> where
        TrueContent: WithSQLExpression, FalseContent: WithSQLExpression
    {
        .init(first: first)
    }
    
    public static func buildEither<TrueContent, FalseContent>(
        second: FalseContent
    ) -> _ConditionalExpression<TrueContent, FalseContent> where
        TrueContent: WithSQLExpression, FalseContent: WithSQLExpression
    {
        .init(second: second)
    }
}

extension WithBuilder {
    public static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> WithTouple<(T0, T1)> where
        T0: WithSQLExpression,
        T1: WithSQLExpression
    {
        .init((t0, t1))
    }
    
    public static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> WithTouple<(T0, T1, T2)> where
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression
    {
        .init((t0, t1, t2))
    }
    
    public static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> WithTouple<(T0, T1, T2, T3)> where
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression
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
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression
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
    ) -> WithTouple<(T0, T1, T2, T3, T4, T5)> where
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression,
        T5: WithSQLExpression
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
    ) -> WithTouple<(T0, T1, T2, T3, T4, T5, T6)> where
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression,
        T5: WithSQLExpression,
        T6: WithSQLExpression
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
    ) -> WithTouple<(T0, T1, T2, T3, T4, T5, T6, T7)> where
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression,
        T5: WithSQLExpression,
        T6: WithSQLExpression,
        T7: WithSQLExpression
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
    ) -> WithTouple<(T0, T1, T2, T3, T4, T5, T6, T7, T8)> where
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression,
        T5: WithSQLExpression,
        T6: WithSQLExpression,
        T7: WithSQLExpression,
        T8: WithSQLExpression
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
    ) -> WithTouple<(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)> where
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression,
        T5: WithSQLExpression,
        T6: WithSQLExpression,
        T7: WithSQLExpression,
        T8: WithSQLExpression,
        T9: WithSQLExpression
    {
        .init((t0, t1, t2, t3, t4, t5, t6, t7, t8, t9))
    }
}
