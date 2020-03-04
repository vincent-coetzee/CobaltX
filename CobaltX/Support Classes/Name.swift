//
//  Name.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 02/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation
    
public struct Name:Hashable
    {
    public static func +(lhs:Name,rhs:String) -> Name
        {
        return(Name(lhs.components + [rhs]))
        }
        
    public static func +(lhs:Name,rhs:Name) -> Name
        {
        return(Name(lhs.components + rhs.components))
        }

    public var count:Int
        {
        return(self.components.count)
        }
        
    public var stringName:String
        {
        if self.components.isEmpty
            {
            return("")
            }
        return(self.components.joined(separator: "::"))
        }
        
    public var first:String
        {
        if self.components.count < 1
            {
            fatalError("Attempt to access first element of name when name has 0 length.")
            }
        return(self.components[0])
        }
        
    public var last:String
        {
        if self.components.count < 1
            {
            fatalError("Attempt to access last element of name when name has 0 length.")
            }
        return(self.components.last!)
        }
        
    private var components:[String] = []
    
    public func withoutFirst() -> Name
        {
        if self.components.count < 1
            {
            fatalError("Attempt to drop first element of name when name has 0 length.")
            }
        return(Name(Array(self.components.dropFirst())))
        }
        
    public func withoutLast() -> Name
        {
        if self.components.count < 1
            {
            fatalError("Attempt to drop first element of name when name has 0 length.")
            }
        return(Name(Array(self.components.dropLast())))
        }
        
    public init(_ components:[String])
        {
        self.components = components
        }
        
    public init(_ piece:String)
        {
        self.components = piece.components(separatedBy: "::")
        }
    }
