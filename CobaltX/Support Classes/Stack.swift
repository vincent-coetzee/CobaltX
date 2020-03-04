//
//  Stack.swift
//  BLADE
//
//  Created by Vincent Coetzee on 16/05/2019.
//  Copyright © 2019 macsemantics. All rights reserved.
//

import Foundation

public class Stack<T>
    {
    private var elements:[T] = []
    
    public var isEmpty:Bool
        {
        return(self.elements.isEmpty)
        }
    
    public var count:Int
        {
        return(self.elements.count)
        }
    
    public func push(_ element:T)
        {
        self.elements.append(element)
        }
    
    @discardableResult
    public func pop() -> T
        {
        if self.elements.isEmpty
            {
            fatalError("Stack underflow")
            }
        return(self.elements.popLast()!)
        }
        
    public var topIndex:Int?
        {
        if self.elements.isEmpty
            {
            return(nil)
            }
        return(self.elements.count - 1)
        }
        
    public func index(before index:Int) -> Int?
        {
        if index == 0
            {
            return(nil)
            }
        return(index - 1)
        }
        
    public subscript(_ index:Int) -> T
        {
        if index < 0 || index >= self.elements.count
            {
            fatalError("Invalid index \(index) to subscript")
            }
        return(self.elements[index])
        }
        
    public func entryMatching(_ matching: (T) -> Bool) -> T?
        {
        for index in stride(from:self.elements.count - 1,to: 0,by: -1)
            {
            let element = self.elements[index]
            if matching(element)
                {
                return(element)
                }
            }
        return(nil)
        }
    }

extension Stack where T:Equatable
    {
    public func contains(_ element:T) -> Bool
        {
        for anElement in self.elements
            {
            if anElement == element
                {
                return(true)
                }
            }
        return(false)
        }
    }
    
