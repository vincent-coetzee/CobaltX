//
//  Method.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Method:Symbol
    {
    private var instances:[MethodInstance] = []
    
    public class func parseMethod(from parser:Parser) throws -> Method
        {
        try parser.nextToken()
        let name = try parser.matchIdentifier(error: .methodNameExpected)
        var theMethod:Method
        if let method = parser.scopeCurrent.lookup(shortName: name) as? Method
            {
            theMethod = method
            }
        else
            {
            throw(CompilerError.multiMethodNeedsDefinitionBeforeInstance(name))
            }
        if parser.token.isLeftBrace
            {
            theMethod.addInstance(try MethodInstance.parseMethodInstance(shortName:name,from:parser))
            }
        return(theMethod)
        }
        
    public override var isPackageLevelSymbol:Bool
        {
        return(true)
        }
        
    public func addInstance(_ instance:MethodInstance)
        {
        self.instances.append(instance)
        }
    }
