//
//  InvocationExpression.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class InvocationExpression:ValueExpression
    {
    private var method:Method?
    private var methodVariable:Variable?
    private var closureVariable:Variable?
    private let arguments:[Argument]
    
    public init(method:Method,arguments:[Argument])
        {
        self.method = method
        self.arguments = arguments
        super.init()
        }
        
    public init(methodVariable:Variable,arguments:[Argument])
        {
        self.methodVariable = methodVariable
        self.arguments = arguments
        super.init()
        }
        
    public init(closureVariable:Variable,arguments:[Argument])
        {
        self.closureVariable = closureVariable
        self.arguments = arguments
        super.init()
        }
    }
