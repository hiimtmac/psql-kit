import Foundation

struct PSQLRaw: PSQLExpression {
    var psql: String
    
    var binds: [Encodable]
    
    init(_ psql: String, _ binds: [Encodable] = []) {
        self.psql = psql
        self.binds = binds
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write(self.psql)
        serializer.binds += self.binds
    }
}
