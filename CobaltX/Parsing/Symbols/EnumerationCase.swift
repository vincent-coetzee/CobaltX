//
//  EnumerationCase.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 01/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class EnumerationCase:Symbol
    {
    public class func parseEnumerationCase(from parser:Parser) throws -> EnumerationCase
        {
        let name = try parser.matchIdentifier(error: CompilerError.enumerationCaseNameExpected)
        var associatedTypes:[Class] = []
        if parser.token.isLeftPar
            {
            associatedTypes = try parser.parseClassReferences()
            }
        var value:LiteralExpression?
        if parser.token.isAssign
            {
            try parser.nextToken()
            value = try Expression.parseLiteralExpression(from:parser)
            }
        return(EnumerationCase(name: name,associatedValueClasses: associatedTypes,value: value))
        }
        
    public class func parseEnumerationCaseInstance(from parser:Parser) throws -> EnumerationCase
        {
        let name = try parser.matchIdentifier(error: CompilerError.enumerationCaseNameExpected)
        return(EnumerationCase(name: name,associatedValueClasses:[]))
        }
        
    public private(set) var associatedValueClasses:[Class]
    public var value:LiteralExpression?
    public var caseIndex = 0
    public var owningEnumeration = Enumeration(name:"Error",class:Package.rootPackage.enumerationClass)
    
    public init(name: String,associatedValueClasses: [Class],value: LiteralExpression? = nil)
        {
        self.associatedValueClasses = associatedValueClasses
        self.value = value
        super.init(shortName: name)
        }
    }
