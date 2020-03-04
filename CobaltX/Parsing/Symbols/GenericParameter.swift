//
//  GenericType.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class GenericParameter:Symbol
    {
    public let constraints:[Class]

    public init(name:String,constraints:[Class] = [])
        {
        self.constraints = constraints
        super.init(shortName: name)
        }
        
    public func instanciate(with value:Class) -> GenericParameterInstance
        {
        return(GenericParameterInstance(genericParameter: self,value:value))
        }
    }

public class GenericParameterInstance:Symbol
    {
    public let value:Class
    public let genericParameter:GenericParameter
    
    public init(genericParameter:GenericParameter,value:Class)
        {
        self.value = value
        self.genericParameter = genericParameter
        super.init(shortName: genericParameter.shortName)
        }
    }
