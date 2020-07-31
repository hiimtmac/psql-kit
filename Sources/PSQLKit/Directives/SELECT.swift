import Foundation

typealias SELECT = SelectDirective

struct SelectDirective: Directive {
    let type: DistinctType
    var psql: PSQLExpression
    
    init(@SelectBuilder builder: () -> PSQLExpression) {
        self.type = .default
        self.psql = builder()
    }
    
    init<T: ExpressibleAsSelect>(@SelectBuilder builder: () -> T) {
        self.type = .default
        self.psql = builder().select
    }

    init(type: DistinctType, psql: PSQLExpression) {
        self.type = type
        self.psql = psql
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("SELECT")
        serializer.writeSpace()
        
        switch type {
        case .default:
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
        
        psql.serialize(to: &serializer)
    }
    
    enum DistinctType {
        case `default`
        case distinct
        case on(PSQLExpression)
    }
}

extension SelectDirective {
    func distinct() -> Self {
        .init(type: .distinct, psql: psql)
    }
    
    /// ```
    /// SELECT DISTINCT ON (address_id) *
    /// FROM purchases
    /// WHERE product_id = 1
    /// ORDER BY address_id, purchased_at DESC
    /// ```
    ///
    func distinctOn(@SelectBuilder builder: () -> PSQLExpression) -> Self {
        .init(type: .on(builder()), psql: psql)
    }
}
