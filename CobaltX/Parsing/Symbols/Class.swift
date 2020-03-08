//
//  Class.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Class:ContainerSymbol
    {
    public var superclasses:[Class] = []
    private var slots:[Slot] = []
    private var classSlots:[Slot] = []
    private var genericParameters:[GenericParameter] = []
    private var _class:Class?
    
    public static func ==(lhs:Class,rhs:Class) -> Bool
        {
        if lhs.name == rhs.name
            {
            return(true)
            }
        return(false)
        }
        
    public class func parseClass(from parser:Parser) throws -> Class
        {
        let accessModifier = parser.currentAccessModifier
        try parser.nextToken()
        let name = try parser.matchIdentifier(error: CompilerError.classNameExpected)
        var generics:[GenericParameter] = []
        if parser.token.isLeftBrocket
            {
            generics = try GenericParameter.parseGenericParameters(from: parser)
            }
        var superclasses:[Class] = []
        if parser.token.isGluon
            {
            try parser.nextToken()
            if parser.token.isLeftPar
                {
                try parser.parseParentheses
                    {
                    repeat
                        {
                        try parser.eatIfComma()
                        superclasses = try parser.parseClassReferences()
                        }
                    while parser.token.isComma
                    }
                }
            }
        let scope = parser.scopeCurrent.localScope()
        scope.push()
        scope.addSymbols(generics)
        let slots = try self.parseSlots(from: parser)
        var theClass:Class
        if let aClass = parser.scopeCurrent.lookup(shortName: name) as? Class
            {
            theClass = aClass
            if aClass.wasDeclaredForward
                {
                aClass.superclasses = superclasses
                }
            else
                {
                throw(CompilerError.duplicateClassDefinition(name))
                }
            }
        else
            {
            theClass = Class(name: name,superclasses: superclasses)
            parser.scopeCurrent.addSymbol(theClass)
            }
        theClass.accessLevel = accessModifier
        theClass.slots = slots.filter{!$0.isClassSlot}
        theClass.classSlots = slots.filter{$0.isClassSlot}
        theClass.genericParameters = generics
        scope.pop()
        return(theClass)
        }
        
    public class func parseClassReference(from parser: Parser) throws -> Class
        {
        if parser.token.isArray
            {
            return(try ArrayClass.parseArrayClassReference(from: parser))
            }
        else if parser.token.isSet
            {
            return(try SetClass.parseSetClassReference(from: parser))
            }
        else if parser.token.isList
            {
            return(try ListClass.parseListClassReference(from: parser))
            }
        else if parser.token.isBitSet
            {
            return(try BitSetClass.parseBitSetClassReference(from: parser))
            }
        else if parser.token.isDictionary
            {
            return(try DictionaryClass.parseDictionaryClassReference(from: parser))
            }
        else if parser.token.isIdentifier || parser.token.isNativeType
            {
            let name = try parser.parseName()
            var theClass:Class?
            if let aClass = parser.scopeCurrent.lookup(name: name) as? Class
                {
                theClass = aClass
                }
            var generics:[GenericParameter]?
            if parser.token.isLeftBrocket
                {
                generics = try GenericParameter.parseGenericParameters(from: parser)
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
                let newClass = Class(shortName: name.last)
                (parser.scopeCurrent.lookup(name: name.withoutLast()) as? Scope)?.addSymbol(newClass)
                newClass.wasDeclaredForward = true
                return(newClass)
                }
            }
        else
            {
            throw(CompilerError.classNameExpected)
            }
        }
        
    private class func parseSlots(from parser:Parser) throws -> [Slot]
        {
        var slots:[Slot] = []
        try parser.parseBraces
            {
            while !parser.token.isRightBrace
                {
                slots.append(try self.parseSlot(from: parser))
                }
            }
        return(slots)
        }
        
    private class func parseSlot(from parser:Parser) throws -> Slot
        {
        if parser.token.isAt
            {
            try parser.parseDirective()
            }
        var slot:Slot?
        try parser.parseAccessModifier()
            {
            accessModifier in
            if parser.token.isVirtual
                {
                slot = try self.parseVirtualSlot(from: parser)
                }
            else if parser.token.isConstant
                {
                slot = try self.parseConstantSlot(from: parser)
                }
            else
                {
                slot = try self.parseRegularSlot(from: parser)
                }
            slot?.accessLevel = accessModifier
            }
        return(slot!)
        }
        
    public class func parseRegularSlot(from parser:Parser) throws -> Slot
        {
        var isClass = false
        if parser.token.isClass
            {
            isClass = true
            try parser.nextToken()
            }
        if !parser.token.isSlot
            {
            throw(CompilerError.slotExpected)
            }
        try parser.nextToken()
        let name = try parser.matchIdentifier(error: CompilerError.slotNameExpected)
        var typeClass:Class?
        var value:Expression?
        if parser.token.isGluon
            {
            try parser.matchGluon()
            typeClass = try parser.parseClassReference()
            }
        parser.rulingClass = typeClass
        if parser.token.isAssign
            {
            try parser.nextToken()
            value = try  Expression.parseExpression(from:parser)
            }
        parser.rulingClass = nil
        if typeClass == nil && value == nil
            {
            throw(CompilerError.slotRequiresInitialValueOrTypeClass)
            }
        else if typeClass == nil
            {
            typeClass = value!.class
            }
        let slot = Slot(name: name,class:typeClass!,isClassSlot: isClass,value: value)
        slot.isClassSlot = isClass
        return(slot)
        }
        
    public class func parseConstantSlot(from parser:Parser) throws -> Slot
        {
        var isClass = false
        try parser.nextToken()
        if parser.token.isClass
            {
            isClass = true
            try parser.nextToken()
            }
        if !parser.token.isSlot
            {
            throw(CompilerError.slotExpected)
            }
        try parser.nextToken()
        let name = try parser.matchIdentifier(error: CompilerError.slotNameExpected)
        var typeClass = Package.rootPackage.objectClass
        if parser.token.isGluon
            {
            try parser.matchGluon()
            typeClass = try parser.parseClassReference()
            }
        parser.rulingClass = typeClass
        if !parser.token.isAssign
            {
            throw(CompilerError.assignExpected)
            }
        try parser.nextToken()
        let slot = ConstantSlot(name: name,class:typeClass,isClassSlot:isClass,value: try Expression.parseExpression(from: parser))
        parser.rulingClass = nil
        slot.isClassSlot = isClass
        return(slot)
        }
        
    private class func parseVirtualSlot(from parser:Parser) throws -> Slot
        {
        var isClass = false
        try parser.nextToken()
        if parser.token.isClass
            {
            isClass = true
            try parser.nextToken()
            }
        if !parser.token.isSlot
            {
            throw(CompilerError.slotExpected)
            }
        try parser.nextToken()
        let name = try parser.matchIdentifier(error: CompilerError.slotNameExpected)
        if !parser.token.isGluon
            {
            throw(CompilerError.gluonExpected)
            }
        try parser.nextToken()
        let typeClass = try parser.parseClassReference()
        var readBlock:VirtualSlotBlock?
        var writeBlock:VirtualSlotBlock?
        try parser.parseBraces
            {
            if parser.token.isRead
                {
                readBlock = try VirtualSlotReadBlock.parseVirtualSlotBlock(from: parser)
                }
            else if parser.token.isWrite
                {
                writeBlock = try VirtualSlotWriteBlock.parseVirtualSlotBlock(typeClass:typeClass,from: parser)
                }
            else
                {
                readBlock = try VirtualSlotReadBlock.parseVirtualSlotBlock(from: parser)
                }
            if writeBlock == nil && parser.token.isWrite
                {
                writeBlock = try VirtualSlotWriteBlock.parseVirtualSlotBlock(typeClass:typeClass,from:parser)
                }
            else if readBlock == nil && parser.token.isRead
                {
                readBlock = try VirtualSlotReadBlock.parseVirtualSlotBlock(from: parser)
                }
            }
        if readBlock == nil
            {
            throw(CompilerError.virtualSlotMustDefineReadBlock(name))
            }
        let slot = VirtualSlot(name: name,class: typeClass)
        slot.readBlock = readBlock!
        slot.writeBlock = writeBlock
        slot.isClassSlot = isClass
        return(slot)
        }
        
    public init(name:String = "",superclasses:[Class] = [])
        {
        self.superclasses = superclasses
        super.init(shortName: name)
        }
        
    public func isSubclass(of theClass:Class) -> Bool
        {
        if self == theClass
            {
            return(true)
            }
        for superclass in self.superclasses
            {
            if superclass.isSubclass(of: theClass)
                {
                return(true)
                }
            }
        return(false)
        }
        
    public override var isPackageLevelSymbol:Bool
        {
        return(true)
        }
        
    public override var `class`:Class
        {
        get
            {
            return(self._class!)
            }
        set
            {
            self._class = newValue
            }
        }
        
    public init(shortName:String,superclasses:[Class] = [])
        {
        self.superclasses = superclasses
        super.init(shortName: shortName)
        }
        
    @discardableResult
    public func addSlot(name:String,class:Class) -> Self
        {
        self.slots.append(Slot(name:name,class:`class`,owner:self))
        return(self)
        }
        
    public func instantiate(with:[GenericParameter]) -> GenericClass
        {
        fatalError("\(#function) has not been implemented")
        }
    }
