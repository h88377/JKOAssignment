//
//  StubbedDataItemLoader.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import Foundation

final class StubbedDataItemLoader: ItemLoader {
    
    func load(with condition: ItemRequestCondition, completion: @escaping (ItemLoader.Result) -> Void) {
        let stubbedItems: [Item]
        
        switch condition.page {
        case 0:
            stubbedItems = page0
            
        case 1:
            stubbedItems = page1
            
        case 2:
            stubbedItems = page2
            
        default:
            stubbedItems = []
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
            completion(.success(stubbedItems))
        }
    }
}

private extension StubbedDataItemLoader {
    private var page0: [Item] {
        return [Item(name: "Harry Potter and the Philosopher's Stone",
                     description: "Harry Potter and the Philosopher's Stone is a fantasy novel written by British author J. K. Rowling. The first novel in the Harry Potter series and Rowling's debut novel, it follows Harry Potter, a young wizard who discovers his magical heritage on his eleventh birthday, when he receives a letter of acceptance to Hogwarts School of Witchcraft and Wizardry. Harry makes close friends and a few enemies during his first year at the school and with the help of his friends, Ron Weasley and Hermione Granger, he faces an attempted comeback by the dark wizard Lord Voldemort, who killed Harry's parents, but failed to kill Harry when he was just 15 months old.",
                     price: 200,
                     timestamp: Date.init(),
                     imageName: "book"),
                Item(name: "Harry Potter and the Chamber of Secrets",
                     description: "Harry Potter and the Chamber of Secrets is a fantasy novel written by British author J. K. Rowling and the second novel in the Harry Potter series. The plot follows Harry's second year at Hogwarts School of Witchcraft and Wizardry, during which a series of messages on the walls of the school's corridors warn that the Chamber of Secrets has been opened and that the heir of Slytherin would kill all pupils who do not come from all-magical families. These threats are found after attacks that leave residents of the school petrified. Throughout the year, Harry and his friends Ron and Hermione investigate the attacks.",
                     price: 210,
                     timestamp: Date.init(),
                     imageName: "book.fill"),
                Item(name: "Harry Potter and the Prisoner of Azkaban",
                     description: "Harry Potter and the Prisoner of Azkaban is a fantasy novel written by British author J. K. Rowling and is the third in the Harry Potter series. The book follows Harry Potter, a young wizard, in his third year at Hogwarts School of Witchcraft and Wizardry. Along with friends Ronald Weasley and Hermione Granger, Harry investigates Sirius Black, an escaped prisoner from Azkaban, the wizard prison, believed to be one of Lord Voldemort's old allies.",
                     price: 230,
                     timestamp: Date.init(),
                     imageName: "book.circle"),
                Item(name: "Harry Potter and the Goblet of Fire",
                     description: "Harry Potter and the Goblet of Fire is a fantasy novel written by British author J. K. Rowling and the fourth novel in the Harry Potter series. It follows Harry Potter, a wizard in his fourth year at Hogwarts School of Witchcraft and Wizardry, and the mystery surrounding the entry of Harry's name into the Triwizard Tournament, in which he is forced to compete.",
                     price: 240,
                     timestamp: Date.init(),
                     imageName: "book.circle.fill")]
    }
    
