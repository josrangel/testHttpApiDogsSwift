//
//  Serializer.swift
//  httpApiDogs
//
//  Created by KMMX on 03/11/20.
//

import Foundation

protocol Serializer{
    func serialize(data: AnyObject) -> NSData?
}

class RequestSerializer: Serializer {
    func serialize(data: AnyObject) -> NSData? {
        return NSData()
    }
}

class DataManager {
    //var serializer: Serializer? = RequestSerializer()//la dependencia existe, pero no se esta injectando
    var serializer: Serializer?
}

class Injection{
    init() {
        let dataManager = DataManager()
        dataManager.serializer=RequestSerializer() //se hace la injeccion de la dependencia
    }
}
