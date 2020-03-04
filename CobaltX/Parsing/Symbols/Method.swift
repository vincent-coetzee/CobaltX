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
    public class func parseMethodDeclaration(from:Parser) throws -> Method
        {
        fatalError("Not implemented")
        }
        
    public override var isPackageLevelSymbol:Bool
        {
        return(true)
        }
    }
