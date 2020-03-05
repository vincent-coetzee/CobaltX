//
//  SelectStatement.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 04/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class SelectStatement:Statement
    {
    private let argument:Argument
    private var whenClauses:[WhenClause] = []
    private var otherwiseClause:OtherwiseClause?
    
    public class func parseSelectStatement(from parser:Parser) throws -> SelectStatement
        {
        fatalError("\(#function) has not been implemented yet")
        }
        
    public init(argument:Argument)
        {
        self.argument = argument
        super.init()
        }
        
    public func addWhenClause(_ clause:WhenClause)
        {
        self.whenClauses.append(clause)
        }
        
    public func addOtherwiseClause(_ clause:OtherwiseClause)
        {
        self.otherwiseClause = clause
        }
    }
