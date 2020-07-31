import Foundation

@_functionBuilder
struct SelectBuilder {
    typealias Expression = PSQLSelectExpression
    typealias Component = PSQLExpression
    
    static func buildBlock(_ components: Component...) -> Component {
        PSQLList(components)
    }
    
    static func buildExpression(_ expression: Expression) -> Component {
        expression
    }
    
    static func buildExpression<T: ExpressibleAsSelect>(_ select: T) -> Component {
        select.select
    }
}
