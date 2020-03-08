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
    public class func parseEnumeration(from parser:Parser) throws -> Enumeration
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
        enumeration.push()
        try parser.parseBraces
            {
            var index = 0
            repeat
                {
                let theCase = try EnumerationCase.parseEnumerationCase(from: parser)
                theCase.caseIndex = index
                index += 1
                enumeration.cases.append(theCase)
                theCase.owningEnumeration = enumeration
                }
            while !parser.token.isRightBrace
            }
        enumeration.accessLevel = accessModifier
        enumeration.pop()
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
        
    public override func lookup(shortName:String) -> Symbol?
        {
        for aCase in self.cases
            {
            if aCase.shortName == shortName
                {
                return(aCase)
                }
            }
        return(self.parentScope?.lookup(shortName: shortName))
        }
    }
