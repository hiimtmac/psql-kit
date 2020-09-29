import Foundation

typealias SELECT = SelectDirective

protocol PSQLSelectExpression {
    var psqlSelectExpression: PSQLExpression { get }
}

struct SelectDirective<Content>: PSQLExpression where Content: PSQLSelectExpression {
    let type: DistinctType
    let content: Content
    
    init(@SelectBuilder builder: () -> Content) {
        self.type = .none
        self.content = builder()
    }

    init(type: DistinctType, content: Content) {
        self.type = type
        self.content = content
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("SELECT")
        serializer.writeSpace()
        
        switch type {
        case .none:
            break
        case .distinct:
            serializer.write("DISTINCT")
            serializer.writeSpace()
        case .on(let columns):
            serializer.write("DISTINCT ON")
            serializer.writeSpace()
            serializer.write("(")
            columns.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeSpace()
        }
        
        content.psqlSelectExpression.serialize(to: &serializer)
    }
    
    enum DistinctType {
        case none
        case distinct
        case on(PSQLExpression)
    }
}

extension SelectDirective: Directive {}

extension SelectDirective {
    func distinct() -> Self {
        .init(type: .distinct, content: content)
    }
    
    /// ```
    /// SELECT DISTINCT ON (address_id) *
    /// FROM purchases
    /// WHERE product_id = 1
    /// ORDER BY address_id, purchased_at DESC
    /// ```
    ///
    func distinctOn(@SelectBuilder builder: () -> PSQLExpression) -> Self {
        .init(type: .on(builder()), content: content)
    }
}
