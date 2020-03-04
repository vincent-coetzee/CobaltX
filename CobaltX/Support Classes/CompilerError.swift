//
//  CompilerError.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public enum CompilerError:Error
    {
    case invalidCharacter(Swift.Character)
    case invalidSymbolCharacter(Swift.Character)
    case packageNameExpected
    case leftBraceExpected
    case rightBraceExpected
    case leftParExpected
    case rightParExpected
    case packageLevelKeywordExpected
    case packageDeclarationExpected
    case genericTypeNameExpected
    case gluonExpected
    case classReferenceExpected
    case classNameExpected
    case duplicateClassDefinition(String)
    case slotExpected
    case slotNameExpected
    case virtualSlotMustDefineReadBlock(String)
    case newValueNameExpected
    case assignExpected
    case slotRequiresInitialValueOrTypeClass
    case virtualSlotReaderMustReturnValue
    case enumerationNameExpected
    case stopPrefixExpectedOnEnumerationCaseName
    case enumerationCaseNameExpected
    case referenceComponentExpected
    case expressionExpected
    case undefinedValue(String)
    case tagExpectedInTupleDeclaration
    case tagExpectedInClosureWithClause
    case identifierExpected
    }
