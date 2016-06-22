# Sticker Loader For Imessage


# Functions :

- createLocalSticker(name: String) -  load sticker from project 
- LoadSticker(url : URL , name : String , directory : String ) - load image from internet save it and create sticker
- LoadStickerListFromJson(url : URL)  - load Json file  with Sticker Packs and parse it 
- LoadStickerFromMemmory(name: String , directory: String) - load images from documents/directory
- addStickersFromJson() - create stickers from Json


   

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


