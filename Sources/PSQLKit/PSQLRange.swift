import Foundation
import SQLKit

public struct PSQLRange<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType
{
    let lower: T
    let upper: U
    
    public init(from: T, to: U) {
        self.lower = from
        self.upper = to
    }
}

extension PSQLRange: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension PSQLRange: CompareSQLExpression where
    T: CompareSQLExpression,
    U: CompareSQLExpression
{
    public var compareSqlExpression: SQLExpression {
        _Compare(lower: lower, upper: upper)
    }
    
    private struct _Compare: SQLExpression {
        let lower: T
        let upper: U
        
        func serialize(to serializer: inout SQLSerializer) {
            lower.compareSqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            serializer.write("AND")
            serializer.writeSpace()
            upper.compareSqlExpression.serialize(to: &serializer)
        }
    }
}
