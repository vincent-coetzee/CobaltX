//
//  ClosureBlock.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Closure:Block,Parsing
    {
    private var parameters:[Parameter] = []
    
    public static func parse(from parser:Parser) throws -> ParseNode
        {
        try parser.nextToken()
        let closure = Closure()
        try parser.parseBraces
            {
            if parser.token.isWith
                {
                try parser.nextToken()
                closure.parameters = try Parameter.parseParameters(from: parser)
                }
            while !parser.token.isRightBrace
                {
                try Statement.parseStatements(from: parser,into: closure)
                }
            }
        return(closure)
        }
    }
