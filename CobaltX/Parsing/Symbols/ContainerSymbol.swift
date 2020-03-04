//
//  ContainerSymbol.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class ContainerSymbol:Symbol,Scope
    {
    public override var isScope:Bool
        {
        return(true)
        }
        
    private var symbols:[String:Symbol] = [:]
    public var parentScope:Scope?
    
    public func addSymbol(_ symbol:Symbol)
        {
        if symbol.isPackageLevelSymbol && !(self is Package)
            {
            self.parentScope?.addSymbol(symbol)
            return
            }
        self.symbols[symbol.shortName] = symbol
        }
        
    public override func lookup(shortName:String) -> Symbol?
        {
        if let symbol = self.symbols[shortName]
            {
            return(symbol)
            }
        return(self.parent?.lookup(shortName: shortName))
        }
    }
