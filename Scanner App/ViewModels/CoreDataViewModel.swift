//
//  CoreDateViewModel.swift
//  Scanner App
//
//  Created by Melih Cesur on 17.04.2024.
//

import Foundation
import CoreData


class CoreDataViewModel: ObservableObject{
    
    let container : NSPersistentContainer
    @Published var savedEntities : [ScannedEntity] = []
    


    init(){
        
        container = NSPersistentContainer(name:"ScannedContainer")
        container.loadPersistentStores{(description , error) in
            
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        
        fetchScannedTexts()
    
    }
    
    
    func fetchScannedTexts(){
        
        let request = NSFetchRequest<ScannedEntity>(entityName: "ScannedEntity")
        
        do{
            savedEntities = try container.viewContext.fetch(request)
        }catch let error{
            print("Error fetching. \(error)")
        }
        
    }
    
    func addScannedText(text:String){
        
        let newText = ScannedEntity(context: container.viewContext)
        newText.text = text
        saveData()
        
    }
    
    func saveData(){
        
        do{
            try container.viewContext.save()
            fetchScannedTexts()
            
        }catch let error{
            print("Error saving. \(error)")
        }
 
    }
    
}


