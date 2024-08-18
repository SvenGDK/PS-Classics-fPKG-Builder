//
//  PSPClassicsViewController.swift
//  PS Mac Tools
//
//  Created by SvenGDK on 14/08/2024.
//

import Foundation
import AppKit

class PSPClassicsViewController: NSViewController {
    
    var CurrentGameID: String = ""
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    @IBOutlet weak var BuildfPKGButton: NSButton!
    @IBOutlet weak var ProgressTextField: NSTextField!
    @IBOutlet weak var fPKGBuilderProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var fPKGBuilderSpinningIndicator: NSProgressIndicator!
    @IBOutlet weak var fPKGBuilderStatusTextField: NSTextField!
    
    @IBOutlet weak var GameTitleTextField: NSTextField!
    @IBOutlet weak var NPTitleTextField: NSTextField!
    @IBOutlet weak var IconTextField: NSTextField!
    @IBOutlet weak var BackgroundTextField: NSTextField!
    @IBOutlet weak var GameISOTextField: NSTextField!
    @IBOutlet weak var CustomConfigTextField: NSTextField!
    
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
    
    @IBAction func BrowseGameISO(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select your PSP ISO file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().ISOType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            let FilePath: String = result!.path
            
            // Check if game is a PSP ISO (error output needs to be checked here)
            let ISOReaderOutput = CheckPSPGame(ISOFile: FilePath).error
            if !ISOReaderOutput.isEmpty {
                
                // Extract UMD_DATA.BIN
                let ExtractedUMDDataPath: String = ExtractFileFromISO(ISOFile: FilePath, FileToExtract: "UMD_DATA.BIN")
    
                // Read UMD_DATA.BIN
                if FileManager.default.fileExists(atPath: ExtractedUMDDataPath) {
                    
                    let UMDData = ReadUMDData(FileToRead: ExtractedUMDDataPath, Offset: 0, Length: 10)
                    let NPTitle = String(bytes: UMDData!, encoding: .ascii)?.replacingOccurrences(of: "-", with: "") ?? ""
                    let GameTitle = result!.deletingPathExtension().lastPathComponent.replacingOccurrences(of: "(.*?)", with: "", options: .regularExpression).replacingOccurrences(of: " {2,}", with: "", options: .regularExpression).replacingOccurrences(of: "_", with: " ")
                
                    NPTitleTextField.stringValue = NPTitle
                    GameTitleTextField.stringValue = GameTitle
                    CurrentGameID = NPTitle
                }
                
                GameISOTextField.stringValue = result!.path
                BuildfPKGButton.isEnabled = true
            }
            else
            {
                // No valid PSP ISO
            }
            
        } else {
            return
        }
    }
    
    @IBAction func BrowseCustomConfig(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select a custom config file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [Utils().TXTType]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            CustomConfigTextField.stringValue = result!.path
        } else {
            return
        }
    }
    
    func CheckPSPGame(ISOFile: String) -> (output: [String], error: [String], exitCode: Int32) {
        var output : [String] = []
        var error : [String] = []
            
        let isoutil = Bundle.main.path(forResource: "isoinfo", ofType: "")
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "'" + isoutil! + "' -i '" + ISOFile + "' -x 'PSP_GAME/PARAM.SFO'"]
        
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
    
    func ReadUMDData(FileToRead: String, Offset: Int64, Length: Int) -> [UInt8]? {
        var offset: Int64 = Offset
        var newByte = [UInt8](repeating: 0, count: Length)
        if let fileHandle = FileHandle(forReadingAtPath: FileToRead) {
            let baseStreamLength = fileHandle.seekToEndOfFile()
            fileHandle.seek(toFileOffset: UInt64(offset))
            var num = 0
            
            while offset < baseStreamLength && num < Length {
                let byte = fileHandle.readData(ofLength: 1)
                if let byteValue = byte.first {
                    newByte[num] = byteValue
                    offset += 1
                    num += 1
                } else {
                    break
                }
            }
            fileHandle.closeFile()
        }
        return newByte
    }
    
    func WriteData(FileToWrite: String, Offset: Int64, DataToWrite: String) {
        if let fileHandle = FileHandle(forWritingAtPath: FileToWrite) {
            let newStringArray = DataToWrite.split(separator: "-").map { String($0) }
            fileHandle.seek(toFileOffset: UInt64(Offset))
            for str in newStringArray {
                if let intValue = Int(str, radix: 16) {
                    fileHandle.write(Data([UInt8(intValue)]))
                }
            }
            fileHandle.closeFile()
        }
    }
    
    func FindOffset(FileName: String, Query: [UInt8]) -> Int64? {
        var returnLength: Int64 = -1
        if let fileHandle = FileHandle(forReadingAtPath: FileName) {
            let baseStreamLength = fileHandle.seekToEndOfFile()
            fileHandle.seek(toFileOffset: 0)

            if Query.count <= baseStreamLength {
                var newByteArray = [UInt8](repeating: 0, count: Query.count)
                let bytesRead = fileHandle.readData(ofLength: Query.count)
                newByteArray = Array(bytesRead)
                var flag = false
                let newQueryLength = Query.count - 1
                var whileInt = 0

                while whileInt <= newQueryLength {
                    if newByteArray[whileInt] == Query[whileInt] {
                        flag = true
                        whileInt += 1
                    } else {
                        flag = false
                        break
                    }
                }

                if !flag {
                    let newBaseStreamLength = baseStreamLength - 1
                    let queryLength = Query.count
                    var queryOffset = queryLength

                    while queryOffset <= newBaseStreamLength {
                        newByteArray.removeFirst()
                        newByteArray.append(fileHandle.readData(ofLength: 1).first ?? 0)
                        var num3 = 0
                        while num3 <= newQueryLength {
                            if newByteArray[num3] == Query[num3] {
                                flag = true
                                num3 += 1
                            } else {
                                flag = false
                                break
                            }
                        }
                        if !flag {
                            queryOffset += 1
                        } else {
                            returnLength = Int64(queryOffset) - Int64(queryLength - 1)
                            break
                        }
                    }
                } else {
                    returnLength = 0
                }
            }
            fileHandle.closeFile()
        }
        return returnLength
    }
    
    func DecryptEBOOT(EBOOTFile: String) {
        // Extracts the specified file into the Tools directory
        let pspdecrypt = Bundle.main.path(forResource: "pspdecrypt", ofType: "")
        let task = Process()
        
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "'" + pspdecrypt! + "' '" + EBOOTFile + "'"]
        task.launch()
        task.waitUntilExit()
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
        if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PSPfPKG.gp4") {
            do {
                try FileManager.default.removeItem(atPath: Utils().CDrivePath + "/Cache/PSPfPKG.gp4")
            } catch (let error) {
                print(error)
            }
        }
        
        // Remove previous fPKG project folder
        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PSPfPKG", isDirectory: &isDir) {
            do {
                try FileManager.default.removeItem(atPath: Utils().CDrivePath + "/Cache/PSPfPKG")
            } catch (let error) {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10
        fPKGBuilderStatusTextField.stringValue = "Preparing the PSP emulator"
        usleep(150000)
        
        // Copy the PS1 emulator to the new project folder
        if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/PS4/emus/psphd", isDirectory: &isDir) {
            do {
                try FileManager.default.copyItem(atPath: Utils().CDrivePath + "/PS4/emus/psphd", toPath: Utils().CDrivePath + "/Cache/PSPfPKG")
            } catch (let error) {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10 //20
        
        // Copy the selected icon to the project folder
        if !IconTextField.stringValue.isEmpty {
            do {
                try FileManager.default.copyItem(atPath: IconTextField.stringValue, toPath: Utils().CDrivePath + "/Cache/PSPfPKG/sce_sys/icon0.png")
            } catch (let error) {
                print(error)
            }
        }
        
        // Copy the selected background to the project folder
        if !BackgroundTextField.stringValue.isEmpty {
            do {
                try FileManager.default.copyItem(atPath: IconTextField.stringValue, toPath: Utils().CDrivePath + "/Cache/PSPfPKG/sce_sys/pic0.png")
            } catch (let error) {
                print(error)
            }
        }
        
        // Get PSP EBOOT
        let SelectedISOFile: String = GameISOTextField.stringValue
        let ExtractedEBOOTPath: String = ExtractFileFromISO(ISOFile: SelectedISOFile, FileToExtract: "PSP_GAME/SYSDIR/EBOOT.BIN")
        let DecryptedEBOOTPath: String = ExtractedEBOOTPath.appending(".dec")
        
        if !FileManager.default.fileExists(atPath: ExtractedEBOOTPath) {
            do {
                // Copy ISO file to fPKG cache
                try FileManager.default.copyItem(atPath: SelectedISOFile, toPath: Utils().CDrivePath + "/Cache/PSPfPKG/data/USER_L0.IMG")
                
                fPKGBuilderProgressIndicator.doubleValue += 10 //30
                fPKGBuilderStatusTextField.stringValue = "Waiting for user input"
                usleep(150000)
                
                let IncompatibilityAlert = NSAlert()
                IncompatibilityAlert.informativeText = "Warning: This game may not work!"
                IncompatibilityAlert.messageText = "Cannot read the EBOOT.BIN file from the ISO."
                IncompatibilityAlert.runModal()
            } catch (let error) {
                print(error)
            }
        }
        else
        {
            fPKGBuilderProgressIndicator.doubleValue += 10 //30
            fPKGBuilderStatusTextField.stringValue = "Decrypting PSP EBOOT & modifying final image"
            usleep(150000)
            
            // Decrypt extracted EBOOT file
            DecryptEBOOT(EBOOTFile: ExtractedEBOOTPath)
            
            // Copy ISO file to fPKG cache
            do {
                try FileManager.default.copyItem(atPath: SelectedISOFile, toPath: Utils().CDrivePath + "/Cache/PSPfPKG/data/USER_L0.IMG")
            } catch (let error) {
                print(error)
            }
            
            let NewFileInfo = try? FileManager.default.attributesOfItem(atPath: ExtractedEBOOTPath)
            let FileLength = (NewFileInfo?[.size] as? NSNumber)?.int64Value ?? 0
            let CappedFileLength = min(FileLength, 512320)
            
            if let TempEBOOTByteArray = ReadUMDData(FileToRead: ExtractedEBOOTPath, Offset: 0, Length: Int(CappedFileLength)),
               let OffsetValue = FindOffset(FileName: Utils().CDrivePath + "/Cache/PSPfPKG/data/USER_L0.IMG", Query: TempEBOOTByteArray) {
                let DecTempEBOOTByteArray = ReadUMDData(FileToRead: DecryptedEBOOTPath, Offset: 0, Length: Int(FileLength))
                let DataString = DecTempEBOOTByteArray?.map { String(format: "%02X", $0) }.joined(separator: "-") ?? ""
                
                // Modify ISO
                WriteData(FileToWrite: Utils().CDrivePath + "/Cache/PSPfPKG/data/USER_L0.IMG", Offset: OffsetValue, DataToWrite: DataString)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10 //40
        fPKGBuilderStatusTextField.stringValue = "Removing temporary files"
        usleep(150000)
        
        // Remove temporary files
        if FileManager.default.fileExists(atPath: ExtractedEBOOTPath) {
            do {
                try FileManager.default.removeItem(atPath: ExtractedEBOOTPath)
            } catch (let error) {
                print(error)
            }
        }
        if FileManager.default.fileExists(atPath: DecryptedEBOOTPath) {
            do {
                try FileManager.default.removeItem(atPath: DecryptedEBOOTPath)
            } catch (let error) {
                print(error)
            }
        }
        
        // If config already exists, remove it
        let ConfigDestinationPath: String = Utils().CDrivePath + "/Cache/PSPfPKG/config-title.txt"
        if FileManager.default.fileExists(atPath: ConfigDestinationPath)
        {
            do {
                try FileManager.default.removeItem(atPath: ConfigDestinationPath)
            } catch (let error) {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10 //50
        fPKGBuilderStatusTextField.stringValue = "Configurating PSP Emulator, please wait"
        usleep(150000)
        
        // Create a new config file
        FileManager.default.createFile(atPath: ConfigDestinationPath, contents:Data(" ".utf8), attributes: nil)
        let ConfigWriter = FileHandle(forWritingAtPath: ConfigDestinationPath)
        if ConfigWriter == nil { }
        else
        {
            // Required config
            let PSPEmulatorConfig: String = """
            --ps4-trophies=0
            --ps5-uds=0
            --trophies=0
            --image="data/USER_L0.IMG"
            --antialias=SSAA4x
            --multisaves=true
            --notrophies=true

            """
            
            ConfigWriter!.write(PSPEmulatorConfig.data(using: .utf8)!)
            ConfigWriter!.closeFile()
        }
        
        // Append custom config
        if !CustomConfigTextField.stringValue.isEmpty {
            let AdditionalConfig = try? String(contentsOfFile: CustomConfigTextField.stringValue, encoding: .utf8)
             if let NewFileHandle = FileHandle(forWritingAtPath: ConfigDestinationPath) {
                 NewFileHandle.seekToEndOfFile()
                 if let DataToWrite = AdditionalConfig!.data(using: .utf8) {
                     NewFileHandle.write(DataToWrite)
                 }
                 NewFileHandle.closeFile()
             }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10 //60
        fPKGBuilderStatusTextField.stringValue = "PSP emulator configuration done. Creating now the param.sfo file, please wait"
        usleep(150000)
        
        // Create a new param.sfo file
        CreateParamSFO(GameTitle: GameTitleTextField.stringValue)
        if FileManager.default.fileExists(atPath: Utils().ToolsPath + "/param.sfo") {
              
            //Delete default param.sfo if exists
            if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PSPfPKG/sce_sys/param.sfo") {
                do {
                    try FileManager.default.removeItem(atPath: Utils().CDrivePath + "/Cache/PSPfPKG/sce_sys/param.sfo")
                } catch (let error) {
                    print(error)
                }
            }
            
            // Move the new param.sfo to the sce_sys folder
            do {
                try FileManager.default.moveItem(atPath: Utils().ToolsPath + "/param.sfo", toPath: Utils().CDrivePath + "/Cache/PSPfPKG/sce_sys/param.sfo")
            } catch (let error) {
                print(error)
            }
        }
        
        fPKGBuilderProgressIndicator.doubleValue += 10 //70
        fPKGBuilderStatusTextField.stringValue = "Param.sfo file created. Creating GP4 project"
        usleep(150000)
        
        // Generate a GP4 project and modify it
        CreateGP4Project()
        if FileManager.default.fileExists(atPath: Utils().CDrivePath + "/Cache/PSPfPKG.gp4") {
            
            // Modify the GP4 project
            do {
                var fileContents = try String(contentsOfFile: Utils().CDrivePath + "/Cache/PSPfPKG.gp4", encoding: .utf8)
                fileContents = fileContents.replacingOccurrences(of: "<?xml version=\"1.1\"", with: "<?xml version=\"1.0\"")
                fileContents = fileContents.replacingOccurrences(of: "<scenarios default_id=\"1\">", with: "<scenarios default_id=\"0\">")
                try fileContents.write(toFile: Utils().CDrivePath + "/Cache/PSPfPKG.gp4", atomically: false, encoding: .utf8)
            } catch {
                print(error)
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
            let PKGFileName: String = "UP9000-" + CurrentGameID + "_00-" + CurrentGameID + "PSPFPKG-A0100-V0100.pkg"
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
    
    @IBAction func BuildfPKG(_ sender: NSButton) {
        
        let MissingInfoAlert = NSAlert()
        MissingInfoAlert.addButton(withTitle: "Close")
        
        if GameISOTextField.stringValue.isEmpty {
            MissingInfoAlert.messageText = "Game ISO is missing, cannot continue."
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
    
    func CreateParamSFO(GameTitle: String) {
        let SFOUtil = Bundle.main.path(forResource: "sfoutil", ofType: "")
        let ContentID: String = "UP9000-" + CurrentGameID + "_00-" + CurrentGameID + "PSPFPKG"
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
        task.arguments = ["-c", "'" + Utils().ToolsPath + "/gengp4_psp'"]
        task.launch()
        task.waitUntilExit()
    }
    
    func BuildPKG() {
        let task = Process()
        
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "'" + Utils().ToolsPath + "/make_fPKG_PSP'"]
        task.launch()
        task.waitUntilExit()
    }
    
}
