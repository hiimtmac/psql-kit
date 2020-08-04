import Foundation

extension String: PSQLable {
    static var psqlType: PSQLType { .text }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("'")
        serializer.write("\(self)")
        serializer.write("'")
    }
}

extension String: TypeComparable {
    typealias T = Self
    var select: PSQLExpression { self }
}

extension String: ExpressibleAsCompare {
    var compare: PSQLExpression { self }
}
