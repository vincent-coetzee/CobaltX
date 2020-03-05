//
//  NeonToken.swift
//  Neon
//
//  Created by Vincent Coetzee on 30/11/2019.
//  Copyright © 2019 macsemantics. All rights reserved.
//

import Foundation

public enum Token:Equatable,CustomStringConvertible
    {
    public enum Symbol:String,CaseIterable
        {
        case none = ""
        case leftParenthesis = "("
        case rightParenthesis = ")"
        case leftBrace = "{"
        case rightBrace = "}"
        case leftBracket = "["
        case rightBracket = "]"
        case colon = ":"
        case gluon = "::"
        case stop = "."
        case comma = ","
        case dollar = "$"
        case hash = "#"
        case at = "@"
        case assign = "="
        case rightArrow = "->"
        case doubleQuote = "\""
        case singleQuote = "'"
        case leftBrocket = "<"
        case rightBrocket = ">"
        case range = ".."
        case ellipsis = "..."
        case rightBrocketEquals = ">="
        case leftBrocketEquals = "<="
        case not = "!"
        case and = "&&"
        case or = "||"
        case modulus = "%"
        case bitNot = "~"
        case bitAnd = "&"
        case bitOr = "|"
        case rightBitShift = ">>"
        case leftBitShift = "<<"
        case mulEquals = "*="
        case divEquals = "/="
        case addEquals = "+="
        case subEquals = "-="
        case bitAndEquals = "&="
        case bitOrEquals = "|="
        case bitNotEquals = "~="
        case shiftLeftEquals = "<<="
        case shiftRightEquals = ">>="
        case mul = "*"
        case sub = "-"
        case div = "/"
        case add = "+"
        case equals = "=="
        case notEquals = "!="
        case other = "other"
        }
    
    public enum Keyword:String,CaseIterable,Equatable
        {
        case Anything
        case Array
        case alias
        case `as`
        case field
        case BitSet
        case Boolean
        case Byte8
        case cfunction
        case Character16
        case children
        case `class`
        case constant
        case Dictionary
        case `else`
        case enumeration
        case export
        case Float32
        case Float64
        case `for`
        case fork
        case handler
        case `if`
        case `import`
        case `in`
        case infix
        case inline
        case instanciate
        case `internal`
        case `let`
        case List
        case macro
        case made
        case make
        case method
        case native
        case next
        case `nil`
        case otherwise
        case `operator`
        case package
        case postfix
        case prefix
        case `private`
//        case Range
        case read
        case `do`
        case `return`
        case resume
        case run
        case sealed
        case select
        case Set
        case signal
        case Signed64
        case Signed32
        case Signed16
        case slot
        case `static`
        case String
        case Symbol
        case system
        case this
        case times
        case Tuple
        case Unsigned64
        case Unsigned32
        case Unsigned16
        case unmade
        case unsealed
        case using
        case virtual
        case void
        case when
        case `while`
        case with
        case write
        }
    
    public static func ==(lhs:Token,rhs:Token) -> Bool
        {
        switch(lhs,rhs)
            {
            case (.none,.none):
                return(true)
            case let (.comment(s1,_),.comment(s2,_)):
                return(s1 == s2)
            case (.end,.end):
                return(true)
            case let (.identifier(s1,_),.identifier(s2,_)):
                return(s1 == s2)
            case let (.keyword(s1,_),.keyword(s2,_)):
                return(s1 == s2)
            case let (.symbol(s1,_),.symbol(s2,_)):
                return(s1 == s2)
            case let (.hashString(s1,_),.hashString(s2,_)):
                return(s1 == s2)
            case let (.string(s1,_),.string(s2,_)):
                return(s1 == s2)
            case let (.integer(s1,_),.integer(s2,_)):
                return(s1 == s2)
            case let (.floatingPoint(s1,_),.floatingPoint(s2,_)):
                return(s1 == s2)
            case let (.text(s1,_),.text(s2,_)):
                return(s1 == s2)
            case let (.nativeType(s1,_),.nativeType(s2,_)):
                return(s1 == s2)
            case let (.tag(s1,_),.tag(s2,_)):
                 return(s1 == s2)
            case let (.operator(s1,_),.operator(s2,_)):
                return(s1 == s2)
            default:
                return(false)
            }
        }
        
    case none
    case comment(String,SourceLocation)
    case end(SourceLocation)
    case identifier(String,SourceLocation)
    case keyword(Keyword,SourceLocation)
    case symbol(Symbol,SourceLocation)
    case hashString(String,SourceLocation)
    case string(String,SourceLocation)
    case integer(Cobalt.Integer,SourceLocation)
    case floatingPoint(Double,SourceLocation)
    case character(String,SourceLocation)
    case boolean(Bool,SourceLocation)
    case text(String,SourceLocation)
    case nativeType(Keyword,SourceLocation)
    case tag(String,SourceLocation)
    case `operator`(String,SourceLocation)
    
    public init(_ symbol:String,_ location:SourceLocation)
        {
        if let aSymbol = Symbol(rawValue: symbol)
            {
            self = .symbol(aSymbol,location)
            }
        else
            {
            self = .symbol(.other,location)
            }
        }
        
    public var customOperatorString:String
        {
        switch(self)
            {
            case .operator(let string,_):
                return(string)
            default:
                fatalError("")
            }
        }
        
    public var description:String
        {
        switch(self)
            {
            case .hashString(let string,_):
                return(".symbolString(\(string))")
            case .comment(let string,_):
                return(".comment(\(string))")
            case .end:
                return(".end")
            case .identifier(let string,_):
                return(".identifier(\(string))")
            case .keyword(let keyword,_):
                return(".keyword(\(keyword))")
            case .string(let string,_):
                return(".string(\(string))")
            case .integer(let value,_):
                return(".integer(\(value))")
            case .floatingPoint(let value,_):
                return(".floatingPoint(\(value))")
            case .text(let string,_):
                return(".text(\(string))")
            case .symbol(let value,_):
                return(".symbol(\(value.rawValue))")
            case .nativeType(let string,_):
                return(".nativeType(\(string))")
            case .tag(let string,_):
                return(".tag(\(string))")
//                 return(".shard(\(shard.shortName))")
            case .none:
                return(".none")
            case .operator(let string,_):
                return(".operator(\(string))")
            case .character(let char, _):
                return(".character(\(char))")
            case .boolean(let boolean, _):
                return(".boolean(\(boolean))")
            }
        }
        
    public var tokenIndex:Int
        {
        switch(self)
            {
            case .text:
                return(0)
            case .comment:
                return(2)
            case .end:
                return(3)
            case .identifier:
                return(4)
            case .keyword:
                return(5)
            case .symbol:
                return(6)
            case .string:
                return(7)
            case .integer:
                return(8)
            case .floatingPoint:
                return(9)
            case .hashString:
                return(10)
            case .nativeType:
                return(12)
//            case .alias:
//                return(13)
//            case .constant:
//                return(14)
            case .tag:
                return(15)
//            case .enumeration:
//                return(18)
//            case .genericType:
//                return(19)
//            case .shard:
//                 return(1)
            case .none:
                return(20)
//            case .variable:
//                return(21)
//            case .byte:
//                return(22)
            case .operator:
                return(23)
            case .character(_, _):
                return(24)
            case .boolean(_, _):
                return(25)
            }
        }
        
    public var hashString:String
        {
        switch(self)
            {
            case .hashString(let string,_):
                return(string)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }
        
    public var symbolTypeString:String
        {
        switch(self)
            {
            case .symbol(let type,_):
                return(type.rawValue)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }
        
    public var location:SourceLocation
        {
        switch(self)
            {
            case .hashString(_,let location):
                return(location)
            case .comment(_,let location):
                return(location)
            case .end(let location):
                return(location)
            case .identifier(_,let location):
                return(location)
            case .keyword(_,let location):
                return(location)
            case .character(_,let location):
                return(location)
            case .boolean(_,let location):
                return(location)
            case .string(_,let location):
                return(location)
            case .integer(_,let location):
                return(location)
            case .floatingPoint(_,let location):
                return(location)
            case .text(_,let location):
                return(location)
            case .symbol(_,let location):
                return(location)
            case .nativeType(_,let location):
                return(location)
//            case .alias(_,let location):
//                return(location)
//            case .constant(_,let location):
//                return(location)
            case .tag(_,let location):
                return(location)
//            case .enumeration(_,let location):
//                return(location)
//            case .genericType(_,let location):
//                return(location)
//            case .shard(_,let location):
//                 return(location)
            case .none:
                return(.zero)
//            case .variable(_,let location):
//                return(location)
//            case .byte(_,let location):
//                return(location)
            case .operator(_, let location):
                return(location)
            }
        }
        
    public var integerValue:Cobalt.Integer
        {
        switch(self)
            {
            case .integer(let value,_):
                return(value)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }
        
    public var floatingPointValue:Double
        {
        switch(self)
            {
            case .floatingPoint(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }
        
    public var operatorName:String
        {
        switch(self)
            {
            case .operator(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }
    
    public var identifier:String
        {
        switch(self)
            {
            case .identifier(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }

    public var tag:String
        {
        switch(self)
            {
            case .tag(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }
    
    public var keyword:Keyword
        {
        switch(self)
            {
            case .nativeType(let name,_):
                return(name)
            case .keyword(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }
        
    public var keywordString:String
        {
        switch(self)
            {
            case .keyword(let name,_):
                return("\(name)")
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }
    
    public var symbol:Symbol
        {
        switch(self)
            {
            case .symbol(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }
        
    public var string:String
        {
        switch(self)
            {
            case .string(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }
        
    public var integer:Cobalt.Integer
        {
        switch(self)
            {
            case .integer(let value,_):
                return(value)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }
    
    public var floatingPoint:Double
        {
        switch(self)
            {
            case .floatingPoint(let value,_):
                return(value)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }

    public var isNativeType:Bool
        {
        switch(self)
            {
            case .nativeType:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isArray:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .Array)
            default:
                return(false)
            }
        }
        
    public var isSet:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .Set)
            default:
                return(false)
            }
        }
        
    public var isDictionary:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .Dictionary)
            default:
                return(false)
            }
        }
        
    public var isList:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .List)
            default:
                return(false)
            }
        }
        
    public var isBitSet:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .BitSet)
            default:
                return(false)
            }
        }
        
    public var isNil:Bool
        {
        switch(self)
            {
            case .keyword(let keyword,_):
                return(keyword == .nil)
            default:
                return(false)
            }
        }
        
    public var isStop:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .stop)
            default:
                return(false)
            }
        }
        
    public var isRightArrow:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightArrow)
            default:
                return(false)
            }
        }
        
    public var isColon:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .colon)
            default:
                return(false)
            }
        }
        
    public var isType:Bool
        {
        switch(self)
            {
            case .nativeType(let kind,_):
                switch(kind)
                    {
                    case .Signed64:
                        fallthrough
                    case .Unsigned64:
                        fallthrough
                    case .Signed32:
                        fallthrough
                    case .Unsigned32:
                        fallthrough
                    case .Signed16:
                        fallthrough
                    case .Unsigned16:
                        fallthrough
                    case .String:
                        fallthrough
//                    case .Array:
//                        fallthrough
//                    case .List:
//                        fallthrough
//                    case .Set:
//                        fallthrough
//                    case .BitSet:
//                        fallthrough
//                    case .Dictionary:
//                        fallthrough
                    case .Boolean:
                        fallthrough
                    case .Byte8:
                        fallthrough
                    case .Character16:
                        fallthrough
                    case .Float32:
                        fallthrough
                    case .Float64:
                        return(true)
                    default:
                        break
                    }
//        case .shard:
//            fallthrough
//        case .enumeration:
//            fallthrough
//        case .alias:
//            return(true)
        default:
            return(false)
            }
        return(false)
        }
        
    public var isInteger:Bool
        {
        switch(self)
            {
            case .integer:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isFloatingPoint:Bool
        {
        switch(self)
            {
            case .floatingPoint:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isOperator:Bool
        {
        switch(self)
            {
            case .operator:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isBlockLevelToken:Bool
        {
        switch(self)
            {
            case .identifier:
                return(true)
            case .keyword(let value,_):
                switch(value)
                    {
                    case .this:
                        return(true)
                    case .for:
                        return(true)
                    case .if:
                        return(true)
                    case .with:
                        return(true)
                    case .select:
                        return(true)
                    case .signal:
                        return(true)
                    case .handler:
                        return(true)
                    case .while:
                        return(true)
                    case .return:
                        return(true)
                    case .let:
                        return(true)
                    case .do:
                        return(true)
                    case .times:
                        return(true)
                    default:
                        break
                    }
                return(false)
            case .symbol(let value,_):
                return(value == .assign)
            default:
                break
            }
        return(false)
        }
        
    public var isVirtualSlotLevelToken:Bool
        {
        switch(self)
            {
            case .identifier:
                return(true)
            case .keyword(let value,_):
                switch(value)
                    {
                    case .for:
                        return(true)
                    case .if:
                        return(true)
                    case .with:
                        return(true)
                    case .select:
                        return(true)
                    case .while:
                        return(true)
                    case .return:
                        return(true)
                    case .let:
                        return(true)
                    case .do:
                        return(true)
                    case .times:
                        return(true)
                    default:
                        break
                    }
                return(false)
            case .symbol(let value,_):
                return(value == .assign)
            default:
                break
            }
        return(false)
        }
        
    public var isReturn:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .return)
            default:
                return(false)
            }
        }
        
    public var isCFunction:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .cfunction)
            default:
                return(false)
            }
        }
        
    public var isNative:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .native)
            default:
                return(false)
            }
        }
        
    public var isSystem:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .system)
            default:
                return(false)
            }
        }
        
    public var isInline:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .inline)
            default:
                return(false)
            }
        }
        
    public var isDirective:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .cfunction || value == .inline || value == .system || value == .native)
            default:
                return(false)
            }
        }
        
        
    public var hasAssociatedSymbol:Bool
        {
        switch(self)
            {
//            case .shard:
//                return(true)
//            case .variable:
//                return(true)
//            case .constant:
//                return(true)
//            case .alias:
//                return(true)
//            case .enumeration:
//                return(true)
            default:
                return(false)
            }
        }
        
    public var associatedSymbol:Symbol
        {
        switch(self)
            {
//            case .shard(let value,_):
//                return(value)
//            case .variable(let value,_):
//                return(value)
//            case .constant(let value,_):
//                return(value)
//            case .alias(let value,_):
//                return(value)
//            case .enumeration(let value,_):
//                return(value)
            default:
                fatalError("This should not be called on a NeonToken of class \(Swift.type(of: self))")
            }
        }

    public var isRead:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .read)
            default:
                return(false)
            }
        }
        
    public var isDo:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .do)
            default:
                return(false)
            }
        }
        
    public var isRun:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .run)
            default:
                return(false)
            }
        }
        
    public var isTimes:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .times)
            default:
                return(false)
            }
        }
        
    public var isMade:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .made)
            default:
                return(false)
            }
        }
        
    public var isWrite:Bool
         {
         switch(self)
             {
             case .keyword(let value,_):
                 return(value == .write)
             default:
                 return(false)
             }
         }
        
    public var isVirtual:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .virtual)
            default:
                return(false)
            }
        }
        
    public var isTuple:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .Tuple)
            default:
                return(false)
            }
        }
        
    public var isSlot:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .slot)
            default:
                return(false)
            }
        }
        
    public var isClass:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .class)
            default:
                return(false)
            }
        }
    
    public var isFor:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .for)
            default:
                return(false)
            }
        }
        
    public var isIf:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .if)
            default:
                return(false)
            }
        }
        
    public var isWith:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .with)
            default:
                return(false)
            }
        }
    
    public var isWhen:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .when)
            default:
                return(false)
            }
        }
        
    public var isLowerThis:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .this)
            default:
                return(false)
            }
        }
        
    public var isIn:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .in)
            default:
                return(false)
            }
        }
    
    public var isOtherwise:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .otherwise)
            default:
                return(false)
            }
        }
        
    public var isSelect:Bool
        {
         switch(self)
            {
            case .keyword(let value,_):
                return(value == .select)
            default:
                return(false)
            }
        }
        
    public var isSignal:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .signal)
            default:
                return(false)
            }
        }
        
    public var isHandler:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .handler)
            default:
                return(false)
            }
        }
        
    public var isMacro:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .macro)
            default:
                return(false)
            }
        }
        
    public var isWhile:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .while)
            default:
                return(false)
            }
        }
        
    public var isAccessModifier:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .export || value == .private || value == .children || value == .internal)
            default:
                return(false)
            }
        }

    public var isHashString:Bool
        {
        switch(self)
            {
            case .hashString:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isString:Bool
        {
        switch(self)
            {
            case .string:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isMethod:Bool
        {
        switch(self)
            {
            case .keyword(let keyword,_):
                return(keyword == .method)
            default:
                return(false)
            }
        }

    public var isThis:Bool
        {
        switch(self)
            {
            case .keyword(let keyword,_):
                return(keyword == .this)
            default:
                return(false)
            }
        }
        
    public var isElse:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .else)
            default:
                return(false)
            }
        }
    
    public var isNot:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .not)
            default:
                return(false)
            }
        }
