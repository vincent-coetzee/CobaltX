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
    private let hasTag:Bool
    
    public class func parseParameter(from parser:Parser) throws -> Parameter
        {
        var hasTag = true
        if parser.token.isSub
            {
            hasTag = false
            try parser.nextToken()
            }
        if !parser.token.isTag
            {
            throw(CompilerError.tagExpectedInClosureWithClause)
            }
        let tag = parser.token.tag
        try parser.nextToken()
        let aClass = try parser.parseClassReference()
        return(Parameter(shortName: tag, class: aClass,hasTag:hasTag))
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
        
    public class func parseParameterArguments(from parser:Parser) throws -> [Argument]
        {
        var arguments:[Argument] = []
        try parser.parseParentheses
            {
            repeat
                {
                arguments.append(try self.parseArgument(from: parser))
                }
            while parser.token.isComma
            }
        return(arguments)
        }
        
    public class func parseArgument(from parser:Parser) throws -> Argument
        {
        var tag:String?
        if parser.token.isTag
            {
            tag = parser.token.tag
            try parser.nextToken()
            }
        let value = try Expression.parseExpression(from: parser)
        return(Argument(tag: tag, value: value))
        }
        
    public init(_ argument:Argument)
        {
        self.hasTag = argument.tag != nil
        super.init(shortName: argument.tag ?? "",class: argument.class)
        }
        
    public init(shortName:String,class:Class,hasTag:Bool = true)
        {
        self.hasTag = hasTag
        super.init(shortName: shortName,class: `class`)
        }
    }
