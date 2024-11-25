//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-25.
//

import Foundation

struct Environment {
    @TaskLocal static var escapeIdentifiers: Bool = false
}
