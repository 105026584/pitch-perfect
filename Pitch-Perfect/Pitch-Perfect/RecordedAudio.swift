//
//  RecordedAudio.swift
//  Pitch-Perfect
//
//  Created by Andreas Pfister on 17/04/15.
//  Copyright (c) 2015 General Electrics. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String ) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}