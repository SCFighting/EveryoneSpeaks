//
//  BaseModel.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/22.
//

import UIKit
import KakaJSON

class BaseModel: NSObject,Convertible {
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name
    }
    var message = ""
    var result = "ok"
    
    required override init(){}
}
