//
//  VirtualSlotReadBlock.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class VirtualSlotReadBlock:VirtualSlotBlock
    {
    public class func parseVirtualSlotBlock(from parser:Parser) throws -> VirtualSlotBlock
        {
        let block = VirtualSlotReadBlock()
        block.push()
        try parser.parseBraces
            {
            repeat
                {
                block.addStatement(try Statement.parseStatement(from: parser))
                }
            while !parser.token.isRightBrace
            }
        if !block.lastStatement.isReturnStatement
            {
            throw(CompilerError.virtualSlotReaderMustReturnValue)
            }
        block.pop()
        return(block)
        }
    }
