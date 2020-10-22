import Foundation
import SQLKit

public struct PSQLRange<T> where T: CompareSQLExpressible {
    let lower: T
    let upper: T
    
    public init(from: T, to: T) {
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
    public typealias CompareType = T
}

extension PSQLRange: CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression { self }
}
