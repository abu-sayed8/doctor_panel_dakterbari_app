import 'package:doctor_panel/providers/doctor_provider.dart';

class StaticVariables {
  static const List<String> articleCategoryItems = [
    "News",
    "Diseases & Cause",
    "Health Tips",
    "Food & Nutrition",
    "Medicine & Treatment",
    "Medicare & Hospital",
    "Tourism & Cost",
    "Symptoms",
    "Visual Story",
  ];
  static const List<String> currency =['BD Taka', 'US Dollar'];

  static const List<String> serviceCategoryItems = [
    'COVID-19 (Coronavirus)',
    'Child Specialists (Pediatricians)',
    'Cardiologist',
    'Chest specialist',
    'Cancer Specialist',
    'Diabetes & Endocrinology',
    'Dentistry(Dentist)',
    'Dietitian & Nutrition Specialist',
    'Eye Specialist',
    'Eye, Nose, Ear (ENT) Specialist',
    'Gastroenterology & Hepatology',
    'Gynecologists & Obstetricians',
    'Hematology',
    'Homeopathic',
    'Medicine',
    'Neuromedicine',
    'Neuro-Surgery',
    'Oncology (Cancer)',
    'Orthopedic Surgeons',
    'Physical Medicine',
    'Pain Medicine',
    'Plastic Surgery',
    'Physiotherapists',
    'Psychiatrist',
    'Sex & Skin VD (Dermatology)',
    'Thyroid & Hormone',
    'Urology Specialist',
    'Urologists (Nephrology)',
    'Unani & Ayurveda',
    'Vascular Surgery',
  ];
  static const List<String> genderItems = ['Male','Female','Others'];

  static const List<String> dosageList =[
    'Tablet', 'Suppository', 'Oral', 'Suspension', 'Pediatric', 'Drops', 'Syrup'
  ];
}

class Entry {
  final String title;
  final List<Entry>
      children; //Since this is an expansion list...children can be another list of entries.

  Entry(this.title, [this.children = const <Entry>[]]);
}

///This is the entire multi-level list displayed by this app
List<Entry> faqDataList(DoctorProvider operation) {
  final List<Entry> data = <Entry>[
    Entry('1. How much experience Dr. ${operation.doctorList[0].fullName} in ${operation.doctorList[0].specification}?', <Entry>[
      Entry('Ans: ${operation.faqList.isEmpty? 'Update your answer':operation.faqList[0].one}.'),
    ]),
    Entry(
        '2. How can I book an online appointment with Dr. ${operation.doctorList[0].fullName}, ${operation.doctorList[0].specification}?',
        <Entry>[
          Entry(
              'Ans: ${operation.faqList.isEmpty? 'Update your answer':operation.faqList[0].two}.'),
        ]),
    Entry('3. What are the consultation charges of Dr. ${operation.doctorList[0].fullName}?', <Entry>[
      Entry('Ans: ${operation.faqList.isEmpty? 'Update your answer':operation.faqList[0].three}.'),
    ]),
    Entry(
        '4. What is the location of the hospital/clinic/chamber in ${operation.doctorList[0].state?? 'your area'}?',
        <Entry>[
          Entry(
              'Ans: ${operation.faqList.isEmpty? 'Update your answer':operation.faqList[0].four}.'),
        ]),
    Entry(
        '5. Can I view the OPD schedule, fee, and other details of Dr. ${operation.doctorList[0].fullName}?',
        <Entry>[
          Entry(
              'Ans: ${operation.faqList.isEmpty? 'Update your answer':operation.faqList[0].five}.'),
        ]),
    Entry('6. Is. Dr. ${operation.doctorList[0].fullName} available at any other hospital?', <Entry>[
      Entry(
          'Ans: ${operation.faqList.isEmpty? 'Update your answer':operation.faqList[0].six}.'),
    ]),
    Entry('7. What is Dr. ${operation.doctorList[0].fullName}\'s fee?', <Entry>[
      Entry(
          'Ans: ${operation.faqList.isEmpty? 'Update your answer':operation.faqList[0].seven}.'),
    ]),
    Entry('8. What are Dr. ${operation.doctorList[0].fullName}\'s specialty interests?', <Entry>[
      Entry(
          'Ans: ${operation.faqList.isEmpty? 'Update your answer':operation.faqList[0].eight}.'),
    ]),
    Entry('9. Where can I consult Dr. ${operation.doctorList[0].fullName}?', <Entry>[
      Entry(
          'Ans: ${operation.faqList.isEmpty? 'Update your answer':operation.faqList[0].nine}.'),
    ]),
    Entry('10. What societies is Dr. ${operation.doctorList[0].fullName} a member of?', <Entry>[
      Entry(
          'Ans: ${operation.faqList.isEmpty? 'Update your answer':operation.faqList[0].ten}.'),
    ]),

    //First Row...
    // Entry(
    //   'Title 1',
    //   <Entry>[
    //     Entry('Subtitle 1',
    //       <Entry>[
    //         Entry('Sub Item 1'),
    //         Entry('Sub Item 2'),
    //         Entry('Sub Item 3'),
    //       ],
    //     ),
    //     Entry('Item 1'),
    //     Entry('Item 2'),
    //   ],
    // ),

    //Second Row...
    // Entry('title 2',
    //     <Entry>[
    //       Entry('Item 1'),
    //       Entry('Item 2'),
    //       Entry('Subtitle',
    //         <Entry>[
    //           Entry('Sub Item 1'),
    //           Entry('Sub Item 2'),
    //         ],
    //       )
    //     ]
    // ),
  ];
  return data;
}

