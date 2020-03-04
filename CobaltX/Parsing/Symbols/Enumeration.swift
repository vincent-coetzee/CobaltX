//
//  Enumeration.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Enumeration:ContainerSymbol
    {
    public class func parseEnumerationDeclaration(from parser:Parser) throws -> Enumeration
        {
        let accessModifier = parser.currentAccessModifier
        try parser.nextToken()
        let name = try parser.matchIdentifier(error: CompilerError.enumerationNameExpected)
        var typeClass = Package.rootPackage.integerClass
        if parser.token.isGluon
            {
            try parser.nextToken()
            typeClass = try parser.parseClassReference()
            }
        let enumeration = Enumeration(name: name,class:typeClass)
        try parser.parseBraces
            {
            var index = 0
            repeat
                {
                let theCase = try EnumerationCase.parse(from: parser) as! EnumerationCase
                theCase.caseIndex = index
                index += 1
                enumeration.cases.append(theCase)
                theCase.owningEnumeration = enumeration
                }
            while !parser.token.isRightBrace
            }
        enumeration.accessLevel = accessModifier
        return(enumeration)
        }
        
    public override var isPackageLevelSymbol:Bool
        {
        return(true)
        }
        
    private let _typeClass:Class
    private var cases:[EnumerationCase] = []
    
    public override var `class`:Class
        {
        return(self._typeClass)
        }
        
    public init(name:String,class:Class)
        {
        self._typeClass = `class`
        super.init(shortName: name)
        }
    }
