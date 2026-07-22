//
//  StubErrorBuilder.swift
//  talk-demo
//
//  Created by Mahmood Tahir on 2026-07-10.
//

import SwiftSyntax

struct StubErrorBuilder: MemberBlockBuilder {
    func build(from decl: ProtocolDeclSyntax) throws -> MemberBlockItemListSyntax {
        try MemberBlockItemListSyntax {
            try EnumDeclSyntax("\(raw: decl.accessPrefix)enum StubError: Error") {
                for function in decl.functions {
                    """
                    case \(function.name.trimmed)
                    """
                }
            }
        }
    }
}
