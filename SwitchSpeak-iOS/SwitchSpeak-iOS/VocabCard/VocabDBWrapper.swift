//
//  VocabDBWrapper.swift
//  SwitchSpeak-iOS
//
//  Created by Arthur Befumo on 3/16/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import UIKit
import GRDB

class VocabCardDB {
    static var shared:VocabCardDB?
    var db:DatabaseQueue
    var colors:[String]
    
    static func load() {
        let dbURL:String = "\(Bundle.main.bundlePath)/SwitchSpeakDB.sql"
        shared = VocabCardDB(dbURL)
    }
    
    init(_ filename:String) {
        do {
            db = try DatabaseQueue(path: filename)
            colors = self.getColors()
        } catch {
            fatalError("Database not correctly loaded from \(filename): \(error)")
        }
    }
    
    // Create a new empty table called [tableName].
    func createTable(_ tableName:String) -> String {
        do {
            try self.db.inDatabase { db in
                try db.create(table: tableName) { t in
                    t.column("id", .integer).primaryKey()
                    t.column("type", .integer)
                    t.column("text", .text)
                    t.column("imagefile", .blob)
                    t.column("parentid", .integer)
                    t.column("voice", .integer)
                    t.column("color", .integer)
                    t.column("hidden", .integer)
                }
            }
        } catch {
            fatalError("Could not create table \(tableName): \(error).")
        }
        return tableName
    }
    
    // Return a list of all tables in the current database (different users can have different tables).
    func getTables() -> [String] {
        do {
            let tables = try self.db.inDatabase { db in
                try String.fetchAll(db, "SELECT name FROM sqlite_master where type='table'")
            }
            
            return tables
        } catch {
            fatalError("Could not get tables: \(error).")
        }
    }

    // Return the array of colors stored in the Colors table.
    func getColors() -> [String]{
        do {
            let colors = try self.db.inDatabase { db in
                try String.fetchAll(db, "SELECT hexcode FROM Colors")
            }

            return colors
        } catch {
            fatalError("Could not get color array: \(error).")
        }
    }

    // Return an array of all vocab cards which have parentid == [id], from the table [table].
    func getCardArray(inTable table:String, withId id:Int64) -> [VocabCard] {
        do {
            let cards = try self.db.inDatabase { db in
                try VocabCard.fetchAll(db, "SELECT * FROM " + table + " WHERE parentid = ?", arguments: [id])
            }
            return cards
        } catch {
            fatalError("Could not get card array for table \(table) with id \(id): \(error).")
        }
    }
    
    // Return an array of all vocab cards in the table [table].
    func getAllCards(inTable table:String) -> [VocabCard] {
        do {
            let cards = try self.db.inDatabase { db in
                try VocabCard.fetchAll(db, "SELECT * FROM " + table)
            }
            
            return cards
        } catch {
            fatalError("Could not get all cards in table \(table): \(error).")
        }
    }
    
    // Add a card to the given table with the specified parameters, and returns the unique id of the card.
    func addCard(_ card: VocabCard, toTable table:String) -> Int64 {
        do {
            var id:Int64 = -1
            try self.db.inDatabase { db in
                try db.execute("INSERT INTO " + table + " (type, text, imagefile, parentid, voice, color) VALUES (?, ?, ?, ?, ?, ?)",
                               arguments: [card.type.rawValue, card.text, card.imagefile, card.parentid, card.voice, card.colorHex])
                id = db.lastInsertedRowID
            }
            return id
        } catch {
            fatalError("Could not add vocab card to table \(table): \(error).")
        }
    }
    
    // Clear all records from given table.
    func clearTable(_ tableName:String) {
        do {
            try self.db.inDatabase { db in
                try db.execute("DELETE FROM " + tableName)
            }
        } catch {
            fatalError("Could not clear table \(tableName): \(error).")
        }
    }
    