    private var page1: [Item] {
        return [Item(name: "Harry Potter and the Order of the Phoenix",
                     description: "Harry Potter and the Order of the Phoenix is a fantasy novel written by British author J. K. Rowling and the fifth novel in the Harry Potter series. It follows Harry Potter's struggles through his fifth year at Hogwarts School of Witchcraft and Wizardry, including the surreptitious return of the antagonist Lord Voldemort, O.W.L. exams, and an obstructive Ministry of Magic. The novel was published on 21 June 2003 by Bloomsbury in the United Kingdom, Scholastic in the United States, and Raincoast in Canada. It sold five million copies in the first 24 hours of publication.",
                     price: 250,
                     timestamp: Date.init(),
                     imageName: "books.vertical"),
                Item(name: "Harry Potter and the Half-Blood Prince",
                     description: "Harry Potter and the Half-Blood Prince is a fantasy novel written by British author J. K. Rowling and the sixth and penultimate novel in the Harry Potter series. Set during Harry Potter's sixth year at Hogwarts, the novel explores the past of the boy wizard's nemesis, Lord Voldemort, and Harry's preparations for the final battle against Voldemort alongside his headmaster and mentor Albus Dumbledore.",
                     price: 260,
                     timestamp: Date.init(),
                     imageName: "books.vertical.fill"),
                Item(name: "Harry Potter and the Deathly Hallows",
                     description: "Harry Potter and the Deathly Hallows is a fantasy novel written by British author J. K. Rowling and the seventh and final novel in the Harry Potter series. It was released on 21 July 2007 in the United Kingdom by Bloomsbury Publishing, in the United States by Scholastic, and in Canada by Raincoast Books. The novel chronicles the events directly following Harry Potter and the Half-Blood Prince (2005) and the final confrontation between the wizards Harry Potter and Lord Voldemort.",
                     price: 270,
                     timestamp: Date.init(),
                     imageName: "books.vertical.circle"),
                Item(name: "A Game of Thrones",
                     description: "Game of Thrones is an American fantasy drama television series created by David Benioff and D. B. Weiss for HBO. It is an adaptation of A Song of Ice and Fire, a series of fantasy novels by George R. R. Martin, the first of which is A Game of Thrones. The show was shot in the United Kingdom, Canada, Croatia, Iceland, Malta, Morocco, and Spain. It premiered on HBO in the United States on April 17, 2011, and concluded on May 19, 2019, with 73 episodes broadcast over eight seasons.",
                     price: 280,
                     timestamp: Date.init(),
                     imageName: "books.vertical.circle.fill")]
    }
    
    private var page2: [Item] {
        return [Item(name: "A Clash of Kings",
                     description: "A Clash of Kings is the second of seven planned novels in A Song of Ice and Fire, an epic fantasy series by American author George R. R. Martin. It was first published on November 16, 1998 in the United Kingdom; the first United States edition followed on February 2, 1999.[2] Like its predecessor, A Game of Thrones, it won the Locus Award (in 1999) for Best Novel and was nominated for the Nebula Award (also in 1999) for Best Novel. In May 2005, Meisha Merlin released a limited edition of the novel, fully illustrated by John Howe. The novel has been adapted for television by HBO as the second season of the TV series Game of Thrones.",
                     price: 290,
                     timestamp: Date.init(),
                     imageName: "book"),
                Item(name: "A Storm of Swords",
                     description: "A Storm of Swords is the third of seven planned novels in A Song of Ice and Fire, a fantasy series by American author George R. R. Martin. It was first published on August 8, 2000, in the United Kingdom,[1] with a United States edition following in November 2000. Its publication was preceded by a novella called Path of the Dragon, which collects some of the Daenerys Targaryen chapters from the novel into a single book.",
                     price: 300,
                     timestamp: Date.init(),
                     imageName: "book.fill"),
                Item(name: "A Feast for Crows",
                     description: "A Feast for Crows is the fourth of seven planned novels in the epic fantasy series A Song of Ice and Fire by American author George R. R. Martin. The novel was first published on October 17, 2005, in the United Kingdom,[1] with a United States edition following on November 8, 2005.",
                     price: 310,
                     timestamp: Date.init(),
                     imageName: "book.circle"),
                Item(name: "A Dance with Dragons",
                     description: "A Dance with Dragons is the fifth novel of seven planned in the epic fantasy series A Song of Ice and Fire by American author George R. R. Martin. In some areas, the paperback edition was published in two parts, titled Dreams and Dust and After the Feast. It was the only novel in the series to be published during the eight-season run of the HBO adaptation of the series, Game of Thrones, and runs to 1,040 pages with a word count of almost 415,000.",
                     price: 320,
                     timestamp: Date.init(),
                     imageName: "book.circle.fill")]
    }
}
