import Foundation

extension Int: PSQLable {
    static var psqlType: PSQLType { .integer }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Int: TypeComparable {
    typealias T = Self
    var select: PSQLExpression { self }
}

extension Int: ExpressibleAsCompare {
    var compare: PSQLExpression { self }
}
