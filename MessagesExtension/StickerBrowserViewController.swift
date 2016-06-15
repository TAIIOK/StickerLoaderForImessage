//
//  StickerBrowserViewController.swift
//  StikerLoader
//
//  Created by Roman Efimov on 15.06.16.
//  Copyright © 2016 Roman Efimov. All rights reserved.
//

import Foundation
import Messages
import UIKit

class StickerBrowserViewController: MSStickerBrowserViewController {
    
    var stickers = [MSSticker]()
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSticker(name: "yaoming")
        let url = URL(string: "https://pp.vk.me/c616730/v616730757/fea/Oq5FXiHPi0Y.jpg")
        LoadSticker(url: url!)
        
    
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

                    try  data.write(to: Url)
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
    
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView,
                                     stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }

}
