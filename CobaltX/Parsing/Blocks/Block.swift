//
//  Block.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Block:ParseNode,Scope
    {
    public var parentScope:Scope?
    public var index = Cobalt.nextIndex()
    private var statements:[Statement] = []
    private var symbols:[String:Symbol] = [:]
    
    public var lastStatement:Statement
        {
        return(self.statements.last!)
        }
        
    public func addSymbol(_ symbol:Symbol)
        {
        if symbol is Class
            {
            self.parentScope?.addSymbol(symbol)
            return
            }
        self.symbols[symbol.shortName] = symbol
        }
        
    public func addStatement(_ statement:Statement)
        {
        self.statements.append(statement)
        }
        
    public func lookup(shortName:String) -> Symbol?
        {
        return(self.symbols[shortName])
        }
    }
