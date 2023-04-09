import SwiftUI

struct KhachTroView: View {
    @State var khachModel = [Khach]()

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSideBarOpened = false

    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("back")
            }
        }
    }
    
    func loadDataKhach() async {
          guard let url = URL(string: "http://192.168.1.183/nhatro/admin/api/khach/list.php")
//          guard let url = URL(string: "http://192.168.0.104/nhatro/admin/api/khach/list.php")
        
        else {
              print("Invalid URL")
              return
          }
          do {
              let (data, _) = try await URLSession.shared.data(from: url)
              khachModel = try JSONDecoder().decode([Khach].self, from: data) // <-- here
          } catch {
              print(error)  // <-- important
          }
      }
    
    
    var body: some View {
        ZStack{
            VStack{
                // tieu de dich vu
                ZStack{
                    HStack{
                        Image("khachtro")
                        Text("Quản lí khách trọ").textCase(.uppercase).foregroundColor(Color(hex: "#354B9C"))
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        // chuyển tiếp sang trang thêm
                        NavigationLink(destination: KhachTroAddView()){
                            Image("add")
                                .padding(.bottom, 2)
                                .padding(.trailing, 2)
                        }
                        
                        Image("search").padding(.trailing, 10)
                        
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
                            Spacer()
                            Spacer()
                            Text("Điện thoại").font(.system(size: 16, weight: .bold))
                            Spacer()
                            Text("Tác vụ").font(.system(size: 16, weight: .bold))
                        }.padding(.top, 16)
                            .padding(.leading, 25)
                            .padding(.trailing, 15)
                            .padding(.bottom, 4)
                        
                        //tbody
                  
                        if #available(iOS 15.0, *) {
                       
                            VStack{
                                ForEach(khachModel) { model in
                                    HStack(spacing: 10){
                                        Text(model.fullname ?? "").padding(.leading, 5)
                                        Spacer()
                                        Text(model.dienthoai ?? "")
                                        Spacer()

                                      NavigationLink(destination: KhachTroEditView(khachTroItem : model)){
                                            Image("edit").padding(.trailing, 5)
                                      }
                                            
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
                                await loadDataKhach()
                            }
                        } else {
                            // Fallback on earlier versions
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

struct Khach: Codable, Identifiable {
    var id = UUID()
    let idkhach: String?
    let username: String?
    let password: String?
    let email: String?
    let fullname: String?
    let nhom: String?
    let dienthoai: String?
    let diachi: String?
    let cancuoc: String?
    let ngaycap: String?
    let quoctich: String?
    let ngaysinh: String?
    let gioitinh: String?
    
    enum CodingKeys: String, CodingKey {
        case idkhach = "id"
        case username = "username"
        case password = "password"
        case email = "email"
        case fullname = "fullname"
        case nhom = "nhom"
        case dienthoai = "dienthoai"
        case diachi = "diachi"
        case cancuoc = "cancuoc"
        case ngaycap = "ngaycap"
        case quoctich = "quoctich"
        case ngaysinh = "ngaysinh"
        case gioitinh = "gioitinh"
        
    }
}
struct KhachTroView_Previews: PreviewProvider {
    static var previews: some View {
        KhachTroView()
    }
}
