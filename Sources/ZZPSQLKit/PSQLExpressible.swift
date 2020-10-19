import Foundation
import PostgresKit

protocol PSQLExpressible: SQLExpression, TypeEquatable {
    static var postgresColumnType: PostgresColumnType { get }
}

struct PrimativeSelect<T>: SQLExpression where T: PSQLExpressible {
    let value: T
    
    func serialize(to serializer: inout SQLSerializer) {
        value.serialize(to: &serializer)
        serializer.write("::")
        T.postgresColumnType.serialize(to: &serializer)
    }
}
