//
//  Cobalt.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/25.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public struct Cobalt
    {
    private static var nextIndexNumber = 0
    
    public static func nextIndex() -> Int
        {
        let index = self.nextIndexNumber
        self.nextIndexNumber += 1
        return(index)
        }
    
    public typealias Integer = Int64
    public typealias UInteger = UInt64
    public typealias Float32 = Float
    public typealias Float64 = Double
    public typealias Byte = UInt8
    public typealias Character = UInt16
    public typealias Boolean = Bool
    public typealias Address = UInt64
    public typealias UniqueString = String
    }
