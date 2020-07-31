import Foundation

extension Float: PSQLable {
    static var psqlType: PSQLType { .decimal }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Float: TypeComparable {
    typealias T = Self
    var select: PSQLExpression { self }
}
