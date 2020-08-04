import Foundation

@_functionBuilder
struct QueryBuilder {
    typealias Expression = PSQLExpression
    typealias Component = PSQLExpression
    
    static func buildBlock(_ components: Component...) -> Component {
        PSQLList(components, separator: " ")
    }
    
    static func buildExpression(_ expression: Expression) -> Component {
        expression
    }
}
