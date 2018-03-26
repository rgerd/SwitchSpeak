//
//  SwitchSpeak_iOSTests.swift
//  SwitchSpeak-iOSTests
//
//  Created by Robert Gerdisch on 2/5/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import XCTest

@testable import SwitchSpeak_iOS

class SwitchSpeak_iOSTests: XCTestCase {
    
    var Database: cardDB?
    
    override func setUp(){
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        do{
            Database = try cardDB(filename: "/Users/gessicani/Documents/SwitchSpeak/SwitchSpeak-iOS/SwitchSpeak-iOS/Base.lproj/SwitchSpeakDB.sql")
        }catch{
            Database = nil
        }
        
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Database = nil
        super.tearDown()
        
    }
    
    func testDB() {
        //1) Test that Database is open and Default table exists
        XCTAssertNotNil(self.Database)
        var names:[String]?
        do{
            names = try self.Database?.getTables()
        }catch{
            print(error.localizedDescription)
        }
        XCTAssertNotNil(names)
        XCTAssertEqual(names?[0], "User1", "Name not equal User1")
        
        //2) Test every card from the home screen
        var prefixes:[Int64] = []
        var initialCards:[VocabCard]?
        
        do{
            initialCards = try self.Database?.getCardArr(table: "User1", id: 0)
            
        }catch{
            print(error.localizedDescription)
            
        }
        
        XCTAssertNotNil(initialCards)
        for item in initialCards!{
            self.testChild(card: item)
        }
        
    }
    
    
    func testChild(card: VocabCard)
    {
        let children:[VocabCard]? = try self.Databse?.getCardArr(table: "User1", id: card.id)
        if card.type == VocabCardType.word {
            XCTAssertNil(children)
        }
        else{
            XCTAssertNotNil(children)
            for item in children
            {
                self.testChild(card: item)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

