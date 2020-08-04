import Foundation

extension Optional: PSQLExpression where Wrapped: PSQLable {
    func serialize(to serializer: inout PSQLSerializer) {
        if let self = self {
            self.serialize(to: &serializer)
        } else {
            serializer.write("NULL")
        }
    }
}

extension Optional: PSQLable where Wrapped: PSQLable {
    static var psqlType: PSQLType { Wrapped.psqlType }
}

extension Optional: ExpressibleAsSelect where Wrapped: ExpressibleAsSelect & PSQLable {
    var select: PSQLExpression { self }
}

extension Optional: TypeComparable where Wrapped: TypeComparable & PSQLable {
    typealias T = Wrapped
}

extension Optional: ExpressibleAsCompare where Wrapped: ExpressibleAsCompare & PSQLable {
    var compare: PSQLExpression { self }
}
