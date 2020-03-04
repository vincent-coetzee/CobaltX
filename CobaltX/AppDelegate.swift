//
//  AppDelegate.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/25.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification)
        {
        do
            {
            let path = "/Users/vincent/Development/Development2020/CobaltX/Sample.cobalt"
            let source = try! String(contentsOfFile: path)
            Parser.shared.source = source
            let package = try Parser.shared.parse()
            print(package)
            }
        catch let error
            {
            print("parsing failed with \(error)")
            }
        }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

