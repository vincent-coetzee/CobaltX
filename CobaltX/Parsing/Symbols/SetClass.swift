//
//  SetClass.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 06/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class SetClass:GenericClass
    {
    private let elementClass:Class
    
    public class func parseSetClassReference(from parser:Parser) throws -> SetClass
        {
        fatalError("\(#function) has not been implemented")
        }
        
    public init(elementClass:Class)
        {
        self.elementClass = elementClass
        super.init(shortName:"Set\(Cobalt.nextIndex())")
        }
    }
