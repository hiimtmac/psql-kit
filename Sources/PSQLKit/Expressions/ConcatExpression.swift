import Foundation

typealias CONCAT = ConcatExpression

struct ConcatExpression<T: PSQLable>: PSQLExpression, FunctionExpression {
    let expressions: [PSQLExpression]
    
    init(_ expressions: PSQLExpression...) {
        self.expressions = expressions
    }
    
    init<U: TypeComparable & ExpressibleAsColumn, V: TypeComparable & ExpressibleAsColumn>(_ a: U, _ b: V) where U.T == T, V.T == T {
        self.expressions = [a.columnExpression, b.columnExpression]
    }
    
    init<U: TypeComparable & ExpressibleAsColumn, V: TypeComparable & ExpressibleAsColumn, W: TypeComparable & ExpressibleAsColumn>(_ a: U, _ b: V, _ c: W) where U.T == T, V.T == T, W.T == T {
        self.expressions = [a.columnExpression, b.columnExpression, c.columnExpression]
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("CONCAT")
        serializer.write("(")
        PSQLList(expressions).serialize(to: &serializer)
        serializer.write(")")
    }
}

extension ConcatExpression: PSQLSelectExpression {
    var psqlSelectExpression: PSQLExpression { self }
}
