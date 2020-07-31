import Foundation

struct PSQLList: PSQLExpression {
    let bounds: (PSQLExpression, PSQLExpression)?
    let expressions: [PSQLExpression]
    let separator: PSQLExpression

    init(_ expressions: [PSQLExpression], separator: PSQLExpression = PSQLRaw(", "), bounds: (PSQLExpression, PSQLExpression)? = nil) {
        self.bounds = bounds
        self.expressions = expressions
        self.separator = separator
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        if let bounds = bounds {
            bounds.0.serialize(to: &serializer)
        }
        var first = true
        for el in self.expressions {
            if !first {
                self.separator.serialize(to: &serializer)
            }
            first = false
            el.serialize(to: &serializer)
        }
        if let bounds = bounds {
            bounds.1.serialize(to: &serializer)
        }
    }
}

extension PSQLList: ExpressibleAsCompare {
    var compare: PSQLExpression { self }
}
