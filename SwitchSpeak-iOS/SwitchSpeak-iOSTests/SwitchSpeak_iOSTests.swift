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
    var Database:  VocabCardDB?

    override func setUp(){
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        Database = VocabCardDB("\(Bundle.main.bundlePath)/SwitchSpeakDB.sql")


    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Database = nil
        super.tearDown()

    }

//    func testDB() {
//        //1) Test that Database is open and Default table exists
//        XCTAssertNotNil(self.Database)
//        var names:[String]?
//        names = self.Database?.getTables()
//        XCTAssertNotNil(names)
//        XCTAssertEqual(names?[0], "User1", "Name not equal User1")
//
//        //2) Test every card from the home screen
//        var initialCards:[VocabCard]?
//
//        initialCards = self.Database?.getCardArray(inTable:"User1" , withId: 0)
//
//        XCTAssertNotNil(initialCards)
//        for item in initialCards!{
//            self.testChild(card: item)
//        }
//
//    }


//    func testChild(card: VocabCard)
//    {
//        let children:[VocabCard]? = self.Database?.getCardArray(inTable: "User1", withId:card.id!)
//        if card.type == VocabCardType.word {
//            XCTAssertNil(children)
//        }
//        else{
//            XCTAssertNotNil(children)
//            for item in children!
//            {
//                self.testChild(card: item)
//            }
//        }
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


class TreeFactoryTests: XCTestCase {
    
    //var factory: TreeFactory!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testbuildScanType() {
        // check if the tree build is of the correct scan type
        
        let scanType = ScanType.LINEAR
        let size = (3,4)
        let T = TreeFactory.buildTree(type: scanType, size: size, dummyNum: 0)
        if ( T.treeType != scanType ) {
            XCTAssert(false)
        }
        else {
            XCTAssert(true)
        }
    }
    
    func testLinearScanTreeStructure() {
        //    checks whether the tree created has the right structure
        let T = TreeFactory.treeForCellByCellScanning(rows: 3, cols: 4, dummyNum: 0)
        
        for i in 0...11 {
            if (((T.rootNode?.childNodes[i] as? ButtonNode)) == nil) {    //    i.e. the node is not a button node
                XCTAssert(false)
            }
        }
        XCTAssert(true)
    }
    
    func testRowColScanTreeStructure() {
        //    checks whether the tree created has the right structure
        let T = TreeFactory.treeForRowColumnScanning(rows: 3, cols: 4, dummyNum: 0)
        
        for i in 0...2 {
            let curNode = T.rootNode?.childNodes[i]
            for j in 0...3 {
                if (((curNode?.childNodes[j] as? ButtonNode)) == nil) {    //    i.e. the node is not a button node
                    XCTAssert(false)
                }
            }
        }
        XCTAssert(true)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}


class ButtonNodeTests: XCTestCase {
    
    var buttonNode: ButtonNode?
    var dummybuttonNode: ButtonNode?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let button1 = UIButton()
        buttonNode = ButtonNode(button: button1, gridPosition: (2,3))    // arbitrary grid location (2,3)
        let button2 = UIButton()
        let dummyButtonNode = ButtonNode(button: button2, gridPosition: (2,3))
        dummyButtonNode.dummy = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testButtonHighlight() {
        // checks if non-dummy button are highlighted
        buttonNode?.highlightSubTree()
        dummybuttonNode?.highlightSubTree()
        
        XCTAssertEqual(buttonNode?.button.layer.borderColor, UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor,"non dummy node not highlighted")
        
        XCTAssertEqual(dummybuttonNode?.button.layer.borderColor, nil)
    }
    
    func testButtonUnhighlight() {
        // checks if non-dummy button are unhighlighted
        buttonNode?.highlightSubTree()
        buttonNode?.unHighlightSubTree()
        
        dummybuttonNode?.highlightSubTree()
        dummybuttonNode?.unHighlightSubTree()
        
        XCTAssertEqual(buttonNode?.button.layer.borderColor, UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor,"non dummy node not unhighlighted")
        
        XCTAssertEqual(dummybuttonNode?.button.layer.borderColor, nil)
    }
    
    
}

class NodeTests: XCTestCase {
    
    var node: Node!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        node = Node()
        
        //    create 5 child nodes of the node object
        for _ in 1...5 {
            let newNode = Node()
            node.childNodes.append(newNode)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        node = nil
        
    }
    
    func testChildCount() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(node.childNodes.count, 5, "incorrect number of child nodes")
    }
    
    func testAddChildFunc() {
        let newNode = Node()
        node.addChild(child: newNode)
        XCTAssertEqual(node.childNodes.count, 6, "New child node not correctly inserted")
    }
    
    func testAddChildrenFunc() {
        var newNodeArray: [Node]
        newNodeArray = []
        //    create array of four nodes
        for _ in 1...4 {
            newNodeArray.append(Node())
        }
        node.addChildren(children: newNodeArray)
        XCTAssertEqual(node.childNodes.count, 9, "New children node not correctly inserted")
    }
    
}


class TreeTests: XCTestCase {
    