//    
//    public var isClassDeclarationPrefix:Bool
//        {
//        return(self.isKeyword && self.keyword == .class)
//        }
        
    public var isNumber:Bool
        {
        switch(self)
            {
            case .integer:
                return(true)
            case .floatingPoint:
                return(true)
            default:
                return(false)
            }
        }
        
    public var isComma:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .comma)
            default:
                return(false)
            }
        }
    
    public var isBitAnd:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitAnd)
            default:
                return(false)
            }
        }

    public var isBitOr:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitOr)
            default:
                return(false)
            }
        }
        
    public var isBitNot:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitNot)
            default:
                return(false)
            }
        }
        
    public var isLeftBracket:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftBracket)
            default:
                return(false)
            }
        }
    
    public var isRightBracket:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightBracket)
            default:
                return(false)
            }
        }
    
    public var isLeftBrace:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftBrace)
            default:
                return(false)
            }
        }
    
    public var isRightBrace:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightBrace)
            default:
                return(false)
            }
        }
    
    public var isTag:Bool
        {
        switch(self)
            {
            case .tag:
                return(true)
            default:
                return(false)
            }
        }
        
        
    public var isTypeKeyword:Bool
        {
        switch(self)
            {
            case .keyword(let keyword,_):
                return(keyword == .this)
            case .nativeType(let value,_):
                switch(value)
                    {
                    case .Tuple:
                        return(true)
                    case .this:
                        return(true)
                    case .Signed64:
                        return(true)
                    case .Signed32:
                        return(true)
                    case .Signed16:
                        return(true)
                    case .Unsigned64:
                        return(true)
                    case .Unsigned32:
                        return(true)
                    case .Unsigned16:
                        return(true)
                    case .Boolean:
                        return(true)
                    case .String:
                        return(true)
                    case .Byte8:
                        return(true)
                    case .Character16:
                        return(true)
                    case .Float32:
                        return(true)
                    case .Float64:
                        return(true)
//                    case .Array:
//                        return(true)
                    case .Symbol:
                        return(true)
//                    case .List:
//                        return(true)
//                    case .Set:
//                        return(true)
//                    case .BitSet:
//                        return(true)
//                    case .Dictionary:
//                        return(true)
                    default:
                        break
                    }
                print(value)
            default:
                return(false)
            }
        return(false)
        }
        
    public var isLeftBrocket:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftBrocket)
            default:
                return(false)
            }
        }
    
    public var isRightBrocket:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightBrocket)
            default:
                return(false)
            }
        }

    public var isLeftBrocketEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftBrocketEquals)
            default:
                return(false)
            }
        }
    
    public var isRightBrocketEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightBrocketEquals)
            default:
                return(false)
            }
        }
    
    public var isRightBitShift:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightBitShift)
            default:
                return(false)
            }
        }
        
    public var isLeftBitShift:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftBitShift)
            default:
                return(false)
            }
        }
        
    public var isDollar:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .dollar)
            default:
                return(false)
            }
        }
        
    public var isEllipsis:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .ellipsis)
            default:
                return(false)
            }
        }
        
    public var isLeftPar:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftParenthesis)
            default:
                return(false)
            }
        }
    
    public var isRightPar:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightParenthesis)
            default:
                return(false)
            }
        }
    
    public var isHash:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .hash)
            default:
                return(false)
            }
        }
        
    public var isAt:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .at)
            default:
                return(false)
            }
        }
        
        
    public var isEnd:Bool
        {
        switch(self)
            {
            case .end:
                return(true)
            default:
                return(false)
            }
        }

    public var isRange:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .range)
            default:
                return(false)
            }
        }
    
    public var isMulEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .mulEquals)
            default:
                return(false)
            }
        }
    
    public var isSubEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .subEquals)
            default:
                return(false)
            }
        }
    
    public var isDivEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .divEquals)
            default:
                return(false)
            }
        }
    
    public var isAddEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .addEquals)
            default:
                return(false)
            }
        }
        
    public var isBitAndEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitAndEquals)
            default:
                return(false)
            }
        }
    
    public var isBitNotEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitNotEquals)
            default:
                return(false)
            }
        }
    
    public var isBitOrEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitOrEquals)
            default:
                return(false)
            }
        }
        
    public var isMul:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .mul)
            default:
                return(false)
            }
        }
    
    public var isSub:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .sub)
            default:
                return(false)
            }
        }
    
    public var isDiv:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .div)
            default:
                return(false)
            }
        }
    
    public var isAdd:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .add)
            default:
                return(false)
            }
        }
    
    public var isAnd:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .and)
            default:
                return(false)
            }
        }
        
    public var isOr:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .or)
            default:
                return(false)
            }
        }
        
    public var isPackage:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .package)
            default:
                return(false)
            }
        }
        
    public var isPrefix:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .prefix)
            default:
                return(false)
            }
        }
    
    public var isPostfix:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .postfix)
            default:
                return(false)
            }
        }
    
    public var isInfix:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .infix)
            default:
                return(false)
            }
        }
    
    public var isConstant:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .constant)
            default:
                return(false)
            }
        }
    
    public var isEnumeration:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .enumeration)
            default:
                return(false)
            }
        }
        
    public var isLet:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .let)
            default:
                return(false)
            }
        }
    
    public var isImport:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .import)
            default:
                return(false)
            }
        }
    
    public var isExport:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .export)
            default:
                return(false)
            }
        }

    public var isAs:Bool
        {        switch(self)
                {
                case .keyword(let value,_):
                    return(value == .as)
                default:
                    return(false)
                }
        }
        
    public var isAssign:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .assign)
            default:
                return(false)
            }
        }
        
    public var isEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .equals)
            default:
                return(false)
            }
        }
    
    public var isNotEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .notEquals)
            default:
                return(false)
            }
        }
    
    public var isBitShiftRight:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightBitShift)
            default:
                return(false)
            }
        }
        
    public var isBitShiftLeft:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftBitShift)
            default:
                return(false)
            }
        }
        
    public var isBitShiftRightEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .shiftRightEquals)
            default:
                return(false)
            }
        }
        
    public var isBitShiftLeftEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .shiftLeftEquals)
            default:
                return(false)
            }
        }
        
    public  var isComment:Bool
        {
        switch(self)
            {
            case .comment:
                return(true)
            default:
                return(false)
            }
        }

    public var isKeyword:Bool
        {
        switch(self)
            {
            case .keyword:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isIdentifier:Bool
        {
        switch(self)
            {
            case .identifier:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isSymbol:Bool
        {
        switch(self)
            {
            case .symbol:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isGluon:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .gluon)
            default:
                return(false)
            }
        }
        
    public var isPackageLevelKeyword:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .package || value == .let || value == .method || value == .alias || value == .class || value == .enumeration || value == .constant)
            default:
                return(false)
            }
        }
    }
