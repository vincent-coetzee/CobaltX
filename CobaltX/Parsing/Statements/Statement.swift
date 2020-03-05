//
//  Statement.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Statement:ParseNode
    {
    public var isReturnStatement:Bool
        {
        return(false)
        }
        
    public static func parseStatement(from parser: Parser) throws -> Statement
        {
        if parser.token.isWhile
            {
            return(try WhileStatement.parseWhileStatement(from: parser))
            }
        else if parser.token.isSelect
            {
            return(try SelectStatement.parseSelectStatement(from: parser))
            }
        else if parser.token.isIf
            {
            return(try IfStatement.parseIfStatement(from: parser))
            }
        else if parser.token.isReturn
            {
            return(try ReturnStatement.parseReturnStatement(from: parser))
            }
        else if parser.token.isSignal
            {
            return(try SignalStatement.parseSignalStatement(from: parser))
            }
        else if parser.token.isHandler
            {
            return(try HandlerStatement.parseHandlerStatement(from: parser))
            }
        else if parser.token.isFor
            {
            return(try ForStatement.parseForStatement(from: parser))
            }
        else if parser.token.isTimes
            {
            return(try TimesStatement.parseTimesStatement(from: parser))
            }
        else if parser.token.isDo
            {
            return(try DoStatement.parseDoStatement(from: parser))
            }
        else if parser.token.isRun
            {
            return(try DoStatement.parseDoStatement(from: parser))
            }
        else if parser.token.isIdentifier
            {
            let name = try parser.parseName()
            if let symbol = parser.scopeCurrent.lookup(name: name)
                {
                if symbol.isMethod || symbol.isClosure
                    {
                    }
                else if symbol.isVariable
                    {
                    }
                else
                    {
                    }
                }
            }
        fatalError()
        }
        
    public class func parseStatements(from parser:Parser,into block:Block) throws
        {
        while !parser.token.isRightBrace
            {
            block.addStatement(try self.parseStatement(from: parser))
            }
        }
    }