    var T: Tree!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        T = Tree()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testButtonSizeLessThanMaxSize() {
        // This checks that the button sizes computed by the computeButtonSize function are less than the input max button size
        let gridSize = (4,5)
        let containerSize = (100,200)
        let maxButtonSize = (10,10)
        let (buttonHeight, buttonWidth, _, _) = Tree.computeButtonSize(gridSize: gridSize, containerSize: containerSize, maxButtonSize: maxButtonSize)
        //    check if no button size exceeds max button size
        if (buttonWidth > maxButtonSize.0 || buttonHeight > maxButtonSize.1) {
            XCTAssert(false, "button size exceeds max button size")
        }
        else{
            XCTAssert(true)
        }
    }
    
    func testButtonSizePreservesSize() {
        // This checks if the buttons almost perfectly fit the container given the gap sizes
        let gridSize = (4,5)
        let containerSize = (100,200)
        let maxButtonSize = (10,10)
        let (buttonHeight, buttonWidth, colGap, rowGap) = Tree.computeButtonSize(gridSize: gridSize, containerSize: containerSize, maxButtonSize: maxButtonSize)
        
        //    In the below if-condition I'm testing if the gridSize is filled with an error of at max 1 unit...the error could arise due to the round of integers in computeButtonSize function
        if ( abs((rowGap * (gridSize.0 + 1)) + (gridSize.0 * buttonHeight) - containerSize.0) < 1 || abs((colGap * (gridSize.1 + 1)) + (gridSize.1 * buttonWidth) - containerSize.1) < 1) {
            XCTAssert(false, "container size not preserved by the buttons")
        }
        else{
            XCTAssert(true)
        }
    }
}

class CrumbManagerTest: XCTestCase {
    var testCrumbManager:CrumbStack!
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        testCrumbManager=nil
        super.tearDown()
    }
    
    func emptyCrumstacktest() {
        let vCard1 = VocabCard(type:VocabCardType.word, text: "hello test1", imagefile:Data(), voice: false, color: "ffffff")
        let vCard2 = VocabCard(type:VocabCardType.word, text: "hello test2", imagefile:Data(), voice: false, color: "ffffff")
        let baseButton1 = UIButton()
        let baseButton2 = UIButton()
        let node1 = ButtonNode(button: baseButton1, gridPosition: (1,1))
        node1.setCardData(cardData: vCard1)
        let node2 = ButtonNode(button: baseButton2, gridPosition: (2,2))
        node2.setCardData(cardData: vCard2)
        testCrumbManager.push(buttonNode:node1)
        testCrumbManager.push(buttonNode: node2)
        testCrumbManager.emptyCrumbStack()
        XCTAssertNil(testCrumbManager.getString())
    }
    
    func CrumStackPushTest()  {
        let x1 = "hello test1"
        let x2 = "hello test2"
        let vCard1 = VocabCard(type:VocabCardType(rawValue: 2)!, text:x1, imagefile:Data(), voice: false, color: "ffffff")
        let vCard2 = VocabCard(type:VocabCardType(rawValue: 2)!, text:x2, imagefile:Data(), voice: false, color: "ffffff")
        let baseButton1 = UIButton()
        let baseButton2 = UIButton()
        let node1 = ButtonNode(button: baseButton1, gridPosition: (1,1))
        let node2 = ButtonNode(button: baseButton2, gridPosition: (2,2))
        testCrumbManager.push(buttonNode: node1)
        testCrumbManager.push(buttonNode: node2)
        node1.setCardData(cardData: vCard1)
        node2.setCardData(cardData: vCard2)
        let content = x1 + " " + x2
        XCTAssertEqual(testCrumbManager.getString(), content)
    }
    
    func CrumbUpdateSubviewTest() {
        let TestView = UIView()
        let ContainerView = UIView()
        let content = ["1", "2", "3", "4"]
        var labels : [UILabel] = []
        for string in content{
            let vCard1 = VocabCard(type:VocabCardType(rawValue: 2)!, text:string, imagefile:Data(), voice: false, color: "ffffff")
            let baseButton = UIButton()
            let node = ButtonNode(button: baseButton, gridPosition: (1,1))
            node.setCardData(cardData: vCard1)
            testCrumbManager.push(buttonNode: node)
            let label = UILabel()
            label.text = string
            labels.append(label)
        }
        testCrumbManager.updateSubViews(insideView: TestView)
        for label in labels {
            ContainerView.addSubview(label)
        }
        XCTAssertEqual(TestView, ContainerView)
    }
    
//    func testgetString() {
//        let x = "hello test"
//        let vCard = VocabCard(type:VocabCardType(rawValue: 2)!, text:x, imagefile:Data(), voice: false, color: "ffffff")
//        let baseButton = UIButton()
//        let node = ButtonNode(button: baseButton, gridPosition: (1,1))
//        node.setCardData(cardData: vCard)
//        XCTAssertNotNil(node.cardData)
//        testCrumbManager.push(buttonNode:node)
//        XCTAssertEqual(testCrumbManager.getString(), "hello test1 ")
//
//    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
    
}




