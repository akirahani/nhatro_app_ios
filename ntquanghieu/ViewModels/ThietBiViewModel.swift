import Foundation
import SwiftUI
import Combine

final class ListThietBiModel: BindableObject{
    init(){
        fetchThietBi()
    }
    
    var thietBiGetAll = [ThietBi](){
        didSet{
            didChange.send(self)
        }
    }
    
    func fetchThietBi(){
        getAllService{
            self.thietBiGetAll = $0
        }
    }
    
    let didChange = PassthroughSubject<ListThietBiModel,Never>()
}
 
