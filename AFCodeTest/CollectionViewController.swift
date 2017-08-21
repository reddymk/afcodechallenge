//
//  CollectionViewController.swift
//  AFCodeTest
//
//  Created by Manish Reddy on 10/30/16.
//  Copyright © 2016 Manish. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionViewCell"

class CollectionViewController: UICollectionViewController {
    
    var arrayData: NSArray = []
    let regExPattern = "<(.*?)>"        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Getting Data from server
        Networking.sharedInstance.getJsonData() { result in
            guard let array = result.0, result.1 else {
                // No Data
            return
            }
            self.arrayData = array
            self.collectionView?.reloadData()
        }
    }


    //CollectionView
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell

        cell.button.removeFromSuperview()
        
        if let data = arrayData[indexPath.row] as? NSDictionary {
            
            //Applying data to the cell labels.
            cell.title.text = data["title"] as? String
            cell.topDescription.text = data["topDescription"] as? String
            cell.promoMessage.text = data["promoMessage"] as? String
            let unFormattedText = data["bottomDescription"] as? String
            
            //Parsing bottomDescription and remove reference link.
            do {
            cell.bottomDescription.text = try unFormattedText?.replacing(pattern: regExPattern, withTemplate: "")
            } catch { }
            
            //Downloading Image and appling it to Cell ImageView,
            if let imageLink = data["backgroundImage"] as? String {
                Networking.sharedInstance.downloadImageFromServer(imageLink, completionHandler: { (image, response) in
                    guard response else {
                        //No Image
                        return
                    }
                    cell.imageView.image = image
                })
            }            
            
            //Cell Buttons
            if let content = data["content"] as? NSArray {
                
                for index in 0...(content.count-1) {
                    if let dicData = content[index] as? NSDictionary {
                        
                        cell.button = UIButton(frame: CGRect(x: 100, y: 333+(35*index), width: 200, height: 30))
                        let title1 = dicData["title"] as? String
                        cell.button.setTitle(title1 as String?, for: .normal)
                        cell.button.setTitleColor(UIColor.darkGray, for: .normal)
                        cell.button.layer.borderWidth = 1
                        cell.button.layer.borderColor = UIColor.darkGray.cgColor
                        cell.button.titleLabel?.font = UIFont(name: "System", size: 15)
                        cell.button.addTarget(self, action: #selector(buttonCLick) , for: .touchUpInside)
                        cell.button.tag = index
                        cell.contentView.addSubview(cell.button)
                    }
                }
            }
        }
        return cell
    }
 
    //Button Logic click to display the webpage. 
    func buttonCLick(sender: AnyObject) {
        if let URL = URL(string: "https://www.abercrombie.com/shop/us") {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
    }

}

//String Extension
extension String {
    //RegularExperssion parsing.
    func replacing(pattern: String, withTemplate: String) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(0..<self.utf16.count), withTemplate: withTemplate)
    }
}
