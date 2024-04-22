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
                .padding(.top, 48)
                .padding(.leading,16)
                
                if vm.savedEntities.isEmpty {
                    Spacer()
                    Text("No scan yet")
                        .font(.title)
                        .foregroundColor(.black)
                } else {
                    GeometryReader { geometry in
                        List {
                            ForEach(vm.savedEntities) { entity in
                                NavigationLink(
                                    destination: detailView(for: entity, geometry: geometry)
                                        .background(Color.white),
                                    label: {
                                        listItem(for: entity)
                                            .padding(.vertical, 8) // Add padding for space between items
                                      
                                    }
                                )
                            }
                            .onDelete(perform: deleteItem)
                        }
                        .listStyle(PlainListStyle()) // Remove default separators
                        .background(Color.white)
                        .scrollContentBackground(.hidden)
                        .environment(\.colorScheme, .light)
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
                Text(entity.text ?? "")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                    .padding(.bottom, 60)
                    .padding()
            }
            .frame(width: geometry.size.width - 32, height: geometry.size.height)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .cornerRadius(12)
            .padding()

            Spacer()

                    Button {
                        UIPasteboard.general.string = entity.text ?? ""
                        showAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showAlert = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: showAlert ? "checkmark" : "doc.on.doc")
                                .foregroundColor(.white)
                            
                            Text(showAlert ?  "Text Copied" : "")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity,maxHeight: 60)
                    
                        .background(
                            
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color("main"),
                                    Color("gradientEnd")
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                   
                        .cornerRadius(12)
                        .padding(.horizontal,16)
                        .padding(.bottom,24)
                        
                       
                    
                    }
                   
        }
    }

    func listItem(for entity: ScannedEntity) -> some View {
          
            HStack {
                Text(entity.text ?? "")
                    .foregroundColor(.black)
                
                    .font(.system(size: 18))
                    .lineLimit(2)
            }
            .padding(.bottom,4)
            .padding(.top,4)
        
         
            
        
    }

    func createScannerButton() -> some View {
        ZStack {
            Circle()
                .fill(Color("main"))
                .frame(width: 80, height: 80)
                .shadow(color: .gray, radius: 10, x: 0, y: -5)
                .offset(y: -10)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .offset(y: -10)
                )
            
            Image(systemName: "qrcode.viewfinder")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .offset(y: -10)
        }
    }

    func makeScannerView() -> ScannerView {
        ScannerView(completion: { textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(content: outputText)
                vm.addScannedText(text: newScanData.content)
            }
            showScannerSheet = false
        })
    }

    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let entityToDelete = vm.savedEntities[index]
            vm.deleteScannedText(entity: entityToDelete)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
