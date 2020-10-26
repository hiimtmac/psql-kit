import Foundation
import PostgresKit

public protocol PSQLExpression {
    static var postgresColumnType: PostgresColumnType { get }
}

extension PSQLExpression where Self: SQLExpression {
    public func `as`(_ alias: String) -> RawValueAlias<Self> {
        RawValueAlias(value: self, alias: alias)
    }
}

extension PSQLExpression where Self: Encodable {
    public func asBind() -> PSQLBind<Self> {
        .init(self)
    }
}
