//
//  SymbolValueExpression.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 03/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class SymbolValueExpression:ValueExpression
    {
    private let symbol:Symbol
    
    public init(symbol:Symbol)
        {
        self.symbol = symbol
        super.init()
        }
    }
