//
//  CobaltPackage.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 28/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class CobaltPackage:Package
    {
    public let objectClass = Class(shortName:"Object")
    
    public let metaClass = Class(shortName:"Metaclass")
    
    public let classClass = Class(shortName:"Class")
    
    public let undefinedObjectClass = Class(shortName:"UndefinedObject")
        
    public var integerClass:Class
        {
        return(self.lookup(shortName:"Integer") as! Class)
        }
        
    public var uintegerClass:Class
        {
        return(self.lookup(shortName:"UInteger") as! Class)
        }
        
    public var float32Class:Class
        {
        return(self.lookup(shortName:"Float32") as! Class)
        }
        
    public var float64Class:Class
        {
        return(self.lookup(shortName:"Float64") as! Class)
        }

    public var byteClass:Class
        {
        return(self.lookup(shortName:"Byte") as! Class)
        }
        
    public var characterClass:Class
        {
        return(self.lookup(shortName:"Character") as! Class)
        }
        
    public var booleanClass:Class
        {
        return(self.lookup(shortName:"Boolean") as! Class)
        }
        
    public var stringClass:Class
        {
        return(self.lookup(shortName:"String") as! Class)
        }
        
    public var symbolClass:Class
        {
        return(self.lookup(shortName:"Symbol") as! Class)
        }
        
    public var arrayClass:Class
        {
        return(self.lookup(shortName:"Array") as! Class)
        }
            
    public var enumerationClass:Class
        {
        return(self.lookup(shortName:"Enumeration") as! Class)
        }
        
    public func initCobaltPackage() -> Self
        {
        self.objectClass.class = self.classClass
        self.classClass.class = self.metaClass
        self.classClass.superclasses = [self.objectClass]
        self.metaClass.class = self.metaClass
        self.metaClass.superclasses = [self.objectClass]
        self.undefinedObjectClass.class = self.classClass
        self.undefinedObjectClass.superclasses = [self.objectClass]
        let magnitudeClass = self.createAndAddClass(named:"Magnitude",superclasses: [self.objectClass])
        let executableClass = self.createAndAddClass(named:"Executable",superclasses: [self.objectClass])
        self.createAndAddClass(named:"Thread",superclasses: [executableClass])
        self.createAndAddClass(named:"Method",superclasses: [executableClass])
        self.createAndAddClass(named:"MethodInstance",superclasses: [executableClass])
        let enumeratedValueClass = self.createAndAddClass(named:"EnumeratedValue",superclasses: [self.objectClass])
        self.createAndAddClass(named:"Enumeration",superclasses: [enumeratedValueClass])
        self.createAndAddClass(named:"EnumerationCase",superclasses: [self.objectClass])
        let numberClass = self.createAndAddClass(named:"Number",superclasses: [magnitudeClass])
        let floatClass = self.createAndAddClass(named:"Float",superclasses: [numberClass])
        self.createAndAddValueClass(named:"Float32",superclasses: [floatClass])
        self.createAndAddValueClass(named:"Float64",superclasses: [floatClass])
        let integerClass = self.createAndAddClass(named:"Integer",superclasses: [numberClass])
        self.createAndAddValueClass(named:"Integer64",superclasses: [integerClass])
        self.createAndAddValueClass(named:"Integer32",superclasses: [integerClass])
        self.createAndAddValueClass(named:"Integer16",superclasses: [integerClass])
        self.createAndAddValueClass(named:"Byte",superclasses: [magnitudeClass])
        self.createAndAddValueClass(named:"Character",superclasses: [magnitudeClass])
        self.createAndAddValueClass(named:"Boolean",superclasses: [self.objectClass])
        let collectionClass = self.createAndAddClass(named:"Collection",superclasses: [self.objectClass])
        let indexedCollectionClass = self.createAndAddClass(named:"IndexedCollection ",superclasses: [collectionClass])
        self.createAndAddGenericClass(named:"Array",superclasses: [indexedCollectionClass])
        let stringClass = self.createAndAddClass(named:"String",superclasses: [indexedCollectionClass]).addSlot(name:"count",class: integerClass)
        self.createAndAddClass(named:"Symbol",superclasses: [stringClass])
        self.createAndAddClass(named:"Dictionary ",superclasses: [indexedCollectionClass])
        let setClass = self.createAndAddClass(named:"Set ",superclasses: [collectionClass])
        self.createAndAddClass(named:"List ",superclasses: [collectionClass])
        self.createAndAddClass(named:"BitSet ",superclasses: [setClass])
        return(self)
        }
        
    @discardableResult
    private func createAndAddClass(named:String,superclasses:[Class]) -> Class
        {
        let theClass = Class(name: named,superclasses:superclasses)
        theClass.class = self.classClass
        self.addSymbol(theClass)
        return(theClass)
        }
        
    @discardableResult
    private func createAndAddGenericClass(named:String,superclasses:[Class]) -> Class
        {
        let theClass = GenericClass(name: named,superclasses:superclasses,genericParameters: [])
        theClass.class = self.classClass
        self.addSymbol(theClass)
        return(theClass)
        }
        
    @discardableResult
    private func createAndAddValueClass(named:String,superclasses:[Class]) -> Class
        {
        let theClass = ValueClass(name: named,superclasses:superclasses)
        theClass.class = self.classClass
        self.addSymbol(theClass)
        return(theClass)
        }
    }
