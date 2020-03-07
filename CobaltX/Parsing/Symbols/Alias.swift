//
//  Alias.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Alias:Symbol
    {
    private let aliasedClass:Class
    
    public class func parseAlias(from parser:Parser) throws -> Alias
        {
        if !parser.token.isAlias
            {
            throw(CompilerError.aliasExpected)
            }
        try parser.nextToken()
        let aClass = try Class.parseClassReference(from: parser)
        if !parser.token.isAs
            {
            throw(CompilerError.asExpected)
            }
        try parser.nextToken()
        if !parser.token.isIdentifier
            {
            throw(CompilerError.aliasNameExpected)
            }
        let name = parser.token.identifier
        try parser.nextToken()
        return(Alias(shortName: name,class:aClass))
        }
        
    public init(shortName:String,class:Class)
        {
        self.aliasedClass = `class`
        super.init(shortName:shortName)
        }
    }
