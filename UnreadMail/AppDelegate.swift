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

    let menuItem: NSMenuItem = NSMenuItem()
    let menubarItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)

    var timer: NSTimer = NSTimer()

    var unread: String = "?"
    let scriptSource: String = "tell application \"Mail\"\nget unread count of inbox\nend tell"

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Hide app from dock and tab
        NSApp.setActivationPolicy(NSApplicationActivationPolicy.Accessory)
    }

    override func awakeFromNib() {
        // Initialize UnreadMail system tray (statusBar)
        let icon = NSImage(named: "UnreadMailIconSet")
        icon?.setTemplate(true)
        menubarItem.image = icon
        menubarItem.title = unread
        menubarItem.menu = UnreadMainMenu
        updateUnreadCount()
        timer = NSTimer.scheduledTimerWithTimeInterval(30, target:self, selector: Selector("updateUnreadCount"), userInfo: nil, repeats: true)
    }
    
    func updateUnreadCount(){
        NSLog("getUnreadCount(): " + unread)
        let script: NSAppleScript = NSAppleScript(source: scriptSource)!
        var errorInfo: NSDictionary?
        var retDesc = script.executeAndReturnError(&errorInfo)
        if(retDesc?.stringValue != nil){
            unread = retDesc!.stringValue!
        }
        NSLog("getUnreadCount(): " + unread)
        menubarItem.title = self.unread
    }
    
    @IBAction func QuitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}

