//
//  ValueBox.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/25.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public protocol NativeType
    {
    }
    
public indirect enum ValueBox
    {
    case integer(Cobalt.Integer)
    case uinteger(Cobalt.UInteger)
    case float32(Cobalt.Float32)
    case float64(Cobalt.Float64)
    case string(String)
    case symbol(String)
    case boolean(Cobalt.Boolean)
    case byte(Cobalt.Byte)
    case character(Cobalt.Character)
    case array([ValueBox])
    case `class`(Class)
    case method(Method)
    case closure(Closure)
    case enumeration(Enumeration)
    case enumerationCase(EnumerationCase)
    case genericParameter(GenericParameter)
    case association(Expression,Expression)
    case dictionary([ValueBox])
    case expression(Expression)
    case tuple(Tuple)
    
    public var typeClass:Class
        {
        switch(self)
            {
        case .integer(_):
            return(Package.rootPackage.integerClass)
        case .uinteger(_):
            return(Package.rootPackage.uintegerClass)
        case .float32(_):
            return(Package.rootPackage.float32Class)
        case .float64(_):
            return(Package.rootPackage.float64Class)
        case .string(_):
            return(Package.rootPackage.stringClass)
        case .symbol(_):
            return(Package.rootPackage.symbolClass)
        case .boolean(_):
            return(Package.rootPackage.booleanClass)
        case .byte(_):
            return(Package.rootPackage.byteClass)
        case .character(_):
            return(Package.rootPackage.characterClass)
        case .array(_):
            return(Package.rootPackage.integerClass)
        case .class(_):
            return(Package.rootPackage.integerClass)
        case .method(_):
            return(Package.rootPackage.integerClass)
        case .closure(_):
            return(Package.rootPackage.integerClass)
        case .enumeration(_):
            return(Package.rootPackage.integerClass)
        case .enumerationCase(_):
            return(Package.rootPackage.integerClass)
        case .genericParameter(let parameter):
            return(parameter.class)
        case .association(_,_):
            return(Package.rootPackage.integerClass)
        case .dictionary(_):
            return(Package.rootPackage.integerClass)
        case .expression(let value):
            return(value.class)
        case .tuple(_):
            return(Package.rootPackage.tupleClass)
            }
        }
    }
