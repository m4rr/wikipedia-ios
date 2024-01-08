import XCTest
@testable import Components

final class WKSourceEditorFormatterButtonActionTests: XCTestCase {
    
    let mediator = {
        let viewModel = WKSourceEditorViewModel(configuration: .full, initialText: "", localizedStrings: WKSourceEditorLocalizedStrings.emptyTestStrings, isSyntaxHighlightingEnabled: true, textAlignment: .left)
        let mediator = WKSourceEditorTextFrameworkMediator(viewModel: viewModel)
        mediator.updateColorsAndFonts()
        return mediator
    }()

    func testBoldInsert() throws {
        let text = "One Two Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 4, length: 3)
        mediator.boldItalicsFormatter?.toggleBoldFormatting(action: .add, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One '''Two''' Three Four")
    }
    
    func testBoldRemove() throws {
        let text = "One '''Two''' Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 7, length: 3)
        mediator.boldItalicsFormatter?.toggleBoldFormatting(action: .remove, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three Four")
    }
    
    func testItalicsInsert() throws {
        let text = "One Two Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 8, length: 5)
        mediator.boldItalicsFormatter?.toggleItalicsFormatting(action: .add, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two ''Three'' Four")
    }
    
    func testItalicsRemove() throws {
        let text = "One Two '''Three''' Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 11, length: 5)
        mediator.boldItalicsFormatter?.toggleBoldFormatting(action: .remove, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three Four")
    }
    
    func testSingleBoldRemove() throws {
        let text = "One '''Two''' Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 8, length: 0) // Just a cursor inside Two
        mediator.boldItalicsFormatter?.toggleBoldFormatting(action: .remove, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three Four")
    }
    
    func testSingleItalicsRemove() throws {
        let text = "One Two '''Three''' Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 14, length: 0)
        mediator.boldItalicsFormatter?.toggleBoldFormatting(action: .remove, in: mediator.textView) // Just a cursor inside Three
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three Four")
    }
    
    func testBoldItalicsInsert() throws {
        let text = "One Two Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 4, length: 3)
        mediator.boldItalicsFormatter?.toggleBoldFormatting(action: .add, in: mediator.textView)
        mediator.boldItalicsFormatter?.toggleItalicsFormatting(action: .add, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One '''''Two''''' Three Four")
    }
    
    func testBoldItalicsRemove() throws {
        let text = "One '''''Two''''' Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 9, length: 3)
        mediator.boldItalicsFormatter?.toggleBoldFormatting(action: .remove, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One ''Two'' Three Four")
        mediator.boldItalicsFormatter?.toggleItalicsFormatting(action: .remove, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three Four")
    }
    
    func testSingleBoldInsertAndRemove() throws {
        let text = "One Two Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 4, length: 0) // Just a cursor before Two
        mediator.boldItalicsFormatter?.toggleBoldFormatting(action: .add, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One ''' '''Two Three Four")
        mediator.boldItalicsFormatter?.toggleBoldFormatting(action: .remove, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three Four")
    }
    
    func testSingleItalicsInsertAndRemove() throws {
        let text = "One Two Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 4, length: 0) // Just a cursor before Two
        mediator.boldItalicsFormatter?.toggleItalicsFormatting(action: .add, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One '' ''Two Three Four")
        mediator.boldItalicsFormatter?.toggleItalicsFormatting(action: .remove, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three Four")
    }
    
    func testTemplateInsert() throws {
        let text = "One Two Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 4, length: 3)
        mediator.templateFormatter?.toggleTemplateFormatting(action: .add, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One {{Two}} Three Four")
    }
    
    func testTemplateRemove() throws {
        let text = "One {{Two}} Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 6, length: 3)
        mediator.templateFormatter?.toggleTemplateFormatting(action: .remove, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three Four")
    }
    
    func testSingleTemplateInsertAndRemove() throws {
        let text = "One Two Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 4, length: 0) // Just a cursor before Two
        mediator.templateFormatter?.toggleTemplateFormatting(action: .add, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One {{ }}Two Three Four")
        mediator.templateFormatter?.toggleTemplateFormatting(action: .remove, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three Four")
    }
    
    func testStrikethroughInsertAndRemove() throws {
        let text = "One Two Three Four"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 4, length:3)
        mediator.strikethroughFormatter?.toggleStrikethroughFormatting(action: .add, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One <s>Two</s> Three Four")
        mediator.strikethroughFormatter?.toggleStrikethroughFormatting(action: .remove, in: mediator.textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three Four")
    }
    
    func testLinkWizardParametersEdit() throws {
        let text = "Testing [[Cat]] Testing"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 10, length:3)
        let wizardParameters = mediator.linkFormatter?.linkWizardParameters(action: .edit, in: mediator.textView)
        XCTAssertEqual(wizardParameters?.editPageTitle, "Cat")
        XCTAssertNil(wizardParameters?.editPageLabel)
        XCTAssertEqual(wizardParameters?.preselectedTextRange, mediator.textView.selectedTextRange)
    }
    
    func testLinkWizardParametersEditWithLabel() throws {
        let text = "Testing [[Cat|Kitty]] Testing"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 10, length:3)
        let wizardParameters = mediator.linkFormatter?.linkWizardParameters(action: .edit, in: mediator.textView)
        XCTAssertEqual(wizardParameters?.editPageTitle, "Cat")
        XCTAssertEqual(wizardParameters?.editPageLabel, "Kitty")
        XCTAssertEqual(wizardParameters?.preselectedTextRange, mediator.textView.selectedTextRange)
    }
    
    func testLinkWizardParametersInsert() throws {
        let text = "Testing Cat Testing"
        mediator.textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 8, length:3)
        let wizardParameters = mediator.linkFormatter?.linkWizardParameters(action: .insert, in: mediator.textView)
        XCTAssertEqual(wizardParameters?.insertSearchTerm, "Cat")
        XCTAssertEqual(wizardParameters?.preselectedTextRange, mediator.textView.selectedTextRange)
    }
    
    func testLinkInsert() {
        let text = "One Two Three Four"
        let textView = mediator.textView
        textView.attributedText = NSAttributedString(string: text)
        
        guard let startPos = textView.position(from: textView.beginningOfDocument, offset: 4),
              let endPos = textView.position(from: textView.beginningOfDocument, offset: 7),
        let preselectedTextRange = textView.textRange(from: startPos, to: endPos) else {
            XCTFail("Failure creating preselectedTextRange")
            return
        }
        
        mediator.linkFormatter?.insertLink(in: textView, pageTitle: "Two", preselectedTextRange: preselectedTextRange)
        XCTAssertEqual(mediator.textView.attributedText.string, "One [[Two]] Three Four")
    }
    
    func testLinkEdit() {
        let text = "One Two [[Three]] Four"
        let textView = mediator.textView
        textView.attributedText = NSAttributedString(string: text)
        
        guard let startPos = textView.position(from: textView.beginningOfDocument, offset: 10),
              let endPos = textView.position(from: textView.beginningOfDocument, offset: 15),
        let preselectedTextRange = textView.textRange(from: startPos, to: endPos) else {
            XCTFail("Failure creating preselectedTextRange")
            return
        }
        
        mediator.linkFormatter?.editLink(in: textView, newPageTitle: "Five", newPageLabel: nil, preselectedTextRange: preselectedTextRange)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two [[Five]] Four")
    }
    
    func testLinkEditWithLabel() {
        let text = "One Two [[Three]] Four"
        let textView = mediator.textView
        textView.attributedText = NSAttributedString(string: text)
        
        guard let startPos = textView.position(from: textView.beginningOfDocument, offset: 10),
              let endPos = textView.position(from: textView.beginningOfDocument, offset: 15),
        let preselectedTextRange = textView.textRange(from: startPos, to: endPos) else {
            XCTFail("Failure creating preselectedTextRange")
            return
        }
        
        mediator.linkFormatter?.editLink(in: textView, newPageTitle: "Five", newPageLabel: "fiver", preselectedTextRange: preselectedTextRange)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two [[Five|fiver]] Four")
    }
    
    func testLinkRemove() {
        let text = "One Two [[Three]] Four"
        let textView = mediator.textView
        textView.attributedText = NSAttributedString(string: text)
        
        guard let startPos = textView.position(from: textView.beginningOfDocument, offset: 10),
              let endPos = textView.position(from: textView.beginningOfDocument, offset: 15),
        let preselectedTextRange = textView.textRange(from: startPos, to: endPos) else {
            XCTFail("Failure creating preselectedTextRange")
            return
        }
        
        mediator.linkFormatter?.removeLink(in: textView, preselectedTextRange: preselectedTextRange)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three Four")
    }
    
    func testLinkRemoveWithLabel() {
        let text = "One Two [[Three|3]] Four"
        let textView = mediator.textView
        textView.attributedText = NSAttributedString(string: text)
        
        guard let startPos = textView.position(from: textView.beginningOfDocument, offset: 10),
              let endPos = textView.position(from: textView.beginningOfDocument, offset: 17),
        let preselectedTextRange = textView.textRange(from: startPos, to: endPos) else {
            XCTFail("Failure creating preselectedTextRange")
            return
        }
        
        mediator.linkFormatter?.removeLink(in: textView, preselectedTextRange: preselectedTextRange)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two Three|3 Four")
    }
    
    func testLinkInsertImage() {
        let text = "One Two Three Four"
        let textView = mediator.textView
        textView.attributedText = NSAttributedString(string: text)
        mediator.textView.selectedRange = NSRange(location: 8, length:0)
        
        mediator.linkFormatter?.insertImage(wikitext: "[[File:Cat November 2010-1a.jpg | thumb | 220x124px | right]]", in: textView)
        XCTAssertEqual(mediator.textView.attributedText.string, "One Two [[File:Cat November 2010-1a.jpg | thumb | 220x124px | right]]Three Four")
    }
}
