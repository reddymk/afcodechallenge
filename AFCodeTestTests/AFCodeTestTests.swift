//
//  AFCodeTestTests.swift
//  AFCodeTestTests
//
//  Created by Manish Reddy on 10/30/16.
//  Copyright © 2016 Manish. All rights reserved.
//

import XCTest
@testable import AFCodeTest

class AFCodeTestTests: XCTestCase {
    
    var collectionViewController: CollectionViewController = CollectionViewController()
    let networking = Networking()
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        collectionViewController = storyboard.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
        _ = collectionViewController.view
        collectionViewController.viewDidLoad()
        
    }

    //Service
    func testForConnection() {
        networking.getJsonData(completionHandler: { response, success in
            XCTAssert(success == true, "Service is good")
            XCTAssert(response?.count == 10, "Array has 10 elements")
        })
    }
    
    func testForDataNotNil() {
        networking.getJsonData(completionHandler: { response, _ in
            
            for index in 0...((response?.count)!-1) {
                let data = response?[index] as? NSDictionary
                let promo = data?["promoMessage"] as? String
                XCTAssert((promo != nil)  , "")
            }
        })
    }
    

    //Collectionview cell data for TDD
    func testForData() {
        
        //MockData
        let data = [["title":"TOPS STARTING AT $12", "backgroundImage":"http://anf.scene7.com/is/image/anf/anf-20160527-app-m-shirts?$anf-ios-fullwidth-3x$", "promoMessage":"USE CODE: 99999", "topDescription":"A&F ESSENTIALS", "bottomDescription":"*In stores & online.","content": ["title":"Shop Men", "target": "https://www.abercrombie.com"]]]
        
        collectionViewController.arrayData = data as NSArray
        collectionViewController.collectionView?.reloadData()
        let index = NSIndexPath(row: 0, section: 0)

        //Cell
        let cell = collectionViewController.collectionView(collectionViewController.collectionView!, cellForItemAt: index as IndexPath) as! CollectionViewCell
        
        //Data Extraction
        let dataExtract = data[0]
        let bottomDesccription = dataExtract["bottomDescription"] as? String
        let title = dataExtract["title"] as? String
        let promoMessage = dataExtract["promoMessage"] as? String
        let topDescription = dataExtract["topDescription"] as? String
        let content = dataExtract["content"] as? NSArray
        let button = content?[0] as? NSDictionary
        let titleButton = button?["title"] as? String

        //Tests
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell.title.text, title)
        XCTAssertEqual(cell.promoMessage.text, promoMessage)
        XCTAssertEqual(cell.topDescription.text, topDescription)
        XCTAssertEqual(cell.button.titleLabel?.text, titleButton)
        XCTAssertEqual(cell.bottomDescription.text, bottomDesccription)

    }

    //CollectionView Tests
    func testForConfirmingCollectionViewDelegate() {
        
        XCTAssert(collectionViewController.conforms(to: UICollectionViewDelegate.self))
    }
    
    func testForCollectionViewIsNotNilAfterViewDidLoad() {
        
        XCTAssertNotNil(collectionViewController.collectionView)
    }
    
    func testForInstantiateViewController() {
        
        XCTAssertNotNil(collectionViewController)
    }
    
    func testForHasItemsForCollectionView() {
        
        XCTAssertNotNil(collectionViewController.arrayData)
    }
    
    func testForCollectionViewDataSource() {
        
        XCTAssertNotNil(collectionViewController.collectionView?.dataSource)
    }
}
