//
//  NSKeyedArchiver+HF.swift
//  Pods
//
//  Created by DragonCherry on 7/19/16.
//
//

import Foundation

extension NSKeyedArchiver {
    
    @discardableResult
    public class func archive(_ object: Any, path: String, key: String) -> Bool {
        let mutableData: NSMutableData = NSMutableData()
        let archiver: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: mutableData)
        archiver.encode(object, forKey: key)
        archiver.finishEncoding()
        return mutableData.write(toFile: path, atomically: true)
    }
}
