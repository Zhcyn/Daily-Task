final class HomeViewModel: NSObject {
    private var groups: Results<Group>?
    var didShowCreateGroup: (() -> Void)?
    var didMoveToCreateTaskVC: ((Group) -> Void)?
    override init() {
        super.init()
        setupData()
    }
    private func setupData() {
        groups = RealmService.shared.fetch(Group.self)
    }
}
extension HomeViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return groups?.count ?? 0
        } else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: GroupCell = collectionView.dequeueReusableCell(for: indexPath)
            guard let groupData = groups?[indexPath.row] else { return UICollectionViewCell() }
            cell.configGroupCell(groupData)
            cell.delegate = self
            return cell
        } else {
            let cell: CategoryCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.didAddCategory = { [weak self] in
                guard let self = self else { return }
                self.didShowCreateGroup?()
            }
            return cell
        }
    }
}
extension HomeViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 4)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 16, right: 16)
        }
    }
}
extension HomeViewModel: GroupCellProtocol {
    func moveToCreateTaskVC(group: Group) {
        didMoveToCreateTaskVC?(group)
    }
}
