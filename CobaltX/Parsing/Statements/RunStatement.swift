//
//  RunStatement.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class RunStatement:Statement
    {
    public let argument:Argument
    
    public class func parseRunStatement(from parser:Parser) throws -> RunStatement
        {
        fatalError("\(#function) has not been implemented yet")
        }
        
    public init(argument:Argument)
        {
        self.argument = argument
        super.init()
        }
    }
