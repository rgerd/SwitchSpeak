//
//  SwitchSpeak_iOSTests.swift
//  SwitchSpeak-iOSTests
//
//  Created by Robert Gerdisch on 2/5/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import XCTest

@testable import SwitchSpeak_iOS

class DatabaseTest: XCTestCase {
    var testDatabase:VocabCardDB!
    
    // This method is called before the invocation of each test method in the class.
    override func setUp(){
        super.setUp()
        testDatabase = VocabCardDB("\(Bundle.main.bundlePath)/SwitchSpeakDB.sql")
    }
    
    // This method is called after the invocation of each test method in the class.
    override func tearDown() {
        testDatabase = nil
        super.tearDown()
        
    }
    
    // Test that Database is open and has tables
    func testDB() {
        let tableNames:[String]? = testDatabase.getTables()
        XCTAssertNotNil(tableNames)
    }
    
    // Test every card on the home screen
    func testHomeScreenCards() {
        let initialCards:[VocabCard] = testDatabase.getCardArray(inTable:"User1" , withId: 0)
        
        XCTAssertNotNil(initialCards)
        
        for item in initialCards {
            self.testChild(card: item)
        }
    }
    
    func testChild(card: VocabCard) {
        let children:[VocabCard] = testDatabase.getCardArray(inTable: "User1", withId:card.id!)
        
        if card.type == .word {
            XCTAssertEqual(children.count, 0, "Word has children in database")
        } else {
            XCTAssertGreaterThan(children.count, 0, "Non-word has no children in database")
            for item in children {
                self.testChild(card: item)
            }
        }
    }
}


class TreeFactoryTest: XCTestCase {
    
    // Check if the tree build is of the correct scan type.
    func testBuildScanType() {
        let scanType:ScanType = .LINEAR
        let T = TreeFactory.buildTree(type: scanType, size: (3,4), dummyNum: 0)
        XCTAssertEqual(T.treeType, ScanType.LINEAR, "Tree type does not match specified scan type.")
    }
    
    // Check that the created tree has the right structure
    func testLinearScanTreeStructure() {
        let numRows = 3
        let numCols = 4
        
        let T = TreeFactory.treeForCellByCellScanning(rows: numRows, cols: numCols, dummyNum: 0)
        
        let numNodes = numRows * numCols
        for i in 0...(numNodes - 1) {
            if (((T.rootNode?.childNodes[i] as? ButtonNode)) == nil) {
                XCTFail("Leaf node is not a button node.")
            }
        }
    }
    
    // Check that the created tree has the right structure
    func testRowColScanTreeStructure() {
        let numRows = 3
        let numCols = 4
        
        let T = TreeFactory.treeForRowColumnScanning(rows: numRows, cols: numCols, dummyNum: 0)
        
        for i in 0...(numRows - 1) {
            let curNode = T.rootNode?.childNodes[i]
            for j in 0...(numCols - 1) {
                if (((curNode?.childNodes[j] as? ButtonNode)) == nil) {
                    XCTFail("Leaf node is not a button node.")
                }
            }
        }
    }
}


class ButtonNodeTests: XCTestCase {
    var buttonNode:ButtonNode!
    var dummyButtonNode:ButtonNode!
    
    // This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
        
        var mockVocabCard:VocabCard = VocabCard()
        mockVocabCard.text = "Hello World"
        
        buttonNode = ButtonNode(button: UIButton(), gridPosition: (2,3)) // Arbitrary grid location (2,3)
        buttonNode.setCardData(cardData: mockVocabCard)
        
        dummyButtonNode = ButtonNode(button: UIButton(), gridPosition: (2,3))
        dummyButtonNode.dummy = true
        dummyButtonNode.setCardData(cardData: EmptyVocabCard)
    }
    
    // Checks that non-dummy buttons can't be highlighted, and button nodes can be highlighted
    func testButtonHighlight() {
        buttonNode.highlightSubTree()
        dummyButtonNode.highlightSubTree()
        
        XCTAssertEqual(buttonNode.button.layer.borderColor, ButtonNode.highlightColor,"Button node not highlighted")
        XCTAssertEqual(buttonNode.button.layer.borderWidth, ButtonNode.highlightBorderWidth,"Button node not highlighted")
        XCTAssertEqual(dummyButtonNode.button.layer.borderWidth, CGFloat(0), "Dummy node highlighted")
    }
    
    // Checks that unhighlighting button node works
    func testButtonUnhighlight() {
        buttonNode.highlightSubTree()
        buttonNode.unHighlightSubTree()
        
        XCTAssertEqual(buttonNode.button.layer.borderWidth, CGFloat(0),"Button node still highlighted")
    }
    
    func testButtonTitle() {
        XCTAssertEqual(buttonNode.button.titleLabel!.text!, "Hello World", "Button node's title does not match vocab card text")
    }
    
    func testAssignCardData() {
        XCTAssertNotNil(buttonNode.cardData)
    }
}

class NodeTests: XCTestCase {
    var node: Node!
    
