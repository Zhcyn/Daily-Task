final class CategoryCell: UICollectionViewCell, NibReusable {
    @IBOutlet private weak var addCategoryView: UIView!
    var didAddCategory: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAddCategoryButtonTapped))
        tapGesture.numberOfTapsRequired = 1
        addCategoryView.addGestureRecognizer(tapGesture)
    }
    @objc
    private func handleAddCategoryButtonTapped(_ gesture: UITapGestureRecognizer) {
        didAddCategory?()
    }
}
