//
//  SourceLocation.swift
//  Argon
//
//  Created by Vincent Coetzee on 2019/02/14.
//  Copyright © 2019 Vincent Coetzee. All rights reserved.
//

import Foundation

public struct SourceLocation:Equatable
    {
    public static let zero = SourceLocation(line: 0, lineStart: 0, lineStop: 0, tokenStart: 0, tokenStop: 0)
    
    public static func ==(lhs:SourceLocation,rhs:SourceLocation) -> Bool
        {
        return(lhs.line == rhs.line && lhs.lineStart == rhs.lineStart && lhs.lineStop == rhs.lineStop && lhs.tokenStart == rhs.tokenStart && lhs.tokenStop == rhs.tokenStop)
        }
    
    public let line:Int
    public let lineStart:Int
    public let lineStop:Int
    public let tokenStart:Int
    public let tokenStop:Int
    
    public init(line:Int,lineStart:Int,lineStop:Int,tokenStart:Int,tokenStop:Int)
        {
        self.line = line
        self.lineStart = lineStart
        self.lineStop = lineStop
        self.tokenStart = tokenStart
        self.tokenStop = tokenStop
        }
    }
