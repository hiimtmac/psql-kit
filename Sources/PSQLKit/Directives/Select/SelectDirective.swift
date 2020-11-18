import Foundation
import SQLKit

public struct SelectDirective<Content>: SQLExpression where Content: SelectSQLExpression {
    let content: Content
    
    public init(@SelectBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    init(content: Content) {
        self.content = content
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if content is EmptyExpression { return }
        
        serializer.write("SELECT")
        serializer.writeSpace()
        content.selectSqlExpression.serialize(to: &serializer)
    }
}

public struct DistinctModifier<Content>: SelectSQLExpression where Content: SelectSQLExpression {
    let content: Content
    
    private struct _Select: SQLExpression {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("DISTINCT")
            serializer.writeSpace()
            content.selectSqlExpression.serialize(to: &serializer)
        }
    }
    
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content)
    }
}

extension SelectDirective {
    /// ```
    /// SELECT DISTINCT first_name, last_name
    /// FROM people
    /// ```
    ///
    public func distinct() -> SelectDirective<DistinctModifier<Content>> {
        .init(content: DistinctModifier(content: content))
    }
}


public struct DistinctOnModifier<DistinctOn, Content>: SelectSQLExpression where DistinctOn: SelectSQLExpression, Content: SelectSQLExpression {
    let distinctOn: DistinctOn
    let content: Content
    
    private struct _Select: SQLExpression {
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
    
    public var selectSqlExpression: some SQLExpression {
        _Select(distinctOn: distinctOn, content: content)
    }
}

extension SelectDirective {
    /// ```
    /// SELECT DISTINCT ON (address_id) *
    /// FROM purchases
    /// WHERE product_id = 1
    /// ORDER BY address_id, purchased_at DESC
    /// ```
    ///
    public func distinctOn<DistinctOn>(@SelectBuilder builder: () -> DistinctOn) -> SelectDirective<DistinctOnModifier<DistinctOn, Content>> where DistinctOn: SelectSQLExpression {
        .init(content: DistinctOnModifier(distinctOn: builder(), content: content))
    }
}

extension SelectDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
