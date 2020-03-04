//
//  PseudoVariable.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 02/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class PseudoVariable:Constant
    {
    public static let nilVariable = PseudoVariable(name:"nil",class: Package.rootPackage.undefinedObjectClass)
    public static let thisVariable = PseudoVariable(name:"this",class: Package.rootPackage.classClass)
    }
