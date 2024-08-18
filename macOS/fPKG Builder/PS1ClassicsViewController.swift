//
//  PS1ClassicsViewController.swift
//  PS Mac Tools
//
//  Created by SvenGDK on 14/08/2024.
//

import Foundation
import AppKit

class PS1ClassicsViewController: NSViewController {
    
    var CurrentGameID: String = ""
    var Disc1CueFile: String = ""
    var Disc2CueFile: String = ""
    var Disc3CueFile: String = ""
    var Disc4CueFile: String = ""
    
    @IBOutlet weak var BuildfPKGButton: NSButton!
    @IBOutlet weak var ProgressTextField: NSTextField!
    @IBOutlet weak var fPKGBuilderProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var fPKGBuilderSpinningIndicator: NSProgressIndicator!
    @IBOutlet weak var fPKGBuilderStatusTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Select 6x upscaling by default
        UpscalingComboBox.selectItem(at: 3)
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
    
    @IBOutlet weak var GameTitleTextField: NSTextField!
    @IBOutlet weak var NPTitleTextField: NSTextField!
    @IBOutlet weak var IconTextField: NSTextField!
    @IBOutlet weak var BackgroundTextField: NSTextField!
    @IBOutlet weak var Disc1TextField: NSTextField!
    @IBOutlet weak var Disc2TextField: NSTextField!
    @IBOutlet weak var Disc3TextField: NSTextField!
    @IBOutlet weak var Disc4TextField: NSTextField!
    @IBOutlet weak var TXTConfigTextField: NSTextField!
    @IBOutlet weak var LUAConfigTextField: NSTextField!
    @IBOutlet weak var SkipBootlogoCheckBox: NSButton!
    @IBOutlet weak var Force60HzCheckBox: NSButton!
    @IBOutlet weak var EmulateAnalogSticksCheckBox: NSButton!
    @IBOutlet weak var EnableGunconCheckBox: NSButton!
    @IBOutlet weak var UpscalingComboBox: NSComboBox!
    
