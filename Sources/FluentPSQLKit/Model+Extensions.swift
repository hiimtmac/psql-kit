//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-05.
//

import PSQLKit
import FluentKit

public protocol FluentCTE: CTE, AnyObject {}

extension FluentCTE where Self: Model {
    public static var schema: String { tableName }
    public static var space: String? { schemaName }
}
