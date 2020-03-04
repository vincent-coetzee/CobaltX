//
//  Slot.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Slot:Symbol
    {
    public let _class:Class
    public var owner:Class
    public var isClassSlot:Bool
    public let value:Expression?
    
    public override var `class`:Class
        {
        return(self._class)
        }
        
    public init(name:String,class:Class,owner:Class = Package.rootPackage.objectClass,isClassSlot:Bool = false,value:Expression? = nil)
        {
        self._class = `class`
        self.owner = owner
        self.isClassSlot = isClassSlot
        self.value = value
        super.init(shortName: name)
        }
    }