    // Erase the contents of [toTable] and copy the contents of [fromTable] to [toTable].
    func copyTable(fromTable:String, toTable:String) {
        self.clearTable(toTable)
        
        let cards = self.getAllCards(inTable: fromTable)
        for card in cards {
            let _ = self.addCard(card, toTable: toTable)
        }
    }
    
    // Removes the card given by [id] (and all its children) from the given table.
    func removeCard(fromTable table: String, withId id: Int64) {
        do {
            let card = try self.db.inDatabase { db in
                try VocabCard.fetchOne(db, "SELECT * FROM + " + table + " WHERE id = ?", arguments: [id])
            }
            
            if card!.type == .category {
                let children = self.getCardArray(inTable: table, withId: id)
                for child in children {
                    self.removeCard(fromTable: table, withId: child.id!)
                }
            }
            
            try self.db.inDatabase { db in
                try db.execute("DELETE FROM " + table + " WHERE id = ?", arguments: [id])
            }
        } catch {
            fatalError("Could not remove card with id \(id) from table \(table): \(error).")
        }
    }
    
    //Adds a dummy child card (for use when a new category is inserted). This card can then be edited by the user.
    func addPlaceholder(withParentId parentid:Int64, toTable table:String) {
        var placeHolder:VocabCard = VocabCard(type: .word, text: "EDIT TEXT", imagefile: Data(), voice: false, color: "#D35400", hidden: false)
        placeHolder.parentid = parentid
        let _ = self.addCard(placeHolder, toTable: table)
    }

    // Copies the given card from one table to another.
    // The new parentid of the card must be updated before being passed to this function.
    func copyCard(_ card:VocabCard, fromTable:String, toTable:String) {
        let newId = self.addCard(card, toTable: toTable)

        if card.type == .category {
            let children = self.getCardArray(inTable: fromTable, withId: newId)
            for var child in children {
                child.parentid = newId
                self.copyCard(child, fromTable: fromTable, toTable: toTable)
            }
        }
    }

    //Adds a dummy child card (for use when a new category is inserted). This card can then be edited by the user.
    func addPlaceHolder(parentid:Int64, toTable table:String) {
        var placeHolder:VocabCard = VocabCard(type: .word, text: "EDIT TEXT", imagefile: Data(), voice: false, color: "#D35400", hidden: false)
        placeHolder.parentid = parentid
        let _ = self.addCard(placeHolder, toTable: table)
    }
    
    // Edits the data of the given card in the table it was retrieved from.
    // If a card type is changed from word to category, then a dummy child is inserted into the table.
    func editCard(_ card:VocabCard, inTable table:String) {
        let cardId:Int64 = card.id!
        
        do {
            let oldCard = try self.db.inDatabase { db in
                try VocabCard.fetchOne(db, "SELECT * FROM + " + table + " WHERE id = ?", arguments: [cardId])
            }

            try self.db.inDatabase { db in
                try db.execute("""
                    UPDATE \(table)
                        SET
                        type = \(card.type.rawValue),
                        text = \(card.text),
                        imagefile = \(card.imagefile),
                        parentid = \(card.parentid),
                        card.voice = \(card.voice),
                        card.colorHex = \(card.colorHex)
                        WHERE id = \(cardId)
                    """)
            }

            if card.type == .category && oldCard!.type == .word {
                self.addPlaceholder(withParentId: cardId, toTable: table)
            }

        } catch {
            fatalError("Could not edit card with id \(cardId) in table \(table): \(error).")
        }
    }

    // Takes a card array, edits the cards that already exist in the database and inserts those that do not exist.
    // For all categories created, a dummy child word will also be inserted into the database.
    func updateCardArray(_ cards:[VocabCard], inTable table:String) {
        for card in cards {
            if card.id == 0 {
                let newId = self.addCard(card, toTable: table)
                if card.type == .category {
                    self.addPlaceholder(withParentId: newId, toTable: table)
                }
            } else {
                self.editCard(card, inTable: table)
            }
        }
    }
}
