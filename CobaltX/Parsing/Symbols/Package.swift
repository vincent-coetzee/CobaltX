//
//  Package.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Package:ContainerSymbol
    {
    public static let rootPackage = CobaltPackage(shortName: "Cobalt").initCobaltPackage()
    
    public class func canParse(token:Token) -> Bool
        {
        return(token.isPackage)
        }
        
    public class func parsePackage(from parser:Parser) throws -> Package
        {
        if parser.token.isAt
            {
            try parser.parseDirective()
            }
        var package:Package?
        try parser.parseAccessModifier
            {
            accessModifier in
            if !parser.token.isPackage
                {
                throw(CompilerError.packageDeclarationExpected)
                }
            try parser.nextToken()
            let name = try parser.matchIdentifier(error: .packageNameExpected)
            package = Package(shortName: name)
            package?.push()
            if parser.token.isLeftBrocket
                {
                package!.genericTypes = try GenericParameter.parseGenericParameters(from: parser)
                for type in package!.genericTypes
                    {
                    package!.addSymbol(type)
                    }
                }
            try parser.parseBraces
                {
                while !parser.token.isRightBrace
                    {
                    if parser.token.isAt
                        {
                        try parser.parseDirective()
                        }
                    try parser.parseAccessModifier
                        {
                        accessModifier in
                        if parser.token.isPackageLevelKeyword
                            {
                            var symbol:Symbol
                            switch(parser.token.keyword)
                                {
                                case .package:
                                    symbol = try Package.parsePackage(from: parser)
                                case .method:
                                    symbol = try Method.parseMethod(from: parser)
                                case .let:
                                    symbol = try Variable.parseVariable(from: parser)
                                case .constant:
                                    symbol = try Constant.parseConstant(from: parser)
                                case .alias:
                                    symbol = try Alias.parseAlias(from: parser)
                                case .class:
                                    symbol = try Class.parseClass(from: parser)
                                case .enumeration:
                                    symbol = try Enumeration.parseEnumeration(from: parser)
                                case .macro:
                                    symbol = try Macro.parseMacro(from: parser)
                                default:
                                    throw(CompilerError.packageLevelKeywordExpected)
                                }
                            symbol.accessLevel = accessModifier
                            package!.addSymbol(symbol)
                            }
                        else
                            {
                            throw(CompilerError.packageLevelKeywordExpected)
                            }
                        }
                    }
                }
            package!.pop()
            }
        return(package!)
        }
        
    public override var isPackageLevelSymbol:Bool
        {
        return(true)
        }
        
    public private(set) var genericTypes:[GenericParameter] = []
    }


