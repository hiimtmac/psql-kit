import Foundation

protocol PSQLColumnExpression: PSQLExpression {}

struct PSQLTypedColumnExpression<T: PSQLable> {
    let column: PSQLColumnExpression
}

extension PSQLTypedColumnExpression: TypeComparable {
    var select: PSQLExpression { column }
}

extension PSQLTypedColumnExpression: ExpressibleAsCompare {
    var compare: PSQLExpression { column }
}

struct PSQLPathColumnExpression: PSQLColumnExpression {
    let alias: String?
    let path: String?
    let schema: String?
    let column: String
    
    func serialize(to serializer: inout PSQLSerializer) {
        if let alias = alias {
            serializer.writeQuote()
            serializer.write(alias)
            serializer.writeQuote()
            serializer.writePeriod()
        } else {
            if let path = path {
                serializer.writeQuote()
                serializer.write(path)
                serializer.writeQuote()
                serializer.writePeriod()
            }
            
            if let schema = schema {
                serializer.writeQuote()
                serializer.write(schema)
                serializer.writeQuote()
                serializer.writePeriod()
            }
        }
        
        serializer.writeQuote()
        serializer.write(column)
        serializer.writeQuote()
    }
}

struct PSQLLiteralColumnExpression: PSQLColumnExpression {
    let value: PSQLExpression
    
    func serialize(to serializer: inout PSQLSerializer) {
        value.serialize(to: &serializer)
    }
}

typealias COLUMN = PSQLRawColumnExpression

struct PSQLRawColumnExpression<T: PSQLable>: PSQLColumnExpression {
    let column: String
    
    init(_ raw: String) {
        self.column = raw
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.writeQuote()
        serializer.write(column)
        serializer.writeQuote()
        serializer.write("::")
        serializer.write(T.psqlType.psqlValue)
    }
}

extension PSQLRawColumnExpression: ExpressibleAsSelect {
    var select: PSQLExpression { self }
}

extension PSQLRawColumnExpression: ExpressibleAsOrderBy {
    struct OrderBy: PSQLExpression {
        let column: String
        
        func serialize(to serializer: inout PSQLSerializer) {
            serializer.writeQuote()
            serializer.write(column)
            serializer.writeQuote()
        }
    }
    
    var orderBy: PSQLExpression { OrderBy(column: column) }
}
