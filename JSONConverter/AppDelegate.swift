//
//  AppDelegate.swift
//  JSONConverter
//
//  Created by Yao on 2018/1/26.
//  Copyright © 2018年 Yao. All rights reserved.
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
        NotificationCenter.default.post(name: NSNotification.Name.ApplicationWillTerminateNotification, object: nil)
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            mainWindowController.window?.makeKeyAndOrderFront(self)
        }
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
