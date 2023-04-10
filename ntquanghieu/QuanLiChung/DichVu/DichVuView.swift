import SwiftUI
import Combine
import Foundation

struct DichVuView: View {
    @State var thietBiModel = [ThietBi]()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSideBarOpened = false
    @State private var xoaDichVuThanhCong = false
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        isSideBarOpened = true
        }) {
            HStack {
                Image("back")
            }
        }
    }
    
    func loadDataTB() async {
          guard let url = URL(string: "http://192.168.1.183/nhatro/admin/api/thiet-bi/list.php")
//          guard let url = URL(string: "http://192.168.0.104/nhatro/admin/api/thiet-bi/list.php")
        
        else {
              print("Invalid URL")
              return
          }
          do {
              let (data, _) = try await URLSession.shared.data(from: url)
              thietBiModel = try JSONDecoder().decode([ThietBi].self, from: data) // <-- here
          } catch {
              print(error)  // <-- important
          }
      }
    
    func delTB(parameters : [String: Any]) async {
          guard let url = URL(string: "http://192.168.1.183/nhatro/admin/api/thiet-bi/del.php") else {
              return
          }
        
         let jsonData = try? JSONSerialization.data(withJSONObject: parameters ,options: .fragmentsAllowed)
         var request = URLRequest(url: url)
         
         request.httpMethod = "POST"
         request.setValue("application/json", forHTTPHeaderField: "Content-Length")
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         request.setValue("application/json", forHTTPHeaderField: "Accept")
         request.httpBody = jsonData
                
        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data, error == nil else {
                return
            }
        
            let responseJSON = try? JSONDecoder().decode([ThietBi].self ,from: data )
            xoaDichVuThanhCong = true
            
            if(xoaDichVuThanhCong == true){
                    DichVuView()
            }
        }.resume()
      }

    
    var body: some View {
        ZStack{
            VStack{
                // tieu de dich vu
                ZStack{
                    HStack{
                        Image("dichvu")
                        Text("Quản lí dịch vụ").textCase(.uppercase).foregroundColor(Color(hex: "#354B9C"))
                            .font(.system(size: 18, weight: .bold))
                    }.padding(.top, 13)
                    .padding(.leading, 23)
                    .frame(
                          minWidth: 0,
                          maxWidth: .infinity,
                          minHeight: 0,
                          maxHeight: 59,
                          alignment: .topLeading
                        )
                }.background(Color.white)
                    .zIndex(2)
                
                // thong tin dich vu
                ScrollView{
                    VStack{
                        // thead
                        HStack{
                            Text("Tên").font(.system(size: 16, weight: .bold))
                            Spacer()
                            Text("Giá").font(.system(size: 16, weight: .bold))
                            Spacer()
                            Text("Tác vụ").font(.system(size: 16, weight: .bold))
                        }.padding(.top, 16)
                            .padding(.leading, 25)
                            .padding(.trailing, 25)
                            .padding(.bottom, 4)
                        
                        //tbody
                  
                        if #available(iOS 15.0, *) {
                       
                            VStack{
                                ForEach(thietBiModel) { model in
                                    HStack(spacing: 10){
                                        Text(model.ten ?? "").padding(.leading, 5)
                                        Spacer()
                                        Text("\(model.gia!)đ")
                                        Spacer()
                                        HStack{
                                            NavigationLink(destination: DichVuEditView(dichVuItem :model)){
                                                Image("edit")   
                                            }
                                            
                                            // Xoá thiết bị
                                            Image("del").onTapGesture {
                                                Task{
                                                    let param : [String: Any] = ["id": model.idtb]
                                                    print(param)
                                                    await delTB(parameters: param)
                                        
                                                }
                                            }.overlay{
                                                NavigationLink(destination: DichVuView(), isActive: $xoaDichVuThanhCong){
                                                        EmptyView()
                                                }
                                            }
                                            
                                        }.padding(.trailing, 5)
                                    }
                                    .frame(width: .none, height: 44)
                                    .background(Color(hex: "E8EDFF"))
                                    .clipShape(RoundedRectangle(cornerRadius:10))
                                    .padding(.top, 4)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)
                                    .padding(.bottom, 4)
                                }                                   
                            }
                            .task {
                                await loadDataTB()
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                        
                        // chuyển tiếp sang trang thêm
                        NavigationLink(destination: DichVuAddView()){
                            Image("add").padding(.top, 8)
                                .padding(.bottom, 14)
                        }
 
                    }.background(Color.white)
                        .padding(.top,20)
                }
                .zIndex(1)
                
                Spacer()
            }.background(Color(hex: "#F2F1F6"))
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    btnBack
                }
                ToolbarItem(placement: .principal) {
                    Image("logohome")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("bar") .onTapGesture {
                        isSideBarOpened.toggle()
                    }
                }
            }.navigationBarBackButtonHidden(true)
            MenuSlideView(isSidebarVisible: $isSideBarOpened)

        }
    }
    
}



struct ThietBi: Identifiable, Codable {
    let id = UUID()
    var idtb:String?
    var ten: String?
    var gia: String?
    
    enum CodingKeys: String, CodingKey {
        case ten = "ten"
        case gia = "gia"
        case idtb = "id"
        
    }
}


struct DichVuView_Previews: PreviewProvider {
    static var previews: some View {
        DichVuView()
    }
}
