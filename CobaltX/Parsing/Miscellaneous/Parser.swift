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
    public  var rulingClass:Class?
    
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
        return(try Package.parsePackage(from: self))
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
        
    public func parseBrockets(_ closure:() throws -> Void) throws
        {
        if !self.token.isLeftBrocket
            {
            throw(CompilerError.leftBrocketExpected)
            }
        try self.nextToken()
        try closure()
        if !self.token.isRightBrocket
            {
            throw(CompilerError.rightBrocketExpected)
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
        if !(self.token.isIdentifier || self.token.isNativeType)
            {
            throw(CompilerError.nameComponentExpected)
            }
        var names = self.token.isIdentifier ? [self.token.identifier] : [self.token.keyword.rawValue]
        try self.nextToken()
        while self.token.isGluon
            {
            try self.nextToken()
            if self.token.isIdentifier || self.token.isNativeType
                {
                names.append(self.token.isIdentifier ? self.token.identifier : self.token.keyword.rawValue)
                try self.nextToken()
                }
            }
        return(Name(names))
        }
        
    public func parseClassReference() throws -> Class
        {
        let name = try self.parseName()
        var theClass:Class?
        if let aClass = self.scopeCurrent.lookup(name: name) as? Class
            {
            theClass = aClass
            }
        var generics:[GenericParameter]?
        if self.token.isLeftBrocket
            {
            generics = try GenericParameter.parseGenericParameters(from: self)
            }
        if theClass != nil && generics != nil
            {
            return(theClass!.instantiate(with: generics!))
            }
        else if theClass != nil
            {
            return(theClass!)
            }
        else
            {
            let newClass = Class(name: name.last)
            (self.scopeCurrent.lookup(name: name.withoutLast()) as? Scope)?.addSymbol(newClass)
            newClass.wasDeclaredForward = true
            return(newClass)
            }
        }
        
    internal func tokenIsBitShiftRight() throws -> Bool
        {
        if self.token.isRightBrocket
            {
            try self.nextToken()
            if self.token.isRightBrocket
                {
                return(true)
                }
            else
                {
                self.tokenStream.pushBack(self.token)
                }
            }
        return(false)
        }
        
    public func eatIfComma() throws
        {
        if self.token.isComma
            {
            try self.nextToken()
            }
        }
        
    public func eatIfGluon() throws
        {
        if self.token.isGluon
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
        

    }