    @IBAction func BrowseIcon(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select an icon for your game"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().PNGType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            IconTextField.stringValue = result!.path
        } else {
            return
        }
    }
    
    @IBAction func BrowseBackground(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select a background for your game"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().PNGType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            BackgroundTextField.stringValue = result!.path
        } else {
            return
        }
    }
    
    @IBAction func BrowseDisc1(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select your PS1 BIN file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().BINType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            Disc1TextField.stringValue = result!.path
            checkPS1Game(inputPath: result!.path)
            BuildfPKGButton.isEnabled = true
        } else {
            return
        }
    }
    
    @IBAction func BrowseDisc2(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select the Disc 2 BIN file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().BINType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            Disc2TextField.stringValue = result!.path
        } else {
            return
        }
    }
    
    @IBAction func BrowseDisc3(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select the Disc 3 BIN file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().BINType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            Disc3TextField.stringValue = result!.path
        } else {
            return
        }
    }
    
    @IBAction func BrowseDisc4(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select the Disc 4 BIN file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().BINType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            Disc4TextField.stringValue = result!.path
        } else {
            return
        }
    }
    
    @IBAction func BrowseTXTConfig(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select a TXT config file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().TXTType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            TXTConfigTextField.stringValue = result!.path
        } else {
            return
        }
    }
    
    @IBAction func BrowseLUAConfig(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select a LUA config file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().TXTType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            LUAConfigTextField.stringValue = result!.path
        } else {
            return
        }
    }
    
    func checkPS1Game(inputPath: String) {
        
        // Read the BIN file and try to get the game ID
        let BINReaderOutput = ReadBINFile(fileInput: inputPath).output
        var BINGameTitleID = BINReaderOutput.filter({(item: String) -> Bool in
            let stringMatch = item.lowercased().range(of: "BOOT = ".lowercased())
            let stringMatch2 = item.lowercased().range(of: "BOOT=".lowercased())
            if stringMatch == nil {
                return stringMatch2 != nil ? true : false
            }
            else {
                return stringMatch != nil ? true : false
            }
        })
        
        if BINGameTitleID.count == 0 {
            BINGameTitleID = ["Title ID not found", "Title ID not found"]
        }
        else {
            if BINGameTitleID[0].starts(with: "BOOT=") {
                NPTitleTextField.stringValue = BINGameTitleID[0].components(separatedBy:  "=")[1]
            }
            else {
                NPTitleTextField.stringValue = BINGameTitleID[0].components(separatedBy: " = ")[1]
            }
            
            CurrentGameID = BINGameTitleID[0].replacingOccurrences(of: "BOOT = cdrom:\\", with: "").replacingOccurrences(of: "BOOT=cdrom:\\", with: "").replacingOccurrences(of: "BOOT = cdrom:", with: "").replacingOccurrences(of: ";1", with: "").replacingOccurrences(of: "_", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "MGS\"", with: "")
            
            NPTitleTextField.stringValue = CurrentGameID
            
            // Check for a game title if we have a game ID
            if !CurrentGameID.isEmpty {
                var AdjustedGameID: String = CurrentGameID
                AdjustedGameID.insert("-", at: AdjustedGameID.index(AdjustedGameID.startIndex, offsetBy: 4))
                
                print(AdjustedGameID)
                
                let GameTitle: String = FindGameTitle(GameID: AdjustedGameID)
                if !GameTitle.isEmpty {
                    GameTitleTextField.stringValue = GameTitle
                }
            }
        }
        
    }
    
    func ReadBINFile(fileInput: String) -> (output: [String], error: [String], exitCode: Int32) {
        var output : [String] = []
        var error : [String] = []
        
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "strings '" + fileInput + "' | LANG=C fgrep 'BOOT'"]
        
        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe
        
        task.launch()
        
        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }
        
        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
        }
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return (output, error, status)
    }
    
    @IBAction func BuildfPKG(_ sender: NSButton) {
        
        let MissingInfoAlert = NSAlert()
        MissingInfoAlert.addButton(withTitle: "Close")
        
        if Disc1TextField.stringValue.isEmpty {
            MissingInfoAlert.messageText = "Disc 1 is missing, cannot continue."
            MissingInfoAlert.runModal()
            return
        }
        
        if GameTitleTextField.stringValue.isEmpty {
            MissingInfoAlert.messageText = "The Game Title is missing, cannot continue."
            MissingInfoAlert.runModal()
            return
        }
        
        if NPTitleTextField.stringValue.isEmpty {
            MissingInfoAlert.messageText = "The NP Title is missing, cannot continue."
            MissingInfoAlert.runModal()
            return
        }
        
        ProgressTextField.isHidden = false
        fPKGBuilderProgressIndicator.isHidden = false
        fPKGBuilderSpinningIndicator.isHidden = false
        fPKGBuilderStatusTextField.isHidden = false
        
        fPKGBuilderProgressIndicator.isIndeterminate = true
        fPKGBuilderProgressIndicator.startAnimation(nil)
        fPKGBuilderSpinningIndicator.startAnimation(nil)
        fPKGBuilderStatusTextField.stringValue = "Waiting for user input"
        
        CreatefPKG()
    }
    
    func CreatefPKG() {
        
        var PKGOutputPath: String = ""
        let FolderBrowserOpenPanel = NSOpenPanel()
        
        FolderBrowserOpenPanel.title = "Select an output folder"
        FolderBrowserOpenPanel.showsResizeIndicator = true
        FolderBrowserOpenPanel.showsHiddenFiles = false
        FolderBrowserOpenPanel.canChooseFiles = false
        FolderBrowserOpenPanel.canChooseDirectories = true
        FolderBrowserOpenPanel.allowsMultipleSelection = false
        
        // Set destination folder where the pkg file will be moved into
        if (FolderBrowserOpenPanel.runModal() == NSApplication.ModalResponse.OK) {
            let result = FolderBrowserOpenPanel.url
            PKGOutputPath = result!.path
        } else {
            return
        }

        fPKGBuilderProgressIndicator.stopAnimation(nil)
        fPKGBuilderProgressIndicator.isIndeterminate = false
        fPKGBuilderProgressIndicator.doubleValue = 0
        fPKGBuilderStatusTextField.stringValue = "Removing old fPKG build folder"
        usleep(150000)
        
        // Remove previous fPKG GP4 project
        if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PS1fPKG.gp4") {
            do {
                try FileManager.default.removeItem(atPath: Utils().CDrivePath + "/Cache/PS1fPKG.gp4")
            } catch (let error) {
                print(error)
            }
        }
        
        // Remove previous fPKG project folder
        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PS1fPKG", isDirectory: &isDir) {
            do {
                try FileManager.default.removeItem(atPath: Utils().CDrivePath + "/Cache/PS1fPKG")
            } catch (let error) {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10
        fPKGBuilderStatusTextField.stringValue = "Preparing the PS1 emulator"
        usleep(150000)
        
        // Copy the PS1 emulator to the new project folder
        if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/PS4/emus/ps1hd", isDirectory: &isDir) {
            do {
                try FileManager.default.copyItem(atPath: Utils().CDrivePath + "/PS4/emus/ps1hd", toPath: Utils().CDrivePath + "/Cache/PS1fPKG")
            } catch (let error) {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10
        
        // Copy the selected icon to the project folder
        if !IconTextField.stringValue.isEmpty {
            do {
                try FileManager.default.copyItem(atPath: IconTextField.stringValue, toPath: Utils().CDrivePath + "/Cache/PS1fPKG/sce_sys/icon0.png")
            } catch (let error) {
                print(error)
            }
        }
        
        // Copy the selected background to the project folder
        if !BackgroundTextField.stringValue.isEmpty {
            do {
                try FileManager.default.copyItem(atPath: IconTextField.stringValue, toPath: Utils().CDrivePath + "/Cache/PS1fPKG/sce_sys/pic0.png")
            } catch (let error) {
                print(error)
            }
        }

        // If config already exists, remove it
        let ConfigDestinationPath: String = Utils().CDrivePath + "/Cache/PS1fPKG/config-title.txt"
        if FileManager.default.fileExists(atPath: ConfigDestinationPath)
        {
            do {
                try FileManager.default.removeItem(atPath: ConfigDestinationPath)
            } catch (let error) {
                print(error)
            }
        }
        
        // Create a new config file
        FileManager.default.createFile(atPath: ConfigDestinationPath, contents:Data(" ".utf8), attributes: nil)
        let ConfigWriter = FileHandle(forWritingAtPath: ConfigDestinationPath)
        if ConfigWriter == nil { }
        else
        {
            ConfigWriter!.write("--ps4-trophies=0\n".data(using: .utf8)!)
            ConfigWriter!.write("--ps5-uds=0\n".data(using: .utf8)!)
            ConfigWriter!.write("--trophies=0\n".data(using: .utf8)!)
            
            fPKGBuilderProgressIndicator.doubleValue += 10
            fPKGBuilderStatusTextField.stringValue = "Preparing selected disc(s)"
            usleep(150000)
            
            // Discs Setup
            Disc1CueFile = Disc1TextField.stringValue.replacingOccurrences(of: ".bin", with: ".cue")
            ConfigWriter!.write(#"--image="data/disc1.bin"\#n"#.data(using: .utf8)!)
            
            // Copy selected discs to the inner Games folder (if not already exists)
            let Disc1BINFileName: String = URL(string: Disc1TextField.stringValue)!.lastPathComponent
            let Disc1CUEFileName: String = URL(string: Disc1CueFile)!.lastPathComponent
            
            if FileManager.default.fileExists(atPath: Disc1TextField.stringValue) && !FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Games/" + Disc1BINFileName) {
                
                do {
                    try FileManager.default.copyItem(atPath: Disc1TextField.stringValue, toPath: Utils().CDrivePath + "/Games/" + Disc1BINFileName)
                    try FileManager.default.copyItem(atPath: Disc1CueFile, toPath: Utils().CDrivePath + "/Games/" + Disc1CUEFileName)
                } catch (let error) {
                    print(error)
                }
            }
            
            if !Disc2TextField.stringValue.isEmpty {
                Disc2CueFile = Disc2TextField.stringValue.replacingOccurrences(of: ".bin", with: ".cue")
                ConfigWriter!.write(#"--image="data/disc2.bin"\#n"#.data(using: .utf8)!)
                
                if FileManager.default.fileExists(atPath: Disc2TextField.stringValue) {
                    do {
                        let Disc2FileName: String = URL(string: Disc2TextField.stringValue)!.lastPathComponent
                        let Disc2CUEFileName: String = URL(string: Disc2CueFile)!.lastPathComponent
                        try FileManager.default.copyItem(atPath: Disc2TextField.stringValue, toPath: Utils().CDrivePath + "/Games/" + Disc2FileName)
                        try FileManager.default.copyItem(atPath: Disc2CueFile, toPath: Utils().CDrivePath + "/Games/" + Disc2CUEFileName)
                    } catch (let error) {
                        print(error)
                    }
                }
            }
            if !Disc3TextField.stringValue.isEmpty {
                Disc3CueFile = Disc3TextField.stringValue.replacingOccurrences(of: ".bin", with: ".cue")
                ConfigWriter!.write(#"--image="data/disc3.bin"\#n"#.data(using: .utf8)!)
                
                if FileManager.default.fileExists(atPath: Disc3TextField.stringValue) {
                    do {
                        let Disc3FileName: String = URL(string: Disc3TextField.stringValue)!.lastPathComponent
                        let Disc3CUEFileName: String = URL(string: Disc3CueFile)!.lastPathComponent
                        try FileManager.default.copyItem(atPath: Disc3TextField.stringValue, toPath: Utils().CDrivePath + "/Games/" + Disc3FileName)
                        try FileManager.default.copyItem(atPath: Disc3CueFile, toPath: Utils().CDrivePath + "/Games/" + Disc3CUEFileName)
                    } catch (let error) {
                        print(error)
                    }
                }
            }
            if !Disc4TextField.stringValue.isEmpty {
                Disc4CueFile = Disc4TextField.stringValue.replacingOccurrences(of: ".bin", with: ".cue")
                ConfigWriter!.write(#"--image="data/disc4.bin"\#n"#.data(using: .utf8)!)
                
                if FileManager.default.fileExists(atPath: Disc4TextField.stringValue) {
                    do {
                        let Disc4FileName: String = URL(string: Disc4TextField.stringValue)!.lastPathComponent
                        let Disc4CUEFileName: String = URL(string: Disc4CueFile)!.lastPathComponent
                        try FileManager.default.copyItem(atPath: Disc4TextField.stringValue, toPath: Utils().CDrivePath + "/Games/" + Disc4FileName)
                        try FileManager.default.copyItem(atPath: Disc4CueFile, toPath: Utils().CDrivePath + "/Games/" + Disc4CUEFileName)
                    } catch (let error) {
                        print(error)
                    }
                }
            }
            
            fPKGBuilderProgressIndicator.doubleValue += 10
            fPKGBuilderStatusTextField.stringValue = "Checking for game protection"
            usleep(150000)
            
            // Check for game protection
            var AdjustedGameID: String = CurrentGameID
            AdjustedGameID.insert("_", at: AdjustedGameID.index(AdjustedGameID.startIndex, offsetBy: 4))
            AdjustedGameID.insert(".", at: AdjustedGameID.index(AdjustedGameID.startIndex, offsetBy: 8))
            var GameProtectionPatch: String = IsGameProtected(GameID: AdjustedGameID)
            if !GameProtectionPatch.isEmpty {
                let GameProtectionAlert = NSAlert()
                GameProtectionAlert.messageText = "Please confirm"
                GameProtectionAlert.informativeText = "This game is LibCrypt protected. Do you want to patch it automatically ?"
                GameProtectionAlert.addButton(withTitle: "Yes")
                GameProtectionAlert.addButton(withTitle: "No")
                
                fPKGBuilderStatusTextField.stringValue = "Waiting for user input"
                
                if GameProtectionAlert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
                {
                    GameProtectionPatch = "--libcrypt=" + GameProtectionPatch + "\n"
                    ConfigWriter!.write(GameProtectionPatch.data(using: .utf8)!)
                }
            }
            
            // LUA config
            if !LUAConfigTextField.stringValue.isEmpty {
                let LUATitleID: String = "--ps1-title-id=" + NPTitleTextField.stringValue + "\n"
                ConfigWriter!.write(LUATitleID.data(using: .utf8)!)
            }
            
            // Graphics config
            let UpscaleValue: String = "--scale=" + UpscalingComboBox.stringValue + "\n"
            ConfigWriter!.write(UpscaleValue.data(using: .utf8)!)
            
            if SkipBootlogoCheckBox.state == .on {
                ConfigWriter!.write("--bios-hide-sce-osd=1\n".data(using: .utf8)!)
            }
            if EnableGunconCheckBox.state == .on {
                ConfigWriter!.write("--guncon\n".data(using: .utf8)!)
            }
            if Force60HzCheckBox.state == .on {
                ConfigWriter!.write("--gpu-scanout-fps-override=60\n".data(using: .utf8)!)
            }
            if EmulateAnalogSticksCheckBox.state == .on {
                ConfigWriter!.write("--sim-analog-pad=0x2020\n".data(using: .utf8)!)
            }
            
            // User config
            if !TXTConfigTextField.stringValue.isEmpty {
                ConfigWriter!.write("#User imported config".data(using: .utf8)!)
                do {
                    let UserConfigData = try String(contentsOfFile: TXTConfigTextField.stringValue, encoding: .utf8)
                    if !UserConfigData.isEmpty {
                        ConfigWriter!.write(UserConfigData.data(using: .utf8)!)
                    }
                } catch {
                    print(error)
                }
            }
            
            // Save config
            ConfigWriter!.closeFile()
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10 //50
        fPKGBuilderStatusTextField.stringValue = "PS1 emulator configuration done. Creating now the param.sfo file, please wait"
        usleep(150000)
        
        // Create a new param.sfo file
        CreateParamSFO(GameTitle: GameTitleTextField.stringValue)
        if FileManager.default.fileExists(atPath: Utils().ToolsPath + "/param.sfo") {
              
            //Delete default param.sfo if exists
            if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PS1fPKG/sce_sys/param.sfo") {
                do {
                    try FileManager.default.removeItem(atPath: Utils().CDrivePath + "/Cache/PS1fPKG/sce_sys/param.sfo")
                } catch (let error) {
                    print(error)
                }
            }
            
            // Move the new param.sfo to the sce_sys folder
            do {
                try FileManager.default.moveItem(atPath: Utils().ToolsPath + "/param.sfo", toPath: Utils().CDrivePath + "/Cache/PS1fPKG/sce_sys/param.sfo")
            } catch (let error) {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10 //60
        fPKGBuilderStatusTextField.stringValue = "Param.sfo file created. Creating disc(s) TOC"
        usleep(150000)
        
        // Create a TOC file
        CreateTOCFile()
        
        let CU2Path: String = Utils().ToolsPath + "/" + URL(fileURLWithPath: Disc1TextField.stringValue).deletingPathExtension().lastPathComponent + ".cu2"
        let TOCPath: String = Utils().ToolsPath + "/" + URL(fileURLWithPath: Disc1TextField.stringValue).deletingPathExtension().lastPathComponent + ".TOC"
        
        if FileManager.default.fileExists(atPath: TOCPath) {
            do {
                try FileManager.default.moveItem(atPath: TOCPath, toPath: Utils().CDrivePath + "/Cache/PS1fPKG/data/disc1.toc")
                try FileManager.default.removeItem(atPath: CU2Path)
            } catch {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10 //70
        fPKGBuilderStatusTextField.stringValue = "Disc(s) TOC created. Proceeding to GP4 project creation"
        usleep(150000)
        
        // Generate a GP4 project and modify it
        CreateGP4Project()
        if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PS1fPKG.gp4") {
            
            let BaseFileNameWithExt: String = URL(fileURLWithPath: Disc1TextField.stringValue).lastPathComponent
            let BaseFileName: String = BaseFileNameWithExt.replacingOccurrences(of: ".bin", with: "")
            let Disc1CUEFilePath: String = "C:\\Games\\" + BaseFileName + ".cue"
            let Disc1BINFilePath: String = "C:\\Games\\" + BaseFileName + ".bin"
            
            let XMLDisc1CuePath = "\n    <file targ_path=\"data/disc1.cue\" orig_path=\"\(Disc1CUEFilePath)\" pfs_compression=\"enable\"/>"
            let XMLDisc1BinPath = "\n    <file targ_path=\"data/disc1.bin\" orig_path=\"\(Disc1BINFilePath)\" pfs_compression=\"enable\"/>"

            do {
                var fileContents = try String(contentsOfFile: Utils().CDrivePath + "/Cache/PS1fPKG.gp4", encoding: .utf8)
                fileContents = fileContents.replacingOccurrences(of: "<?xml version=\"1.1\"", with: "<?xml version=\"1.0\"")
                fileContents = fileContents.replacingOccurrences(of: "<scenarios default_id=\"1\">", with: "<scenarios default_id=\"0\">")
                fileContents = fileContents.replacingOccurrences(of: "</files>", with: "\(XMLDisc1CuePath)\(XMLDisc1BinPath)\n</files>")
                
                try fileContents.write(toFile: Utils().CDrivePath + "/Cache/PS1fPKG.gp4", atomically: false, encoding: .utf8)
            } catch {
                print(error)
            }
            
            if !Disc2TextField.stringValue.isEmpty {
                let BaseFileNameWithExt: String = URL(fileURLWithPath: Disc2TextField.stringValue).lastPathComponent
                let BaseFileName: String = BaseFileNameWithExt.replacingOccurrences(of: ".bin", with: "")
                let Disc2CUEFilePath: String = "C:\\Games\\" + BaseFileName + ".cue"
                let Disc2BINFilePath: String = "C:\\Games\\" + BaseFileName + ".bin"
                
                let XMLDisc2CuePath = "\n    <file targ_path=\"data/disc2.cue\" orig_path=\"\(Disc2CUEFilePath)\" pfs_compression=\"enable\"/>"
                let XMLDisc2BinPath = "\n    <file targ_path=\"data/disc2.bin\" orig_path=\"\(Disc2BINFilePath)\" pfs_compression=\"enable\"/>"

                do {
                    var fileContents = try String(contentsOfFile: Utils().CDrivePath + "/Cache/PS1fPKG.gp4", encoding: .utf8)
                    fileContents = fileContents.replacingOccurrences(of: "</files>", with: "\(XMLDisc2CuePath)\(XMLDisc2BinPath)\n</files>")
                    try fileContents.write(toFile: Utils().CDrivePath + "/Cache/PS1fPKG.gp4", atomically: true, encoding: .utf8)
                } catch {
                    print(error)
                }
            }
            
            if !Disc3TextField.stringValue.isEmpty {
                let BaseFileNameWithExt: String = URL(fileURLWithPath: Disc3TextField.stringValue).lastPathComponent
                let BaseFileName: String = BaseFileNameWithExt.replacingOccurrences(of: ".bin", with: "")
                let Disc3CUEFilePath: String = "C:\\Games\\" + BaseFileName + ".cue"
                let Disc3BINFilePath: String = "C:\\Games\\" + BaseFileName + ".bin"
                
                let XMLDisc3CuePath = "\n    <file targ_path=\"data/disc3.cue\" orig_path=\"\(Disc3CUEFilePath)\" pfs_compression=\"enable\"/>"
                let XMLDisc3BinPath = "\n    <file targ_path=\"data/disc3.bin\" orig_path=\"\(Disc3BINFilePath)\" pfs_compression=\"enable\"/>"

                do {
                    var fileContents = try String(contentsOfFile: Utils().CDrivePath + "/Cache/PS1fPKG.gp4", encoding: .utf8)
                    fileContents = fileContents.replacingOccurrences(of: "</files>", with: "\(XMLDisc3CuePath)\(XMLDisc3BinPath)\n</files>")
                    try fileContents.write(toFile: Utils().CDrivePath + "/Cache/PS1fPKG.gp4", atomically: true, encoding: .utf8)
                } catch {
                    print(error)
                }
            }
            
            if !Disc4TextField.stringValue.isEmpty {
                let BaseFileNameWithExt: String = URL(fileURLWithPath: Disc4TextField.stringValue).lastPathComponent
                let BaseFileName: String = BaseFileNameWithExt.replacingOccurrences(of: ".bin", with: "")
                let Disc4CUEFilePath: String = "C:\\Games\\" + BaseFileName + ".cue"
                let Disc4BINFilePath: String = "C:\\Games\\" + BaseFileName + ".bin"
                
                let XMLDisc4CuePath = "\n    <file targ_path=\"data/disc4.cue\" orig_path=\"\(Disc4CUEFilePath)\" pfs_compression=\"enable\"/>"
                let XMLDisc4BinPath = "\n    <file targ_path=\"data/disc4.bin\" orig_path=\"\(Disc4BINFilePath)\" pfs_compression=\"enable\"/>"

                do {
                    var fileContents = try String(contentsOfFile: Utils().CDrivePath + "/Cache/PS1fPKG.gp4", encoding: .utf8)
                    fileContents = fileContents.replacingOccurrences(of: "</files>", with: "\(XMLDisc4CuePath)\(XMLDisc4BinPath)\n</files>")
                    try fileContents.write(toFile: Utils().CDrivePath + "/Cache/PS1fPKG.gp4", atomically: true, encoding: .utf8)
                } catch {
                    print(error)
                }
            }
            
            fPKGBuilderProgressIndicator.doubleValue += 10 //80
            fPKGBuilderStatusTextField.stringValue = "GP4 project created. fPKG will be built after user confirmation"
            usleep(100000)
            
            let PKGReadyAlert = NSAlert()
            PKGReadyAlert.messageText = "Files are ready for fPKG creation."
            PKGReadyAlert.informativeText = "fPKG Ready"
            PKGReadyAlert.addButton(withTitle: "Continue")
            PKGReadyAlert.runModal()
            
            fPKGBuilderProgressIndicator.isIndeterminate = true
            fPKGBuilderProgressIndicator.startAnimation(nil)
            fPKGBuilderStatusTextField.stringValue = "The fPKG is building, please wait until done"
            usleep(150000)
            
            // Create the fPKG
            BuildPKG()
            
            // Check build
            let PKGFileName: String = "UP9000-" + CurrentGameID + "_00-" + CurrentGameID + "PS1FPKG-A0100-V0100.pkg"
            if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/" + PKGFileName) {
                
                // Move the created fPKG into the selected output folder
                do {
                    try FileManager.default.moveItem(atPath: Utils().CDrivePath + "/Cache/" + PKGFileName, toPath: PKGOutputPath + "/" + PKGFileName)
                } catch (let error) {
                    print(error)
                }
                
                fPKGBuilderProgressIndicator.stopAnimation(nil)
                fPKGBuilderProgressIndicator.isIndeterminate = false
                fPKGBuilderProgressIndicator.doubleValue = 100 //100
                fPKGBuilderSpinningIndicator.stopAnimation(nil)
                fPKGBuilderSpinningIndicator.isHidden = true
                fPKGBuilderStatusTextField.stringValue = "Done"
                
                let SuccessAlert = NSAlert()
                SuccessAlert.messageText = "fPKG created with success!"
                SuccessAlert.informativeText = "Done"
                SuccessAlert.addButton(withTitle: "Continue")
                SuccessAlert.runModal()
                
            }
        }
        
    }
    
    func FindGameTitle(GameID: String) -> String {
        if !GameID.isEmpty {
            do {
                let PS1DBContent = try String(contentsOfFile: Utils().CDrivePath + "/PS4/ps1ids.txt", encoding: .utf8)
                let GameIDs = PS1DBContent.components(separatedBy: .newlines)
                
                var FoundTitle: String = ""
                for FoundGameID in GameIDs {
                    if FoundGameID.contains(GameID) {
                        FoundTitle = FoundGameID.components(separatedBy: ";")[1]
                        break
                    }
                }
                
                if FoundTitle.isEmpty { return "" }
                else { return FoundTitle }
                
            } catch {
                print(error)
                return ""
            }
            
        }
        else {
            return ""
        }
    }
    
    func IsGameProtected(GameID: String) -> String {
        if !GameID.isEmpty {
            do {
                let LibCrData = try String(contentsOfFile: Utils().CDrivePath + "/PS4/libcrypt.txt", encoding: .utf8)
                let GameIDs = LibCrData.components(separatedBy: .newlines)
                
                var FoundPatch: String = ""
                for FoundGameID in GameIDs {
                    if FoundGameID.contains(GameID) {
                        FoundPatch = FoundGameID.components(separatedBy: " ")[1]
                        break
                    }
                }
                
                if FoundPatch.isEmpty { return "" }
                else { return FoundPatch }
                
            } catch {
                print(error)
                return ""
            }
            
        }
        else {
            return ""
        }
    }
    
    func CreateParamSFO(GameTitle: String) {
        let SFOUtil = Bundle.main.path(forResource: "sfoutil", ofType: "")
        let ContentID: String = "UP9000-" + CurrentGameID + "_00-" + CurrentGameID + "PS1FPKG"
        let DestinationPath: String = "'" + Utils().ToolsPath + "/param.sfo'"
        let task = Process()

        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "'" + SFOUtil! + "' --force --new-file " + DestinationPath + " --add int APP_TYPE 1 --add str APP_VER \"01.00\" --add int ATTRIBUTE 0 --add str CATEGORY \"gd\" --add str CONTENT_ID \"\(ContentID)\" --add int DOWNLOAD_DATA_SIZE 0 --add str FORMAT \"obs\" --add int PARENTAL_LEVEL 5 --add int SYSTEM_VER 0 --add str TITLE \"" + GameTitle + "\" --add str TITLE_ID \"\(NPTitleTextField.stringValue)\" --add str VERSION \"01.00\""]
        
        task.launch()
        task.waitUntilExit()
    }
    
    func CreateTOCFile() {
        let task = Process()
        
        let GameBINFileName: String = Disc1CueFile.replacingOccurrences(of: ".cue", with: ".bin")
        var GameBINFileSize: String = ""
        if let GameFileAttributes = try? FileManager.default.attributesOfItem(atPath: GameBINFileName) {
            if let GameFileSizeAsBytes = GameFileAttributes[.size] as? Int64 {
                let NewByteCountFormatter = ByteCountFormatter()
                NewByteCountFormatter.allowedUnits = [.useBytes]
                NewByteCountFormatter.countStyle = .file
                NewByteCountFormatter.includesUnit = false
                NewByteCountFormatter.zeroPadsFractionDigits = true
                let FileSizeInBytes = NewByteCountFormatter.string(fromByteCount: GameFileSizeAsBytes)
                GameBINFileSize = FileSizeInBytes.replacingOccurrences(of: ".", with: "")
            }
        }
        
        task.launchPath = "/bin/sh"
        task.currentDirectoryPath = Utils().ToolsPath
        task.arguments = ["-c", "'" + Utils().ToolsPath + "/cue2toc' '" + Disc1CueFile + "' --size " + GameBINFileSize]
        
        task.launch()
        task.waitUntilExit()
    }
    
    func CreateGP4Project() {
        let task = Process()
        
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "'" + Utils().ToolsPath + "/gengp4_ps1'"]
        task.launch()
        task.waitUntilExit()
    }
    
    func BuildPKG() {
        let task = Process()
        
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "'" + Utils().ToolsPath + "/make_fPKG_PS1'"]
        task.launch()
        task.waitUntilExit()
    }
    
}
