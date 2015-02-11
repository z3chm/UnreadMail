//
//  AppDelegate.swift
//  UnreadMail
//
//  Created by Eder Zechim on 2/9/15.
//  Copyright (c) 2015 Eder Zechim. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var UnreadMainMenu: NSMenu!

    let menubarItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let menu: NSMenu = NSMenu()
    let menuItem: NSMenuItem = NSMenuItem()
    
    var timer: NSTimer = NSTimer()
    var errorInfo: AutoreleasingUnsafeMutablePointer<NSDictionary?>
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Hide app from dock and tab
        NSApp.setActivationPolicy(NSApplicationActivationPolicy.Accessory)
        timer = NSTimer.scheduledTimerWithTimeInterval(30, target:self, selector: Selector("checkInbox"), userInfo: nil, repeats: true)
    }

    override func awakeFromNib() {
        // Initialize UnreadMail system tray (statusBar)
        let icon = NSImage(named: "UnreadMailIconSet")
        icon?.setTemplate(true)
        menubarItem.image = icon
        menubarItem.menu = UnreadMainMenu
        menubarItem.title = self.getUnreadCount()
    }
    
    func getUnreadCount() -> String {
        let unread = "?"
        let scriptSource: String = "tell application \"Mail\"\nget unread count of inbox\nend tell"
        let script: NSAppleScript = NSAppleScript(source: scriptSource)!
        let retDesc = script.executeAndReturnError(errorInfo)
        return unread
    }
    
    @IBAction func QuitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}

