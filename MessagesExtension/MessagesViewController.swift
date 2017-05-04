//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Roman Efimov on 21.06.16.
//  Copyright © 2016 Roman Efimov. All rights reserved.
//

import UIKit
import Messages


class MessagesViewController: MSMessagesAppViewController , UIScrollViewDelegate , MSStickerBrowserViewDataSource   {
    

    var stickers = [MSSticker]()
    

    
    var StikerPacks = [StickerPack]()
    
  //  @IBOutlet weak var StickerScroll: UIScrollView!

    @IBOutlet weak var Browser: MSStickerBrowserView!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        print(self.tabBarItem.accessibilityFrame)
 //       StickerScroll.delegate = self
   //     StickerScroll.isUserInteractionEnabled = true
     //   StickerScroll.isScrollEnabled = true

        
        Browser.dataSource = self
        
        //setupStickerScroll()
        
        let 😍 = "gff"
        print(😍)
        
        
        self.LoadStickerListFromJson(url : URL(string: "http://spl.tophope.ru/document.json")!)
        
        /*
        DispatchQueue.global().async {
            self.LoadStickerListFromJson(url : URL(string: "https://spl.tophope.ru/document.json")!)
            // Bounce back to the main thread to update the UI

        }
        */
        
    }
    
    
    

    /*
    func setupStickerScroll(){
    
        StickerScroll.contentSize = CGSize(width: 1000, height: 98)
        var x = CGFloat(integerLiteral: 0)
        for q in 0...10{
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 100, height: 98))
        var label  =    UILabel(frame: CGRect(x: 25, y: 100 , width: 100, height: 15))
            
        image.image = UIImage(named: "yaoming.png") // image of sticker pack
        label.text = "text" // name of sticker pack
            
        image.frame.origin.x = x
        label.frame.origin.x = label.frame.origin.x + x
        StickerScroll.addSubview(label)
        StickerScroll.addSubview(image)
            x += 100
        }
    } */
    @IBAction func OpenStickerBrowser(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "MainInterface", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StickerBrowserViewController") as! StickerBrowserViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
       func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    
     func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView,
                                     stickerAt index: Int) -> MSSticker {
        return stickers[index]
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
    
    func LoadStickerListFromJson(url : URL)
    {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
              var  html = String(data: data, encoding: String.Encoding.utf8) {
                print(html)
            }
        }
        task.resume()
        
       
        
        print(url)
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
                if(q == 1 || q%2 == 0)
                {
                    self.reloadInputViews()
                    Browser.reloadData()
                }
            }
        }
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
            guard let placeholderURL = bundle.url(forResource: name, withExtension: "png")  else {
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
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    


    

}
