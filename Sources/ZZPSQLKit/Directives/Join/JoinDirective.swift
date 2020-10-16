//import Foundation
//import SQLKit
//
//typealias JOIN = JoinDirective
//
//struct JoinDirective<Content>: SQLExpression where Content: JoinSQLExpressible {
//    let content: Content
//    
//    init(@JoinBuilder builder: () -> Content) {
//        self.content = builder()
//    }
//    
//    init(content: Content) {
//        self.content = content
//    }
//    
//    func serialize(to serializer: inout SQLSerializer) {
//        serializer.write("SELECT")
//        serializer.writeSpace()
//        content.selectSqlExpression.serialize(to: &serializer)
//    }
//}
