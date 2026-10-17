struct TreeNode: Identifiable, Decodable {
    let id: String
    let parentId: String?
    let title: String
    var children: [TreeNode]

    enum CodingKeys: String, CodingKey {
        case id, parentId, title, children
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        parentId = try c.decodeIfPresent(String.self, forKey: .parentId)
        title = try c.decode(String.self, forKey: .title)
        children = try c.decodeIfPresent([TreeNode].self, forKey: .children) ?? []
    }
}
