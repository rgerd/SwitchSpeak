//
//  VocabDBWrapper.swift
//  SwitchSpeak-iOS
//
//  Created by Arthur Befumo on 3/16/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import GRDB

class VocabCardDB {
    static var shared:VocabCardDB?
    var db:DatabaseQueue
    
    static func load() {
        let dbURL:String = "\(Bundle.main.bundlePath)/SwitchSpeakDB.sql"
        do {
            try shared = VocabCardDB(dbURL)
        } catch {
            fatalError("Database not correctly loaded.")
        }
    }
    
    init(_ filename:String) throws {
        db = try DatabaseQueue(path: filename)
    }
    
    func createTable(tablename: String) throws -> String {
        // Create a new empty table called 'tablename'
        try self.db.inDatabase { db in
            try db.create(table: tablename) { t in
                t.column("id", .integer).primaryKey()
                t.column("type", .integer)
                t.column("text", .text)
                t.column("imagefile", .blob)
                t.column("parentid", .integer)
                t.column("voice", .integer)
                t.column("color", .text)
            }
        }
        
        return tablename
    }
    
    // Return a list of all tables in the current database (different users can have different tables.
    func getTables() throws -> [String]? {
        let tables = try self.db.inDatabase { db in
            try String.fetchAll(db, "SELECT name FROM sqlite_master where type='table'")
        }
        return tables
    }
    
    // Return an arr of all vocab cards which have parentid == 'id', from the table 'table'.
    func getCardArray(table: String, id: Int) throws -> [VocabCard]! {
        let cards = try self.db.inDatabase { db in
            try VocabCard.fetchAll(db, "SELECT * FROM " + table + " WHERE parentid = ?", arguments: [id])
        }
        return cards
    }
    
    func getAllCards(table: String) throws -> [VocabCard]? {
        // Return on arr of all vocab cards in the table 'table'
        
        let cards = try self.db.inDatabase { db in
            try VocabCard.fetchAll(db, "SELECT * FROM " + table)
        }
        
        return cards
    }
    
    func addCardtoTable(table: String, card: VocabCard) throws -> Int {
        // Add a card to the given table with the specified parameters, and returns the unique id of the card
        
        try self.db.inDatabase { db in
            try db.execute("INSERT INTO " + table + " (type, text, imagefile, parentid, voice, color) VALUES (?, ?, ?, ?, ?, ?)",
                           arguments: [card.type.rawValue, card.text, card.imagefile, card.parentid, card.voice, card.colorHex])
            let id = db.lastInsertedRowID              
        }

        return id
    }
    
    func clearTable(table: String) throws {
        // Clear all records from given table
        
        try self.db.inDatabase { db in
            try db.execute("DELETE FROM " + table)
        }
    }
    
    func copyTable(toTable: String, fromTable: String) throws {
        // Erase the contents of table1 and copy the contents of table2 to table1
        
        try self.clearTable(table: toTable)
        
        let cards = try self.getAllCards(table: fromTable)
        
        if cards != nil {
            for card in cards! {
                try addCardtoTable(table: toTable, card: card)
            }
        }
    }

    func removeCard(table: String, id: Int) throws {
        // Removes the card given by id (and all its children) from the given table

        let card = try self.db.inDatabase { db in 
            try vocabCard.fetchOne(db, "SELECT * FROM + " + table + " WHERE id = ?", arguments: [id])
        }

        if card!.type == VocabCardType.category {
            let children = self.getCardArray(table: table, id: id)
            for child in children {
                self.removeCard(table:table, id: child.id)
            }
        }

        try self.db.inDatabase { db in
            try db.execute("DELETE FROM " + table + " WHERE id = ?", arguemtns: [id])
        }
    }

    func copyCard(toTable: String, fromTable: String, card: VocabCard) throws {
        // Copies the given card from one table to another. The new parentid of the card must be updated before being passed to this function

        let new_id = self.addCardtoTable(table: toTable, card: card)

        if card.type == VocabCardType.category {
            let children = self.getCardArray(table: fromTable, id: id)
            for child in children {
                child.parentid = new_id
                self.copyCardfromTable(toTable: toTable, card: child)
            }
        }
    }
}
