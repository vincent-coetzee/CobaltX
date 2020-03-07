//
//  Symbol.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Symbol:ParseNode,Equatable
    {
    public let shortName:String
    public let index = Cobalt.nextIndex()
    public var wasDeclaredForward = false
    private var references:[SourceReference] = []
    public var accessLevel = AccessModifier.public
    public var parent:Symbol?
    
    public var isScope:Bool
        {
        return(false)
        }
        
    public var isMethod:Bool
        {
        return(false)
        }
        
    public var isVariable:Bool
        {
        return(false)
        }
        
    public var isClosure:Bool
        {
        return(false)
        }
        
    public var typeName:String
        {
        return(self.shortName)
        }
        
    public var `class`:Class
        {
        fatalError("This should have been overridden in a subclass")
        }
        
    public var name:Name
        {
        let aName = self.parent?.name
        return(aName == nil ? Name(self.shortName) : aName! + ("::" + self.shortName))
        }
    
    public static func ==(lhs:Symbol,rhs:Symbol) -> Bool
        {
        return(lhs.index == rhs.index)
        }
        
    public var isPackageLevelSymbol:Bool
        {
        return(false)
        }
        
    public init(shortName:String = "",parent:Symbol? = nil)
        {
        self.shortName = shortName
        self.parent = parent
        }
        
    public func addRead(location:SourceLocation)
        {
        self.references.append(.read(location))
        }
        
    public func addWrite(location:SourceLocation)
        {
        self.references.append(.write(location))
        }
    
    public func addDeclaration(location:SourceLocation)
        {
        self.references.append(.declaration(location))
        }
        
    public func lookup(shortName:String) -> Symbol?
        {
        fatalError("\(#function) should have been overridden in a subclass of Symbol")
        }
    }
