//
//  ArrayClass.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 05/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public enum ArrayIndexType:Equatable
    {
    case none
    case size(Int)
    case range(Int,Int)
    case enumeration(Enumeration)
    
    public var typeName:String
        {
        switch(self)
            {
            case .none:
                return("Error")
            case .size(let size):
                return("IntegerIndex(\(size))")
            case .range(let lower,let upper):
                return("RangeIndex(\(lower),\(upper))")
            case .enumeration(let enumeration):
                return("EnumerationIndex(\(enumeration.shortName))")
            }
        }
    }
    
public class ArrayClass:GenericClass
    {
    private let indexType:ArrayIndexType
    private let elementClass:Class
    
    public static func ==(lhs:ArrayClass,rhs:Class) -> Bool
        {
        if !(rhs is ArrayClass)
            {
            return(false)
            }
        let rhsArray = rhs as! ArrayClass
        return(lhs.indexType == rhsArray.indexType && lhs.elementClass == rhsArray.elementClass)
        }
    
    public class func typeName(forIndexType indexType:ArrayIndexType,forElementClass elementType:Class) -> String
        {
        return("Array<\(indexType.typeName) x \(elementType.typeName)>")
        }
        
    public class func parseArrayClassReference(from parser:Parser) throws -> ArrayClass
        {
        try parser.nextToken()
        var indexType:ArrayIndexType = .none
        var aClass:Class = Package.rootPackage.objectClass
        try parser.parseBrockets
            {
            indexType = try self.parseArrayIndexType(from: parser)
            if !parser.token.isComma
                {
                throw(CompilerError.commaExpected)
                }
            try parser.nextToken()
            aClass = try Class.parseClassReference(from: parser)
            }
        let typeName = self.typeName(forIndexType: indexType, forElementClass: aClass)
        if let type = parser.scopeCurrent.lookup(shortName: typeName) as? ArrayClass
            {
            return(type)
            }
        let type = ArrayClass(indexType: indexType, elementClass: aClass)
        return(type)
        }
        
    public class func parseArrayIndexType(from parser:Parser) throws -> ArrayIndexType
        {
        if parser.token.isIdentifier
            {
            let name = try parser.parseName()
            if let enumeration = parser.scopeCurrent.lookup(name: name) as? Enumeration
                {
                return(.enumeration(enumeration))
                }
            throw(CompilerError.enumerationExpected)
            }
        else if parser.token.isIntegerNumber
            {
            let lower = Int(parser.token.integerValue)
            try parser.nextToken()
            if parser.token.isRange
                {
                let upper = Int(parser.token.integerValue)
                try parser.nextToken()
                return(.range(lower,upper))
                }
            return(.size(lower))
            }
        throw(CompilerError.invalidArrayIndexType)
        }

    public init(indexType:ArrayIndexType,elementClass:Class)
        {
        self.indexType = indexType
        self.elementClass = elementClass
        super.init(shortName: Self.typeName(forIndexType: indexType,forElementClass: elementClass))
        }
    }
