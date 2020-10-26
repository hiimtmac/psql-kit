import Foundation
import SQLKit

public struct PSQLRange<T, U> where
    T: CompareSQLExpression & TypeEquatable,
    U: CompareSQLExpression & TypeEquatable,
    T.CompareType == U.CompareType
{
    let lower: T
    let upper: U
    
    public init(from: T, to: U) {
        self.lower = from
        self.upper = to
    }
}

extension PSQLRange: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        lower.compareSqlExpression.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("AND")
        serializer.writeSpace()
        upper.compareSqlExpression.serialize(to: &serializer)
    }
}

extension PSQLRange: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension PSQLRange: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}