    // This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
        
        node = Node()
        
        // Create 5 child nodes for the node object
        for _ in 1...5 {
            node.childNodes.append(Node())
        }
    }
    
    func testChildCount() {
        XCTAssertEqual(node.childNodes.count, 5, "Incorrect number of child nodes")
    }
    
    func testAddChildFunc() {
        let newNode = Node()
        node.addChild(child: newNode)
        XCTAssertEqual(node.childNodes.count, 6, "New child node not correctly inserted")
    }
    
    func testAddChildrenFunc() {
        var newNodeArray: [Node]
        newNodeArray = []
        // Create array of four nodes
        for _ in 1...4 {
            newNodeArray.append(Node())
        }
        node.addChildren(children: newNodeArray)
        XCTAssertEqual(node.childNodes.count, 9, "New children node not correctly inserted")
    }
}


class TreeTests: XCTestCase {
    var T: Tree!
    
    // This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
        T = Tree()
    }
    
    // Check that the button sizes computed by the computeButtonSize function are less than the input max button size
    func testButtonSizeLessThanMaxSize() {
        let gridSize = (4,5)
        let containerSize = (100,200)
        let maxButtonSize = (10,10)
        let (buttonHeight, buttonWidth, _, _) = Tree.computeButtonSize(gridSize: gridSize, containerSize: containerSize, maxButtonSize: maxButtonSize)
        
        XCTAssertTrue(buttonWidth <= maxButtonSize.0 && buttonHeight <= maxButtonSize.1, "Button size exceeds max button size")
    }
    
    // Checks if the buttons almost perfectly fits the container given the gap sizes
    func testButtonSizePreservesSize() {
        let gridSize = (4,5)
        let containerSize = (100,200)
        let maxButtonSize = (10,10)
        let (buttonHeight, buttonWidth, colGap, rowGap) = Tree.computeButtonSize(gridSize: gridSize, containerSize: containerSize, maxButtonSize: maxButtonSize)
        
        //    In the below if-condition I'm testing if the gridSize is filled with an error of at max 1 unit...the error could arise due to the round of integers in computeButtonSize function
        if (abs((rowGap * (gridSize.0 + 1)) + (gridSize.0 * buttonHeight) - containerSize.0) < 1 || abs((colGap * (gridSize.1 + 1)) + (gridSize.1 * buttonWidth) - containerSize.1) < 1) {
            XCTFail("Container size not preserved by the buttons")
        }
    }
}

class CrumbManagerTest: XCTestCase {
    var testCrumbManager:CrumbStack!
    
    override func setUp() {
        super.setUp()
        testCrumbManager = CrumbStack()
    }
    
    func testEmptyCrumbStack() {
        var vCard1 = VocabCard(); vCard1.text = "hello test1"; vCard1.type = .word
        var vCard2 = VocabCard(); vCard2.text = "hello test2"; vCard2.type = .word
        
        testCrumbManager.push(cardData: vCard1)
        testCrumbManager.push(cardData: vCard2)
        
        testCrumbManager.emptyCrumbStack()
        
        XCTAssertEqual(testCrumbManager.getString(), "", "CrumbStack string not empty")
    }
    
    func textCrumbStackPush()  {
        var vCard1 = VocabCard(); vCard1.text = "hello test1"; vCard1.type = .word; vCard1.voice = true
        var vCard2 = VocabCard(); vCard2.text = "hello test2"; vCard2.type = .word; vCard2.voice = true
        
        testCrumbManager.push(cardData: vCard1)
        testCrumbManager.push(cardData: vCard2)
        
        let content = "\(vCard1.text) \(vCard2.text)"
        XCTAssertEqual(testCrumbManager.getString(), content)
    }
    
    func testCrumbStackGetString() {
        var vCard = VocabCard(); vCard.text = "hello test"; vCard.type = .word; vCard.voice = true
        
        testCrumbManager.push(cardData: vCard)
        XCTAssertEqual(testCrumbManager.getString(), "\(vCard.text) ")
    }
    
    // NOTE: This should be a UI test
    //    func testCrumbUpdateSubview() {
    //        let TestView = UIView()
    //        let ContainerView = UIView()
    //        let content = ["1", "2", "3", "4"]
    //        var labels : [UILabel] = []
    //        for string in content{
    //            let vCard1 = VocabCard(type:VocabCardType(rawValue: 2)!, text:string, imagefile:Data(), voice: false, color: "ffffff")
    //            let baseButton = UIButton()
    //            let node = ButtonNode(button: baseButton, gridPosition: (1,1))
    //            node.setCardData(cardData: vCard1)
    //            testCrumbManager.push(buttonNode: node)
    //            let label = UILabel()
    //            label.text = string
    //            labels.append(label)
    //        }
    //        testCrumbManager.updateSubViews(insideView: TestView)
    //        for label in labels {
    //            ContainerView.addSubview(label)
    //        }
    //        XCTAssertEqual(TestView, ContainerView)
    //    }
}
