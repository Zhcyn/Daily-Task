extension UIScrollView {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    @objc
    func dismissKeyboard(_ gesture : UITapGestureRecognizer) {
        self.endEditing(true)
    }
}
