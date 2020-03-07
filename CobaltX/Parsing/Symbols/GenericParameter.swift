//
//  GenericType.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class GenericParameter:Symbol
    {
    public class func parseGenericParameter(from parser:Parser) throws -> GenericParameter
        {
        if !parser.token.isIdentifier
            {
            throw(CompilerError.genericTypeNameExpected)
            }
        let name = parser.token.identifier
        try parser.nextToken()
        if !parser.token.isGluon
            {
            throw(CompilerError.gluonExpected)
            }
        try parser.nextToken()
        var constraints:[Class] = []
        try parser.parseParentheses
            {
            repeat
                {
                try parser.eatIfComma()
                constraints.append(try parser.parseClassReference())
                }
            while parser.token.isComma
            }
        return(GenericParameter(shortName: name,constraints: constraints))
        }
        
    public class func parseGenericParameters(from parser:Parser) throws -> [GenericParameter]
        {
        var parameters:[GenericParameter] = []
        try parser.nextToken()
        repeat
            {
            parameters.append(try self.parseGenericParameter(from: parser))
            }
        while !parser.token.isRightBrocket
        try parser.nextToken()
        return(parameters)
        }
        
    public let constraints:[Class]

    public init(shortName:String,constraints:[Class] = [])
        {
        self.constraints = constraints
        super.init(shortName: shortName)
        }
        
    public func instanciate(with value:Class) -> GenericParameterInstance
        {
        return(GenericParameterInstance(genericParameter: self,value:value))
        }
    }

public class GenericParameterInstance:Symbol
    {
    public let value:Class
    public let genericParameter:GenericParameter
    
    public init(genericParameter:GenericParameter,value:Class)
        {
        self.value = value
        self.genericParameter = genericParameter
        super.init(shortName: genericParameter.shortName)
        }
    }
