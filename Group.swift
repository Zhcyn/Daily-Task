@objcMembers class Group: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var groupName: String = ""
    dynamic var icon: String?
    var tasks = List<Task>()
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(groupName: String, icon: String?) {
        self.init()
        self.groupName = groupName
        self.icon = icon
    }
}
