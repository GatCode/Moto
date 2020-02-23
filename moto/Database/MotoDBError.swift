enum MotoDBError: Error {
    // Indicates a parsing error of the received document
    case parse
    // Indicates a missing document
    case noDocument(error: Error)
    // Indicates a wrong search term
    case invalidSeachTerm
    // Indicates an invalid input
    case invalidInput(wordsNeeded: Int)
    // Indicates an invalid input
    case invalidInput(minWordsNeeded: Int, maxWordsNeeded: Int)
    // Indicates an invalid firestore entry
    case invalidFirestoreEntry
    // Indicates an unexpected error
    case unexpectedError
    // Indicates an invalig input Term
    case invalidInputTerm
    // Indicates a wrong document path
    case documentDirError
    // Indicates a database opening error
    case databaseOpenError
}
