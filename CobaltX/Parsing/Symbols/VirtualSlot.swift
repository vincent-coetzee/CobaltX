//
//  VirtualSlot.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class VirtualSlot:Slot
    {
    public var readBlock:VirtualSlotBlock?
    public var writeBlock:VirtualSlotBlock?
    }
