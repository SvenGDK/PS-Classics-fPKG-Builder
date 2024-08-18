//
//  Utils.swift
//  fPKG Builder
//
//  Created by SvenGDK on 17/08/2024.
//

import Foundation
import UniformTypeIdentifiers

class Utils {
    
    // UTTypes for file selection filters
    public let BINType: UTType = UTType(tag: "bin", tagClass: .filenameExtension, conformingTo: .archive)!
    public let ISOType: UTType = UTType(tag: "iso", tagClass: .filenameExtension, conformingTo: .diskImage)!
    public let PNGType: UTType = UTType(tag: "png", tagClass: .filenameExtension, conformingTo: .png)!
    public let TXTType: UTType = UTType(tag: "txt", tagClass: .filenameExtension, conformingTo: .text)!
    
    // Frequently used paths
    public let ToolsPath: String = Bundle.main.bundleURL.deletingLastPathComponent().path + "/Tools"
    public let CDrivePath: String = Bundle.main.bundleURL.deletingLastPathComponent().path + "/Tools/Resources/wine-prefix/drive_c"
    
}
