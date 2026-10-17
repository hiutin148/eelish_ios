struct ApiResponseDto<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let statusCode: Int
    let message: String
    let errorCode: String?
}
