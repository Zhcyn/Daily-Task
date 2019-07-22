@objcMembers class Task: Object {
    dynamic var id = UUID().uuidString
    dynamic var taskName: String = ""
    dynamic var isChecked: Bool = false
    dynamic var timer: Date?
    let group = LinkingObjects(fromType: Group.self, property: "tasks")
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(taskName: String, timer: Date?) {
        self.init()
        self.taskName = taskName
        self.timer = timer
    }
}
