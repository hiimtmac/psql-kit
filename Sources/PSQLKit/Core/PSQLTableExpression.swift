import Foundation

struct PSQLTableExpression: PSQLExpression {
    let path: String?
    let schema: String
    
    func serialize(to serializer: inout PSQLSerializer) {
        if let path = path {
            serializer.writeQuote()
            serializer.write(path)
            serializer.writeQuote()
            serializer.writePeriod()
        }
        
        serializer.writeQuote()
        serializer.write(schema)
        serializer.writeQuote()
    }
}
