//
//  Parameter.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 29/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Parameter:Variable
    {
    public class func parseParameter(from parser:Parser) throws -> Parameter
        {
        if !parser.token.isTag
            {
            throw(CompilerError.tagExpectedInClosureWithClause)
            }
        let tag = parser.token.tag
        try parser.nextToken()
        let aClass = try parser.parseClassReference()
        return(Parameter(name: tag, class: aClass))
        }
        
    public class func parseParameters(from parser:Parser) throws -> [Parameter]
        {
        var parameters:[Parameter] = []
        try parser.parseParentheses
            {
            repeat
                {
                try parser.eatIfComma()
                parameters.append(try self.parseParameter(from: parser))
                }
            while parser.token.isComma
            }
        return(parameters)
        }
    }
