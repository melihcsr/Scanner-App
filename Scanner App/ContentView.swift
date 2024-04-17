//
//  ContentView.swift
//  Scanner App
//
//  Created by Melih Cesur on 16.04.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showScannerSheet = false
    @State private var showAlert = false
    @StateObject var vm = CoreDataViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Text Scanner")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 48)
                
                if vm.savedEntities.isEmpty {
                    Spacer()
                    Text("No scan yet")
                        .font(.title)
                        .foregroundColor(.black)
                } else {
                    GeometryReader { geometry in
                        ScrollView {
                            VStack {
                                ForEach(vm.savedEntities) { entity in
                                    NavigationLink(
                                        destination: detailView(for: entity, geometry: geometry)
                                         
                                            .background(.white)
                                         
                                        ,
                                        label: {
                                            listItem(for: entity)
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    showScannerSheet = true
                } label: {
                    createScannerButton()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .sheet(isPresented: $showScannerSheet) {
                makeScannerView()
            }
        }
    }
    
    func detailView(for entity: ScannedEntity, geometry: GeometryProxy) -> some View {
        VStack {
            ScrollView {
                Spacer()
                // Ensure to handle optional chaining for 'text'
                Text(entity.text ?? "")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.bottom, 60)
                    .padding()
            }
        
            .frame(width: geometry.size.width - 32, height: geometry.size.height)
           
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 3)
            )
            .cornerRadius(12)
            
            

            Spacer()

            Button {
                // Copy the text (ensure 'entity.text' is not nil)
                UIPasteboard.general.string = entity.text ?? ""
                showAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showAlert = false
                }
            } label: {
                copyTextButton()
            }
        }
       
       
    }
    
    func listItem(for entity: ScannedEntity) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.8))
                .frame(height: 60)
                .padding()
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            
            HStack {
                Text(entity.text ?? "")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.leading, 16)
                    .lineLimit(1)
                
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .padding(.trailing, 16)
            }
            .padding(.horizontal)
        }
    }
    
    func copyTextButton() -> some View {
        HStack {
            Spacer()
            Image(systemName: showAlert ? "checkmark" : "doc.on.doc")
                .foregroundColor(.white)
            Text(showAlert ? "Text Copied" : "Copy Text")
            Spacer()
        }
        .padding()
        .background(showAlert ? Color.green : Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
    
    func createScannerButton() -> some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 80, height: 80)
                .shadow(color: .gray, radius: 10, x: 0, y: -5)
                .offset(y: -30)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .offset(y: -30)
                )
            
            Image(systemName: "qrcode.viewfinder")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .offset(y: -30)
        }
    }
    
    private func makeScannerView() -> ScannerView {
        // ScannerView should be defined appropriately and imported.
        // ScannerView is supposed to return scanned text per page.
        ScannerView(completion: { textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                // Create a new ScanData
                let newScanData = ScanData(content: outputText)
                // Save the new scan data to Core Data
                vm.addScannedText(text: newScanData.content)
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
