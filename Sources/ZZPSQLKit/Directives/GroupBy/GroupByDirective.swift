import Foundation
import SQLKit

typealias GROUPBY = GroupByDirective

struct GroupByDirective<Content>: SQLExpression where Content: GroupBySQLExpressible {
    let content: Content
    
    init(@GroupByBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("GROUP BY")
        serializer.writeSpace()
        content.groupBySqlExpression.serialize(to: &serializer)
    }
}
