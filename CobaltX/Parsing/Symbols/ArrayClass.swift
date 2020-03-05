//
//  ArrayClass.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 05/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public enum ArrayIndexType
    {
    case size(Int)
    case range(Int,Int)
    case enumeratedRange(EnumerationCase,EnumerationCase)
    case enumeration(Enumeration)
    }
    
public class ArrayClass:GenericClass
    {
    private let indexType:ArrayIndexType
    private let elementClass:Class
    
    public class func parseArrayClassReference(from parser:Parser) throws -> ArrayClass
        {
        fatalError("\(#function) has not been implemented")
        }
        
    public init(indexType:ArrayIndexType,elementClass:Class)
        {
        self.indexType = indexType
        self.elementClass = elementClass
        super.init(shortName:"Array\(Cobalt.nextIndex())")
        }
    }
