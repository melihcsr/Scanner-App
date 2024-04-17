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
            }
            .navigationTitle("Scan OCR")
            .navigationBarItems(trailing: Button(action: {
                self.showScannerSheet = true
            }, label: {
                Image(systemName: "doc.text.viewfinder")
                    .font(.title)
            }))
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
