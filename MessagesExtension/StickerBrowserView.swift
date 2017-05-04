//
//  StickerBrowserView.swift
//  StickerPackLoader
//
//  Created by Roman Efimov on 23.06.16.
//  Copyright © 2016 Roman Efimov. All rights reserved.
//

import UIKit
import Messages

class StickerBrowserView: MSStickerBrowserView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var stickers = [MSSticker]()
    
    var StikerPacks = [StickerPack]()
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    override init (frame : CGRect) {
    
        super.init(frame: frame)
        self.LoadStickerListFromJson(url : URL(string: "https://spl.tophope.ru/document.json")!)
        self.addStickersFromJson()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func LoadStickerFromDocuments(name: String , directory: String)
    {
        var Url : URL
        do {
        
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            do
            {
                let filePath = try paths[0].appendingPathComponent("\(directory)/\(name).png")
                Url = filePath
            }
            catch {fatalError(" \(error)") }
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
    
    
    func removeDirectory(directory : String )
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        do
        {
            let dataPath = try paths[0].appendingPathComponent("\(directory)")
            do{
                try FileManager.default.removeItem(at: dataPath)
                //try FileManager.default().createDirectory(at: dataPath, withIntermediateDirectories: false, attributes: nil)
            }
            catch let error as NSError { print(error.localizedDescription)}
        }
        catch let error as NSError { print(error.localizedDescription)}
        
        
    }
    func LoadSticker(url : URL , name : String , directory : String )
    {
        
        do {
            let data = try Data(contentsOf: url)
           
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            var Url : URL
            do
            {
                let dataPath = try paths[0].appendingPathComponent("\(directory)")
                do{
                    
                    try FileManager.default.createDirectory(at: dataPath, withIntermediateDirectories: false, attributes: nil)
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
            let bundle = Bundle.main
    
            guard let placeholderURL = bundle.url(forResource: name, withExtension: "png") else {
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
    
     func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    
     func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView,
                                     stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }
    

    

}
