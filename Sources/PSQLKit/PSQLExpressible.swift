import Foundation
import PostgresKit

public protocol PSQLExpressible: SQLExpression, TypeEquatable {
    static var postgresColumnType: PostgresColumnType { get }
}

extension PSQLExpressible where Self: Encodable {
    public func asBind() -> PSQLBind<Self> {
        .init(self)
    }
}

struct PrimativeSelect<T>: SQLExpression where T: PSQLExpressible {
    let value: T
    
    func serialize(to serializer: inout SQLSerializer) {
        value.serialize(to: &serializer)
        serializer.write("::")
        T.postgresColumnType.serialize(to: &serializer)
    }
}
