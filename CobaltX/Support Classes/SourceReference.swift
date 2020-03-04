//
//  SourceReference.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 28/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public enum SourceReference
    {
    case declaration(SourceLocation)
    case read(SourceLocation)
    case write(SourceLocation)
    }
