# Sticker Loader For Imessage

# ScreenShots : 

![ScreenShot](https://spl.tophope.ru/firstScreen.png)
![ScreenShot](https://spl.tophope.ru/secondScreen.png)


# Functions :

- createLocalSticker(name: String) -  load sticker from project 
- LoadSticker(url : URL , name : String , directory : String ) - load image from internet save it and create sticker
- LoadStickerListFromJson(url : URL)  - load Json file  with Sticker Packs and parse it 
- LoadStickerFromDocuments(name: String , directory: String) - load images from directory in Documents
- addStickersFromJson() - create stickers from Json
- removeDirectory(directory: String) - remove directory in Documents folder  


   

# JsonStruct :

```sh
{"StickerPacks":[ 

    {
    "name": "",
    "count": 0,
    "link": ""
    }
    ]
}
```
# To Do :

- Save path of downloaded Stickers
- Add sticker catalog 
- Add sticker manager
- Add design
- Create Stickers from photo library 


