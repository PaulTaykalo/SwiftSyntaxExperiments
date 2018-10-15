//
//  CodeBlockSyntaxExtensions.swift
//  SwiftSyntax
//
//  Created by Paul Taykalo on 10/14/18.
//

import SwiftSyntax

extension FunctionDeclSyntax {
    public func only<T>(_ match: (Syntax) -> T?) -> T? {
        return body.flatMap { $0.only(match) }
    }
}
extension CodeBlockSyntax {

    public func only<T>(_ match: (Syntax) -> T?) -> T? {
        guard statements.count == 1 else { return nil }
        guard let one = statements.first else { return nil }
        return match(one.item)
    }
}
