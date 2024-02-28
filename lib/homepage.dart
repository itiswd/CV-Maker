import 'dart:io';
import 'dart:ui' as ui;
import 'package:cv_maker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color mainColor = const Color(0x0fd9d8ed);
  //Image Picker Vars
  double radius = 0;
  File? selectedImage;
  //width and height
  double? mainWidth;
  double? mainHeight;
  int x = 5;
  TextEditingController textController = TextEditingController();
  //Save Image Vars
  GlobalKey scaffoldKey = GlobalKey();
  Uint8List? imageBytes;
  //Pick Image
  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  //Save Image
  void captureScreenshot() async {
    RenderRepaintBoundary boundary =
        scaffoldKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 5.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    setState(() {
      imageBytes = byteData!.buffer.asUint8List();
    });
    _saveScreenshot();
  }

  //save image to gallery
  void _saveScreenshot() async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/screenshot.png';
    File file = File(filePath);
    await file.writeAsBytes(imageBytes!);
    await ImageGallerySaver.saveFile(filePath);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      mainWidth = 595 / 1.8;
      mainHeight = 842 / 1.8;
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[350],
        //App Bar
        appBar: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            80,
          ),
          child: Card(
            color: Colors.black,
            elevation: 4,
            margin: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
            child: Center(
              child: Row(
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  //Save Image
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        captureScreenshot();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            content: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 24,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "تم الحفظ في وحدة التخزين",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontFamily: 'me_quran',
                                        wordSpacing: 4,
                                        height: 1.33,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                32,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                    child: const Icon(
                      Icons.save,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  //App Title
                  const Text(
                    'CV Maker',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'AbrilFatface',
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(
                    flex: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
        //Body
        body: InteractiveViewer(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      left: 8,
                      bottom: 76,
                    ),
                    child: RepaintBoundary(
                      key: scaffoldKey,
                      child: Container(
                        width: mainWidth,
                        height: mainHeight! + 16,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/CV01.jpg'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: mainWidth! / 2,
                                  height: mainHeight,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: mainWidth! / 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: mainWidth! / 2,
                                              height: mainWidth! / 2.2,
                                              child: Column(
                                                children: [
                                                  const Spacer(
                                                    flex: 12,
                                                  ),
                                                  //Job Title
                                                  GestureDetector(
                                                    onTap: () {
                                                      mainField(
                                                        context,
                                                        jobTitle,
                                                        'Your job title..',
                                                        (value) {
                                                          setState(() {
                                                            jobTitle = value;
                                                          });
                                                        },
                                                        () {
                                                          textController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      jobTitle == ''
                                                          ? 'Electrical\nEngineer'
                                                          : jobTitle,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            mainWidth! / 14,
                                                        fontFamily:
                                                            'AbrilFatface',
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(
                                                    flex: 3,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: mainWidth! / 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: mainWidth! / 16,
                                                    ),
                                                    //Name
                                                    GestureDetector(
                                                      onTap: () {
                                                        mainField(
                                                          context,
                                                          perName,
                                                          'Your name..',
                                                          (value) {
                                                            setState(() {
                                                              perName = value;
                                                            });
                                                          },
                                                          () {
                                                            textController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      },
                                                      child: dataRow(
                                                        Icons.person,
                                                        perName == ''
                                                            ? 'Ibrahim Tharwat Ibrahim'
                                                            : perName,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: mainWidth! / 48,
                                                    ),
                                                    //Email
                                                    GestureDetector(
                                                      onTap: () {
                                                        mainField(
                                                          context,
                                                          perMail,
                                                          'Your mail..',
                                                          (value) {
                                                            setState(() {
                                                              perMail = value;
                                                            });
                                                          },
                                                          () {
                                                            textController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      },
                                                      child: dataRow(
                                                        Icons.email,
                                                        perMail == ''
                                                            ? 'itiswdev97@gmail.com'
                                                            : perMail,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: mainWidth! / 48,
                                                    ),
                                                    //Phone
                                                    GestureDetector(
                                                      onTap: () {
                                                        mainField(
                                                          context,
                                                          perPhone,
                                                          'Your phone..',
                                                          (value) {
                                                            setState(() {
                                                              perPhone = value;
                                                            });
                                                          },
                                                          () {
                                                            textController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      },
                                                      child: dataRow(
                                                        Icons.phone,
                                                        perPhone == ''
                                                            ? '01553889243'
                                                            : perPhone,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: mainWidth! / 48,
                                                    ),
                                                    //Address
                                                    GestureDetector(
                                                      onTap: () {
                                                        mainField(
                                                          context,
                                                          perAddress,
                                                          'Your address..',
                                                          (value) {
                                                            setState(() {
                                                              perAddress =
                                                                  value;
                                                            });
                                                          },
                                                          () {
                                                            textController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      },
                                                      child: dataRow(
                                                        Icons.home,
                                                        perAddress == ''
                                                            ? '10th of Ramadan Sharkia- Egypt'
                                                            : perAddress,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: mainWidth! / 48,
                                                    ),
                                                    SizedBox(
                                                      height: mainWidth! / 16,
                                                    ),
                                                    //Language
                                                    lableName(
                                                      'Language',
                                                    ),
                                                    SizedBox(
                                                      height: mainWidth! / 32,
                                                    ),
                                                    //First Language
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            mainField(
                                                              context,
                                                              lang01,
                                                              'Your fist lang..',
                                                              (value) {
                                                                setState(() {
                                                                  lang01 =
                                                                      value;
                                                                });
                                                              },
                                                              () {
                                                                textController
                                                                    .clear();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            );
                                                          },
                                                          child: skillRow(
                                                            lang01 == ''
                                                                ? 'English'
                                                                : lang01,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        PopupMenuButton(
                                                          itemBuilder:
                                                              (context) => [
                                                            for (int o = 1;
                                                                o < 6;
                                                                o++)
                                                              PopupMenuItem(
                                                                child:
                                                                    Text('$o'),
                                                                onTap: () {
                                                                  setState(() {
                                                                    langRate01 =
                                                                        o;
                                                                  });
                                                                },
                                                              ),
                                                          ],
                                                          child: mainRate(
                                                            langRate01,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: mainWidth! / 48,
                                                    ),
                                                    //Second Language
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            mainField(
                                                              context,
                                                              lang02,
                                                              'Your second lang..',
                                                              (value) {
                                                                setState(() {
                                                                  lang02 =
                                                                      value;
                                                                });
                                                              },
                                                              () {
                                                                textController
                                                                    .clear();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            );
                                                          },
                                                          child: skillRow(
                                                            lang02 == ''
                                                                ? 'France'
                                                                : lang02,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        PopupMenuButton(
                                                            itemBuilder:
                                                                (context) => [
                                                                      for (int o =
                                                                              1;
                                                                          o < 6;
                                                                          o++)
                                                                        PopupMenuItem(
                                                                          child:
                                                                              Text('$o'),
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              langRate02 = o;
                                                                            });
                                                                          },
                                                                        ),
                                                                    ],
                                                            child: mainRate(
                                                              langRate02,
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Selected Image
                                      Positioned(
                                        top: 50,
                                        left: 26.5,
                                        child: selectedImage != null
                                            ? GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    pickImageFromGallery();
                                                  });
                                                },
                                                child: Container(
                                                  width: 105,
                                                  height: 112,
                                                  decoration: BoxDecoration(
                                                    color: mainColor
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                          mainWidth! / 2),
                                                    ),
                                                    image: DecorationImage(
                                                      image: FileImage(
                                                          selectedImage!),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    pickImageFromGallery();
                                                  });
                                                },
                                                child: SizedBox(
                                                  width: mainWidth! / 3,
                                                  height: mainWidth! / 3,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.add_a_photo,
                                                      size: 32,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: mainWidth! / 2,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: mainWidth! / 12,
                                            ),
                                            //Education
                                            lableName('Education'),
                                            //Faculty
                                            GestureDetector(
                                              onTap: () {
                                                mainField(
                                                  context,
                                                  faculty,
                                                  'Your faculty name..',
                                                  (value) {
                                                    setState(() {
                                                      faculty = value;
                                                    });
                                                  },
                                                  () {
                                                    textController.clear();
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                              child: dataScript(
                                                faculty == ''
                                                    ? "Bachelor's degree in Mechanical Engineering faculty of engineering, zagazig university"
                                                    : faculty,
                                                Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: mainWidth! / 24,
                                            ),
                                            //Internships
                                            lableName('Internships'),
                                            //Internship
                                            GestureDetector(
                                              onTap: () {
                                                mainField(
                                                  context,
                                                  interns,
                                                  'Your internship..',
                                                  (value) {
                                                    setState(() {
                                                      interns = value;
                                                    });
                                                  },
                                                  () {
                                                    textController.clear();
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                              child: dataScript(
                                                interns == ''
                                                    ? "Elhandsia for heavy equipment (EHE), 10th of Ramadan Maintenance engineer AutoCAD Essential learned about important types of hydraulic pumps and also determined their faults and how tomaintain them I also learned the different hydraulic circuits, the faults that can occur in them, and how to maintain them"
                                                    : interns,
                                                Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: mainWidth! / 24,
                                            ),
                                            //Cources
                                            lableName('Cources'),
                                            //Cource
                                            GestureDetector(
                                              onTap: () {
                                                mainField(
                                                  context,
                                                  cources,
                                                  'Your cource name..',
                                                  (value) {
                                                    setState(() {
                                                      cources = value;
                                                    });
                                                  },
                                                  () {
                                                    textController.clear();
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                              child: dataScript(
                                                cources == ''
                                                    ? 'I learned the essential of AutoCAD and also how to use the program to carry out MEP works'
                                                    : cources,
                                                Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: mainWidth! / 24,
                                            ),
                                            //Skills
                                            lableName('Skills'),
                                            SizedBox(
                                              height: mainWidth! / 48,
                                            ),
                                            //Skill_1
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8,
                                                left: 8,
                                                bottom: 4,
                                              ),
                                              child: Row(
                                                children: [
                                                  //Skill
                                                  GestureDetector(
                                                    onTap: () {
                                                      mainField(
                                                        context,
                                                        skill01,
                                                        'Your first skill..',
                                                        (value) {
                                                          setState(() {
                                                            skill01 = value;
                                                          });
                                                        },
                                                        () {
                                                          textController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      );
                                                    },
                                                    child: skillRow(
                                                      skill01 == ''
                                                          ? 'Dart'
                                                          : skill01,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  //Rate
                                                  PopupMenuButton(
                                                      itemBuilder: (context) =>
                                                          [
                                                            for (int o = 1;
                                                                o < 6;
                                                                o++)
                                                              PopupMenuItem(
                                                                child:
                                                                    Text('$o'),
                                                                onTap: () {
                                                                  setState(() {
                                                                    skillRate01 =
                                                                        o;
                                                                  });
                                                                },
                                                              ),
                                                          ],
                                                      child: mainRate(
                                                          skillRate01)),
                                                ],
                                              ),
                                            ),
                                            //Skill_2
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8,
                                                left: 8,
                                                bottom: 4,
                                              ),
                                              child: Row(
                                                children: [
                                                  //Skill
                                                  GestureDetector(
                                                    onTap: () {
                                                      mainField(
                                                        context,
                                                        skill02,
                                                        'Your second skill..',
                                                        (value) {
                                                          setState(() {
                                                            skill02 = value;
                                                          });
                                                        },
                                                        () {
                                                          textController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      );
                                                    },
                                                    child: skillRow(
                                                      skill02 == ''
                                                          ? 'Flutter'
                                                          : skill02,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  //Rate
                                                  PopupMenuButton(
                                                      itemBuilder: (context) =>
                                                          [
                                                            for (int o = 1;
                                                                o < 6;
                                                                o++)
                                                              PopupMenuItem(
                                                                child:
                                                                    Text('$o'),
                                                                onTap: () {
                                                                  setState(() {
                                                                    skillRate02 =
                                                                        o;
                                                                  });
                                                                },
                                                              ),
                                                          ],
                                                      child: mainRate(
                                                          skillRate02)),
                                                ],
                                              ),
                                            ),
                                            //Skill_3
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: Row(
                                                children: [
                                                  //Skill
                                                  GestureDetector(
                                                    onTap: () {
                                                      mainField(
                                                        context,
                                                        skill03,
                                                        'Your third skill..',
                                                        (value) {
                                                          setState(() {
                                                            skill03 = value;
                                                          });
                                                        },
                                                        () {
                                                          textController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      );
                                                    },
                                                    child: skillRow(
                                                      skill03 == ''
                                                          ? 'Java'
                                                          : skill03,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  //Rate
                                                  PopupMenuButton(
                                                      itemBuilder: (context) =>
                                                          [
                                                            for (int o = 1;
                                                                o < 6;
                                                                o++)
                                                              PopupMenuItem(
                                                                child:
                                                                    Text('$o'),
                                                                onTap: () {
                                                                  setState(() {
                                                                    skillRate03 =
                                                                        o;
                                                                  });
                                                                },
                                                              ),
                                                          ],
                                                      child: mainRate(
                                                          skillRate03)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Main TextField
  Future<dynamic> mainField(
    BuildContext context,
    dynamic text01,
    String hint,
    Function(String v) onChange,
    Function() onTap,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.center,
          child: Card(
            child: SizedBox(
              width: mainWidth!,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: null,
                  controller: textController,
                  decoration: InputDecoration(
                    enabled: true,
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontFamily: 'BricolageGrotesque',
                      color: Colors.black54,
                    ),
                    border: InputBorder.none,
                    suffixIcon: GestureDetector(
                      onTap: onTap,
                      child: const Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(
                      onChange(value),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //Scrip
  Padding dataScript(
    String script,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: Text(
        script,
        style: TextStyle(
          fontSize: mainWidth! / 38,
          height: 1,
          fontFamily: 'BricolageGrotesque',
          color: color,
        ),
      ),
    );
  }

  //Skill
  Container skillRow(
    String skill,
  ) {
    return Container(
      color: Colors.white,
      child: Text(
        skill,
        style: TextStyle(
          fontSize: mainWidth! / 32,
          fontFamily: 'BricolageGrotesque',
        ),
      ),
    );
  }

  //Skill Rate
  Container mainRate(
    int num,
  ) {
    setState(() {
      x = num;
    });
    return Container(
      color: Colors.white,
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          for (int i = 0; i < 5; i++)
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: CircleAvatar(
                radius: 3,
                backgroundColor: x > i ? Colors.black : Colors.black26,
              ),
            ),
        ],
      ),
    );
  }

  //Main Lable
  Card lableName(
    String text,
  ) {
    return Card(
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      color: mainColor.withOpacity(0.2),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 4,
          left: 4,
          bottom: 12,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: mainWidth! / 20,
            height: 0.1,
            fontFamily: 'AbrilFatface',
          ),
        ),
      ),
    );
  }

  //Data Row
  Row dataRow(
    IconData icon,
    String text,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: mainWidth! / 32,
        ),
        const SizedBox(
          width: 4,
        ),
        SizedBox(
          width: mainWidth! / 2 - 32,
          child: Text(
            text,
            style: TextStyle(
              fontSize: mainWidth! / 38,
              height: 1,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
        ),
      ],
    );
  }
}
