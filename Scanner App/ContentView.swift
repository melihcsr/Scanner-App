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
    @State private var texts2: [String] = ["Melih","Cesur"]
    @State private var showAlert: Bool = false
    class ViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set the navigation title color
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    }
    
    var body: some View {
        NavigationView {
           
            VStack {
                HStack {
                    Text("Text Scanner")
                              .font(.system(size: 36, weight: .heavy)) // Font size 40 with heavy weight
                              .foregroundColor(.black) // Black color
                    
                    Spacer()
                }
                .padding(.leading,16)
                .padding(.top,48)
                if texts.isEmpty {
                 Spacer()
                    Text("No scan yet")
                        .font(.title)
                        .foregroundColor(.black)
                } else {
                    GeometryReader { geometry in
                        VStack {

                            ForEach(texts) { text in
                                NavigationLink(
                                    destination:VStack
                                    {
                                        
                                  
                                            ScrollView{
                                                Spacer()
                                                Text(text.content)
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity,alignment:.leading)
                                                .padding(.bottom,60)
                                                .padding()
                                            }
                                        
                                  
                                        .frame(width: .infinity, height: geometry.size.height )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12) // No rounded corners, creating a rectangle
                                                .stroke(Color.gray, lineWidth: 3) // Border color and width
                                        )
                                     
                                        .cornerRadius(12)
                                        .padding()
                                        
                                        Spacer()
                                       
                                        Button {
                                            UIPasteboard.general.string = text.content
                                            showAlert = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                                     showAlert = false
                                                                 }
                                        } label: {
                                            HStack {
                                                Spacer()
                                                Image(systemName: showAlert  == false ? "doc.on.doc" : "checkmark")
                                                    .foregroundColor(.white)
                                                Text(showAlert  == false ?  "Copy Text" : "Text Copied")
                                                Spacer()
                                                    
                                            }
                                            .padding()
                                        
                                            .background( showAlert  == false ? Color.blue : .green)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                            .padding(.horizontal,24)
                                            .padding(.bottom,24)
                                        }
                                        
                                       
                                    },
                                    label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.blue.opacity(0.8))
                                                .frame(height: 60)
                                                .padding()
                                                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                                            
                                            HStack {
                                                Text(text.content)
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                                    .padding(.leading,16)
                                                    .lineLimit(1)
                                                   
                                                
                                                Spacer() // Metni sağa hizala
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(.white)
                                                    .padding(.trailing,16)
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                )
                            }
                        }
                    }
                  
                }
                
                Spacer()
                
                Button {
                    self.showScannerSheet = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 80, height: 80)
                            .shadow(color: .gray, radius: 10, x: 0, y: -5)
                            .offset(y: -30) // Düğmeyi biraz yukarı kaldırarak
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                                    .offset(y: -30)
                            )
                        
                        // Tarayıcı ikonu
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .offset(y: -30) // İkonu düğmenin offset'i ile hizala
                    }
                }
                
               
                
            }
            .frame(maxWidth: .infinity,maxHeight:.infinity)
            .background(.white)
            
          
           
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
