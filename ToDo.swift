
import Foundation
import RealmSwift

class ToDo: Object {
    @Persisted var Description: String = ""
    @Persisted var isDone: Bool = false
}
