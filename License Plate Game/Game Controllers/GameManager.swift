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
    
    
    func save(game: Game) {
        var gameObject: GameManagedObject!
        if let savedGame = getSavedGame(with: game.gameID) {
            print("Previously saved game")
            gameObject = savedGame as? GameManagedObject
        }else {
            print("New Saved Game")
            let entity = NSEntityDescription.entity(forEntityName: "Games", in: context)
            //        let newGame = NSEntityDescription.insertNewObject(forEntityName: "Games", into: context)
            gameObject = GameManagedObject.init(entity: entity!, insertInto: context)
        }
        
        
//        let test = GameManagedObject.init(entity: entity!, insertInto: context)
//        test.game = game
        gameObject.game = game
        
//        newGame.setValue(game.gameName, forKey: "gameName")
        
        do {
            try context.save()
            print("Saved Game")
        }catch {
            print("Error")
        }
    }
    
    func loadGame(withName: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Games")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject]{
                    print("result: \(result)")
                    print("game: \(result.value(forKey: "game"))")
                    //                    if let username = result.value(forKey: "username") as? string {
                    //
                    //                    }
                }
            }
        }catch {
            
        }
    }
    
    func getSavedGame(with ID: UUID) -> GameManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Games")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    guard let game: Game = (result as! GameManagedObject).game else { continue }
//                    guard let game: Game = result.value(forKey: "game") as? Game else { continue }
//                    guard let game: Game = result.game else { continue }
//                    if game.gameID == ID {
                    if game.gameID == ID {
                        return result as? GameManagedObject
                    }
                }
            }
        }catch {
            
        }
        return nil
    }
    
    func getSavedGames() -> [Game]? {
        var games: [Game] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Games")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject]{
                    print("result: \(result)")
                    guard let game: Game = result.value(forKey: "game") as? Game else { continue }
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
        NSBatchDeleteRequest(fetchRequest: request)
//        do {
//            let results = try context.fetch(request)
//            if !results.isEmpty {
//                for result in results as! [NSManagedObject]{
//                    print("Deleted Game")
//                    context.delete(result)
//                }
//            }
//            try context.save()
//        }catch {
//        }
    }
}
