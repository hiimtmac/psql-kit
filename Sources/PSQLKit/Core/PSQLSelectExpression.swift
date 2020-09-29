import Foundation

//protocol ExpressibleAsSelect {
//    var select: PSQLExpression { get }
//}
//
//struct PSQLSelectExpression: PSQLExpression {
//    let selection: PSQLColumnExpression
//    let type: PSQLType
//    let alias: String?
//    
//    func serialize(to serializer: inout PSQLSerializer) {
//        selection.serialize(to: &serializer)
//        serializer.write("::")
//        serializer.write(type.psqlValue)
//        
//        if let alias = alias {
//            serializer.writeSpace()
//            serializer.write("AS")
//            serializer.writeSpace()
//            serializer.writeQuote()
//            serializer.write(alias)
//            serializer.writeQuote()
//        }
//    }
//}
//
//extension PSQLSelectExpression: ExpressibleAsSelect {
//    var select: PSQLExpression { self }
//}
//
//extension PSQLSelectExpression {
//    func `as`(_ alias: String) -> Self {
//        .init(selection: selection, type: type, alias: alias)
//    }
//}
