import Foundation
import SQLKit

struct SelectDirective<Content>: SQLExpression where Content: SelectSQLExpressible {
    let content: Content
    
    init(@SelectBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    init(content: Content) {
        self.content = content
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("SELECT")
        serializer.writeSpace()
        content.selectSqlExpression.serialize(to: &serializer)
    }
}

struct DistinctModifier<Content>: SelectSQLExpressible where Content: SelectSQLExpressible {
    let content: Content
    
    struct Select: SQLExpression {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("DISTINCT")
            serializer.writeSpace()
            content.selectSqlExpression.serialize(to: &serializer)
        }
    }
    
    var selectSqlExpression: Select { .init(content: content) }
}

extension SelectDirective {
    /// ```
    /// SELECT DISTINCT first_name, last_name
    /// FROM people
    /// ```
    ///
    func distinct() -> SelectDirective<DistinctModifier<Content>> {
        .init(content: DistinctModifier(content: content))
    }
}


struct DistinctOnModifier<DistinctOn, Content>: SelectSQLExpressible where DistinctOn: SelectSQLExpressible, Content: SelectSQLExpressible {
    let distinctOn: DistinctOn
    let content: Content
    
    struct Select: SQLExpression {
        let distinctOn: DistinctOn
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("DISTINCT ON")
            serializer.writeSpace()
            serializer.write("(")
            distinctOn.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeSpace()
            content.selectSqlExpression.serialize(to: &serializer)
        }
    }
    
    var selectSqlExpression: Select { .init(distinctOn: distinctOn, content: content) }
}

extension SelectDirective {
    /// ```
    /// SELECT DISTINCT ON (address_id) *
    /// FROM purchases
    /// WHERE product_id = 1
    /// ORDER BY address_id, purchased_at DESC
    /// ```
    ///
    func distinctOn<DistinctOn>(@SelectBuilder builder: () -> DistinctOn) -> SelectDirective<DistinctOnModifier<DistinctOn, Content>> where DistinctOn: SelectSQLExpressible {
        .init(content: DistinctOnModifier(distinctOn: builder(), content: content))
    }
}

extension SelectDirective: QuerySQLExpressible {
    var querySqlExpression: Self { self }
}
