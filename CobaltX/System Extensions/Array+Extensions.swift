//
//  Array+Extensions.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 01/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

extension Array where Element == ValueBox
    {
    public var typeClass:Class
        {
        fatalError("The typeClass of an array can nnot be found if it is empty")
        }
    }
