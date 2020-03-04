//
//  Variable.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Variable:Symbol
    {
    public override var `class`:Class
        {
        get
            {
            return(self._class)
            }
        set
            {
            self._class = newValue
            }
        }
        
    private var _class:Class
    
    public class func parseVariableDeclaration(from:Parser) throws -> Variable
        {
        fatalError("Not implemented")
        }
        
    public init(name:String,class:Class)
        {
        self._class = `class`
        super.init(shortName:name)
        }
    }
