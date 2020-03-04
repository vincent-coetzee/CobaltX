//
//  Parsing.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public protocol Parsing
    {
    static func parse(from:Parser) throws -> ParseNode
    }
