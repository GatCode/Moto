import GRDB

struct MotorcycleExtentionEntry: Codable {
    var id: Int64?
}

extension MotorcycleExtentionEntry : FetchableRecord {
    init(row: Row) {
        id = row["id"]
    }
}
