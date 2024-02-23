// _ConditionalContent.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation

public enum _ConditionalContent<T, U> {
    case left(T)
    case right(U)
}
