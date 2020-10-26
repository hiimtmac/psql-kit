import Foundation
import PostgresKit

public protocol PSQLExpression: SQLExpression {
    static var postgresColumnType: PostgresColumnType { get }
}

extension PSQLExpression {
    public func `as`(_ alias: String) -> RawValueAlias<Self> {
        RawValueAlias(value: self, alias: alias)
    }
}

extension PSQLExpression where Self: Encodable {
    public func asBind() -> PSQLBind<Self> {
        .init(self)
    }
}
