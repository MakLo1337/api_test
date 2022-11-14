part of 'pages.dart';

class OngkirPage extends StatefulWidget {
  const OngkirPage({super.key});

  @override
  State<OngkirPage> createState() => _OngkirPageState();
}

class _OngkirPageState extends State<OngkirPage> {

  bool _isLoading = false;
  String dropdowndefault = "jne";
  var kurir = [
    'jne','pos','tiki'
  ];
  var selectedKurir = "";

  final ctrlBerat = TextEditingController();

  dynamic provId;
  dynamic provinceData;
  dynamic selectedProv;
  dynamic provId2;
  dynamic provinceData2;
  dynamic selectedProv2;
  Future<List<Province>> getProvinces() async {
    dynamic listProvince;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        listProvince = value;
      });
    });

    return listProvince;
  }


  dynamic cityId;
  dynamic cityData;
  dynamic selectedCity;
  dynamic cityId2;
  dynamic cityData2;
  dynamic selectedCity2;
  Future<List<City>> getCities(dynamic provId) async {
    dynamic listCity;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        listCity = value;
      });
    });

    return listCity;
  }

  List<Costs> listCosts = [];
  Future<dynamic> getCostsData() async {
    await RajaOngkirService.getMyOngkir(cityId, cityId2, int.parse(ctrlBerat.text) , selectedKurir).then((value) {
      setState(() {
        listCosts = value;
        _isLoading = false;
      });
      print(listCosts.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    provinceData = getProvinces();
    provinceData2 = getProvinces();
    selectedKurir = dropdowndefault;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Hitung Ongkir"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                //Form Flexible
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton(
                              value: dropdowndefault,
                              icon: const Icon(Icons.arrow_drop_down),
                              items: kurir.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items)
                                  );
                              }).toList(), 
                              onChanged: (String? newVal){
                                setState(() {
                                  dropdowndefault = newVal!;
                                  selectedKurir = newVal;
                                });
                              }
                            ),
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: ctrlBerat,
                                decoration: InputDecoration(
                                  labelText: 'Berat (gr)'
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: ((value) {
                                  return value == null || value == 0 ? 'Berat harus diisi atau tidak boleh 0' : null;
                                }),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Origin",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              height: 50,
                              child: FutureBuilder<List<Province>>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    return DropdownButton(
                                      hint: Text("Pilih Provinsi"),
                                      isExpanded: true,
                                      value: selectedProv,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 16,
                                      style: TextStyle(color:Colors.black),
                                      items: snapshot.data!.map<DropdownMenuItem<Province>>(
                                        (Province value){
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value.province.toString()),
                                          );
                                        }
                                      ).toList(),
                                      onChanged: (newValue){
                                        setState(() {
                                          selectedProv = newValue;
                                          provId = selectedProv.provinceId;
                                          cityData = getCities(provId);
                                        });
                                        selectedCity = null;
                                        cityData = getCities(provId);
                                        cityId = null;
                                      }
                                    );
                                  } else if (snapshot.hasError){
                                    return Text('Tidak ada data!');
                                  }

                                  return UiLoading.loadingDD();
                                },
                              ),
                            ),
                            selectedProv == null ? 
                              Text("Pilih Provinsi Terlebih Dahulu")
                            : 
                              Container(
                              width: 150,
                              height: 50,
                              child: FutureBuilder<List<City>>(
                                future: cityData,
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    return DropdownButton(
                                      hint: Text("Pilih Kota"),
                                      isExpanded: true,
                                      value: selectedCity,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 16,
                                      style: TextStyle(color:Colors.black),
                                      items: snapshot.data!.map<DropdownMenuItem<City>>(
                                        (City value){
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value.cityName.toString()),
                                          );
                                        }
                                      ).toList(),
                                      onChanged: (newValue){
                                        setState(() {
                                          selectedCity = newValue;
                                          cityId = selectedCity.cityId;
                                        });
                                      }
                                    );
                                  } else if (snapshot.hasError){
                                    return Text('Tidak ada data!');
                                  }

                                  return UiLoading.loadingDD();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Destination",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              height: 50,
                              child: FutureBuilder<List<Province>>(
                                future: provinceData2,
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    return DropdownButton(
                                      hint: Text("Pilih Provinsi"),
                                      isExpanded: true,
                                      value: selectedProv2,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 16,
                                      style: TextStyle(color:Colors.black),
                                      items: snapshot.data!.map<DropdownMenuItem<Province>>(
                                        (Province value){
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value.province.toString()),
                                          );
                                        }
                                      ).toList(),
                                      onChanged: (newValue){
                                        setState(() {
                                          selectedProv2 = newValue;
                                          provId2 = selectedProv2.provinceId;
                                          cityData2 = getCities(provId2);
                                        });
                                        selectedCity2 = null;
                                        cityData2 = getCities(provId2);
                                        cityId2 = null;
                                      }
                                    );
                                  } else if (snapshot.hasError){
                                    return Text('Tidak ada data!');
                                  }

                                  return UiLoading.loadingDD();
                                },
                              ),
                            ),
                            selectedProv2 == null ? 
                              Text("Pilih Provinsi Terlebih Dahulu")
                            : 
                            Container(
                              width: 150,
                              height: 50,
                              child: FutureBuilder<List<City>>(
                                future: cityData2,
                                builder: (context, snapshot2) {
                                  if(snapshot2.hasData){
                                    return DropdownButton(
                                      hint: Text("Pilih Kota"),
                                      isExpanded: true,
                                      value: selectedCity2,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 16,
                                      style: TextStyle(color:Colors.black),
                                      items: snapshot2.data!.map<DropdownMenuItem<City>>(
                                        (City value2){
                                          return DropdownMenuItem(
                                            value: value2,
                                            child: Text(value2.cityName.toString()),
                                          );
                                        }
                                      ).toList(),
                                      onChanged: (newValue){
                                        setState(() {
                                          selectedCity2 = newValue;
                                          cityId2 = selectedCity2.cityId;
                                          print(cityId2);
                                        });
                                      }
                                    );
                                  } else if (snapshot2.hasError){
                                    return Text('Tidak ada data!');
                                  }

                                  return UiLoading.loadingDD();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: (() {
                              if(cityId.isEmpty || cityId2.isEmpty || selectedKurir.isEmpty || ctrlBerat.text.isEmpty ){
                                UiToast.toastErr("Semua field harus di isi !");
                                // Fluttertoast.showToast(msg: "Semua field harus di isi !" );
                              } else {
                                setState(() {
                                  _isLoading = true;
                                });
                                getCostsData();
                                // UiToast.toastOk("SIAP LANJUT!");
                                // Fluttertoast.showToast(msg: "Origin : " + selectedCity.cityName.toString() + ", Destination : " + selectedCity2.cityName.toString());
                              }
                            }),
                            child: Text("Hitung",style: TextStyle(fontSize: 16),)
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                //Flexible for showing data
                Flexible(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: listCosts.isEmpty ? 
                    const Align(
                      alignment: Alignment.center,
                      child: Text("Tidak ada data"),
                    ) : ListView.builder(
                      itemCount: listCosts.length,
                      itemBuilder: (context, index) {
                        return LazyLoadingList(
                          initialSizeOfItems: 10,
                          loadMore: (){},
                          child: CardOngkir(listCosts[index]),
                          index: index,
                          hasMore: true,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isLoading == true ? UiLoading.loadingBlock() : Container()
        ],
      ),
    );
  }
}