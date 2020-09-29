import Foundation

///
/// ```
/// "p"."name"
/// "public"."people"."name"
/// "raw_column"
/// ```
///
struct PSQLColumnExpression: PSQLExpression {
    let aliasName: String?
    let pathName: String?
    let schemaName: String?
    let columnName: String
    
    func serialize(to serializer: inout PSQLSerializer) {
        if let alias = aliasName {
            serializer.writeQuote()
            serializer.write(alias)
            serializer.writeQuote()
            serializer.writePeriod()
        } else {
            if let path = pathName {
                serializer.writeQuote()
                serializer.write(path)
                serializer.writeQuote()
                serializer.writePeriod()
            }
            
            if let schema = schemaName {
                serializer.writeQuote()
                serializer.write(schema)
                serializer.writeQuote()
                serializer.writePeriod()
            }
        }
        
        serializer.writeQuote()
        serializer.write(columnName)
        serializer.writeQuote()
    }
}

protocol PSQLColumnSelectionExpression: PSQLExpression {}

///
/// ```
/// "p"."name"::text AS "n"
/// "public"."people"."name"::text
/// "raw_column"::text
/// ```
///
struct PSQLColumnColumnSelection: PSQLColumnSelectionExpression {
    let aliasName: String?
    let pathName: String?
    let schemaName: String?
    let columnName: String
    let columnType: String
    let columnAlias: String?
    
    func serialize(to serializer: inout PSQLSerializer) {
        if let alias = aliasName {
            serializer.writeQuote()
            serializer.write(alias)
            serializer.writeQuote()
            serializer.writePeriod()
        } else {
            if let path = pathName {
                serializer.writeQuote()
                serializer.write(path)
                serializer.writeQuote()
                serializer.writePeriod()
            }
            
            if let schema = schemaName {
                serializer.writeQuote()
                serializer.write(schema)
                serializer.writeQuote()
                serializer.writePeriod()
            }
        }
        
        serializer.writeQuote()
        serializer.write(columnName)
        serializer.writeQuote()
        
        serializer.write("::")
        serializer.write(columnType)
        
        if let alias = columnAlias {
            serializer.write(" AS ")
            serializer.writeQuote()
            serializer.write(alias)
            serializer.writeQuote()
        }
    }
}

///
/// ```
/// 'raw_string'::text
/// 3::integer
/// TRUE::boolean AS "bool"
/// ```
///
struct PSQLLiteralColumnSelection: PSQLColumnSelectionExpression {
    let value: PSQLExpression
    let type: String
    let columnAlias: String?
    
    func serialize(to serializer: inout PSQLSerializer) {
        value.serialize(to: &serializer)
        serializer.write("::")
        serializer.write(type)
        
        if let alias = columnAlias {
            serializer.write(" AS ")
            serializer.writeQuote()
            serializer.write(alias)
            serializer.writeQuote()
        }
    }
}
