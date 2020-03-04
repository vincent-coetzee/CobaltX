//
//  ClosureValueExpression.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class ClosureValueExpression:ValueExpression
    {
    public let closure:Closure
    public let arguments:[Argument]
    
    public init(closure:Closure,arguments:[Argument])
        {
        self.closure = closure
        self.arguments = arguments
        }
    }
