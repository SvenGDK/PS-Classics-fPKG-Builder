//
//  PreloaderViewController.swift
//  fPKG Builder
//
//  Created by SvenGDK on 18/08/2024.
//

import Foundation
import Cocoa

class PreloaderViewController: NSViewController {
    
    @IBOutlet weak var LoadingProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var LoadingStatusTextField: NSTextField!
    
    var isDir: ObjCBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            NSApplication.shared.activate(ignoringOtherApps: true)
            self.SetupfPKGBuilder()
            }
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
    
    func SetupfPKGBuilder() {
        let ErrorAlert = NSAlert()
        ErrorAlert.addButton(withTitle: "Continue")
        
        LoadingProgressIndicator.doubleValue = 0
        LoadingStatusTextField.stringValue = "Checking if wine has been installed ..."
        sleep(1)
        
        // Setup wine if app still exists and wine-home/usr folder is missing
        if FileManager.default.fileExists(atPath: Utils().ToolsPath + "/Wine Stable.app") && !FileManager.default.fileExists(atPath: Utils().ToolsPath + "/Resources/wine-home/usr", isDirectory: &isDir) {
            if CheckWineQuarantine() == true {
                
                LoadingProgressIndicator.doubleValue += 25
                LoadingStatusTextField.stringValue = "Wine is not installed & quarantined, please wait ..."
                sleep(1)
                
                DequarantineWine()
                
                if CheckWineQuarantine() == false {
                    
                    LoadingProgressIndicator.doubleValue += 25
                    LoadingStatusTextField.stringValue = "Wine dequarantined, installing now please wait ..."
                    sleep(1)
                    
                    MoveDequarantinedWine()
                    
                    if FileManager.default.fileExists(atPath: Utils().ToolsPath + "/Resources/wine-home/usr", isDirectory: &isDir) {
                        
                        // Remove wine app
                        do {
                            try FileManager.default.removeItem(atPath: Utils().ToolsPath + "/Wine Stable.app")
                        } catch (let error) {
                            print(error)
                        }
                        
                        // Make shell scripts in the Tools folder executable
                        MakeBinariesExecutable()
                        
                        LoadingProgressIndicator.doubleValue += 50
                        LoadingStatusTextField.stringValue = "PS Classics fPKG Builder is ready. Starting ..."
                        sleep(2)
                        
                        // Open the main window and close the preloader
                        let MainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
                        let PSClassicsTabVC = MainStoryBoard.instantiateController(withIdentifier: "PSClassicsTabViewController") as! PSClassicsTabViewController
                        let MainWC = MainStoryBoard.instantiateController(withIdentifier: "MainWindowController") as! PSClassicsWindowController
                        
                        MainWC.contentViewController = PSClassicsTabVC
                        MainWC.window?.setContentSize(NSSize(width: 805, height: 650))
                        MainWC.showWindow(self)

                        self.view.window?.close()
                    }
                    else
                    {
                        ErrorAlert.messageText = "Could not move wine into the final destination. Errors will happen if you continue."
                        ErrorAlert.runModal()
                    }
                    
                }
                else
                {
                    ErrorAlert.messageText = "Could not dequarantine wine. Errors will happen if you continue."
                    ErrorAlert.runModal()
                }
                
            }
            else
            {
                ErrorAlert.messageText = "Could not check quarantine status of wine. Errors will happen if you continue."
                ErrorAlert.runModal()
            }
        }
        else
        {
            // Assuming wine has been installed before
            // Open the main window and close the preloader
            let MainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
            let PSClassicsTabVC = MainStoryBoard.instantiateController(withIdentifier: "PSClassicsTabViewController") as! PSClassicsTabViewController
            let MainWC = MainStoryBoard.instantiateController(withIdentifier: "MainWindowController") as! PSClassicsWindowController
            
            MainWC.contentViewController = PSClassicsTabVC
            MainWC.window?.setContentSize(NSSize(width: 805, height: 650))
            MainWC.showWindow(self)

            self.view.window?.close()
        }
    }
    
    func CheckWineQuarantine() -> Bool {
        var output : [String] = []
        
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "xattr '" + Utils().ToolsPath + "/Wine Stable.app'"]
        
        let outpipe = Pipe()
        task.standardOutput = outpipe

        task.launch()
        
        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }

        task.waitUntilExit()
        
        if !output.isEmpty {
            if output.contains("com.apple.quarantine") {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            return true
        }
    }
    
    func DequarantineWine() {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "xattr -r -d com.apple.quarantine '" + Utils().ToolsPath + "/Wine Stable.app'"]
        
        let outpipe = Pipe()
        task.standardOutput = outpipe

        task.launch()
        task.waitUntilExit()
    }
    
    func MoveDequarantinedWine() {
        // Create wine-home folder
        if !FileManager.default.fileExists(atPath: Utils().ToolsPath + "/Resources/wine-home", isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(atPath: Utils().ToolsPath + "/Resources/wine-home", withIntermediateDirectories: false)
            } catch (let error) {
                print(error)
            }
        }
        
        // Copy wine files to the wine-home/usr folder
        if FileManager.default.fileExists(atPath: Utils().ToolsPath + "/Wine Stable.app/Contents/Resources/wine", isDirectory: &isDir) {
            do {
                try FileManager.default.copyItem(atPath: Utils().ToolsPath + "/Wine Stable.app/Contents/Resources/wine", toPath: Utils().ToolsPath + "/Resources/wine-home/usr")
            } catch (let error) {
                print(error)
            }
        }
    }
    
    func MakeBinariesExecutable() {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "chmod +x '" + Utils().ToolsPath + "/cue2toc' '" + Utils().ToolsPath + "/gengp4_ps1' '" + Utils().ToolsPath + "/gengp4_ps2' '" + Utils().ToolsPath + "/gengp4_psp' '" + Utils().ToolsPath + "/make_fPKG_PS1' '" + Utils().ToolsPath + "/make_fPKG_PS2' '" + Utils().ToolsPath + "/make_fPKG_PSP'"]
        task.launch()
        task.waitUntilExit()
    }
    
}
