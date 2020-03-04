//
//  ConstantExpression.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 03/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class ConstantValueExpression:Expression
    {
    private var constant:Constant
    
    public override var `class`:Class
        {
        return(self.constant.class)
        }
        
    public init(constant:Constant)
        {
        self.constant = constant
        super.init()
        }
    }
