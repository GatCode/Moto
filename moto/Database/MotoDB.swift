import UIKit
import GRDB

class MotoDB {
    
    private var dbQueue = DatabaseQueue()
    
    init(completion: @escaping (MotoDBError?) -> Void) {
        guard let documentDirectory = Bundle.main.path(forResource: "motodb", ofType: "sqlite3") else { completion(.documentDirError); return }
        guard let queue = try? DatabaseQueue(path: documentDirectory) else { completion(.databaseOpenError); return }
        dbQueue = queue
    }
    
    // f.e. motorcycleName = "BMW_K1100" -> [ID[BMW_K1100_LT], ID[BMW_K1100_RS]]
    func getMotorcycleAdditives(motorcycleName: String, completion: @escaping ([Int64]?, MotoDBError?) -> Void) {
        
        let numberOfWordsInMotorcycleString = 2
        var result = [Int64]()
        
        let motorcycle = motorcycleName.split(separator: "_")
        if motorcycle.count != numberOfWordsInMotorcycleString {
            completion(nil, MotoDBError.invalidInput(wordsNeeded: numberOfWordsInMotorcycleString))
            return
        }
        
        do {
            try dbQueue.read { db in
                let res = try MotorcycleExtentionEntry.fetchAll(db, sql: "SELECT id FROM motorcycles WHERE brand LIKE '\(String(motorcycle[0]))' AND model like '\(String(motorcycle[1]))'")
                res.forEach({ item in
                    if let id = item.id {
                        result.append(id)
                    }
                })
            }
        }
        catch {
            completion(nil, .invalidSeachTerm)
            return
        }
        
        completion(result, nil)
    }
    
    // f.e. motorcycleName = "BMW_K1100_LT" -> { MotorcycleDetails }
    func getMotorcycleInformation(uniqueMotorcycleName: String, completion: @escaping (MotorcycleEntry?, MotoDBError?)->Void ) {
        
        let minNumberOfWordsInMotorcycleString = 2
        let numberOfWordsInMotorcycleString = 3
        var result: MotorcycleEntry?
        
        let motorcycle = uniqueMotorcycleName.split(separator: "_")
        if motorcycle.count >= numberOfWordsInMotorcycleString || motorcycle.count < minNumberOfWordsInMotorcycleString {
            completion(nil, MotoDBError.invalidInput(minWordsNeeded: minNumberOfWordsInMotorcycleString, maxWordsNeeded: numberOfWordsInMotorcycleString))
            return
        }

        do {
            try dbQueue.read { db in
                var query = ""
                
                switch motorcycle.count {
                case minNumberOfWordsInMotorcycleString:
                    query = "SELECT * FROM motorcycles WHERE brand LIKE '\(String(motorcycle[0]))' AND model like '\(String(motorcycle[1]))'"
                case numberOfWordsInMotorcycleString:
                    query = "SELECT * FROM motorcycles WHERE brand LIKE '\(String(motorcycle[0]))' AND model like '\(String(motorcycle[1]))' AND modelExtention like '\(String(motorcycle[2]))'"
                default:
                    completion(nil, MotoDBError.invalidInput(minWordsNeeded: minNumberOfWordsInMotorcycleString, maxWordsNeeded: numberOfWordsInMotorcycleString))
                }
 
                result = try MotorcycleEntry.fetchAll(db, sql: query).first
                
                if result != nil {
                    completion(result, nil)
                }
                else {
                    completion(nil, .invalidInputTerm)
                }
            }
        }
        catch {
            completion(nil, .invalidSeachTerm)
            return
        }
    }
    
    func getMotorcycleById(id: Int64, completion: @escaping (MotorcycleEntry?, MotoDBError?)->Void ) {
        
        do {
            try dbQueue.read { db in
                let query = "SELECT * FROM motorcycles WHERE id = \(id)"
                
                let result = try MotorcycleEntry.fetchAll(db, sql: query).first
                
                if result != nil {
                    completion(result, nil)
                }
                else {
                    completion(nil, .invalidInputTerm)
                }
            }
        }
        catch {
            completion(nil, .invalidSeachTerm)
            return
        }
    }
    
    func getMotorcycleImage(id: Int64, completion: @escaping (UIImage?, MotoDBError?)->Void ) {
        
        do {
            try dbQueue.read { db in
                let query = "SELECT * FROM motorcycles WHERE id = \(id)"
                
                let result = try MotorcycleEntry.fetchAll(db, sql: query).first
                
                if result != nil {
                    guard let data = result?.image else { completion(nil, .unexpectedError); return }
                    completion(UIImage(data: data), nil)
                }
                else {
                    completion(nil, .invalidInputTerm)
                }
            }
        }
        catch {
            completion(nil, .unexpectedError)
            return
        }
    }
    
    func serchDatabase(searchTerm: String, completion: @escaping ([MotorcycleEntry]?, MotoDBError?)->Void ) {
        
        let motorcycle = searchTerm.split(separator: " ")
        var result = [MotorcycleEntry]()
        
        do {
            try dbQueue.read { db in
                var query = ""
                
                switch motorcycle.count {
                case 1:
                    query = "SELECT * FROM motorcycles WHERE (brand LIKE '%\(String(motorcycle[0]))%') OR (model LIKE '%\(String(motorcycle[0]))%') OR (modelExtention LIKE '%\(String(motorcycle[0]))%')"
                case 2:
                    query = "SELECT * FROM motorcycles WHERE (brand LIKE '%\(String(motorcycle[0]))%' AND model LIKE '%\(String(motorcycle[1]))%') OR (brand LIKE '%\(String(motorcycle[1]))%' AND model like '%\(String(motorcycle[0]))%')"
                case 3:
                    query = "SELECT * FROM motorcycles WHERE brand LIKE '%\(String(motorcycle[0]))%' AND model LIKE '%\(String(motorcycle[1]))%' AND modelExtention LIKE '%\(String(motorcycle[3]))%'"
                default:
                    query = "SELECT * FROM motorcycles"
                }
                
                let res = try MotorcycleEntry.fetchAll(db, sql: query)
                res.forEach({ item in
                    result.append(item)
                })
                
                completion(result, nil)
                return
            }
        }
        catch {
            completion(nil, .invalidSeachTerm)
            return
        }
    }
}
