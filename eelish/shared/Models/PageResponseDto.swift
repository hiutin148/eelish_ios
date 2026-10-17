struct PageResponseDto<T: Decodable>: Decodable {
    let content: [T]
    let page: Int
    let size: Int
    let totalElements: CFloat
    let totalPages: Int
    let first: Bool
    let last: Bool
}
