//
//  PFDSSetTests.swift
//  PurelySwiftDS
//
//  Created by Curt Clifton on 10/31/15.
//  Copyright © 2015 curtclifton.net. All rights reserved.
//

import XCTest
@testable import PurelySwiftDS

class PFDSSetTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testIsEmpty() {
        let tree = BinaryTree<Int>.Empty
        XCTAssert(tree.isEmpty)
        let tree2 = BinaryTree.Node(element: 213, left: BinaryTree.Empty, sright: BinaryTree.Empty)
        XCTAssertFalse(tree2.isEmpty)
    }
    
    func testInsert() {
        var tree = BinaryTree<Int>.Empty
        XCTAssertFalse(tree.member(1))
        XCTAssertFalse(tree.member(2))
        XCTAssertFalse(tree.member(3))
        
        tree.insert(1)
        XCTAssert(tree.member(1))
        XCTAssertFalse(tree.member(2))
        XCTAssertFalse(tree.member(3))
        
        tree.insert(3)
        XCTAssert(tree.member(1))
        XCTAssertFalse(tree.member(2))
        XCTAssert(tree.member(3))
        
        tree.insert(2)
        XCTAssert(tree.member(1))
        XCTAssert(tree.member(2))
        XCTAssert(tree.member(3))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}