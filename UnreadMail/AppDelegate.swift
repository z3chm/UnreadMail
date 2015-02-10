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

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var UnreadMainMenu: NSMenu!

    var menubarItem = NSStatusBar.systemStatusBar().statusItemWithLength(48)
    var menu: NSMenu = NSMenu()
    var menuItem: NSMenuItem = NSMenuItem()

    var unreadMsgs: Int = -1
    var inboxFile = "/Users/zechim/Library/Mail/V2/IMAP-eder.zechim@oracle.com@stbeehive.oracle.com/INBOX.mbox/Info.plist"

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Hide app from dock and tab
        NSApp.setActivationPolicy(NSApplicationActivationPolicy.Accessory)

        // Initialize UnreadMail system tray (statusBar)
        let icon = NSImage(named: "UnreadMailIconSet")
        icon?.setTemplate(true)
        menubarItem.image = icon
        menubarItem.menu = UnreadMainMenu
        menubarItem.title = "?"

        if let inbox = NSMutableDictionary(contentsOfFile: inboxFile) {
            unreadMsgs = inbox.objectForKey("IMAPMailboxUnseenCount") as Int
            menubarItem.title = String(unreadMsgs)
        } else {
            menubarItem.title = "?"
        }
    }

    @IBAction func QuitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}

