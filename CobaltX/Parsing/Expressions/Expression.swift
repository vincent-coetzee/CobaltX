//
//  Expression.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 29/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Expression:ParseNode
    {
    @inline(__always)
    public class func parseExpression(from parser:Parser) throws -> Expression
        {
        return(try self.parseLogicalOrExpression(from: parser))
        }
    
    @inline(__always)
    private class func parseLogicalOrExpression(from parser:Parser) throws -> Expression
        {
        var lhs = try self.parseLogicalAndExpression(from: parser)
        while parser.token.isOr
            {
            try parser.nextToken()
            let rhs = try self.parseLogicalAndExpression(from: parser)
            lhs = BinaryExpression(lhs: lhs,operation: .or,rhs: rhs)
            }
        return(lhs)
        }
        
    @inline(__always)
    private class func parseLogicalAndExpression(from parser:Parser) throws -> Expression
        {
        var lhs = try self.parseEqualityExpression(from: parser)
        while parser.token.isAnd
            {
            try parser.nextToken()
            let rhs = try self.parseEqualityExpression(from: parser)
            lhs = BinaryExpression(lhs: lhs,operation: .and,rhs: rhs)
            }
        return(lhs)
        }
        
    @inline(__always)
    private class func parseEqualityExpression(from parser:Parser) throws -> Expression
        {
        var lhs = try self.parseComparisonExpression(from: parser)
        while parser.token.isEquals || parser.token.isNotEquals
            {
            try parser.nextToken()
            let rhs = try self.parseComparisonExpression(from: parser)
            lhs = BinaryExpression(lhs: lhs,operation: .equals,rhs: rhs)
            }
        return(lhs)
        }
        
    @inline(__always)
    private class func parseComparisonExpression(from parser:Parser) throws -> Expression
        {
        var lhs = try self.parseBitwiseOperationExpression(from: parser)
        while parser.token.isLeftBrocket || parser.token.isLeftBrocketEquals || parser.token.isRightBrocket || parser.token.isRightBrocketEquals
            {
            let operation = parser.token.symbol
            try parser.nextToken()
            let rhs = try self.parseBitwiseOperationExpression(from: parser)
            lhs = BinaryExpression(lhs: lhs,operation: operation,rhs: rhs)
            }
        return(lhs)
        }
        
    @inline(__always)
    private class func parseBitwiseOperationExpression(from parser:Parser) throws -> Expression
        {
        var lhs = try self.parseAdditionExpression(from: parser)

        while try parser.token.isBitAnd || parser.token.isBitOr || parser.token.isBitNot || parser.token.isBitShiftLeft || parser.tokenIsBitShiftRight()
            {
            let operation = parser.token.symbol
            try parser.nextToken()
            let rhs = try self.parseAdditionExpression(from: parser)
            lhs = BinaryExpression(lhs: lhs,operation: operation,rhs: rhs)
            }
        return(lhs)
        }
        
    @inline(__always)
    private class func parseAdditionExpression(from parser:Parser) throws -> Expression
        {
        var lhs = try self.parseMultiplicationExpression(from: parser)
        while parser.token.isSub || parser.token.isAdd
            {
            let operation = parser.token.symbol
            try parser.nextToken()
            let rhs = try self.parseMultiplicationExpression(from: parser)
            lhs = BinaryExpression(lhs: lhs,operation: operation,rhs: rhs)
            }
        return(lhs)
        }
    
    @inline(__always)
    private class func parseMultiplicationExpression(from parser:Parser) throws -> Expression
        {
        var lhs = try self.parseUnaryExpression(from: parser)
        while parser.token.isDiv || parser.token.isMul
            {
            let operation = parser.token.symbol
            try parser.nextToken()
            let rhs = try self.parseUnaryExpression(from: parser)
            lhs = BinaryExpression(lhs: lhs,operation: operation,rhs: rhs)
            }
        return(lhs)
        }
    
    @inline(__always)
    private class func parseOperationAssignmentExpression(from parser:Parser) throws -> Expression
        {
        var lhs = try self.parseUnaryExpression(from:parser)
        while parser.token.isDivEquals || parser.token.isMulEquals || parser.token.isAddEquals || parser.token.isSubEquals || parser.token.isBitAndEquals || parser.token.isBitNotEquals || parser.token.isBitOrEquals || parser.token.isBitShiftLeftEquals || parser.token.isBitShiftRightEquals
            {
            let operation = parser.token.symbol
            try parser.nextToken()
            let rhs = try self.parseUnaryExpression(from: parser)
            lhs = BinaryExpression(lhs: lhs,operation: operation,rhs: rhs)
            }
        return(lhs)
        }
        
    @inline(__always)
    private class func parseUnaryExpression(from parser:Parser) throws -> Expression
        {
        if parser.token.isNot || parser.token.isSub || parser.token.isBitNot
            {
            let operation = parser.token.symbol
            try parser.nextToken()
            let rhs = try self.parseUnaryExpression(from:parser)
            return(UnaryExpression(operation: operation,rhs: rhs))
            }
        return(try self.parsePrimaryExpression(from:parser))
        }
        
    public class func parseLiteralExpression(from parser:Parser) throws -> LiteralExpression
        {
        try parser.nextToken()
        if parser.lastToken.isString
            {
            return(LiteralExpression(string: parser.lastToken.string))
            }
        else if parser.lastToken.isIntegerNumber
            {
            return(LiteralExpression(integer: parser.lastToken.integer))
            }
        else if parser.lastToken.isFloatingPointNumber
            {
            return(LiteralExpression(float64: parser.lastToken.floatingPoint))
            }
        else
            {
            throw(CompilerError.literalValueExpected)
            }
        }
        
    @inline(__always)
    private class func parseMacroExpression(macro:Macro,from parser:Parser) throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private class func parseEnumerationExpression(enumeration:Enumeration,from parser:Parser) throws -> Expression
        {
        try parser.nextToken()
        if !parser.token.isIdentifier
            {
            throw(CompilerError.enumerationCaseExpected)
            }
        let shortName = parser.token.identifier
        try parser.nextToken()
        if let aCase = enumeration.lookup(shortName: shortName) as? EnumerationCase
            {
            return(LiteralExpression(enumerationCase: aCase))
            }
        throw(CompilerError.enumerationCaseExpected)
        }
        
    @inline(__always)
    private class func parseInvocationExpression(name:String,from parser:Parser) throws -> Expression
        {
        let arguments = try Parameter.parseParameterArguments(from: parser)
        let method = Method(shortName: name)
        method.wasDeclaredForward = true
        parser.scopeCurrent.addSymbol(method)
        let methodInstance = MethodInstance(shortName: name)
        methodInstance.parameters = arguments.map{Parameter($0)}
        method.addInstance(methodInstance)
        methodInstance.wasDeclaredForward = true
        return(InvocationExpression(method:method,arguments:arguments))
        }
        
    @inline(__always)
    private class func parseInvocationExpression(variable:Variable,from parser:Parser) throws -> Expression
        {
        let arguments = try Parameter.parseParameterArguments(from: parser)
        if variable.class == Package.rootPackage.closureClass
            {
            return(InvocationExpression(closureVariable:variable,arguments:arguments))
            }
        else if variable.class == Package.rootPackage.methodClass
            {
            return(InvocationExpression(methodVariable:variable,arguments:arguments))
            }
        else
            {
            throw(CompilerError.variableMustContainExecutable)
            }
        }
        
    @inline(__always)
    private class func parseInvocationExpression(method:Method,from parser:Parser) throws -> Expression
        {
        let arguments = try Parameter.parseParameterArguments(from: parser)
        return(InvocationExpression(method:method,arguments:arguments))
        }
        
    @inline(__always)
    private class func parseSubscriptedExpression(variable:Variable,from parser:Parser) throws -> Expression
        {
        try parser.nextToken()
        let index = try self.parseExpression(from:parser)
        if !parser.token.isRightBracket
            {
            throw(CompilerError.rightBracketExpectedAfterSubscript)
            }
        try parser.nextToken()
        return(index)
        }
        
    @inline(__always)
    private class func parseSlotExpression(variable:Variable,from parser:Parser) throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private class func parseTupleExpression(from parser:Parser) throws -> Expression
        {
        let tuple = Tuple()
        repeat
            {
            if parser.token.isComma
                {
                try parser.nextToken()
                }
            var tag:String = ""
            if !parser.token.isTag
                {
                throw(CompilerError.tagExpectedInTupleDeclaration)
                }
            else
                {
                tag = parser.token.tag
                try parser.nextToken()
                }
            let value = try self.parseExpression(from:parser)
            tuple.append(tag: tag, value: value)
            }
        while parser.token.isComma
        if parser.token.isRightPar
            {
            try parser.nextToken()
            }
        return(LiteralExpression(tuple: tuple))
        }
        
    @inline(__always)
    private class func parseCollectionLiteralExpression(from parser:Parser) throws -> Expression
        {
        var collection:[ValueBox] = []
        try parser.nextToken()
        var wereAssociations = false
        repeat
            {
            if !parser.token.isRightBracket
                {
                var isAssociation = false
                var value = try self.parseExpression(from: parser)
                var key:Expression = Expression()
                if parser.token.isColon
                    {
                    try parser.nextToken()
                    key = value
                    value = try self.parseExpression(from: parser)
                    isAssociation = true
                    }
                try parser.eatIfComma()
                if isAssociation
                    {
                    wereAssociations = true
                    collection.append(.association(key,value))
                    }
                else
                    {
                    collection.append(.expression(value))
                    }
                }
            }
        while !parser.token.isRightBracket
        try parser.nextToken()
        if wereAssociations
            {
            return(LiteralExpression(dictionary: collection))
            }
        return(LiteralExpression(array:collection))
        }
        
    @inline(__always)
    private class func parseDateExpression(from parser:Parser) throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private class func parseIdentifierExpression(from parser:Parser) throws -> Expression
        {
        let name = parser.token.identifier
        let location = parser.token.location
        try parser.nextToken()
        if let symbol = parser.scopeCurrent.lookup(shortName: name)
            {
            symbol.addRead(location:location)
            switch(symbol)
                {
                //
                // A macro has been invoked, so insert the
                // macro text and variables and then return
                //
                case is Macro:
                    return(try self.parseMacroExpression(macro: symbol as! Macro,from: parser))
                //
                // Handle a constant in a similar fashion as a variable because
                // it is actually just a read only variable
                //
                case is Constant:
                    return(ConstantValueExpression(constant: symbol as! Constant))
                //
                // Check if was instanciated if not throw an error
                //
                case is GenericParameter:
                    return(SymbolValueExpression(symbol: symbol))
                //
                // Something looking for the enumeration value, check if there is dotted access after
                // in which case it is a case not the enumeration
                //
                case is Enumeration:
                    if !parser.token.isStop
                        {
                        return(LiteralExpression(enumeration: symbol as! Enumeration))
                        }
                    return(try self.parseEnumerationExpression(enumeration: symbol as! Enumeration,from: parser))
                //
                // This could be the invocation of a generic function, check to
                // see and generate an invocation if required.
                //
                case is Method:
                    let method = symbol as! Method
                    if parser.token.isLeftPar
                        {
                        return(try self.parseInvocationExpression(method:method,from: parser))
                        }
                    else
                        {
                        return(LiteralExpression(method: method))
                        }
                //
                // Parameters are for reading only
                //
                case is Parameter:
                    return(SymbolValueExpression(symbol: symbol))
                //
                // Variable could be many things, handle them all
                //
                case is Variable:
                    let variable = symbol as! Variable
                    if variable.shortName == "arguments"
                        {
                        print("halt")
                        }
                    if parser.token.isStop
                        {
                        return(try parseSlotExpression(variable: variable,from: parser))
                        }
                    else if parser.token.isLeftPar
                        {
                        return(try parseInvocationExpression(variable: variable,from: parser))
                        }
                    else if parser.token.isLeftBracket
                        {
                        return(try parseSubscriptedExpression(variable: variable,from: parser))
                        }
                    else
                        {
                        return(SymbolValueExpression(symbol: symbol))
                        }
                //
                // Handle a slot that has been detected, generate the appropriate
                // accessor that will give access to contents of the slot
                //
                case is Class:
                    return(LiteralExpression(class: symbol as! Class))
//                case is Slot:
//                    return(try self.parseSlotExpression(symbol: symbol))
                default:
                    if parser.token.isLeftPar
                        {
                        return(try self.parseInvocationExpression(name: name,from: parser))
                        }
                    throw(CompilerError.undefinedValue(name))
                }
            }
        else if parser.token.isNil
            {
            try parser.nextToken()
            return(NilExpression())
            }
        else if parser.token.isLeftPar
            {
            return(try self.parseInvocationExpression(name: name,from: parser))
            }
        else
            {
            let symbol = Variable(shortName: name, class: Package.rootPackage.undefinedObjectClass)
            symbol.addDeclaration(location: location)
            parser.scopeCurrent.addSymbol(symbol)
            symbol.wasDeclaredForward = true
            return(SymbolValueExpression(symbol: symbol))
            }
//        return(UndefinedValueExpression(location: parser.token.location,symbol: nil))
        }
            
    @inline(__always)
    private class func parsePrimaryExpression(from parser:Parser) throws -> Expression
        {
        print("\n\(parser.token.location.line) -- \(#function)\n")
        if parser.token.isIdentifier
            {
            return(try self.parseIdentifierExpression(from: parser))
            }
        if parser.token.isGluon
            {
            try parser.nextToken()
            return(LiteralExpression(enumerationCase: try EnumerationCase.parseEnumerationCaseInstance(from: parser)))
            }
        if parser.token.isLeftBracket
            {
            return(try self.parseCollectionLiteralExpression(from: parser))
            }
        if parser.token.isAt
            {
            return(try parseDateExpression(from: parser))
            }
        if parser.token.isLeftBrace
            {
            let closure = try Closure.parseClosure(from: parser)
            if parser.token.isLeftPar
                {
                let arguments = try Parameter.parseParameterArguments(from: parser)
                return(ClosureValueExpression(closure: closure, arguments: arguments))
                }
            return(LiteralExpression(closure: closure))
            }
        if parser.token.isIntegerNumber
            {
            let number = LiteralExpression(integer: parser.token.integerValue)
            try parser.nextToken()
            return(number)
            }
        if parser.token.isFloatingPointNumber
            {
            let number = LiteralExpression(float64: parser.token.floatingPointValue)
            try parser.nextToken()
            return(number)
            }
        if parser.token.isString
            {
            let string = parser.token.string
            try parser.nextToken()
            return(LiteralExpression(string:string))
            }
        if parser.token.isThis
            {
            try parser.nextToken()
            return(ThisExpression())
            }
        if parser.token.isKeyword
            {
            let identifier = parser.token.keywordString
            try parser.nextToken()
            if let symbol = parser.scopeCurrent.lookup(shortName: identifier) as? Class
                {
                return(LiteralExpression(class: symbol))
                }
            }
        else if parser.token.isLeftPar
            {
            try parser.nextToken()
            if parser.token.isTag
                {
                return(try self.parseTupleExpression(from: parser))
                }
            let value = try self.parseExpression(from: parser)
            if !parser.token.isRightPar
                {
                throw(CompilerError.rightParExpected)
                }
            try parser.nextToken()
            return(value)
            }
        throw(CompilerError.expressionExpected)
        }
            
    public var `class`:Class
        {
        fatalError("Not implemented")
        }
    }
