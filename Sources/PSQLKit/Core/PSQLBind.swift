import Foundation

struct PSQLBind<T: PSQLable & Encodable>: PSQLExpression {
    let encodable: Encodable
    
    init(_ encodable: T) {
        self.encodable = encodable
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write(bind: self.encodable)
    }
}

extension PSQLBind {
//    public static func group(_ items: [Encodable]) -> PSQLExpression {
//        PSQLGroupExpression(items.map(PSQLBind.init))
//    }
}

extension PSQLBind: TypeComparable {
    var select: PSQLExpression { self }
}

extension PSQLBind: ExpressibleAsCompare {
    var compare: PSQLExpression { self }
}
