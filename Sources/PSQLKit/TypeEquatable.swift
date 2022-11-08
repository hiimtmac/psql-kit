// TypeEquatable.swift
// Copyright © 2022 hiimtmac

import Foundation

public protocol TypeEquatable {
    associatedtype CompareType
}

extension TypeEquatable where Self: RawRepresentable, RawValue: TypeEquatable {
    public typealias CompareType = RawValue
}
