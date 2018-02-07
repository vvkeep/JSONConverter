//
//  AppDelegate.swift
//  JSONConverter
//
//  Created by 姚巍 on 2018/1/26.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    lazy var mainWindowController: MainWindowController = {
        let mainWin = MainWindowController()
        return mainWin
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindowController.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag{
            sender.windows.forEach({ (window) in
                window.makeKeyAndOrderFront(self)
            })
        }
        return true
    }


}

