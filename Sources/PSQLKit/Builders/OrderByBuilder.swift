import Foundation

@_functionBuilder
struct OrderByBuilder {
    typealias Expression = PSQLOrderByExpression
    typealias Component = PSQLExpression
    
    static func buildBlock(_ components: Component...) -> Component {
        PSQLList(components)
    }
    
    static func buildExpression(_ expression: Expression) -> Component {
        expression
    }
    
    static func buildExpression<T: ExpressibleAsOrderBy>(_ select: T) -> Component {
        select.orderBy
    }
}
