//
//  Storage.swift
//  TumblrClient
//
//  Created by Ivan Murashov on 12/09/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit

class Storage: NSObject {
    
    let mock: [String] = [
        "https://78.media.tumblr.com/7cb3940c521a7f5bc7fd01b18aa0f8fb/tumblr_o144o11G761uh2l19o1_1280.jpg",
        "https://78.media.tumblr.com/45e530a5481cf202272c4d3ca32c4718/tumblr_o144o11G761uh2l19o3_1280.jpg",
        "https://78.media.tumblr.com/62eb64db936ec42590336a650769cbdd/tumblr_o144o11G761uh2l19o4_1280.jpg"]

    func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    func load() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
}
