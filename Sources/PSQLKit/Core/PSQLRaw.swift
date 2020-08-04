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

extension PSQLRaw {
    static var and: Self { .init(" AND ") }
    static var space: Self { .init(" ") }
    static var openBracket: Self { .init("(") }
    static var closedBracket: Self { .init(")") }
}
