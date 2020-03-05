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
    
    public init(shortName:String,superclasses:[Class] = [],genericParameters:[GenericParameter] = [])
        {
        self.genericParameters = genericParameters
        super.init(shortName: shortName,superclasses: superclasses)
        }
    }
