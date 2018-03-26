//
//  VocabDBWrapper.swift
//  SwitchSpeak-iOS
//
//  Created by Arthur Befumo on 3/16/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import GRDB

class cardDB{
    var db:DatabaseQueue
    
    init(filename:String) throws {
        db = try DatabaseQueue(path: filename)
    }
    
    func createTable(tablename: String) throws -> String {
        // Create a new empty table called 'tablename'
        try self.db.inDatabase { db in
            try db.create(table: tablename) { t in
                t.column("id", .integer).primaryKey()
                t.column("target", .text)
                t.column("text", .text)
                t.column("imagefile", .blob)
                t.column("parentid", .integer)
            }
        }
        
        return tablename
    }
    
    func getTables() throws -> [String]? {
        // Return a list of all tables in the current database (different users can have
        // different tables.
        let tables = try self.db.inDatabase { db in
            try String.fetchAll(db, "SELECT name FROM sqlite_master where type='table'")
        }
        return tables
    }
    
    func getCardArr(table: String, id: Int) throws -> [VocabCard]? {
        // Return an arr of all vocab cards which have parentid == 'id', from the table 'table'.
        
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
    
    func addCardtoTable(table: String, card: VocabCard) throws {
        // Add a card to the given table with the specified parameters.
        
        try self.db.inDatabase{ db in
            try db.execute("INSERT INTO " + table + " (target, text, imagefile, parentid) VALUES (?, ?, ?, ?)",
                arguments: [card.target, card.text, card.imagefile, card.parentid])
        }
    }
    
    func clearTable(table: String) throws {
        // Clear all records from given table
        
        try self.db.inDatabase{ db in
            try db.execute("DELETE FROM " + table)
        }
    }
    
    func copyTable(table1: String, table2: String) throws {
        // Erase the contents of table1 and copy the contents of table2 to table1
        
        try self.clearTable(table: table1)
        
        let cards = try self.getAllCards(table: table2)
        
        if cards != nil {
            for card in cards!{
                try addCardtoTable(table: table1, card: card)
            }
        }
    }
}
