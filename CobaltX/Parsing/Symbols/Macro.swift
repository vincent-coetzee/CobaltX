//
//  Macro.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 28/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Macro:Symbol
    {
    public class func parseMacro(from parser:Parser) throws -> Macro
        {
        fatalError("Not implemented")
        }
        
    public override var isPackageLevelSymbol:Bool
        {
        return(true)
        }
    }
