import Foundation
import SQLKit

extension ClosedRange: CompareSQLExpressible where Bound: SQLExpression {
    private struct _Compare: SQLExpression {
        let range: ClosedRange<Bound>
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("(")
            range.lowerBound.serialize(to: &serializer)
            serializer.writeSpace()
            serializer.write("AND")
            serializer.writeSpace()
            range.upperBound.serialize(to: &serializer)
            serializer.write(")")
        }
    }
    
    public var compareSqlExpression: some SQLExpression {
        _Compare(range: self)
    }
}
