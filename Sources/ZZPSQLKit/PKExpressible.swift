import Foundation
import PostgresKit

protocol PKExpressible {
    static var postgresColumnType: PostgresColumnType { get }
}

extension Bool: PKExpressible {
    static var postgresColumnType: PostgresColumnType { .boolean }
}

extension Double: PKExpressible {
    static var postgresColumnType: PostgresColumnType { .decimal }
}

extension Float: PKExpressible {
    static var postgresColumnType: PostgresColumnType { .decimal }
}

extension Int: PKExpressible {
    static var postgresColumnType: PostgresColumnType { .integer }
}

extension Optional: PKExpressible where Wrapped: PKExpressible {
    static var postgresColumnType: PostgresColumnType { Wrapped.postgresColumnType }
}

extension String: PKExpressible {
    static var postgresColumnType: PostgresColumnType { .text }
}

extension UUID: PKExpressible {
    static var postgresColumnType: PostgresColumnType { .uuid }
}
