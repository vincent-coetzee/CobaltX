//
//  WhileStatement.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class WhileStatement:BlockStatement
    {
    public let condition:Expression
    
    public class func parseWhileStatement(from parser:Parser) throws -> WhileStatement
        {
        fatalError("\(#function) has not been implemented yet")
        }
        
    public init(condition:Expression)
        {
        self.condition = condition
        super.init()
        }
    }
