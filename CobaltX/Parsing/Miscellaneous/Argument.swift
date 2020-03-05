//
//  Argument.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public struct Argument
    {
    public let value:Expression
    public let tag:String?
    public var parameter:Parameter?
    
    public var `class`:Class
        {
        return(value.class)
        }
        
    public init(tag:String? = nil,value:Expression,parameter:Parameter? = nil)
        {
        self.tag = tag
        self.value = value
        self.parameter = parameter
        }
    }
