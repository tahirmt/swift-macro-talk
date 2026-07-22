//
//  StubBuilder.swift
//  talk-demo
//
//  Created by Mahmood Tahir on 2026-07-10.
//

import SwiftSyntax

struct StubBuilder: MemberBlockBuilder {
    func build(from decl: ProtocolDeclSyntax) throws -> MemberBlockItemListSyntax {
        let publicPrefix = decl.accessPrefix
        return try MemberBlockItemListSyntax {
            try ClassDeclSyntax("\(raw: publicPrefix)final class Stubs: @unchecked Sendable") {
                for function in decl.functions {
                    """
                    /// The result to return for the method ``\(raw: function.name)``. If set to failure the given error will be thrown
                    \(raw: publicPrefix)var \(function.name.trimmed)Result: Result<\(function.returnType ?? "Void"), any Error>?
                    """
                }
            }

            """
            /// Stubs allow you to stub out what the return value(s) of the mock will be.
            /// There is a stub value for each method and property.
            \(raw: publicPrefix)let stubs = Stubs()
            """
        }
    }
}
