//
//  VirtualSlotWriteBlock.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class VirtualSlotWriteBlock:VirtualSlotBlock
    {
    public class func parseVirtualSlotBlock(typeClass:Class,from parser:Parser) throws -> VirtualSlotBlock
        {
        let block = VirtualSlotWriteBlock()
        block.push()
        try parser.parseParentheses
            {
            let name = try parser.matchIdentifier(error: CompilerError.newValueNameExpected)
            let parameter = Parameter(shortName: name,class: typeClass)
            block.addSymbol(parameter)
            }
        try parser.parseBraces
            {
            repeat
                {
                block.addStatement(try Statement.parseStatement(from: parser))
                }
            while !parser.token.isRightBrace
            }
        block.pop()
        return(block)
        }
    }
