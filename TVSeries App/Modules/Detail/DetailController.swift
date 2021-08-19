//
//  MovieDetailVC.swift
//  TV Series App
//
//  Created by David T on 3/18/21.
//

import UIKit

final class DetailController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var itemViewModel: ItemViewModel?
    private let viewModel: DetailsViewModel
    
    private let collCellId = "collectionCellId"
    private let tableCellId = "tableCellId"
    private lazy var flowLayot = UICollectionViewFlowLayout()
    private let suggestedTitle = UILabel()
    
    deinit { print("OS reclaiming memory for DetailController - No Ratain Cycle/Leak!") }
    
    private lazy var noImageLabel: UILabel = {
        let noImageLabel = UILabel()
        noImageLabel.font = .boldSystemFont(ofSize: 17)
        noImageLabel.textAlignment = .center
        noImageLabel.backgroundColor = .clear
        noImageLabel.textColor = Constants.dynamicSubColors
        noImageLabel.text = "No image"
        return noImageLabel
    }()
    
    private lazy var customImageView: UIImageView = {
        let customImageView = UIImageView()
        customImageView.backgroundColor = .clear
        return customImageView
    }()
    
    private lazy var suggestedBackgroundView: UIView = {
        let suggestedBackgroundView = UIView()
        suggestedBackgroundView.backgroundColor = .clear
        return suggestedBackgroundView
    }()
    
    private lazy var customCollectionView: UICollectionView = {
        let customCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayot)
        flowLayot.scrollDirection = .horizontal
        flowLayot.itemSize = CGSize(width: 150, height: 240)
        flowLayot.minimumLineSpacing = 3
        customCollectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: collCellId)
        customCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        customCollectionView.showsHorizontalScrollIndicator = false
        customCollectionView.backgroundColor = .clear
        customCollectionView.delegate = self
        customCollectionView.dataSource = self
        return customCollectionView
    }()
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        navigationItem.title = "loading..."
        view.backgroundColor = Constants.dynamicBackgroundColors
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: tableCellId)
        bindViewModel()
        
        if let item = itemViewModel {
            navigationItem.title = item.name
            customImageView.loadImageUsingCacheWithURL(urlString: item.backdropPath)
            
            viewModel.appendListToDetailResults(list: item)
            viewModel.fetchSimilarData(with: item.id)
        } else {
            navigationItem.title = "error"
            suggestedTitle.text = "error"
        }
    }
    
    private func bindViewModel() {
        viewModel.detailResultsArray.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                
            }
        }
        viewModel.similarResults.bind({ [weak self] _ in
            DispatchQueue.main.async {
                self?.customCollectionView.reloadData()
            }
        })
    }
    
    private func headerSetUp(header: UIView) {

        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        header.heightAnchor.constraint(equalToConstant: 230.0).isActive = true
        header.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        header.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        header.addSubview(noImageLabel)
        header.addSubview(customImageView)
        
        noImageLabel.fillSuperview()
        customImageView.fillSuperview()        
    }
    
    private func sectionTwoHeader() {
        
        suggestedTitle.font = .boldSystemFont(ofSize: 20)
        suggestedTitle.textAlignment = .left
        suggestedTitle.textColor = Constants.dynamicSubColors
        suggestedTitle.text = "Suggested"
        
        suggestedBackgroundView.addSubview(suggestedTitle)
        
        suggestedBackgroundView.addSubview(customCollectionView)
        
        suggestedTitle.layout(top: suggestedBackgroundView.safeAreaLayoutGuide.topAnchor, leading: suggestedBackgroundView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 13, left: 13, bottom: 0, right: 0), size: .init(width: 100, height: 22))
        
        customCollectionView.layout(top: suggestedTitle.safeAreaLayoutGuide.bottomAnchor, leading: suggestedBackgroundView.safeAreaLayoutGuide.leadingAnchor, bottom: suggestedBackgroundView.safeAreaLayoutGuide.bottomAnchor, trailing: suggestedBackgroundView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    //  MARK: - collectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.similarResults.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collCellId, for: indexPath) as! DetailCollectionViewCell
        let item = viewModel.similarResults.value[indexPath.row]
        cell.configure(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = viewModel.similarResults.value[indexPath.row]
//        navigate(itemViewModel: item)
    }
    
    // MARK: - tableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.detailResultsArray.value.count : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 230.0 : 320.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath) as! DetailTableViewCell
        cell.backgroundColor = Constants.dynamicBackgroundColors
        let highlighedColor = UIView()
        highlighedColor.backgroundColor = .clear
        cell.selectedBackgroundView = highlighedColor
        cell.customTextView.text = viewModel.detailResultsArray.value[indexPath.item]
        cell.descriptionLabel.text = Constants.descriptionData[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSecOne = UIView()
        headerSetUp(header: headerSecOne)
        sectionTwoHeader()
        return section == 0 ? headerSecOne : suggestedBackgroundView
    }
    
    private func navigate(viewModel: DetailsViewModel, itemViewModel: ItemViewModel) {
//        let detailViewController = DetailController(viewModel: viewModel)
//        detailViewController.itemViewModel = itemViewModel
//
//        if UIDevice.current.userInterfaceIdiom == .pad || Constants.deviceModelId.contains(UIDevice.current.modelName) && UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
//            let rootViewController = UINavigationController(rootViewController: detailViewController)
//            showDetailViewController(rootViewController, sender: self)
//        } else {
//            navigationController?.pushViewController(detailViewController, animated: true)
//        }
    }
}


//extension DetailController: Navigator {
//    func navigate(itemViewModel: ItemViewModel) {
//        switch viewModel.type {
//        case .tvSeries:
//            navigate(viewModel: DetailFactory.makeDetailViewModelForSeries(), itemViewModel: itemViewModel)
//        case .movies:
//            navigate(viewModel: DetailFactory.makeDetailViewModelForMovies(), itemViewModel: itemViewModel)
//        }
//    }
//}
