//
//  DictionaryClass.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 06/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class DictionaryClass:GenericClass
    {
    private let elementClass:Class
    private let keyClass:Class
    
    public class func parseDictionaryClassReference(from parser:Parser) throws -> DictionaryClass
        {
        fatalError("\(#function) has not been implemented")
        }
        
    public init(keyClass:Class,elementClass:Class)
        {
        self.elementClass = elementClass
        self.keyClass = keyClass
        super.init(shortName:"Dictionary\(Cobalt.nextIndex())")
        }
    }

