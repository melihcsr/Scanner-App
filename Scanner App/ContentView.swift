//
//  ContentView.swift
//  Scanner App
//
//  Created by Melih Cesur on 16.04.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showScannerSheet = false
    @State private var texts: [ScanData] = []
    
    var body: some View {
        NavigationView {
            VStack {
                
                if texts.isEmpty {
                    Spacer()
                    Text("No scan yet")
                        .font(.title)
                } else {
                    List {
                        ForEach(texts) { text in
                            NavigationLink(
                                destination: ScrollView {
                                    Text(text.content)
                                },
                                label: {
                                    Text(text.content)
                                        .lineLimit(1)
                                }
                            )
                        }
                        
                    }
                }
                Spacer()
                
                
                Button{
                    self.showScannerSheet = true
                }label: {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 80, height: 80)
                            .shadow(color: .gray, radius: 10, x: 0, y: -5)
                            .offset(y: -30)  // Lift the button up a bit and position it partially outside the BottomBar
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                                    .offset(y: -30)
                            )
                        
                        // Scanner icon
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .offset(y: -30) // Align icon with button's offset
                    }
                }
                
                
                
                
            }
            
            .navigationTitle("Scan OCR")
            .sheet(isPresented: $showScannerSheet) {
                makeScannerView()
            }
          
            
        }
    }
    
    private func makeScannerView() -> ScannerView {
        // Make sure ScannerView is defined correctly
        ScannerView(completion: { textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(content: outputText)
                texts.append(newScanData)
            }
            showScannerSheet = false
        })
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
