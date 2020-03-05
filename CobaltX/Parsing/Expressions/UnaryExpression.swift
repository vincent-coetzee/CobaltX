//
//  UnaryExpression.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class UnaryExpression:ValueExpression
    {
    public let rhs:Expression
    public let operation:Token.Symbol
    
    public init(operation:Token.Symbol,rhs:Expression)
        {
        self.operation = operation
        self.rhs = rhs
        super.init()
        }
    }
