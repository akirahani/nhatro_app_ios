//
//  PhongTroView.swift
//  ntquanghieu
//
//  Created by admin on 29/03/2023.
//

import SwiftUI

struct PhongTroView: View {
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
    
    var body: some View {
        ZStack{
            VStack{
                // tieu de dich vu
                ZStack{
                    HStack{
                        Image("phongtro")
                        Text("Quản lí phòng trọ").textCase(.uppercase).foregroundColor(Color(hex: "#354B9C"))
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

struct PhongTroView_Previews: PreviewProvider {
    static var previews: some View {
        PhongTroView()
    }
}
