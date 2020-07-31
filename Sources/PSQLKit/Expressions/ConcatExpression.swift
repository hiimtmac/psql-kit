import Foundation

typealias CONCAT = ConcatExpression

struct ConcatExpression<T: PSQLable>: PSQLExpression, FunctionExpression {
    let expressions: [PSQLExpression]
    
    init(_ expressions: PSQLExpression...) {
        self.expressions = expressions
    }
    
    init<U: TypeComparable, V: TypeComparable>(_ a: U, _ b: V) where U.T == T, V.T == T {
        self.expressions = [a.select, b.select]
    }
    
    init<U: TypeComparable, V: TypeComparable, W: TypeComparable>(_ a: U, _ b: V, _ c: W) where U.T == T, V.T == T, W.T == T {
        self.expressions = [a.select, b.select, c.select]
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("CONCAT")
        serializer.write("(")
        PSQLList(expressions).serialize(to: &serializer)
        serializer.write(")")
    }
}

extension ConcatExpression: ExpressibleAsSelect {
    var select: PSQLExpression { self }
}
