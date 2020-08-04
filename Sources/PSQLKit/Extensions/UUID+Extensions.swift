import Foundation

extension UUID: PSQLable {
    static var psqlType: PSQLType { .uuid }
    
    func serialize(to serializer: inout PSQLSerializer) {
        self.uuidString.serialize(to: &serializer)
    }
}

extension UUID: TypeComparable {
    typealias T = Self
    var select: PSQLExpression { self }
}

extension UUID: ExpressibleAsCompare {
    var compare: PSQLExpression { self }
}
