//
//  SignalStatement.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class SignalStatement:Statement
    {
    public let signal:Cobalt.UniqueString
    
    public class func parseSignalStatement(from parser:Parser) throws -> SignalStatement
        {
        fatalError("\(#function) has not been implemented yet")
        }
        
    public init(signal:Cobalt.UniqueString)
        {
        self.signal = signal
        super.init()
        }
    }
