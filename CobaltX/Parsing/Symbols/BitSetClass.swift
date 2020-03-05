//
//  BitSetClass.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 06/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class BitSetClass:GenericClass
    {
    private let elementClass:Class
    
    public class func parseBitSetClassReference(from parser:Parser) throws -> BitSetClass
        {
        fatalError("\(#function) has not been implemented")
        }
        
    public init(elementClass:Class)
        {
        self.elementClass = elementClass
        super.init(shortName:"BitSet\(Cobalt.nextIndex())")
        }
    }

