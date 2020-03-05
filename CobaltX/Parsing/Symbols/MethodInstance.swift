//
//  MethodInstance.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class MethodInstance:Symbol
    {
    private let block = Block()
    public var parameters:[Parameter] = []
    
    public class func parseMethodInstanceDeclaration(from:Parser) throws -> MethodInstance
        {
        let instance = MethodInstance(shortName: "")
        instance.push()
        instance.pop()
        return(instance)
        }
        
    public override var isPackageLevelSymbol:Bool
        {
        return(true)
        }
        
    public func push()
        {
        self.block.push()
        }
        
    public func pop()
        {
        self.block.pop()
        }
    }
