//
//  MemberBlockBuilder.swift
//  talk-demo
//
//  Created by Mahmood Tahir on 2026-07-10.
//

import SwiftSyntax

/// Build a member block from a declaration
protocol MemberBlockBuilder {
    associatedtype Declaration: DeclSyntaxProtocol
    func build(from decl: Declaration) throws -> MemberBlockItemListSyntax
}
