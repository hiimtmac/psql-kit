import Foundation

protocol ExpressibleAsFrom {
    var from: PSQLExpression { get }
}

struct PSQLFromExpression: PSQLExpression {
    let table: PSQLTableExpression
    let alias: String?
    
    func serialize(to serializer: inout PSQLSerializer) {
        table.serialize(to: &serializer)
        
        if let alias = alias {
            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()
            serializer.writeQuote()
            serializer.write(alias)
            serializer.writeQuote()
        }
    }
}

extension PSQLFromExpression: ExpressibleAsFrom {
    var from: PSQLExpression { self }
}