///This is the entire multi-level list displayed by this app
List<Entry> medicineDataList(String indications, String adultDose, String childDose,
    String renalDose, String administration, String contradiction, String sideEffect,
    String precautions, String pregnancy, String therapeutic, String modeOfAction,
    String interaction){
  final List<Entry> data = <Entry>[
    Entry('Indications', <Entry>[
      Entry(indications),
    ]),
    Entry(
        'Adult dose',
        <Entry>[
          Entry(
              adultDose),
        ]),
    Entry('Child dose', <Entry>[
      Entry(childDose),
    ]),
    Entry(
        'Renal dose',
        <Entry>[
          Entry(
              renalDose),
        ]),
    Entry(
        'Administration',
        <Entry>[
          Entry(
              administration),
        ]),
    Entry('Contraindication', <Entry>[
      Entry(
          contradiction),
    ]),
    Entry('Side effect', <Entry>[
      Entry(
          sideEffect),
    ]),
    Entry('Precautions & warnings', <Entry>[
      Entry(
          precautions),
    ]),
    Entry('Pregnancy & Lactation', <Entry>[
      Entry(
          pregnancy),
    ]),
    Entry('Therapeutic class', <Entry>[
      Entry(
          therapeutic),
    ]),
    Entry('Mode of Action', <Entry>[
      Entry(
          modeOfAction),
    ]),
    Entry('Interaction', <Entry>[
      Entry(
          interaction),
    ]),

    //First Row...
    // Entry(
    //   'Title 1',
    //   <Entry>[
    //     Entry('Subtitle 1',
    //       <Entry>[
    //         Entry('Sub Item 1'),
    //         Entry('Sub Item 2'),
    //         Entry('Sub Item 3'),
    //       ],
    //     ),
    //     Entry('Item 1'),
    //     Entry('Item 2'),
    //   ],
    // ),

    //Second Row...
    // Entry('title 2',
    //     <Entry>[
    //       Entry('Item 1'),
    //       Entry('Item 2'),
    //       Entry('Subtitle',
    //         <Entry>[
    //           Entry('Sub Item 1'),
    //           Entry('Sub Item 2'),
    //         ],
    //       )
    //     ]
    // ),
  ];
  return data;
}
