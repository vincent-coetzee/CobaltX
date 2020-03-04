//
//  Parser.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Parser
    {
    public static let shared = Parser()
    
    public private(set) var token:Token
    public private(set) var lastToken:Token
    private var tokenStream:TokenStream
    private var _source:String
    public private(set) var currentAccessModifier:AccessModifier = .public
    private var scopes:[Int:Scope] = [:]
    private var scopeStack = Stack<Scope>()
    public private(set) var scopeCurrent:Scope = Package.rootPackage
    public private(set) var location:SourceLocation = .zero
    private var accessModifierStack = Stack<AccessModifier>()
    public private(set) var currentDirective:Directive = .none
    
    public var source:String
        {
        get
            {
            return(self._source)
            }
        set
            {
            self._source = newValue
            self.tokenStream = TokenStream(source: newValue)
            }
        }
        
    public init()
        {
        self._source = ""
        self.tokenStream = TokenStream(source: "")
        self.token = .none
        self.lastToken = .none
        }
    
    public func parse() throws -> Package
        {
        try self.nextToken()
        return(try Package.parse(from: self) as! Package)
        }
        
    public func pushScope(_ scope:Scope)
        {
        scope.parentScope = scopeCurrent
        self.scopes[scope.index] = scope
        self.scopeStack.push(self.scopeCurrent)
        self.scopeCurrent = scope
        }
        
    public func popScope()
        {
        self.scopeCurrent = self.scopeStack.pop()
        }
    
    public func nextToken() throws
        {
        self.lastToken = token
        self.token = try self.tokenStream.nextToken()
        self.location = self.token.location
        }
        
    public func matchIdentifier(error:CompilerError) throws -> String
        {
        if !(self.token.isIdentifier || self.token.isKeyword)
            {
            throw(error)
            }
        let identifier = self.token.isKeyword ? self.token.keyword.rawValue : self.token.identifier
        try self.nextToken()
        return(identifier)
        }
        
    public func parseBraces(_ closure:() throws -> Void) throws
        {
        if !self.token.isLeftBrace
            {
            throw(CompilerError.leftBraceExpected)
            }
        try self.nextToken()
        try closure()
        if !self.token.isRightBrace
            {
            throw(CompilerError.rightBraceExpected)
            }
        try self.nextToken()
        }
        
    public func parseParentheses(_ closure:() throws -> Void) throws
        {
        if !self.token.isLeftPar
            {
            throw(CompilerError.leftParExpected)
            }
        try self.nextToken()
        try closure()
        if !self.token.isRightPar
            {
            throw(CompilerError.rightParExpected)
            }
        try self.nextToken()
        }
        
    public func parseAccessModifier(_ closure: (AccessModifier) throws -> Void) throws
        {
        var mustPop = false
        if self.token.isAccessModifier
            {
            self.accessModifierStack.push(self.currentAccessModifier)
            self.currentAccessModifier = AccessModifier(rawValue: self.token.keyword.rawValue)!
            try self.nextToken()
            mustPop = true
            }
        try closure(self.currentAccessModifier)
        if mustPop
            {
            self.currentAccessModifier = self.accessModifierStack.pop()
            }
        }
        
    public func parseVirtualSlotBlock(typeClass:Class? = nil) throws -> VirtualSlotBlock
        {
        let block = typeClass == nil ? VirtualSlotReadBlock() : VirtualSlotWriteBlock()
        block.push()
        if let aClass = typeClass
            {
            try self.parseParentheses
                {
                let name = try self.matchIdentifier(error: CompilerError.newValueNameExpected)
                let parameter = Parameter(name: name,class: aClass)
                block.addSymbol(parameter)
                }
            }
        try self.parseBraces
            {
            repeat
                {
                block.addStatement(try Statement.parse(from: self) as! Statement)
                }
            while !self.token.isRightBrace
            }
        if typeClass == nil && !block.lastStatement.isReturnStatement
            {
            throw(CompilerError.virtualSlotReaderMustReturnValue)
            }
        block.pop()
        return(block)
        }
        
    public func parseExpression() throws -> Expression
        {
        return(Expression())
        }
        
    public func matchGluon() throws
        {
        if !self.token.isGluon
            {
            throw(CompilerError.gluonExpected)
            }
        try self.nextToken()
        }
        
    public func parseDirective() throws
        {
        try self.nextToken()
        self.currentDirective = Directive(self.token.keyword)
        try self.nextToken()
        }
        
    internal func parseGenericTypes() throws -> [GenericParameter]
        {
        var types:[GenericParameter] = []
        try self.nextToken()
        repeat
            {
            try types.append(self.parseGenericType())
            }
        while !self.token.isRightBrocket
        try self.nextToken()
        return(types)
        }
        
    public func parseClassReferences() throws -> [Class]
        {
        var classes:[Class] = []
        try self.parseParentheses
            {
            repeat
                {
                try self.eatIfComma()
                classes.append(try self.parseClassReference())
                }
            while self.token.isComma
            }
        return(classes)
        }
        
    public func parseName() throws -> Name
        {
        if !self.token.isIdentifier
            {
            throw(CompilerError.classReferenceExpected)
            }
        var names:[String] = []
        repeat
            {
            try self.eatIfStop()
            if !self.token.isIdentifier
                {
                throw(CompilerError.identifierExpected)
                }
            names.append(self.token.identifier)
            try self.nextToken()
            }
        while self.token.isStop
        return(Name(names))
        }
        
    public func parseClassReference() throws -> Class
        {
        let name = try self.parseName()
        if let aClass = self.scopeCurrent.lookup(name: name) as? Class
            {
            return(aClass)
            }
        let newClass = Class(name: name.last)
        (self.scopeCurrent.lookup(name: name.withoutLast()) as? Scope)?.addSymbol(newClass)
        newClass.wasDeclaredForward = true
        return(newClass)
        }
        
    public func eatIfComma() throws
        {
        if self.token.isComma
            {
            try self.nextToken()
            }
        }
        
        
    public func eatIfStop() throws
        {
        if self.token.isStop
            {
            try self.nextToken()
            }
        }
        
    private func parseGenericType() throws -> GenericParameter
        {
        if !self.token.isIdentifier
            {
            throw(CompilerError.genericTypeNameExpected)
            }
        let name = self.token.identifier
        try self.nextToken()
        if !self.token.isGluon
            {
            throw(CompilerError.gluonExpected)
            }
        try self.nextToken()
        var constraints:[Class] = []
        try self.parseParentheses
            {
            repeat
                {
                try self.eatIfComma()
                constraints.append(try self.parseClassReference())
                }
            while self.token.isComma
            }
        return(GenericParameter(name: name,constraints: constraints))
        }
        
    public func parseLiteralExpression() throws -> LiteralExpression
        {
        return(LiteralExpression(integer:0))
        }
        
    @inline(__always)
    private func parseMacroExpression(macro:Macro) throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private func parseEnumerationExpression(enumeration:Enumeration) throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private func parseMethodExpression(method:Method) throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private func parseInvocationExpression(name:String) throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private func parseInvocationExpression(variable:Variable) throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private func parseSubscriptedExpression(variable:Variable) throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private func parseSlotValueExpression(variable:Variable) throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private func parseEnumerationCaseExpression() throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private func parseClosure() throws -> Closure
        {
        fatalError("\(#function) should have been implemented")
        }
        
    @inline(__always)
    private func parseTupleExpression() throws -> Expression
        {
        let tuple = Tuple()
        repeat
            {
            if self.token.isComma
                {
                try self.nextToken()
                }
            var tag:String = ""
            if !self.token.isTag
                {
                throw(CompilerError.tagExpectedInTupleDeclaration)
                }
            else
                {
                tag = self.token.tag
                try self.nextToken()
                }
            let value = try self.parseExpression()
            tuple.append(tag: tag, value: value)
            }
        while self.token.isComma
        if self.token.isRightPar
            {
            try self.nextToken()
            }
        return(LiteralExpression(tuple: tuple))
        }
    
    @inline(__always)
    public func parseArguments() throws -> [Argument]
        {
        fatalError("\(#function) should have been implemented")
        return([])
        }
        
    @inline(__always)
    private func parseCollectionLiteralExpression() throws -> Expression
        {
        var collection:[ValueBox] = []
        try self.nextToken()
        var wereAssociations = false
        repeat
            {
            if !self.token.isRightBracket
                {
                var isAssociation = false
                var value = try self.parseExpression()
                var key:Expression = Expression()
                if self.token.isColon
                    {
                    try self.nextToken()
                    key = value
                    value = try self.parseExpression()
                    isAssociation = true
                    }
                try self.eatIfComma()
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
        while !self.token.isRightBracket
        try self.nextToken()
        if wereAssociations
            {
            return(LiteralExpression(dictionary: collection))
            }
        return(LiteralExpression(array:collection))
        }
        
    @inline(__always)
    private func parseDateExpression() throws -> Expression
        {
        fatalError("\(#function) should have been implemented")
        }
        
    public func parseParameter() throws -> Parameter
        {

        }
        
    @inline(__always)
    private func parseIdentifierExpression() throws -> Expression
        {
        let name = self.token.identifier
        let location = self.token.location
        try self.nextToken()
        if let symbol = self.scopeCurrent.lookup(shortName: name)
            {
            symbol.addRead(location:location)
            switch(symbol)
                {
                //
                // A macro has been invoked, so insert the
                // macro text and variables and then return
                //
                case is Macro:
                    return(try self.parseMacroExpression(macro: symbol as! Macro))
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
                    if !self.token.isStop
                        {
                        return(LiteralExpression(enumeration: symbol as! Enumeration))
                        }
                    return(try self.parseEnumerationExpression(enumeration: symbol as! Enumeration))
                //
                // This could be the invocation of a generic function, check to
                // see and generate an invocation if required.
                //
                case is Method:
                    let method = symbol as! Method
                    if self.token.isLeftPar
                        {
                        return(try self.parseMethodExpression(method:method))
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
                    if self.token.isStop
                        {
                        return(try parseSlotValueExpression(variable: variable))
                        }
                    else if self.token.isLeftPar
                        {
                        return(try parseInvocationExpression(variable: variable))
                        }
                    else if self.token.isLeftBracket
                        {
                        return(try parseSubscriptedExpression(variable: variable))
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
                    if self.token.isLeftPar
                        {
                        return(try self.parseInvocationExpression(name: name))
                        }
                    throw(CompilerError.undefinedValue(name))
                }
            }
        else if self.token.isNil
            {
            try self.nextToken()
            return(NilExpression())
            }
        else if self.token.isLeftPar
            {
            return(try self.parseInvocationExpression(name: name))
            }
        else
            {
            let symbol = Variable(name: name, class: Package.rootPackage.undefinedObjectClass)
            symbol.addDeclaration(location: location)
            self.scopeCurrent.addSymbol(symbol)
            symbol.wasDeclaredForward = true
            return(SymbolValueExpression(symbol: symbol))
            }
//        return(UndefinedValueExpression(location: self.token.location,symbol: nil))
        }
            
    @inline(__always)
    private func parsePrimary() throws -> Expression
        {
        print("\n\(self.token.location.line) -- \(#function)\n")
        if self.token.isIdentifier
            {
            return(try self.parseIdentifierExpression())
            }
        if self.token.isStop
            {
            return(try self.parseEnumerationCaseExpression())
            }
        if self.token.isLeftBracket
            {
            return(try self.parseCollectionLiteralExpression())
            }
        if self.token.isAt
            {
            return(try parseDateExpression())
            }
        if self.token.isLeftBrace
            {
            let closure = try self.parseClosure()
            if self.token.isLeftPar
                {
                let arguments = try self.parseArguments()
                return(ClosureValueExpression(closure: closure, arguments: arguments))
                }
            return(LiteralExpression(closure: closure))
            }
        if self.token.isInteger
            {
            let number = LiteralExpression(integer: self.token.integerValue)
            try self.nextToken()
            return(number)
            }
        if self.token.isFloatingPoint
            {
            let number = LiteralExpression(float64: self.token.floatingPointValue)
            try self.nextToken()
            return(number)
            }
        if token.isString
            {
            let string = self.token.string
            try self.nextToken()
            return(LiteralExpression(string:string))
            }
        if self.token.isThis
            {
            try self.nextToken()
            return(ThisExpression())
            }
        if self.token.isKeyword
            {
            let identifier = self.token.keywordString
            try self.nextToken()
            if let symbol = self.scopeCurrent.lookup(shortName: identifier) as? Class
                {
                return(LiteralExpression(class: symbol))
                }
            }
        else if self.token.isLeftPar
            {
            try self.nextToken()
            if self.token.isTag
                {
                return(try self.parseTupleExpression())
                }
            let value = try self.parseExpression()
            if !self.token.isRightPar
                {
                throw(CompilerError.rightParExpected)
                }
            try self.nextToken()
            return(value)
            }
        throw(CompilerError.expressionExpected)
        }
    }
