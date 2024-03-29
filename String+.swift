extension String {
    func setStrikeThrough() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue),
            NSAttributedString.Key.strikethroughColor: UIColor.black
        ]
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttributes(attributes, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    func removeWhitespace() -> String {
        return self.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
    }
}
