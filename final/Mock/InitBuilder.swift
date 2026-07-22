//
//  InitBuilder.swift
//  talk-demo
//
//  Created by Mahmood Tahir on 2026-07-10.
//

import SwiftSyntax

struct InitBuilder: MemberBlockBuilder {
    func build(from decl: ProtocolDeclSyntax) throws -> MemberBlockItemListSyntax {
        MemberBlockItemListSyntax {
            """
            \(raw: decl.accessPrefix)init() {}
            """
        }
    }
}
