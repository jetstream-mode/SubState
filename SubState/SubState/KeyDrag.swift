//
//  KeyDrag.swift
//  keyGrid
//
//  Created by Josh Kneedler on 8/27/20.
//

import Foundation
import MobileCoreServices


enum KeyDragError: Error {
    case keyFailDrag
}

final class KeyDrag: NSObject {
    public static let keyDragIdentifier = "net.jetstream.keyDrag"
    var id: Int
    
    required init(id: Int) {
        self.id = id
    }
    
}

extension KeyDrag: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
       return [keyDragIdentifier as String]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> KeyDrag {
        let components = String(data: data, encoding: .utf8)!.split(separator: ",").map(String.init)
        return KeyDrag(id: Int(components[0]) ?? 0)
    }
    
    /*
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        switch typeIdentifier {
        case keyDragIdentifier:
            debugPrint("keyDrag read object case")

            guard let keyDrag = NSKeyedUnarchiver.unarchiveObject(with: data) as? KeyDrag else {
                throw KeyDragError.keyFailDrag }

            return self.init(id: keyDrag.id)

        default:
            throw KeyDragError.keyFailDrag
        }
    }
 */
}

extension KeyDrag: NSItemProviderWriting, Codable {
    public static var writableTypeIdentifiersForItemProvider: [String] {
        return [keyDragIdentifier as String]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        completionHandler("\(id)".data(using: .utf8), nil) // very terrible encoding and decoding 🙃
        let p = Progress(totalUnitCount: 1)
        p.completedUnitCount = 1
        return p
    }
/*
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Swift.Void) -> Progress? {
        switch typeIdentifier {
        case keyDragIdentifier:
            //let data = NSKeyedArchiver.archivedData(withRootObject: self)
            do {
                let data = try JSONEncoder().encode(self)
                debugPrint("keyDrag data ", data)
                completionHandler(data, nil)
            } catch {
                debugPrint("error \(error.localizedDescription)")
            }

        default:
            completionHandler(nil, KeyDragError.keyFailDrag)
        }
        return nil
    }
 */
}

extension KeyDrag: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let keyId = aDecoder.decodeInteger(forKey: "id")
        self.init(id: keyId)
    }
}


