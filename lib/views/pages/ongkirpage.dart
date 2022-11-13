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
  @override
  void initState() {
    super.initState();
    provinceData = getProvinces();
    provinceData2 = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  flex: 2,
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
                              width: 100,
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
                              width: 100,
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
                              width: 100,
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
                              width: 100,
                              height: 50,
                              child: FutureBuilder<List<City>>(
                                future: cityData2,
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    return DropdownButton(
                                      hint: Text("Pilih Kota"),
                                      isExpanded: true,
                                      value: selectedCity2,
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
                                          selectedCity2 = newValue;
                                          cityId2 = selectedCity2.cityId;
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
                      Center(
                              child: ElevatedButton(
                                onPressed: (() {
                                  if(selectedCity2 == null || selectedCity == null){
                                    Fluttertoast.showToast(msg: "Data belum di isi!" );
                                  } else {
                                    Fluttertoast.showToast(msg: "Origin : " + selectedCity.cityName.toString() + ", Destination : " + selectedCity2.cityName.toString());
                                  }
                                }),
                                child: Text("Hitung",style: TextStyle(fontSize: 16),)
                              ),
                            )
                    ],
                  ),
                ),

                //Flexible for showing data
                Flexible(
                  flex: 2,
                  child: Container(),
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