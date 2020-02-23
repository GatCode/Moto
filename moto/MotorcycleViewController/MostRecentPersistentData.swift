import Foundation

class MostRecentPersistentData {
    
    private var mostRecentMotorcycles = [MostRecentMotorcycle]()
    static let shared = MostRecentPersistentData()
    private let defaults = UserDefaults.standard
    
    func getPersistentData(completion: @escaping ([MostRecentMotorcycle]?, PersistentDataError?) -> Void) {
        if let data = defaults.value(forKey: def_mostRecentPersistentDataKey) as? Data {
            guard let motorcycles = try? PropertyListDecoder().decode(Array<MostRecentMotorcycle>.self, from: data) else { completion(nil, .decodingError); return }
            self.mostRecentMotorcycles = motorcycles
        }
        
        completion(mostRecentMotorcycles, nil)
    }
    
    func saveToPersistentData(motorcycle: MostRecentMotorcycle, completion: @escaping (PersistentDataError?) -> Void) {
        
        var alreadyInPersistentData = false

        if mostRecentMotorcycles.count == 0 {
            mostRecentMotorcycles.insert(motorcycle, at: 0)
        }
        else {
            for item in mostRecentMotorcycles {
                if motorcycle.id == item.id {
                    alreadyInPersistentData = true
                }
            }

            if !alreadyInPersistentData {
                if mostRecentMotorcycles.count < def_mostRecentMaxCellCount {
                    mostRecentMotorcycles.insert(motorcycle, at: 0)
                }
                else {
                    mostRecentMotorcycles.insert(motorcycle, at: 0)
                    mostRecentMotorcycles.remove(at: def_mostRecentMaxCellCount)
                }
            }
        }
        do {
            self.defaults.set(try PropertyListEncoder().encode(mostRecentMotorcycles), forKey: def_mostRecentPersistentDataKey)
            completion(nil)
        }
        catch {
            completion(.encodingError)
        }
    }
}

struct MostRecentMotorcycle: Codable {
    let id: Int64
    let brand: String
    let model: String
    let modelExtention: String?
    let year: String
}

enum PersistentDataError: Error {
    case encodingError
    case decodingError
}
