//
//  ScanDate.swift
//  Scanner App
//
//  Created by Melih Cesur on 16.04.2024.
//

import Foundation


struct ScanData:Identifiable {
    var id = UUID()
    let content:String
    
    init(content:String) {
        self.content = content
    }
}
