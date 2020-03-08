//
//  Scope.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation



public protocol Scope:class
    {
    func addSymbols(_ symbols:[Symbol])
    func addSymbol(_ symbol:Symbol)
    func lookup(name:Name) -> Symbol?
    func lookup(shortName:String) -> Symbol?
    var parentScope:Scope? { get set }
    var index:Int { get }
    func push()
    func pop()
    func localScope() -> Scope
    }
    
extension Scope
    {
    public func addSymbols(_ symbols:[Symbol])
        {
        for symbol in symbols
            {
            self.addSymbol(symbol)
            }
        }
        
    public func lookup(name:Name) -> Symbol?
        {
        if name.count == 0
            {
            return(self as? Symbol)
            }
        if name.count == 1
            {
            return(self.lookup(shortName: name.first))
            }
        return((self.lookup(shortName: name.first) as? Scope)?.lookup(name: name.withoutFirst()))
        }
        
    public func push()
        {
        Parser.shared.pushScope(self)
        }
        
    public func pop()
        {
        Parser.shared.popScope()
        }
        
    public func localScope() -> Scope
        {
        let scope = LocalScope()
        return(scope)
        }
    }
