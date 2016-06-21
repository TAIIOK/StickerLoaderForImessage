//
//  StickerBrowserViewController.swift
//  StikerLoader
//
//  Created by Roman Efimov on 15.06.16.
//  Copyright © 2016 Roman Efimov. All rights reserved.
//

/*
///JSON STRUCT
/*

 {"StickerPacks":[
 {
 "name": "test",
 "count": 1,
 "links": ["https://pp.vk.me/c606621/v606621505/7af7/dZnzJQLMFVs.jpg"]
 }
 ]
 }
 
 */
 */
import Foundation
import Messages
import UIKit

extension UIImage{
    func scaledToSize(size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

class StickerPack{
    
    var  name :String = ""
    var  count : Int = 0
    var  links :[String] = []
    
    init(name:String, count:Int, links: [String]) {
        self.name = name
        self.count = count
        self.links = links
    }
    
};

class StickerBrowserViewController: MSStickerBrowserViewController {
    
    var stickers = [MSSticker]()
    
    var StikerPacks = [StickerPack]()
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSticker(name: "yaoming")
        LoadSticker(url: URL(string: "https://pp.vk.me/c606621/v606621505/7af7/dZnzJQLMFVs.jpg")!)
        
        let bundle = Bundle.main()
        guard let placeholderURL = bundle.urlForResource("document", withExtension: "json") else {
            fatalError("Unable to find placeholder  image")
        }
        
        LoadStickerListFromJson(url : placeholderURL)
    
    }
    

    
    func LoadSticker(url : URL )
    {
            do {
                let data = try Data(contentsOf: url)
                let bundle = Bundle.main()
                let paths = FileManager.default().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)
                var Url : URL
                do
                {
                    let filePath = try paths[0].appendingPathComponent("filename.jpg")
                    Url = filePath
                    
                    
                    try  UIImagePNGRepresentation((UIImage(data: data)?.scaledToSize(size: CGSize(width: 442, height: 556)))!)?.write(to: Url)
                }
                catch {
                    fatalError("\(error)")
                }
                
                
                let sticker: MSSticker = {
                    
                    do {
                        
                        
                        let description = NSLocalizedString("filename", comment: "")
                        return try MSSticker(contentsOfFileURL: Url, localizedDescription: description)
                    }
                    catch {
                        fatalError(" \(error)")
                    }
                }()
                
                self.stickers.append(sticker)
            
            }
            catch {
                fatalError("\(error)")
            }
        
    
    }
    

    func createSticker(name: String) {
        let sticker: MSSticker = {
            let bundle = Bundle.main()
            guard let placeholderURL = bundle.urlForResource(name, withExtension: "png") else {
                fatalError("Unable to find placeholder  image")
            }
            do {
                let description = NSLocalizedString(name, comment: "")
                return try MSSticker(contentsOfFileURL: placeholderURL, localizedDescription: description)
            }
            catch {
                fatalError("\(error)")
            }
        }()
        stickers.append(sticker)
    }
    
    
    func LoadStickerListFromJson(url : URL)
    {
        do{
            let jsonData =  try Data(contentsOf: url)
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if let Packs : [NSDictionary] = json["StickerPacks"] as? [NSDictionary] {
                    for  i : NSDictionary in Packs {
                        let name = i.value(forKey: "name")
                        
                        if let d = name {
                            StikerPacks.append(StickerPack(name: d as! String, count: i.value(forKey: "count") as! Int , links: i.value(forKey: "links") as! [String]))
                        }
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        
        }
        catch {  fatalError(" \(error)")}
        
        print("its works")
        print(StikerPacks.count)
    
    }
    
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView,
                                     stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }

}
