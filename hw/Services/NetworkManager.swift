import Moya

protocol NetworkManagerProtocol {
    func fetchCharacters(
        completion: @escaping (Result<CharacterResponseModel, Error>
        ) -> Void)

    func pageFetchCharacters(
        page: Int,
        completion: @escaping (Result<CharacterResponseModel, Error>
        ) -> Void)
}

final class NetworkManger: NetworkManagerProtocol {
    private var provider = MoyaProvider<API>()

    func fetchCharacters(
        completion: @escaping (Result<CharacterResponseModel, Error>
        ) -> Void)
    {
        request(target: .getCharacters, completion: completion)
    }

    func pageFetchCharacters(
        page: Int,
        completion: @escaping (Result<CharacterResponseModel, Error>
        ) -> Void)
    {
        request(target: .pageGetCharacters(page: page), completion: completion)
    }
}

private extension NetworkManger {
    func request<T: Decodable>(
        target: API,
        completion: @escaping (Result<T, Error>) -> Void)
    {
        provider.request(target) {
            result in switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
