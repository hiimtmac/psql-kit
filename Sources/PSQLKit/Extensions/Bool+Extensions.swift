import Foundation

extension Bool: PSQLable {
    static var psqlType: PSQLType { .boolean }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("\(self)".uppercased())
    }
}

extension Bool: TypeComparable {
    typealias T = Self
    var select: PSQLExpression { self }
}

extension Bool: ExpressibleAsCompare {
    var compare: PSQLExpression { self }
}
