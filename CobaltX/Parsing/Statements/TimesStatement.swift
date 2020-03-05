//
//  TimesStatement.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class TimesStatement:BlockStatement
    {
    public let count:Expression
    
    public class func parseTimesStatement(from parser:Parser) throws -> TimesStatement
        {
        fatalError("\(#function) has not been implemented yet")
        }
        
    public init(count:Expression)
        {
        self.count = count
        super.init()
        }
    }
