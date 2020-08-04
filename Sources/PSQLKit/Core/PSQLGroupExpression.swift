import Foundation

struct PSQLGroupExpression: PSQLExpression {
    let expressions: [PSQLExpression]
    let separator: PSQLExpression
    
    init(_ expression: PSQLExpression, separator: PSQLExpression = PSQLRaw(", ")) {
        self.expressions = [expression]
        self.separator = separator
    }
    
    init(_ expressions: [PSQLExpression], separator: PSQLExpression = PSQLRaw(", ")) {
        self.expressions = expressions
        self.separator = separator
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("(")
        PSQLList(self.expressions, separator: separator).serialize(to: &serializer)
        serializer.write(")")
    }
}

extension PSQLGroupExpression: ExpressibleAsCompare {
    var compare: PSQLExpression { self }
}
