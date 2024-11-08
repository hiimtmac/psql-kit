//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-08.
//

import SQLKit

extension SQLSerializer {
    static var test: SQLSerializer {
        SQLSerializer(database: TestSQLDatabase())
    }
}
