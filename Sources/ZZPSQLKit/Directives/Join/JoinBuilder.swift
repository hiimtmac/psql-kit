//import Foundation
//
//@_functionBuilder
//struct JoinBuilder {
//    static func buildBlock<Content>(_ content: Content) -> Content where Content: JoinSQLExpressible {
//        content
//    }
//    
//    static func buildBlock<T0, T1>(
//        _ t0: T0,
//        _ t1: T1
//    ) -> JoinTouple<(T0, T1)> where
//        T0: JoinSQLExpressible,
//        T1: JoinSQLExpressible
//    {
//        .init((t0, t1))
//    }
//    
//    static func buildBlock<T0, T1, T2>(
//        _ t0: T0,
//        _ t1: T1,
//        _ t2: T2
//    ) -> JoinTouple<(T0, T1, T2)> where
//        T0: JoinSQLExpressible,
//        T1: JoinSQLExpressible,
//        T2: JoinSQLExpressible
//    {
//        .init((t0, t1, t2))
//    }
//    
//    static func buildBlock<T0, T1, T2, T3>(
//        _ t0: T0,
//        _ t1: T1,
//        _ t2: T2,
//        _ t3: T3
//    ) -> JoinTouple<(T0, T1, T2, T3)> where
//        T0: JoinSQLExpressible,
//        T1: JoinSQLExpressible,
//        T2: JoinSQLExpressible,
//        T3: JoinSQLExpressible
//    {
//        .init((t0, t1, t2, t3))
//    }
//    
//    static func buildBlock<T0, T1, T2, T3, T4>(
//        _ t0: T0,
//        _ t1: T1,
//        _ t2: T2,
//        _ t3: T3,
//        _ t4: T4
//    ) -> JoinTouple<(T0, T1, T2, T3, T4)> where
//        T0: JoinSQLExpressible,
//        T1: JoinSQLExpressible,
//        T2: JoinSQLExpressible,
//        T3: JoinSQLExpressible,
//        T4: JoinSQLExpressible
//    {
//        .init((t0, t1, t2, t3, t4))
//    }
//}
