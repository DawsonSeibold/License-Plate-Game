//
//  GameManager.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 2/20/19.
//  Copyright © 2019 Smile App Development. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GameManager {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    init() {
        context = appDelegate.persistentContainer.viewContext
    }
    
    
    func save(game: ClassicGame) {
        var gameObject: NSManagedObject!
        if let savedGame = getSavedGame(with: game.gameID) {
            print("Previously saved game")
            gameObject = savedGame as? NSManagedObject
        }else {
            print("New Saved Game")
            let entity = NSEntityDescription.entity(forEntityName: "Games", in: context)
            gameObject = GameManagedObject.init(entity: entity!, insertInto: context)
        }
    
        gameObject.setValue(game, forKey: "game")
    
        do {
            try context.save()
            print("Saved Game")
        }catch {
            print("Error")
        }
    }
    
    
    func getSavedGame(with ID: UUID) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Games")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    guard let game: ClassicGame = result.value(forKey: "game") as? ClassicGame else { continue }
                    if game.gameID == ID {
                        return result as? NSManagedObject
                    }
                }
            }
        }catch {
            
        }
        return nil
    }
    
    func getSavedGames() -> [ClassicGame]? {
        var games: [ClassicGame] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Games")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject]{
                    print("result: \(result)")
                    guard let game: ClassicGame = result.value(forKey: "game") as? ClassicGame else { continue }
                    print("game: \(game)")
                    games.append(game)
                }
            }
        }catch {
            return nil
        }
        return games
    }
    
    func deleteGames() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Games")
        request.returnsObjectsAsFaults = false
//        let _ = NSBatchDeleteRequest(fetchRequest: request)
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject]{
                    print("Deleted Game")
                    context.delete(result)
                }
            }
            try context.save()
        }catch {
            
        }
    }
}
