import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tawsila/shared/components/Components.dart';

class FilterSearchResultsScreen extends StatefulWidget {
  @override
  State<FilterSearchResultsScreen> createState() => _FilterSearchResultsScreenState();
}

class _FilterSearchResultsScreenState extends State<FilterSearchResultsScreen> {
  var fromPriceController = TextEditingController();
  var toPriceController = TextEditingController();
  var fromModelController = TextEditingController();
  var toModelController = TextEditingController();
  var dateController = TextEditingController();
  var automatic = false;
  var gasoline = false;
  Map<String, bool> brands = {
    "lada": false,
    "verna": false,
    "daewoo": false,
    "nissan": false,
    "elantra": false,
    "kia": false,
    "bmw": false,
    "mercedes": false,
    "fiat": false,
    "other": true
  };
  Map<String, bool> moreBrands = {
    "Convertible": true,
    "Coupe": false,
    "Hatchback": false,
    "MPV": false,
    "SUV": false,
    "Sedan": false,
  };
  Map<String, bool> options = {
    "ABS": false,
    "Air": false,
    "Sunroof": false,
    "Radio": false,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        centerTitle: true,
        elevation: 0.0,
        title: const Text(
          "Filter Results",
          style: TextStyle(
              color: Colors.black,
              fontSize: 25
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // price
              const Text(
                "Price",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 4,),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                        controller: fromPriceController,
                        placeHolder: "from"),
                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    child: buildTextField(
                        controller: toPriceController,
                        placeHolder: "to"),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              //model year
              const Text(
                "Model Year",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 4,),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                        controller: fromModelController,
                        placeHolder: "from",
                    ),

                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    child: buildTextField(
                        controller: toModelController,
                        placeHolder: "to",
                      // onTapFunc: () {
                      //   showDatePicker(
                      //     context: context,
                      //     initialDate: DateTime.now(),
                      //     firstDate: DateTime.now(),
                      //     lastDate: DateTime.parse('2021-05-03'),
                      //   ).then((value) {
                      //     setState(() {
                      //       toModelController.text = DateFormat.yMMMd().format(value!);
                      //     });
                      //   });
                      // }
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              // brands
              const Text(
                "Brands",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 4,),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "LADA"
                          ),
                          value: brands['lada'],
                          onChanged: (value) {
                            setState(() {
                              changeBrand(brand: 'lada');
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Verna"
                          ),
                          value: brands['verna'],
                          onChanged: (value) {
                            setState(() {
                              changeBrand(brand: 'verna');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Daewoo"
                          ),
                          value: brands['daewoo'],
                          onChanged: (value) {
                            setState(() {
                              changeBrand(brand: 'daewoo');
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Nissan"
                          ),
                          value: brands['nissan'],
                          onChanged: (value) {
                            setState(() {
                              changeBrand(brand: 'nissan');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Elantra"
                          ),
                          value: brands['elantra'],
                          onChanged: (value) {
                            setState(() {
                              changeBrand(brand: 'elantra');
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "KIA"
                          ),
                          value: brands['kia'],
                          onChanged: (value) {
                            setState(() {
                              changeBrand(brand: 'kia');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Fiat"
                          ),
                          value: brands['fiat'],
                          onChanged: (value) {
                            setState(() {
                              changeBrand(brand: 'fiat');
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "BMW"
                          ),
                          value: brands['bmw'],
                          onChanged: (value) {
                            setState(() {
                              changeBrand(brand: 'bmw');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Mercedes"
                          ),
                          value: brands['mercedes'],
                          onChanged: (value) {
                            setState(() {
                              changeBrand(brand: 'mercedes');
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Other"
                          ),
                          value: brands['other'],
                          onChanged: (value) {
                            setState(() {
                              changeBrand(brand: 'other');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // more brands
              const Text(
                "More Brands",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 4,),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Convertible"
                          ),
                          value: moreBrands['Convertible'],
                          onChanged: (value) {
                            setState(() {
                              changeMoreBrand(brand: 'Convertible');
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Coupe"
                          ),
                          value: moreBrands['Coupe'],
                          onChanged: (value) {
                            setState(() {
                              changeMoreBrand(brand: 'Coupe');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Hatchback"
                          ),
                          value: moreBrands['Hatchback'],
                          onChanged: (value) {
                            setState(() {
                              changeMoreBrand(brand: 'Hatchback');
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "MPV"
                          ),
                          value: moreBrands['MPV'],
                          onChanged: (value) {
                            setState(() {
                              changeMoreBrand(brand: 'MPV');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "SUV"
                          ),
                          value: moreBrands['SUV'],
                          onChanged: (value) {
                            setState(() {
                              changeMoreBrand(brand: 'SUV');
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Sedan"
                          ),
                          value: moreBrands['Sedan'],
                          onChanged: (value) {
                            setState(() {
                              changeMoreBrand(brand: 'Sedan');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Transmission
              const Text(
                "Transmission",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 4,),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                          "Automatic"
                      ),
                      value: automatic,
                      onChanged: (value) {
                        setState(() {
                          automatic = !automatic;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                          "Manual"
                      ),
                      value: !automatic,
                      onChanged: (value) {
                        setState(() {
                          automatic = !automatic;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              // Fuel Types
              const Text(
                "Fuel Types",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 4,),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                          "Gasoline"
                      ),
                      value: gasoline,
                      onChanged: (value) {
                        setState(() {
                          gasoline = !gasoline;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                          "Natural Gas"
                      ),
                      value: !gasoline,
                      onChanged: (value) {
                        setState(() {
                          gasoline = !gasoline;
                        });
                      },
                    ),
                  ),
                ],
              ),
              // options
              const Text(
                "Options",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 4,),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "ABS"
                          ),
                          value: options['ABS'],
                          onChanged: (value) {
                            setState(() {
                              options['ABS'] = !options['ABS']!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Air Conditioning"
                          ),
                          value: options['Air'],
                          onChanged: (value) {
                            setState(() {
                              options['Air'] = !options['Air']!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Sunroof"
                          ),
                          value: options['Sunroof'],
                          onChanged: (value) {
                            setState(() {
                              options['Sunroof'] = !options['Sunroof']!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                              "Radio"
                          ),
                          value: options['Radio'],
                          onChanged: (value) {
                            setState(() {
                              options['Radio'] = !options['Radio']!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  print("GET SEARCH RESULTS");
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: const [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Show Results",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeBrand({required String brand}) {
    for (var m in brands.entries) {
      if (m.key == brand)
        brands[m.key] = true;
      else
        brands[m.key] = false;
    }
  }
  void changeMoreBrand({required String brand}) {
    for (var m in moreBrands.entries) {
      if (m.key == brand)
        moreBrands[m.key] = true;
      else
        moreBrands[m.key] = false;
    }

  }

  Widget buildTextFieldIn({
    required TextEditingController controller,
    required String placeHolder,
    required Function onTapFunc
  }) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: Colors.black
          )
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: TextField(
          onTap: () {
            onTapFunc();
          },
          cursorColor: Colors.black,
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '${placeHolder}'
          ),
        ),
      ),
    );
  }
}

