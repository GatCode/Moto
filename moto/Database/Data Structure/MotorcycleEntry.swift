import GRDB

struct MotorcycleEntry {
    let id: Int64
    let brand: String
    let model: String
    let modelExtention: String?
    let image: Data?
    let years: String
    let engineOil: String?
    let oilWithFilter: Double?
    let oilWithoutFilter: Double?
    let sparkPlug: String?
    let transmissionOil: String?
    let tirePressureFront: Double?
    let tirePressureBack: Double?
    let coolingFluidAmount: Double?
    let forkOil: String?
    let brakeFluid: String?
}

extension MotorcycleEntry : FetchableRecord {
    init(row: Row) {
        id = row["id"]
        brand = row["brand"]
        model = row["model"]
        modelExtention = row["modelExtention"]
        image = row["image"]
        years = row["years"]
        engineOil = row["engineOil"]
        oilWithFilter = row["oilWithFilter"]
        oilWithoutFilter = row["oilWithoutFilter"]
        sparkPlug = row["sparkPlug"]
        transmissionOil = row["transmissionOil"]
        tirePressureFront = row["tirePressureFront"]
        tirePressureBack = row["tirePressureBack"]
        coolingFluidAmount = row["coolingFluidAmount"]
        forkOil = row["forkOil"]
        brakeFluid = row["brakeFluid"]
    }
}
