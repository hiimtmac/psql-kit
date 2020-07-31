import Foundation

extension Double: PSQLable {
    static var psqlType: PSQLType { .decimal }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Double: TypeComparable {
    typealias T = Self
    var select: PSQLExpression { self }
}
