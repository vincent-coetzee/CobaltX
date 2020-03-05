//
//  ListClass.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 06/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class ListClass:GenericClass
    {
    private let elementClass:Class
    
    public class func parseListClassReference(from parser:Parser) throws -> ListClass
        {
        fatalError("\(#function) has not been implemented")
        }
        
    public init(elementClass:Class)
        {
        self.elementClass = elementClass
        super.init(shortName:"List\(Cobalt.nextIndex())")
        }
    }

