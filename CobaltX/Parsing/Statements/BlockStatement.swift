//
//  BlockStatement.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class BlockStatement:Statement
    {
    private let block = Block()
    
    public func addStatement(_ statement:Statement)
        {
        self.block.addStatement(statement)
        }
        
    public func addSymbol(_ symbol:Symbol)
        {
        self.block.addSymbol(symbol)
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
