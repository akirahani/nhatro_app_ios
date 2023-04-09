import SwiftUI

struct UuDaiEditView: View {
    
    let uuDaiItem : UuDai
    @State var uuDaiModel = [UuDai]()
    @State var getUuDai = false

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSideBarOpened = false
    
    @State private var tenUuDai: String = ""
    @State private var idUD: String = ""
    @State private var apDung: String = ""
    @State private var soNgay: String = ""
    @State var gotConfig = false
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        isSideBarOpened = true
        }) {
            HStack {
                Image("back")
            }
        }
    }
    
    func updateUuDai() async throws {

       guard let urlEditTB =  URL(string:"http://192.168.1.183/nhatro/admin/api/uu-dai/edit.php")
//       guard let urlEditTB =  URL(string:"http://192.168.0.104/nhatro/admin/api/uu-dai/edit.php")
        
        else { return }

        let body: [String: Any] = [
            "idThanhVien": 1,
            "idUuDai" : uuDaiItem.idud ?? "",
            "tenUuDai": tenUuDai,
            "apDung": apDung,
            "soNgayUuDai": soNgay]
        let jsonData = try? JSONSerialization.data(withJSONObject: body,options: .fragmentsAllowed)
        var request = URLRequest(url: urlEditTB)
        
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
        
    
       }.resume()
    }
    
    struct RadioButton: View {

        @Environment(\.colorScheme) var colorScheme

        let id: String
        let callback: (String)->()
        let selectedID : String
        let size: CGFloat
        let color: Color
        let textSize: CGFloat

        init(
            _ id: String,
            callback: @escaping (String)->(),
            selectedID: String,
            size: CGFloat = 20,
            color: Color = Color.primary,
            textSize: CGFloat = 14
            ) {
            self.id = id
            self.size = size
            self.color = color
            self.textSize = textSize
            self.selectedID = selectedID
            self.callback = callback
        }

        var body: some View {
            Button(action:{
                self.callback(self.id)
                
            }) {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: self.selectedID == self.id ? "largecircle.fill.circle" : "circle")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.size, height: self.size)
                        .modifier(ColorInvert())
                    Text(id)
                        .font(Font.system(size: textSize))
                    Spacer()
                }.foregroundColor(self.color)
            }
            .foregroundColor(self.color)
        }
    }
    
    struct ColorInvert: ViewModifier {

        @Environment(\.colorScheme) var colorScheme

        func body(content: Content) -> some View {
            Group {
                if colorScheme == .dark {
                    content.colorInvert()
                } else {
                    content
                }
            }
        }
    }

    let items = ["Có", "Không"]

    @State var selectedId: String = ""

    func radioGroupCallback(id: String) {
        selectedId = id
        if selectedId == "Có"{
            apDung = "1"
        }else{
            apDung = "0"
        }
        
    }

    var body: some View {
        ZStack{
            VStack{
                // tieu de dich vu
                ZStack{
                    HStack{
                        Image("uudai")
                        Text("Sửa ưu đãi").textCase(.uppercase).foregroundColor(Color(hex: "#354B9C"))
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
                    .zIndex(3)
                // sua dich vu
                
                ScrollView{
                    ZStack{
                        VStack{
                            ZStack{
                                HStack{
                                    Text("Tên ưu đãi: ").font(.system(size: 16, weight: .bold))
                                        .padding(.leading, 9)
                                    TextField("Tên ưu đãi", text: $tenUuDai)
                                        .padding(.trailing, 9)
                                    
                                } .padding(.bottom, 8)
                                .padding(.top, 8)
                                .background(Color.white)
                                 .clipShape(RoundedRectangle(cornerRadius:10))
                                
                            }.padding(.top, 16)
                                .padding(.trailing, 8)
                                .padding(.leading, 8)

                            ZStack{
                                HStack{
                                    Text("Số ngày: ").font(.system(size: 16, weight: .bold))
                                        .padding(.leading, 9)
                                    TextField("Số ngày áp dụng", text: $soNgay)
                                        .padding(.trailing, 9)
                                }
                                .padding(.bottom, 8)
                                .padding(.top, 8)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius:10))
                            }.padding(.top, 16)
                                .padding(.trailing, 8)
                                .padding(.leading, 8)
                            
                            ZStack{
                                HStack{
                                    Text("Áp dụng: ").font(.system(size: 16, weight: .bold))
                                        .padding(.leading, 9)
                                        ForEach(0..<items.count) { index in
                                            RadioButton(self.items[index], callback: self.radioGroupCallback, selectedID: selectedId )
                                        }
                                }
                                .padding(.bottom, 8)
                                .padding(.top, 8)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius:10))
                            }.padding(.top, 16)
                                .padding(.trailing, 8)
                                .padding(.leading, 8)

                            
                            HStack{
                                Button
                                {
                                }label: {
                                    Text("Quay lại")
                                        .padding(.top,5)
                                        .padding(.bottom,5)
                                        .padding(.leading, 44)
                                        .padding(.trailing ,44)
                                      .foregroundColor(.white)
                                  }
                                .foregroundColor(Color.white)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#8091CE"),
                                Color(hex:"#3252C5")]),startPoint: .topLeading,endPoint: .bottomTrailing))
                                .cornerRadius(6)
                                .padding(.top,22)
                                .padding(.bottom,17)
                                .padding(.leading,9)
                                
                                Spacer()
                                
                                Button{
                                    Task{
                                        do {
                                           try await updateUuDai()
                                        }
                                       catch {
                                           print(error)
                                       }
                                    }
                                }
                                label:{
                                    Text("Cập nhật")
                                        .padding(.top,5)
                                        .padding(.bottom,5)
                                        .padding(.leading, 44)
                                        .padding(.trailing ,44)
                                }
                                .foregroundColor(Color.white)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#B71616"), Color(hex:"#ec323780")]),startPoint: .topLeading,endPoint: .trailing))
                                .cornerRadius(6)
                                .padding(.top,22)
                                .padding(.bottom,17)
                                .padding(.trailing,9)
                            }
                        }.background(Color(hex: "F3F6FF"))
                            .clipShape(RoundedRectangle(cornerRadius:7))
                    }.padding(.top,16)
                    .padding(.leading,14)
                    .padding(.trailing,14)
                    .zIndex(1)
                }.background(Color.white)
                    .padding(.top,20)
                .zIndex(1)
                
                Spacer()
            }.background(Color(hex: "F2F1F6"))
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
        }.onAppear(perform: {
            self.soNgay = uuDaiItem.songay!
            self.apDung = uuDaiItem.apdung!
            self.tenUuDai = uuDaiItem.ten!
        })
    }
}

enum Choice {
    case chon, khongchon
}

