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
 "link": "https://pp.vk.me/c606621/v606621505/7af7/"
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
    var  link :String = ""
    
    init(name:String, count:Int, link: String) {
        self.name = name
        self.count = count
        self.link = link
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
        
        //createLoacalSticker(name: "yaoming")
        
        //LoadStickerFromMemmory(name: "test.1" , directory : "test")
        
       // LoadStickerListFromJson(url : URL(string: "https://spl.tophope.ru/document.json")!)
      
        
    }
    
    func LoadStickerFromMemmory(name: String , directory: String)
    {
        var Url : URL
        do {
            let bundle = Bundle.main()
            let paths = FileManager.default().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)
            
            do
            {
                let filePath = try paths[0].appendingPathComponent("\(directory)/\(name).png")
                Url = filePath
            }
            catch {fatalError(" \(error)") }
        }
        catch { fatalError(" \(error)") }
        let sticker: MSSticker = {
            
            do {
                
                
                let description = NSLocalizedString("\(name)", comment: "")
                return try MSSticker(contentsOfFileURL: Url, localizedDescription: description)
            }
            catch {
                fatalError(" \(error)")
            }
        }()
        
        self.stickers.append(sticker)
        
    }


    
    func LoadSticker(url : URL , name : String , directory : String )
    {

            do {
                let data = try Data(contentsOf: url)
                let bundle = Bundle.main()
                let paths = FileManager.default().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)
                var Url : URL
                do
                {
                    let dataPath = try paths[0].appendingPathComponent("\(directory)")
                    do{
                     try FileManager.default().createDirectory(at: dataPath, withIntermediateDirectories: false, attributes: nil)
                    }
                    catch let error as NSError { print(error.localizedDescription)}
                    let filePath = try paths[0].appendingPathComponent("\(directory)/\(name).png")
                    
                    
                    Url = filePath
                    
                   
                    
                    try  UIImagePNGRepresentation((UIImage(data: data)?.scaledToSize(size: CGSize(width: 206, height: 206)))!)?.write(to: Url)
                }
                catch {
                    fatalError("\(error)")
                }
                
                
                let sticker: MSSticker = {
                    
                    do {
                        
                        
                        let description = NSLocalizedString("\(name)", comment: "")
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
    

    func createLocalSticker(name: String) {
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
                            StikerPacks.append(StickerPack(name: d as! String, count: i.value(forKey: "count") as! Int , link: i.value(forKey: "link") as! String))
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
        
        addStickersFromJson()
    
    }
    
    func addStickersFromJson()
    {
        for i in StikerPacks
        {
            for q in 0...i.count{
                LoadSticker(url : URL(string: i.link+"\(q+1).png" )! , name: i.name+".\(q+1)" , directory: i.name)
            }
        }
    }
    
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView,
                                     stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }

}
