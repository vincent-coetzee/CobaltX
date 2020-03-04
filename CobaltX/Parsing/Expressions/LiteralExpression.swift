//
//  LiteralExpression.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 01/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class LiteralExpression:ValueExpression
    {
    public let literalValue:ValueBox
    
    public override var `class`:Class
        {
        return(literalValue.typeClass)
        }
        
    public init(string:String)
        {
        self.literalValue = .string(string)
        super.init()
        }
        
    public init(symbol:String)
        {
        self.literalValue = .symbol(symbol)
        super.init()
        }
        
    public init(integer:Cobalt.Integer)
        {
        self.literalValue = .integer(integer)
        super.init()
        }
        
    public init(uinteger:Cobalt.UInteger)
        {
        self.literalValue = .uinteger(uinteger)
        super.init()
        }
        
    public init(boolean:Cobalt.Boolean)
        {
        self.literalValue = .boolean(boolean)
        super.init()
        }
        
    public init(float32:Cobalt.Float32)
        {
        self.literalValue = .float32(float32)
        super.init()
        }
    
    public init(float64:Cobalt.Float64)
        {
        self.literalValue = .float64(float64)
        super.init()
        }
    
    public init(byte:Cobalt.Byte)
        {
        self.literalValue = .byte(byte)
        super.init()
        }
    
    public init(character:Cobalt.Character)
        {
        self.literalValue = .character(character)
        super.init()
        }
    
    public init(class:Class)
        {
        self.literalValue = .class(`class`)
        super.init()
        }
    
    public init(method:Method)
        {
        self.literalValue = .method(method)
        super.init()
        }
    
    public init(closure:Closure)
        {
        self.literalValue = .closure(closure)
        super.init()
        }
    
    public init(enumeration:Enumeration)
        {
        self.literalValue = .enumeration(enumeration)
        super.init()
        }
        
    public init(enumerationCase:EnumerationCase)
        {
        self.literalValue = .enumerationCase(enumerationCase)
        super.init()
        }
    
    public init(genericParameter:GenericParameter)
        {
        self.literalValue = .genericParameter(genericParameter)
        super.init()
        }
        
    public init(dictionary:[ValueBox])
        {
        self.literalValue = .dictionary(dictionary)
        super.init()
        }
        
    public init(array:[ValueBox])
        {
        self.literalValue = .array(array)
        super.init()
        }
        
    public init(tuple:Tuple)
        {
        self.literalValue = .tuple(tuple)
        super.init()
        }
        
    public init(literalValue:ValueBox)
        {
        self.literalValue = literalValue
        super.init()
        }
    }
