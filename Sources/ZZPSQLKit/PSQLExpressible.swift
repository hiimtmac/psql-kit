import Foundation
import PostgresKit

protocol PSQLExpressible: SQLExpression, TypeEquatable, CompareSQLExpressible {
    static var postgresColumnType: PostgresColumnType { get }
}

extension Bool: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .boolean }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
    
    var compareSqlExpression: Bool { self }
}

extension Double: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .decimal }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
    
    var compareSqlExpression: Double { self }
}

extension Float: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .decimal }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
    
    var compareSqlExpression: Float { self }
}

extension Int: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .integer }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
    
    var compareSqlExpression: Int { self }
}

extension String: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .text }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'")
        serializer.write("\(self)")
        serializer.write("'")
    }
    
    var compareSqlExpression: String { self }
}

extension UUID: PSQLExpressible {
    typealias CompareType = Self
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

extension Optional: PSQLExpressible where Wrapped: PSQLExpressible {
    static var postgresColumnType: PostgresColumnType { Wrapped.postgresColumnType }
}
