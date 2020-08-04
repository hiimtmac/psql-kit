import Foundation

struct PSQLList: PSQLExpression {
    let expressions: [PSQLExpression]
    let separator: PSQLExpression

    init(_ expressions: [PSQLExpression], separator: PSQLExpression = PSQLRaw(", ")) {
        self.expressions = expressions
        self.separator = separator
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        var first = true
        for el in self.expressions {
            if !first {
                self.separator.serialize(to: &serializer)
            }
            first = false
            el.serialize(to: &serializer)
        }
    }
}

extension PSQLList: ExpressibleAsCompare {
    var compare: PSQLExpression { self }
}
