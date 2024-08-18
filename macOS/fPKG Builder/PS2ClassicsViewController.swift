//
//  PS2ClassicsViewController.swift
//  PS Mac Tools
//
//  Created by SvenGDK on 14/08/2024.
//

import Foundation
import AppKit

class PS2ClassicsViewController: NSViewController {
    
    var CurrentGameID: String = ""
    var CurrentGameCRC: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set default values
        EmulatorsComboBox.selectItem(at: 0)
        MultitapComboBox.selectItem(at: 0)
        UpscalingComboBox.selectItem(at: 0)
        UprenderComboBox.selectItem(at: 1)
        DisplayModeComboBox.selectItem(at: 0)
        ShaderComboBox.selectItem(at: 0)
    }

    override var representedObject: Any? {
        didSet {
        
        }
    }
    
    @IBOutlet weak var BuildfPKGButton: NSButton!
    @IBOutlet weak var fPKGBuilderProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var fPKGBuilderSpinningIndicator: NSProgressIndicator!
    @IBOutlet weak var fPKGBuilderStatusTextField: NSTextField!
    
    
    @IBOutlet weak var GameTitleTextField: NSTextField!
    @IBOutlet weak var NPTitleTextField: NSTextField!
    @IBOutlet weak var IconTextField: NSTextField!
    @IBOutlet weak var BackgroundTextField: NSTextField!
    @IBOutlet weak var Disc1TextField: NSTextField!
    @IBOutlet weak var Disc2TextField: NSTextField!
    @IBOutlet weak var Disc3TextField: NSTextField!
    @IBOutlet weak var Disc4TextField: NSTextField!
    @IBOutlet weak var Disc5TextField: NSTextField!
    @IBOutlet weak var TXTConfigTextField: NSTextField!
    @IBOutlet weak var LUAConfigTextField: NSTextField!
    @IBOutlet weak var UpscalingComboBox: NSComboBox!
    @IBOutlet weak var UprenderComboBox: NSComboBox!
    @IBOutlet weak var ShaderComboBox: NSComboBox!
    @IBOutlet weak var DisplayModeComboBox: NSComboBox!
    @IBOutlet weak var FixGraphicsCheckBox: NSButton!
    @IBOutlet weak var ImproveSpeedCheckBox: NSButton!
    @IBOutlet weak var DisableMTVUCheckBox: NSButton!
    @IBOutlet weak var DisableInstantVIF1TransferCheckBox: NSButton!
    @IBOutlet weak var PS2MemoryCardTextField: NSTextField!
    @IBOutlet weak var EmulatorsComboBox: NSComboBox!
    @IBOutlet weak var MultitapComboBox: NSComboBox!
    @IBOutlet weak var RestartEmuOnDiscChangeCheckBox: NSButton!
    
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
        
        dialog.title = "Select your PS2 ISO file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().ISOType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            Disc1TextField.stringValue = result!.path
            
            // Read ISO file using isoinfo
            let ISOReaderOutput = CheckPS2Game(ISOFile: result!.path).output
            
            // Get the game ID
            let GameID = ISOReaderOutput.filter({(item: String) -> Bool in
                let stringMatch = item.lowercased().range(of: "BOOT2 = ".lowercased())
                let stringMatch2 = item.lowercased().range(of: "BOOT2=".lowercased())
                if stringMatch == nil {
                    return stringMatch2 != nil ? true : false
                }
                else {
                    return stringMatch != nil ? true : false
                }
            })
            
            // Get the game title if a game ID has been found
            if !GameID.isEmpty {
                if GameID.count > 0 {
                    CurrentGameID = FormatGameID(GameID: GameID[0].components(separatedBy:  "=")[1])
                    let GameTitle: String = FindGameTitle(GameID: CurrentGameID)
                    NPTitleTextField.stringValue = CurrentGameID
                    GameTitleTextField.stringValue = GameTitle
                }
            }
            
            BuildfPKGButton.isEnabled = true
        } else {
            return
        }
    }
    
    @IBAction func BrowseDisc2(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select the Disc 2 ISO file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().ISOType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            Disc2TextField.stringValue = result!.path
        } else {
            return
        }
    }
    
    @IBAction func BrowseDisc3(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select the Disc 3 ISO file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().ISOType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            Disc3TextField.stringValue = result!.path
        } else {
            return
        }
    }
    
    @IBAction func BrowseDisc4(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select the Disc 4 ISO file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().ISOType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            Disc4TextField.stringValue = result!.path
        } else {
            return
        }
    }
    
    @IBAction func BrowseDisc5(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select the Disc 5 ISO file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().ISOType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            Disc5TextField.stringValue = result!.path
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
    
    @IBAction func BrowseMemoryCard(_ sender: NSButton) {
        
    }
    
    func CheckPS2Game(ISOFile: String) -> (output: [String], error: [String], exitCode: Int32) {
        var output : [String] = []
        var error : [String] = []
            
        let isoutil = Bundle.main.path(forResource: "isoinfo", ofType: "")
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "'" + isoutil! + "' -i '" + ISOFile + "' -x '/SYSTEM.CNF;1'"]
            
        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe
            
        task.launch()
            
        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
            print(output)
        }
            
        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
            print(error)
        }
            
        task.waitUntilExit()
        let status = task.terminationStatus
        return (output, error, status)
    }
    
    func FindGameTitle(GameID: String) -> String {
        if !GameID.isEmpty {
            do {
                let PS2DBContent = try String(contentsOfFile: Utils().CDrivePath + "/PS4/ps2ids.txt", encoding: .utf8)
                let GameIDs = PS2DBContent.components(separatedBy: .newlines)
                
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
    
    func FormatGameID(GameID: String) -> String {
        return GameID.components(separatedBy: ":\\")[1].replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "_", with: "", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: ";1", with: "", options: NSString.CompareOptions.literal, range: nil)
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
        
        // Set disc count
        var DiscCount: Int = 1
        if !Disc2TextField.stringValue.isEmpty {
            DiscCount += 1
        }
        if !Disc3TextField.stringValue.isEmpty {
            DiscCount += 1
        }
        if !Disc4TextField.stringValue.isEmpty {
            DiscCount += 1
        }
        if !Disc5TextField.stringValue.isEmpty {
            DiscCount += 1
        }
        
        fPKGBuilderProgressIndicator.stopAnimation(nil)
        fPKGBuilderProgressIndicator.isIndeterminate = false
        fPKGBuilderProgressIndicator.doubleValue = 0
        fPKGBuilderStatusTextField.stringValue = "Removing old fPKG build folder"
        usleep(150000)
        
        // Remove previous fPKG GP4 project
        if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PS2fPKG.gp4") {
            do {
                try FileManager.default.removeItem(atPath: Utils().CDrivePath + "/Cache/PS2fPKG.gp4")
            } catch (let error) {
                print(error)
            }
        }
        
        // Remove previous fPKG project folder
        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PS2fPKG", isDirectory: &isDir) {
            do {
                try FileManager.default.removeItem(atPath: Utils().CDrivePath + "/Cache/PS2fPKG")
            } catch (let error) {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10
        fPKGBuilderStatusTextField.stringValue = "Preparing the PS2 emulator"
        usleep(150000)
        
        // Copy the selected PS2 emulator to the new project folder
        if EmulatorsComboBox.stringValue == "Jak v2" {
            if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/PS4/emus/Jakv2", isDirectory: &isDir) {
                do {
                    try FileManager.default.copyItem(atPath: Utils().CDrivePath + "/PS4/emus/Jakv2", toPath: Utils().CDrivePath + "/Cache/PS2fPKG")
                } catch (let error) {
                    print(error)
                }
            }
        }
        else if EmulatorsComboBox.stringValue == "Rogue v1" {
            if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/PS4/emus/Roguev1", isDirectory: &isDir) {
                do {
                    try FileManager.default.copyItem(atPath: Utils().CDrivePath + "/PS4/emus/Roguev1", toPath: Utils().CDrivePath + "/Cache/PS2fPKG")
                } catch (let error) {
                    print(error)
                }
            }
        }
          
        // Copy the selected icon to the project folder
        if !IconTextField.stringValue.isEmpty {
            do {
                try FileManager.default.copyItem(atPath: IconTextField.stringValue, toPath: Utils().CDrivePath + "/Cache/PS2fPKG/sce_sys/icon0.png")
            } catch (let error) {
                print(error)
            }
        }
        
        // Copy the selected background to the project folder
        if !BackgroundTextField.stringValue.isEmpty {
            do {
                try FileManager.default.copyItem(atPath: IconTextField.stringValue, toPath: Utils().CDrivePath + "/Cache/PS2fPKG/sce_sys/pic0.png")
            } catch (let error) {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10 //20
        fPKGBuilderStatusTextField.stringValue = "Creating param.sfo file, please wait"
        usleep(150000)
        
        // Create a new param.sfo file
        CreateParamSFO(GameTitle: GameTitleTextField.stringValue)
        if FileManager.default.fileExists(atPath: Utils().ToolsPath + "/param.sfo") {
              
            //Delete default param.sfo if exists
            if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PS2fPKG/sce_sys/param.sfo") {
                do {
                    try FileManager.default.removeItem(atPath: Utils().CDrivePath + "/Cache/PS2fPKG/sce_sys/param.sfo")
                } catch (let error) {
                    print(error)
                }
            }
            
            // Move the new param.sfo to the sce_sys folder
            do {
                try FileManager.default.moveItem(atPath: Utils().ToolsPath + "/param.sfo", toPath: Utils().CDrivePath + "/Cache/PS2fPKG/sce_sys/param.sfo")
            } catch (let error) {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10 //30
        fPKGBuilderStatusTextField.stringValue = "Configurating PS2 Emulator, please wait"
        usleep(150000)
        
        // If config already exists, remove it
        let ConfigDestinationPath: String = Utils().CDrivePath + "/Cache/PS2fPKG/config-emu-ps4.txt"
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
            // Required config
            let NewPS2EmulatorConfig: [String] = [
                "--path-vmc=\"/tmp/vmc\"\n",
                "--config-local-lua=\"\"\n",
                "--ps2-title-id=" + CurrentGameID,
                "\n--max-disc-num=" + String(DiscCount),
                "\n--gs-uprender=" + UprenderComboBox.stringValue.lowercased(),
                "\n--gs-upscale=" + UpscalingComboBox.stringValue.lowercased(),
                "\n--host-audio=1\n",
                "--rom=\"PS20220WD20050620.crack\"\n",
                "--verbose-cdvd-reads=0\n",
                "--host-display-mode=" + DisplayModeComboBox.stringValue.lowercased()
            ]
            let NewPS2EmulatorConfigContent: String = NewPS2EmulatorConfig.joined()
            ConfigWriter!.write(NewPS2EmulatorConfigContent.data(using: .utf8)!)
            
            // Restart emulator on disc change config
            if RestartEmuOnDiscChangeCheckBox.state == .on {
                ConfigWriter!.write("#Disable emu reset on disc change".data(using: .utf8)!)
                ConfigWriter!.write("--switch-disc-reset=0".data(using: .utf8)!)
            }
            
            // Multitap config
            if MultitapComboBox.indexOfSelectedItem == 1 {
                ConfigWriter!.write("#Enable Multitap on port 1".data(using: .utf8)!)
                ConfigWriter!.write("--mtap1=always".data(using: .utf8)!)
            }
            else if MultitapComboBox.indexOfSelectedItem == 2 {
                ConfigWriter!.write("#Enable Multitap on port 2".data(using: .utf8)!)
                ConfigWriter!.write("--mtap2=always".data(using: .utf8)!)
            }
            else if MultitapComboBox.indexOfSelectedItem == 3 {
                ConfigWriter!.write("#Enable Multitap on both ports".data(using: .utf8)!)
                ConfigWriter!.write("--mtap1=always".data(using: .utf8)!)
                ConfigWriter!.write("--mtap2=always".data(using: .utf8)!)
            }
            
            // Emulator fixes
            if ImproveSpeedCheckBox.state == .on {
                ConfigWriter!.write("#Improve Speed".data(using: .utf8)!)
                ConfigWriter!.write("-vu0-opt-flags=1".data(using: .utf8)!)
                ConfigWriter!.write("--vu1-opt-flags=1".data(using: .utf8)!)
                ConfigWriter!.write("--cop2-opt-flags=1".data(using: .utf8)!)
                ConfigWriter!.write("--vu0-const-prop=0".data(using: .utf8)!)
                ConfigWriter!.write("--vu1-const-prop=0".data(using: .utf8)!)
                ConfigWriter!.write("--vu1-jr-cache-policy=newprog".data(using: .utf8)!)
                ConfigWriter!.write("--vu1-jalr-cache-policy=newprog".data(using: .utf8)!)
                ConfigWriter!.write("--vu0-jr-cache-policy=newprog".data(using: .utf8)!)
                ConfigWriter!.write("--vu0-jalr-cache-policy=newprog".data(using: .utf8)!)
            }
            if FixGraphicsCheckBox.state == .on {
                ConfigWriter!.write("#Fix Graphics".data(using: .utf8)!)
                ConfigWriter!.write("--fpu-no-clamping=0".data(using: .utf8)!)
                ConfigWriter!.write("--fpu-clamp-results=1".data(using: .utf8)!)
                ConfigWriter!.write("--vu0-no-clamping=0".data(using: .utf8)!)
                ConfigWriter!.write("--vu0-clamp-results=1".data(using: .utf8)!)
                ConfigWriter!.write("--vu1-no-clamping=0".data(using: .utf8)!)
                ConfigWriter!.write("--vu1-clamp-results=1".data(using: .utf8)!)
                ConfigWriter!.write("--cop2-no-clamping=0".data(using: .utf8)!)
                ConfigWriter!.write("--cop2-clamp-results=1".data(using: .utf8)!)
            }
            if DisableMTVUCheckBox.state == .on {
                ConfigWriter!.write("#Disable MTVU".data(using: .utf8)!)
                ConfigWriter!.write("--vu1=jit-sync".data(using: .utf8)!)
            }
            if DisableInstantVIF1TransferCheckBox.state == .on {
                ConfigWriter!.write("#Disable Instant VIF1 Transfer".data(using: .utf8)!)
                ConfigWriter!.write("--vif1-instant-xfer=0".data(using: .utf8)!)
            }
            
            ConfigWriter!.closeFile()
        }
        
        // Append custom config
        if !TXTConfigTextField.stringValue.isEmpty {
            let AdditionalConfig = try? String(contentsOfFile: TXTConfigTextField.stringValue, encoding: .utf8)
             if let NewFileHandle = FileHandle(forWritingAtPath: ConfigDestinationPath) {
                 NewFileHandle.seekToEndOfFile()
                 if let DataToWrite = AdditionalConfig!.data(using: .utf8) {
                     NewFileHandle.write("#User Config".data(using: .utf8)!)
                     NewFileHandle.write(DataToWrite)
                 }
                 NewFileHandle.closeFile()
             }
        }
        
        // Add Memory Card if selected
        if !PS2MemoryCardTextField.stringValue.isEmpty {
            
            var AdjustedGameID: String = CurrentGameID
            AdjustedGameID.insert("-", at: AdjustedGameID.index(AdjustedGameID.startIndex, offsetBy: 4))
            
            // Create feature_data folder
            if !FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PS2fPKG/feature_data", isDirectory: &isDir) {
                do {
                    try FileManager.default.createDirectory(atPath: Utils().CDrivePath + "/Cache/PS2fPKG/feature_data", withIntermediateDirectories: false)
                    try FileManager.default.createDirectory(atPath: Utils().CDrivePath + "/Cache/PS2fPKG/feature_data/" + AdjustedGameID, withIntermediateDirectories: false)
                } catch (let error) {
                    print(error)
                }
            }
            
            // Copy Memory Card to feature_data
            if FileManager.default.fileExists(atPath: PS2MemoryCardTextField.stringValue) {
                do {
                    try FileManager.default.copyItem(atPath: PS2MemoryCardTextField.stringValue, toPath: Utils().CDrivePath + "/Cache/PS2fPKG/feature_data/" + AdjustedGameID + "/custom.card")
                } catch (let error) {
                    print(error)
                }
            }
            
        }
        
        if !FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PS2fPKG/image", isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(atPath: Utils().CDrivePath + "/Cache/PS2fPKG/image", withIntermediateDirectories: false)
            } catch (let error) {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10 //40
        fPKGBuilderStatusTextField.stringValue = "PS2 emulator configuration done. Creating now the GP4 project"
        usleep(150000)
        
        // Generate a GP4 project and modify it
        CreateGP4Project()
        if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PS2fPKG.gp4") {
            
            fPKGBuilderProgressIndicator.doubleValue += 20 //60
            fPKGBuilderStatusTextField.stringValue = "GP4 project created. Preparing disc(s)"
            usleep(100000)
            
            var FullDiscInfo: String = ""
            
            // Copy selected discs to the inner Games folder (if not already exists) & add to GP4 project file
            let Disc1BaseFileNameWithExt: String = URL(fileURLWithPath: Disc1TextField.stringValue).lastPathComponent
            let Disc1BaseFileName: String = Disc1BaseFileNameWithExt.replacingOccurrences(of: ".iso", with: "")
            let Disc1ISOFilePath: String = "C:\\Games\\" + Disc1BaseFileName + ".iso"
            let Disc1ISOFileName: String = URL(string: Disc1TextField.stringValue)!.lastPathComponent
            if FileManager.default.fileExists(atPath: Disc1TextField.stringValue) && !FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Games/" + Disc1ISOFileName) {
                do {
                    try FileManager.default.copyItem(atPath: Disc1TextField.stringValue, toPath: Utils().CDrivePath + "/Games/" + Disc1ISOFileName)
                    let NewDiscInfo = [FullDiscInfo, "\n    <file targ_path=\"image/disc01.iso\" orig_path=\"\(Disc1ISOFilePath)\" pfs_compression=\"enable\"/>"]
                    FullDiscInfo = NewDiscInfo.joined()
                } catch (let error) {
                    print(error)
                }
            }
            if !Disc2TextField.stringValue.isEmpty {
                let Disc2BaseFileNameWithExt: String = URL(fileURLWithPath: Disc2TextField.stringValue).lastPathComponent
                let Disc2BaseFileName: String = Disc2BaseFileNameWithExt.replacingOccurrences(of: ".iso", with: "")
                let Disc2ISOFilePath: String = "C:\\Games\\" + Disc2BaseFileName + ".iso"
                let Disc2ISOFileName: String = URL(string: Disc2TextField.stringValue)!.lastPathComponent
                if FileManager.default.fileExists(atPath: Disc2TextField.stringValue) && !FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Games/" + Disc2ISOFileName) {
                    do {
                        try FileManager.default.copyItem(atPath: Disc2TextField.stringValue, toPath: Utils().CDrivePath + "/Games/" + Disc2ISOFileName)
                        let NewDiscInfo = [FullDiscInfo, "\n    <file targ_path=\"image/disc02.iso\" orig_path=\"\(Disc2ISOFilePath)\" pfs_compression=\"enable\"/>"]
                        FullDiscInfo = NewDiscInfo.joined()
                    } catch (let error) {
                        print(error)
                    }
                }
            }
            if !Disc3TextField.stringValue.isEmpty {
                let Disc3BaseFileNameWithExt: String = URL(fileURLWithPath: Disc3TextField.stringValue).lastPathComponent
                let Disc3BaseFileName: String = Disc3BaseFileNameWithExt.replacingOccurrences(of: ".iso", with: "")
                let Disc3ISOFilePath: String = "C:\\Games\\" + Disc3BaseFileName + ".iso"
                let Disc3ISOFileName: String = URL(string: Disc3TextField.stringValue)!.lastPathComponent
                if FileManager.default.fileExists(atPath: Disc3TextField.stringValue) && !FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Games/" + Disc3ISOFileName) {
                    do {
                        try FileManager.default.copyItem(atPath: Disc3TextField.stringValue, toPath: Utils().CDrivePath + "/Games/" + Disc3ISOFileName)
                        let NewDiscInfo = [FullDiscInfo, "\n    <file targ_path=\"image/disc03.iso\" orig_path=\"\(Disc3ISOFilePath)\" pfs_compression=\"enable\"/>"]
                        FullDiscInfo = NewDiscInfo.joined()
                    } catch (let error) {
                        print(error)
                    }
                }
            }
            if !Disc4TextField.stringValue.isEmpty {
                let Disc4BaseFileNameWithExt: String = URL(fileURLWithPath: Disc4TextField.stringValue).lastPathComponent
                let Disc4BaseFileName: String = Disc4BaseFileNameWithExt.replacingOccurrences(of: ".iso", with: "")
                let Disc4ISOFilePath: String = "C:\\Games\\" + Disc4BaseFileName + ".iso"
                let Disc4ISOFileName: String = URL(string: Disc4TextField.stringValue)!.lastPathComponent
                if FileManager.default.fileExists(atPath: Disc4TextField.stringValue) && !FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Games/" + Disc4ISOFileName) {
                    do {
                        try FileManager.default.copyItem(atPath: Disc4TextField.stringValue, toPath: Utils().CDrivePath + "/Games/" + Disc4ISOFileName)
                        let NewDiscInfo = [FullDiscInfo, "\n    <file targ_path=\"image/disc04.iso\" orig_path=\"\(Disc4ISOFilePath)\" pfs_compression=\"enable\"/>"]
                        FullDiscInfo = NewDiscInfo.joined()
                    } catch (let error) {
                        print(error)
                    }
                }
            }
            if !Disc5TextField.stringValue.isEmpty {
                let Disc5BaseFileNameWithExt: String = URL(fileURLWithPath: Disc5TextField.stringValue).lastPathComponent
                let Disc5BaseFileName: String = Disc5BaseFileNameWithExt.replacingOccurrences(of: ".iso", with: "")
                let Disc5ISOFilePath: String = "C:\\Games\\" + Disc5BaseFileName + ".iso"
                let Disc5ISOFileName: String = URL(string: Disc5TextField.stringValue)!.lastPathComponent
                if FileManager.default.fileExists(atPath: Disc5TextField.stringValue) && !FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Games/" + Disc5ISOFileName) {
                    do {
                        try FileManager.default.copyItem(atPath: Disc5TextField.stringValue, toPath: Utils().CDrivePath + "/Games/" + Disc5ISOFileName)
                        let NewDiscInfo = [FullDiscInfo, "\n    <file targ_path=\"image/disc05.iso\" orig_path=\"\(Disc5ISOFilePath)\" pfs_compression=\"enable\"/>"]
                        FullDiscInfo = NewDiscInfo.joined()
                    } catch (let error) {
                        print(error)
                    }
                }
            }
            
            // Modify the GP4 project
            do {
                var fileContents = try String(contentsOfFile: Utils().CDrivePath + "/Cache/PS2fPKG.gp4", encoding: .utf8)
                fileContents = fileContents.replacingOccurrences(of: "<?xml version=\"1.1\"", with: "<?xml version=\"1.0\"")
                fileContents = fileContents.replacingOccurrences(of: "<scenarios default_id=\"1\">", with: "<scenarios default_id=\"0\">")
                fileContents = fileContents.replacingOccurrences(of: "</files>", with: "\(FullDiscInfo)\n</files>")
                
                try fileContents.write(toFile: Utils().CDrivePath + "/Cache/PS2fPKG.gp4", atomically: false, encoding: .utf8)
            } catch {
                print(error)
            }
            
            fPKGBuilderProgressIndicator.doubleValue += 20 //80
            fPKGBuilderStatusTextField.stringValue = "Disc(s) copied & GP4 project modified. fPKG will be built after user confirmation"
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
            let PKGFileName: String = "UP9000-" + CurrentGameID + "_00-" + CurrentGameID + "PS2FPKG-A0100-V0100.pkg"
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
    
    func ExtractFileFromISO(ISOFile: String, FileToExtract: String) -> String {
        // Extracts the specified file into the Tools directory
        let unAr = Bundle.main.path(forResource: "unar", ofType: "")
        let task = Process()
        
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "'" + unAr! + "' -f -o '" + Utils().ToolsPath + "/' '" + ISOFile + "' " + FileToExtract]
        task.launch()
        task.waitUntilExit()
        
        let OutputFolderName: String = URL(string: ISOFile)!.deletingPathExtension().lastPathComponent
        // Check if file has been extracted successfully
        if FileManager.default.fileExists(atPath: Utils().ToolsPath + "/" + OutputFolderName + "/" + FileToExtract) {
            return Utils().ToolsPath + "/" + OutputFolderName + "/" + FileToExtract
        }
        else
        {
            return ""
        }
    }
    
    func CreateParamSFO(GameTitle: String) {
        let SFOUtil = Bundle.main.path(forResource: "sfoutil", ofType: "")
        let ContentID: String = "UP9000-" + CurrentGameID + "_00-" + CurrentGameID + "PS2FPKG"
        let DestinationPath: String = "'" + Utils().ToolsPath + "/param.sfo'"
        let task = Process()

        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "'" + SFOUtil! + "' --force --new-file " + DestinationPath + " --add int APP_TYPE 1 --add str APP_VER \"01.00\" --add int ATTRIBUTE 0 --add str CATEGORY \"gd\" --add str CONTENT_ID \"\(ContentID)\" --add int DOWNLOAD_DATA_SIZE 0 --add str FORMAT \"obs\" --add int PARENTAL_LEVEL 5 --add int SYSTEM_VER 0 --add str TITLE \"" + GameTitle + "\" --add str TITLE_ID \"\(NPTitleTextField.stringValue)\" --add str VERSION \"01.00\""]
        
        task.launch()
        task.waitUntilExit()
    }
    
    func CreateGP4Project() {
        let task = Process()
        
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "'" + Utils().ToolsPath + "/gengp4_ps2'"]
        task.launch()
        task.waitUntilExit()
    }
    
    func BuildPKG() {
        let task = Process()
        
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "'" + Utils().ToolsPath + "/make_fPKG_PS2'"]
        task.launch()
        task.waitUntilExit()
    }
    
}
