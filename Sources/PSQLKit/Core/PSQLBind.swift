import Foundation

struct PSQLBind: PSQLExpression {
    let encodable: Encodable
    
    init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write(bind: self.encodable)
    }
}

extension PSQLBind {
    public static func group(_ items: [Encodable]) -> PSQLExpression {
        PSQLGroupExpression(items.map(PSQLBind.init))
    }
}
