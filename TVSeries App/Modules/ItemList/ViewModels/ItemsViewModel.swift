//
//  ViewModel.swift
//  TVSeries App
//
//  Created by David T on 7/7/21.
//

import Foundation
import Combine

final class ItemsViewModel {

    private let type: ListType
    private let itemsService: ItemsService

    lazy var page = 1
    private lazy var language = "en-US"
    weak var coordinator: HomeCoordinator?
    
    @Published var searchText: String?
    @Published var fetchingState: FetchingServiceState = FetchingServiceState.loading
    
    private var cancellables = Set<AnyCancellable>()
    
    private let itemsSubject = CurrentValueSubject<[ItemViewModel], Error>([])
    lazy var items: AnyPublisher<[ItemViewModel], Never> = itemsSubject.replaceError(with: []).eraseToAnyPublisher()
    
    private let tableReloadTrigger = PassthroughSubject<Void, Never>()
    lazy var shouldReloadTableView: AnyPublisher<Void, Never> = tableReloadTrigger.eraseToAnyPublisher()
    
    let selectedIndexPath = PassthroughSubject<IndexPath, Never>()

    init(_ service: ItemsService, type: ListType, coordinator: HomeCoordinator) {
        self.itemsService = service
        self.type = type
        self.coordinator = coordinator
        bind()
    }
    
    private func bind() {
        $searchText
            .compactMap({ $0 })
            .sink { [weak self] query in
                self?.searchData(query)
            }
            .store(in: &cancellables)
            
        
        $searchText
            .filter({ [weak self] _ in
                self?.itemsSubject.value.isEmpty == false
            })
            .compactMap({ $0 })
            .sink { [weak self] _ in
                self?.itemsSubject.send([])
            }
            .store(in: &cancellables)
        
        selectedIndexPath
            .compactMap { [weak self] indexPath in
                self?.getItemAtIndex(indexPath: indexPath)
            }
            .sink { [coordinator, type] item in
                coordinator?.openItem(itemViewModel: item, listType: type)
            }
            .store(in: &cancellables)
    }
    
     func performSearch(_ query: String?) {
        if itemsSubject.value.count > 0 {
            itemsSubject.value.removeAll()
            tableReloadTrigger.send()
        }
        searchData(query!)
    }

    func refresh() {
        fetchData()
    }
    
    func moveToNewPageIfNeeded(indexPath: IndexPath) {
        if indexPath.row + 1 == itemsSubject.value.count && fetchingState != .loading {
            page += 1
            if let text = searchText, !text.isEmpty {
                searchData(text)
            } else {
                fetchData()
            }
        }
    }
    
    func clearTableViewIfNeeded() {
        if itemsSubject.value.count >= 0 {
            itemsSubject.value.removeAll()
            tableReloadTrigger.send()
            page = 1
            fetchData()
        }
    }
    
    func getItemAtIndex(indexPath: IndexPath) -> ItemViewModel {
        itemsSubject.value[indexPath.item]
    }
    
    func makeNumberOfRowsInSection() -> Int {
        return itemsSubject.value.count
    }
    
    func makeSearchTextFieldPlaceholder() -> String {
        return type.searchTextFieldPlaceholder
    }

    func fetchData() {
        fetchingState = .loading
        itemsService.fetchData(language: language, page: page, completion: handleApiResults)
    }

    func searchData(_ query: String) {
        fetchingState = .loading
        if itemsSubject.value.count != 1 {
            let queryWithOccurrences = "&query=\(query)".replacingOccurrences(of: " ", with: "%20")
            itemsService.searchData(language: language, page: page, query: queryWithOccurrences, completion: handleApiResults)
        }
    }
    
    private func handleApiResults(_ results: Result<[ItemViewModel], ErrorHandling>) {
        switch results {
        case .success(let list):
            itemsSubject.send(itemsSubject.value + list)
        case .failure(let error):
            print(error)
            fetchingState = .error(error.rawValue)
        }
        fetchingState = .finished
    }
}


enum ListType {
    case tvSeries
    case movies
    
    var searchTextFieldPlaceholder: String {
        switch self {
        case .tvSeries:
            return "Search TV Series"
        case .movies:
            return "Search Movies"
        }
    }
}
