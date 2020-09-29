import Foundation

@_functionBuilder
struct SelectBuilder {
    static func buildBlock<Content>(_ content: Content) -> Content where Content: PSQLSelectExpression {
        content
    }
    
    static func buildBlock<T0, T1>(
        _ t0: T0,
        _ t1: T1
    ) -> ToupleStatement<(T0, T1)>
    where T0: PSQLSelectExpression, T1: PSQLSelectExpression
    {
        .init((t0, t1))
    }
    
    static func buildBlock<T0, T1, T2>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2
    ) -> ToupleStatement<(T0, T1, T2)>
    where T0: PSQLSelectExpression, T1: PSQLSelectExpression, T2: PSQLSelectExpression
    {
        .init((t0, t1, t2))
    }
    
    static func buildBlock<T0, T1, T2, T3>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3
    ) -> ToupleStatement<(T0, T1, T2, T3)>
    where T0: PSQLSelectExpression, T1: PSQLSelectExpression, T2: PSQLSelectExpression, T3: PSQLSelectExpression
    {
        .init((t0, t1, t2, t3))
    }
    
    static func buildBlock<T0, T1, T2, T3, T4>(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4
    ) -> ToupleStatement<(T0, T1, T2, T3, T4)>
    where T0: PSQLSelectExpression, T1: PSQLSelectExpression, T2: PSQLSelectExpression, T3: PSQLSelectExpression, T4: PSQLSelectExpression
    {
        .init((t0, t1, t2, t3, t4))
    }
}
