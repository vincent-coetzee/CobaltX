//
//  Directive.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 28/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public enum Directive:String
    {
    case none
    case system = "system"
    case inline = "inline"
    case cfunction = "cfunction"
    case native = "native"
    
    public init(_ keyword:Token.Keyword)
        {
        self.init(rawValue: "\(keyword)")!
        }
    }
