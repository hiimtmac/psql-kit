// HavingDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct HavingDirective: SQLExpression {
    let content: [any HavingSQLExpression]

    public init(@HavingBuilder builder: () -> [any HavingSQLExpression]) {
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
//        if !self.content.isEmpty {
//            serializer.write("HAVING")
//            serializer.writeSpace()
//            SQLList(self.content.map(\.havingSqlExpression), separator: SQLRaw(" AND "))
//                .serialize(to: &serializer)
//        }
    }
}

extension HavingDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
