//
//  LocalScope.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 28/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class LocalScope:Scope
    {
    public var parentScope:Scope?
    public var index:Int = Cobalt.nextIndex()
    private var symbols:[String:Symbol] = [:]
    
    public func addSymbol(_ symbol: Symbol)
        {
        self.symbols[symbol.shortName] = symbol
        }
        
    public func lookup(shortName:String) -> Symbol?
        {
        if let symbol = self.symbols[shortName]
            {
            return(symbol)
            }
        return(self.parentScope?.lookup(shortName: shortName))
        }
    }
