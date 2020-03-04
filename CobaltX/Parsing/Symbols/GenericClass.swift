//
//  GenericClass.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 01/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class GenericClass:Class
    {
    public var genericParameters:[GenericParameter] = []
    
    public init(name:String,superclasses:[Class] = [],genericParameters:[GenericParameter])
        {
        self.genericParameters = genericParameters
        super.init(name: name,superclasses: superclasses)
        }
        
    public func insanciate(with parameters:[GenericParameterInstance])
        {
        
        }
    }
