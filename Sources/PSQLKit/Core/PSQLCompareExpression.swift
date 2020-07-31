import Foundation

protocol ExpressibleAsCompare {
    var compare: PSQLExpression { get }
}

struct PSQLCompareExpression: PSQLExpression {
    let lhs: ExpressibleAsCompare
    let instruction: String
    let rhs: ExpressibleAsCompare
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("(")
        lhs.compare.serialize(to: &serializer)
        serializer.write(instruction)
        rhs.compare.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension PSQLCompareExpression: ExpressibleAsCompare {
    var compare: PSQLExpression { self }
}
