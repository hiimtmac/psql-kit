import Foundation
import SQLKit

public struct _ConditionalExpression<TrueContent, FalseContent> {
    enum Content {
        case first(TrueContent)
        case second(FalseContent)
    }
    
    let content: Content
    
    init(first: TrueContent) {
        content = .first(first)
    }
    
    init(second: FalseContent) {
        content = .second(second)
    }
}

extension _ConditionalExpression: SelectSQLExpression where TrueContent: SelectSQLExpression, FalseContent: SelectSQLExpression {
    struct _Select: SQLExpression {
        let content: _ConditionalExpression.Content
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .first(let select):
                select.selectSqlExpression.serialize(to: &serializer)
            case .second(let select):
                select.selectSqlExpression.serialize(to: &serializer)
            }
        }
    }
    
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content)
    }
}
