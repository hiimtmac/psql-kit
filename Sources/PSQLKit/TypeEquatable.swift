// TypeEquatable.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation

public protocol TypeEquatable {
    associatedtype CompareType
}

extension TypeEquatable where Self: RawRepresentable, RawValue: TypeEquatable {
    public typealias CompareType = RawValue
}
