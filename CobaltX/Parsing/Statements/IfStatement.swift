//
//  IfStatement.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class IfStatement:Statement
    {
    public let ifBlock:Block
    public var elseBlock:Block?
    
    public class func parseIfStatement(from parser:Parser) throws -> IfStatement
        {
        fatalError("\(#function) has not been implemented yet")
        }
    
    public override init()
        {
        self.ifBlock = Block()
        super.init()
        }
    }
