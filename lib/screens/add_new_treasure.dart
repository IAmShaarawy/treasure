import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treasure/models/categories.dart';
import 'package:treasure/screens/MapSelector.dart';
import 'package:treasure/services/treasure_service.dart';
import 'package:treasure/ui/loading.dart';

class AddNewTreasure extends StatefulWidget {
  static const ROUTE = "new_treasure_route";

  @override
  _State createState() => _State();
}

class _State extends State<AddNewTreasure> {
  Categories _selectedCategory = Categories.values.first;
  String _titleCount = "";
  String _descCount = "";
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sinceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _imageFilePath1;
  String _imageFilePath2;
  String _imageFilePath3;
  String _imageFilePath4;
  bool _isLoading = false;
  LatLng pickedLocation;
  final _treasureService = TreasureService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Monument"),
          centerTitle: true,
        ),
        body: _isLoading
            ? Loading()
            : Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    SizedBox(height: 16),
                    _buildCategorySelector(),
                    SizedBox(height: 16),
                    _buildMediaSelector(),
                    (_imageFilePath1 == null &&
                            _imageFilePath2 == null &&
                            _imageFilePath3 == null &&
                            _imageFilePath4 == null)
                        ? Text(
                            "please pick an image",
                            style: TextStyle(color: Colors.red),
                          )
                        : SizedBox(),
                    SizedBox(height: 16),
                    TextFormField(
                      onChanged: _onTitleChange,
                      controller: _titleController,
                      validator: _validateTitle,
                      decoration: InputDecoration(
                        counterText: _titleCount,
                        filled: true,
                        labelText: "Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      onChanged: _onDescriptionChange,
                      maxLines: 7,
                      minLines: 3,
                      controller: _descriptionController,
                      validator: _validateDescription,
                      decoration: InputDecoration(
                        counterText: _descCount,
                        filled: true,
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _sinceController,
                      validator: _validateSince,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Since",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    pickedLocation == null
                        ? SizedBox()
                        : Container(
                            padding: EdgeInsets.only(top: 16),
                            height: 150,
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: GoogleMap(
                                markers: {
                                  Marker(
                                      markerId: MarkerId("my_marker"),
                                      position: pickedLocation)
                                },
                                liteModeEnabled: true,
                                compassEnabled: true,
                                initialCameraPosition: CameraPosition(
                                  target: pickedLocation,
                                  zoom: 15,
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: ElevatedButton(
                          onPressed: () => _pickLocation(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                  "${pickedLocation == null ? "Pick" : "Change"} location")
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                          onPressed: () => _onPostReport(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Add Monument")
                            ],
                          )),
                    )
                  ],
                ),
              ));
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 64,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: Categories.values.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = Categories.values[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              avatar: CircleAvatar(
                backgroundImage: NetworkImage(
                  categoryImage(category),
                ),
              ),
              label: Text(categoryLabel(category)),
              selected: _selectedCategory == category,
              onSelected: (isSelected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectImage(1),
            onDoubleTap: () => setState(() {
              _imageFilePath1 = null;
            }),
            child: _imageFilePath1 != null
                ? Image.file(
                    File(_imageFilePath1),
                    height: 100,
                  )
                : Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: 100,
                        color: Colors.green.shade100,
                      ),
                      Container(
                        child: Icon(Icons.add_a_photo),
                      )
                    ],
                  ),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: InkWell(
            onTap: () => _selectImage(2),
            onDoubleTap: () => setState(() {
              _imageFilePath2 = null;
            }),
            child: _imageFilePath2 != null
                ? Image.file(
                    File(_imageFilePath2),
                    height: 100,
                  )
                : Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: 100,
                        color: Colors.green.shade100,
                      ),
                      Container(
                        child: Icon(Icons.add_a_photo),
                      )
                    ],
                  ),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: InkWell(
            onTap: () => _selectImage(3),
            onDoubleTap: () => setState(() {
              _imageFilePath3 = null;
            }),
            child: _imageFilePath3 != null
                ? Image.file(
                    File(_imageFilePath3),
                    height: 100,
                  )
                : Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: 100,
                        color: Colors.green.shade100,
                      ),
                      Container(
                        child: Icon(Icons.add_a_photo),
                      )
                    ],
                  ),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: InkWell(
            onTap: () => _selectImage(4),
            onDoubleTap: () => setState(() {
              _imageFilePath4 = null;
            }),
            child: _imageFilePath4 != null
                ? Image.file(
                    File(_imageFilePath4),
                    height: 100,
                  )
                : Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: 100,
                        color: Colors.green.shade100,
                      ),
                      Container(
                        child: Icon(Icons.add_a_photo),
                      )
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  String _validateTitle(String title) {
    if (title.isEmpty || title.trim().length <= 0) {
      return "Enter some value";
    }

    if (title.length < 10) {
      return "Title Text must be at min 10 character";
    }

    if (title.length > 30) {
      return "Title Text must be at max 30 character";
    }
    return null;
  }

  void _onTitleChange(String text) {
    setState(() {
      _titleCount = "${text.length}/30";
    });
  }

  String _validateSince(String price) {
    if (price.isEmpty || price.trim().length <= 0) {
      return "Enter some value";
    }

    try {
      final p = double.parse(price);
      if (p < -6000) return "Min since is 6000 b.c";
      if (p > 2021) return "Max since is 2021 a.d";
    } catch (e) {
      return "Not supported age";
    }
    return null;
  }

  String _validateDescription(String desc) {
    if (desc.isEmpty || desc.trim().length <= 0) {
      return "Enter some value";
    }

    if (desc.length < 10) {
      return "Description Text must be at min 10 character";
    }

    if (desc.length > 300) {
      return "Description Text must be at max 300 character";
    }
    return null;
  }

  void _onDescriptionChange(String text) {
    setState(() {
      _descCount = "${text.length}/300";
    });
  }

  void _selectImage(int index) async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 50);

    if (pickedFile == null) {
      return;
    }

    setState(() {
      if (index == 1) _imageFilePath1 = pickedFile.path;
      if (index == 2) _imageFilePath2 = pickedFile.path;
      if (index == 3) _imageFilePath3 = pickedFile.path;
      if (index == 4) _imageFilePath4 = pickedFile.path;
    });
  }

  void _pickLocation(BuildContext context) async {
    final result = (await Navigator.of(context)
        .pushNamed(MapSelector.ROUTE, arguments: pickedLocation)) as LatLng;
    setState(() {
      pickedLocation = result;
    });
  }

  void _onPostReport(BuildContext context) async {
    if (_formKey.currentState.validate() &&
        (_imageFilePath1 != null ||
            _imageFilePath2 != null ||
            _imageFilePath3 != null ||
            _imageFilePath4 != null)) {
      try {
        setState(() {
          _isLoading = true;
        });
        final paths = <String>[];
        if (_imageFilePath1 != null) paths.add(_imageFilePath1);
        if (_imageFilePath2 != null) paths.add(_imageFilePath2);
        if (_imageFilePath3 != null) paths.add(_imageFilePath3);
        if (_imageFilePath4 != null) paths.add(_imageFilePath4);
        await _treasureService.addNewTreasure(
            category: _selectedCategory,
            title: _titleController.text,
            desc: _descriptionController.text,
            since: int.parse(_sinceController.text),
            imagesPaths: paths,
            location: pickedLocation);
        Navigator.of(context).pop();
      } catch (e) {} finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
