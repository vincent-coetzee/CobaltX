//
//  BinaryExpression.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class BinaryExpression:ValueExpression
    {
    public let lhs:Expression
    public let rhs:Expression
    public let operation:Token.Symbol
    
    public init(lhs:Expression,operation:Token.Symbol,rhs:Expression)
        {
        self.lhs = lhs
        self.operation = operation
        self.rhs = rhs
        super.init()
        }
    }
