import Foundation

@_functionBuilder
struct GroupByBuilder {
    typealias Expression = PSQLGroupByExpression
    typealias Component = PSQLExpression
    
    static func buildBlock(_ components: Component...) -> Component {
        PSQLList(components)
    }
    
    static func buildExpression(_ expression: Expression) -> Component {
        expression
    }
}
