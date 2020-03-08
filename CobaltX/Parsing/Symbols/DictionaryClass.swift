//
//  DictionaryClass.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 06/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class DictionaryClass:GenericClass
    {
    private let elementClass:Class
    private let keyClass:Class
        
    public class func parseDictionaryClassReference(from parser:Parser) throws -> DictionaryClass
        {
        if !parser.token.isDictionary
            {
            throw(CompilerError.dictionaryExpected)
            }
        try parser.nextToken()
        var keyType:Class = Package.rootPackage.objectClass
        var valueType:Class = Package.rootPackage.objectClass
        try parser.parseBrockets
            {
            keyType = try Class.parseClassReference(from: parser)
            if !parser.token.isComma
                {
                throw(CompilerError.commaExpected)
                }
            try parser.nextToken()
            valueType = try Class.parseClassReference(from: parser)
            }
        return(DictionaryClass(keyClass: keyType, elementClass: valueType))
        }
        
    public override var typeName:String
        {
        return("\(self.name)< \(self.keyClass.typeName) x \(self.elementClass.typeName) >")
        }
        
    public init(keyClass:Class,elementClass:Class)
        {
        self.elementClass = elementClass
        self.keyClass = keyClass
        super.init(shortName:"Dictionary\(Cobalt.nextIndex())")
        }
    }

