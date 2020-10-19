import Foundation
import SQLKit

public struct PSQLBind<T> where T: PSQLExpressible & Encodable & Comparable {
    let value: T
    
    public init(_ value: T) {
        self.value = value
    }
}

extension PSQLBind: CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression {
        SQLBind(value)
    }
}

extension PSQLBind: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression {
        SQLBind(value)
    }
}

extension PSQLBind: Comparable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
    
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}

extension PSQLBind: TypeEquatable {
    public typealias CompareType = T
}
