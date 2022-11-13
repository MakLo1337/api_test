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
  Future<List<Province>> getCities(dynamic provId) async {
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
                            FutureBuilder<List<Province>>(
                              future: provinceData,
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  return DropdownButton(
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
                                      });
                                    }
                                  );
                                } else if (snapshot.hasError){
                                  return Text('Tidak ada data!');
                                }

                                return UiLoading.loadingDD();
                              },
                            )
                          ],
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