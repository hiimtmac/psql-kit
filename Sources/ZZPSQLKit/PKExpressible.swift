import Foundation
import PostgresKit

protocol PKExpressible: SQLExpression, TypeEquatable, CompareSQLExpressible {
    static var postgresColumnType: PostgresColumnType { get }
}

extension Bool: PKExpressible {
    typealias CompareType = Self
    typealias Compare = Self
    static var postgresColumnType: PostgresColumnType { .boolean }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
    
    var compareSqlExpression: Bool { self }
}

extension Double: PKExpressible {
    typealias CompareType = Self
    typealias Compare = Self
    static var postgresColumnType: PostgresColumnType { .decimal }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
    
    var compareSqlExpression: Double { self }
}

extension Float: PKExpressible {
    typealias CompareType = Self
    typealias Compare = Self
    static var postgresColumnType: PostgresColumnType { .decimal }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
    
    var compareSqlExpression: Float { self }
}

extension Int: PKExpressible {
    typealias CompareType = Self
    typealias Compare = Self
    static var postgresColumnType: PostgresColumnType { .integer }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
    
    var compareSqlExpression: Int { self }
}

extension String: PKExpressible {
    typealias CompareType = Self
    typealias Compare = Self
    static var postgresColumnType: PostgresColumnType { .text }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'")
        serializer.write("\(self)")
        serializer.write("'")
    }
    
    var compareSqlExpression: String { self }
}

extension UUID: PKExpressible {
    typealias CompareType = Self
    typealias Compare = Self
    static var postgresColumnType: PostgresColumnType { .uuid }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'")
        serializer.write("\(self)")
        serializer.write("'")
    }
    
    var compareSqlExpression: UUID { self }
}

extension Optional: SQLExpression where Wrapped: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        if let self = self {
            self.serialize(to: &serializer)
        } else {
            serializer.write("NULL")
        }
    }
}

extension Optional: CompareSQLExpressible where Wrapped: SQLExpression & CompareSQLExpressible {
    var compareSqlExpression: Self { self }
}

extension Optional: TypeEquatable where Wrapped: TypeEquatable {
    typealias CompareType = Wrapped
}

extension Optional: PKExpressible where Wrapped: PKExpressible {
    static var postgresColumnType: PostgresColumnType { Wrapped.postgresColumnType }
}
