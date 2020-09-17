//
//  MainWindowController.swift
//  JSONConverter
//
//  Created by Yao on 2018/1/27.
//  Copyright © 2018年 Yao. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    lazy var mainViewController: MainViewController = {
        let mainVc = MainViewController()
        return mainVc
    }()

    override func windowDidLoad() {
        super.windowDidLoad()
        contentViewController = mainViewController
        window?.delegate = self
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("MainWindowController")
    }
}

extension MainWindowController: NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        return true;
    }
}
