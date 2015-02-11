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
    @IBOutlet weak var PrefWindow: NSWindow!
    @IBOutlet weak var InboxList: NSPopUpButton!


    let menubarItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let menu: NSMenu = NSMenu()
    let menuItem: NSMenuItem = NSMenuItem()
    
    var timer: NSTimer = NSTimer()
    
    var inboxFile: String = ""
    let inboxPrefix: String = NSHomeDirectory() + "/Library/Mail/V2/"
    let inboxSuffix: String = "/INBOX.mbox/Info.plist"
    let pfile = NSHomeDirectory() + "/.unreadmail.inbox"
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Hide app from dock and tab
        NSApp.setActivationPolicy(NSApplicationActivationPolicy.Accessory)
        timer = NSTimer.scheduledTimerWithTimeInterval(30, target:self, selector: Selector("checkInbox"), userInfo: nil, repeats: true)
        
        self.getInboxFile()
        
        if ( self.inboxFile == "" ) {
            InboxList.addItemWithTitle("choose your inbox path")
        }
        if let accountsDict = NSDictionary(contentsOfFile: inboxPrefix + "MailData/Accounts.plist") {
            let accounts = accountsDict.objectForKey("MailAccounts") as NSArray
            for mailboxDict in accounts {
                var mailboxpath = mailboxDict.objectForKey("AccountPath") as String
                if ( mailboxpath != "~/Library/Mail/V2/Mailboxes" ) {
                    NSLog("Found mailbox: " + mailboxpath)
                    InboxList.addItemWithTitle(mailboxpath)
                }
            }
        }
    }

    override func awakeFromNib() {
        // Initialize UnreadMail system tray (statusBar)
        let icon = NSImage(named: "UnreadMailIconSet")
        icon?.setTemplate(true)
        menubarItem.image = icon
        menubarItem.menu = UnreadMainMenu
        menubarItem.title = "?"
        self.checkInbox()
    }
    
    func checkInbox(){
        NSLog("Trying to read " + inboxFile)
        if let inbox = NSMutableDictionary(contentsOfFile: inboxFile) {
            if let unread = inbox.objectForKey("IMAPMailboxUnseenCount") as? Int {
                menubarItem.title = String(unread)
            }
        } else {
            menubarItem.title = "?"
        }
    }
    
    func getInboxFile(){
        NSLog("getInboxFile - start: " + self.inboxFile)
        let fileManager = NSFileManager.defaultManager()
        if ((fileManager.fileExistsAtPath(pfile))) {
            NSLog("file exists: " + pfile)
            self.inboxFile = String(contentsOfFile: pfile, encoding: NSUTF8StringEncoding, error: nil)!
        }
        NSLog("getInboxFile - end: " + self.inboxFile)
    }
    
    func setInboxFile(){
        NSLog("setInboxFile - start: " + self.inboxFile)
        let fileManager = NSFileManager.defaultManager()
        self.inboxFile.writeToFile(pfile, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        NSLog("setInboxFile - end: " + self.inboxFile)
    }
    
    @IBAction func PrefClicked(sender: NSMenuItem) {
        self.PrefWindow!.orderFront(self)
    }
    
    @IBAction func CloseClicked(sender: NSButton) {
        self.PrefWindow!.orderOut(self)
    }
    
    @IBAction func InboxSelection(sender: NSPopUpButton) {
        self.inboxFile = InboxList.titleOfSelectedItem! + inboxSuffix
        self.inboxFile = self.inboxFile.stringByReplacingOccurrencesOfString("~", withString: NSHomeDirectory())
        setInboxFile()
        NSLog("inboxFile set to = " + inboxFile)
        
    }
    
    @IBAction func QuitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}

