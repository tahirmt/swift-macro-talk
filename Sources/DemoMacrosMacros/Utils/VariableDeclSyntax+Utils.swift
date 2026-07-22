import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension VariableDeclSyntax {
    var name: TokenSyntax {
        get throws {
            .identifier(try binding.pattern.trimmedDescription)
        }
    }

    var type: TypeSyntax {
        get throws {
            guard let typeAnnotation = try binding.typeAnnotation else {
                throw MacroError.invalidVariableRequirement
            }
            return typeAnnotation.type.trimmed
        }
    }

    var binding: PatternBindingSyntax {
        get throws {
            guard let binding = bindings.first else {
                throw MacroError.invalidVariableRequirement
            }
            return binding
        }
    }

    private var accessors: AccessorDeclListSyntax {
        get throws {
            guard let accessorBlock = try binding.accessorBlock,
                  case .accessors(let accessorList) = accessorBlock.accessors else {
                throw MacroError.invalidVariableRequirement
            }
            return accessorList
        }
    }

    var typeName: String {
        get throws {
            try type.description
        }
    }
    var defaultValue: String {
        get throws {
            try Self.defaultValue(for: type, variableName: name)
        }
    }

    var initializerArgument: String {
        get throws {
            try "\(name): \(typeName) = \(defaultValue)"
        }
    }

    var functionParameter: String {
        get throws {
            try "\(name): \(name)"
        }
    }

    var variableDeclaration: String {
        get throws {
            try "var \(name): \(typeName)"
        }
    }

    private static func defaultValue(for type: TypeSyntax, variableName: TokenSyntax) -> String {
        if type.is(ArrayTypeSyntax.self) {
            return "[]"
        }
        if type.is(DictionaryTypeSyntax.self) {
            return "[:]"
        }
        if type.is(OptionalTypeSyntax.self) {
            return "nil"
        }
        switch type.description {
        case "String":
            return """
                "\(variableName.description)"
                """
        case "Int", "UInt", "Double", "Float", "CGFLoat":
            return "1"
        default:
            return ".stub"
        }
    }
}
