//
//  Method.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Method:Symbol
    {
    private var instances:[MethodInstance] = []
    
    public class func parseMethod(from:Parser) throws -> Method
        {
        let method = Method(shortName: "")
        return(method)
        }
        
    public override var isPackageLevelSymbol:Bool
        {
        return(true)
        }
        
    public func addInstance(_ instance:MethodInstance)
        {
        self.instances.append(instance)
        }
    }
