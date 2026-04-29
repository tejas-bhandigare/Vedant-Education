class ProductData {

  static final Map<String, Map<String, dynamic>> products = {

    /// ================= BAGS =================
    "bag1": {
      "name": "Bag 1",
      "mrp": 440.0,
      "discount": 27,
      "image": "assets/image/Bag1.jpg",
      "description": "SCHOOL BAG CUSTOMIZED SCHOOL BAGS HIGH QUALITY NOTE: QUANTITIY RESTRICTIONS",
    },

    "bag2": {
      "name": "Bag 2",
      "mrp": 440.0,
      "discount": 27,
      "image": "assets/image/Bag2.jpg",
      "description": "SCHOOL BAG CUSTOMIZED SCHOOL BAGS HIGH QUALITY NOTE: QUANTITIY RESTRICTIONS",
    },


    "bag3": {
      "name": "Kids School Bag",
      "mrp": 420.0,
      "discount": 33,
      "image": "assets/image/Bag3.jpg",
      "description": "SCHOOL BAG CUSTOMIZED SCHOOL BAG HIGH QUALITY NOTE: QUANTITIY RESTRICTIONS"
    },

    "bag4": {
      "name": "Junior School Bag",
      "mrp": 420.0,
      "discount": 33,
      "image": "assets/image/Bag4.jpeg",
      "description": "SCHOOL BAG CUSTOMIZED SCHOOL BAGS HIGH QUALITY NOTE: QUANTITIY RESTRICTIONS"
    },

    "bag5": {
      "name": "Senior School Bag",
      "mrp": 440.0,
      "discount": 27,
      "image": "assets/image/bag5.jpg",
      "description": "SCHOOL BAG CUSTOMIZED SCHOOL BAGS HIGH QUALITY NOTE: QUANTITIY RESTRICTIONS"
    },

    "bag6": {
      "name": "Waterproof School Bag",
      "mrp": 420.0,
      "discount": 33,
      "image": "assets/image/bag6.jpg",
      "description": "SCHOOL BAG CUSTOMIZED SCHOOL BAGS HIGH QUALITY NOTE: QUANTITIY RESTRICTIONS"
    },


    "bag7": {
      "name": "Lightweight School Bag",
      "mrp": 420.0,
      "discount": 33,
      "image": "assets/image/bag7.jpg",
      "description": "SCHOOL BAG CUSTOMIZED SCHOOL BAGS HIGH QUALITY NOTE: QUANTITIY RESTRICTIONS"
    },

    "bag8": {
      "name": "Multi Pocket Bag",
      "mrp": 449.0,
      "discount": 38,
      "image": "assets/image/bag8.jpg",
      "description": "SCHOOL BAG CUSTOMIZED SCHOOL BAGS HIGH QUALITY NOTE: QUANTITIY RESTRICTIONS"
    },

    "bag9": {
      "name": "Premium School Bag",
      "mrp": 459.0,
      "discount": 27,
      "image": "assets/image/bag9.jpg",
      "description": "SCHOOL BAG CUSTOMIZED SCHOOL BAG HIGH QUALITY NOTE: QUANTITIY RESTRICTIONS"
    },


    /// ================= PLAY GROUP BOOKS =================


    "PlayGroup Merged Books": {
      "name": "PlayGroup Merged Books",
      "mrp": 1649.0,
      "discount": 55,
      "image": "assets/image/PlayGroup.jpeg",
      "description": "Complete PlayGroup merged books set",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/playgroup_merged/Play_group_book1.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/playgroup_merged/Play_group_book2.pdf"},
        {"label": "Book 3", "asset": "assets/pdfs/playgroup_merged/Play group book 3.pdf"},
        {"label": "Book 4", "asset": "assets/pdfs/playgroup_merged/Play group book 4.pdf"},
      ],

    },

    "PlayGroup Subject Wise": {
      "name": "PlayGroup Subject Wise",
      "mrp": 1649.0,
      "discount": 27,
      "image": "assets/image/PlayGroup.jpeg",
      "description": "PlayGroup subject wise books set",
      "pdfs": [
        {"label": "English",  "asset": "assets/pdfs/playgroup_subject/PG English 1.8.1.pdf"},
        {"label": "Maths",    "asset": "assets/pdfs/playgroup_subject/PG Maths 1.8.1.pdf"},
        {"label": "EVS",      "asset": "assets/pdfs/playgroup_subject/PG EVS 1.8.1.pdf"},
        {"label": "RHYMES & STORIES",      "asset": "assets/pdfs/PG Rhymes & Stories.pdf"}
      ],
    },

    /// ================= NURSERY =================


    "Nursery Merged Books": {
      "name": "Nursery Merged Books",
      "mrp": 1749.0,
      "discount": 51,
      "image": "assets/image/Nursery.jpeg",
      "description": "Complete Nursery merged books",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/nursery_merged/Nursery Book 1.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/nursery_merged/Nursery Book 2.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/nursery_merged/Nursery Book 3.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/nursery_merged/Nursery Book 4.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/nursery_merged/Nursery Book 5.pdf"},


      ],
    },


    "Nursery Subject Wise": {
      "name": "Nursery Subject Wise",
      "mrp": 1649.0,
      "discount": 55,
      "image": "assets/image/Nursery.jpeg",
      "description": "Nursery subject wise books",
      "pdfs": [
        {"label": "English",  "asset": "assets/pdfs/nursery_subject/english.pdf"},
        {"label": "Maths",    "asset": "assets/pdfs/nursery_subject/maths.pdf"},
        {"label": "EVS",      "asset": "assets/pdfs/nursery_subject/evs.pdf"},
      ],

    },

    /// ================= JUNIOR =================
    "Junior Merged Books": {
      "name": "Junior Merged Books",
      "mrp": 1949.0,
      "discount": 54,
      "image": "assets/image/JuniorKgEnglish.jpeg",
      "description": "Complete Junior KG merged books",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/junior_merged/book1.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/junior_merged/book2.pdf"},

      ],
    },

    "Junior Subject Wise": {
      "name": "Junior Subject Wise",
      "mrp": 1949.0,
      "discount": 54,
      "image": "assets/image/JuniorKgEnglish.jpeg",
      "description": "Junior KG subject wise books",
      "pdfs": [
        {"label": "English",  "asset": "assets/pdfs/junior_subject/english.pdf"},
        {"label": "Maths",    "asset": "assets/pdfs/junior_subject/maths.pdf"},
        {"label": "EVS",      "asset": "assets/pdfs/junior_subject/evs.pdf"},
      ],
    },

    /// ================= SENIOR =================
    "Senior Merged Books": {
      "name": "Senior Merged Books",
      "mrp": 949.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "Complete Senior KG merged books",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/senior_merged/book1.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/senior_merged/book2.pdf"},
      ],
    },

    "Senior Subject Wise": {
      "name": "Senior Subject Wise",
      "mrp": 749.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "Senior KG subject wise books",
      "pdfs": [
        {"label": "English",  "asset": "assets/pdfs/senior_subject/english.pdf"},
        {"label": "Maths",    "asset": "assets/pdfs/senior_subject/maths.pdf"},
        {"label": "EVS",      "asset": "assets/pdfs/senior_subject/evs.pdf"},
      ],
    },

    "Senior KG Worksheet": {
      "name": "Senior KG Worksheet",
      "mrp": 299.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "Senior KG worksheets",
      "pdfs": [
        {"label": "Worksheet 1", "asset": "assets/pdfs/senior_worksheet/worksheet1.pdf"},
        {"label": "Worksheet 2", "asset": "assets/pdfs/senior_worksheet/worksheet2.pdf"},
      ],
    },

    /// ================= ENGLISH CURSIVE =================
    "English Cursive Level 1": {
      "name": "English Cursive Level 1",
      "mrp": 299.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "English cursive writing level 1",
    },


    "English Cursive Level 2": {
      "name": "English Cursive Level 2",
      "mrp": 299.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "English cursive writing level 2",
    },

    /// ================= MARATHI =================
    "मराठी Nursery Book": {
      "name": "मराठी Nursery Book",
      "mrp": 199.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "Marathi Nursery language book",
    },

    "मराठी Junior Kg Book": {
      "name": "मराठी Junior Kg Book",
      "mrp": 249.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "Marathi Junior KG book",
    },

    /// ================= CERTIFICATES =================
    "Certificate 1": {
      "name": "Certificate 1",
      "mrp": 35.0,
      "discount": 46,
      "image": "assets/image/Certification1.jpeg",
      "description": "CUSTOMIZED CERTIFICATES CUSTOMIZED CERTIFICATES CERTIFICATE SIZE: 200GSM"
                     "NOTE: NO DESIGN CHARGES REQUIRED "
                     "NOTE: QUANTITY RESTRICTIONS",
    },

    "Certificate 2": {
      "name": "Certificate 2",
      "mrp": 35.0,
      "discount": 46,
      "image": "assets/image/Certification2.jpeg",
      "description": "CUSTOMIZED CERTIFICATES"
      "CUSTOMIZED CERTIFICATES"
     " CERTIFICATE SIZE: 200GSM"

     " NOTE: NO DESIGN CHARGES REQUIRED"
     " NOTE: QUANTITY RESTRICTIONS",
    },



    "Certificate 3": {
      "name": "Certificate 3",
      "mrp": 35.0,
      "discount": 46,
      "image": "assets/image/Certification3.jpeg",
      "description": "Certificate"
     " Sports and cultural certificates"
     " Note: Quantity required",
    },

    "Certificate 4": {
      "name": "Certificate 4",
      "mrp": 35.0,
      "discount": 46,
      "image": "assets/image/Certification4.jpeg",
      "description": "Certificate"
    "  PAPER 250 GSM",
    },

    "Certificate 5": {
      "name": "Certificate 4",
      "mrp": 35.0,
      "discount": 46,
      "image": "assets/image/Certification5.jpeg",
      "description": "Certificate"
                     "PAPER 250 GSM",
    },


    "Certificate 6": {
      "name": "Certificate 4",
      "mrp": 35.0,
      "discount": 46,
      "image": "assets/image/Certification6.jpeg",
      "description": "Certificate",
    },

    /// ================= ID CARD =================
    "Id Card 1": {
      "name": "Id Card 1",
      "mrp": 75.0,
      "discount": 27,
      "image": "assets/image/IdCard1.jpeg",
      "description": "ID CARD"
      "HIGH QUALITY"
      "PRODUCTS"
      "VERTICAL AND HORIZONTAL"

     " NOTE: QUANTITY RESTRICTIONS",
    },

    "Id Card 2": {
      "name": "Id Card 2",
      "mrp": 75.0,
      "discount": 55,
      "image": "assets/image/IdCard2.jpeg",
      "description": "Student ID card",
    },

    /// ================= MEDALS =================
    "Gold Silver Bronze": {
      "name": "Medals Set",
      "mrp": 119.0,
      "discount": 34,
      "image": "assets/image/medals.jpg",
      "description": "Gold, Bronze, Silver medals"
     " Min Qty 75 required",
    },

    /// ================= NOTEBOOK =================
    "Notebook 1": {
      "name": "Notebook 1",
      "mrp": 58.0,
      "discount": 24,
      "image": "assets/image/notebook 1.jpg",
      "description": "NOTE BOOKS "
          " YOUR SCHOOL NAME AND LOGO "
          " PAGES: 200 "
          " SIZE:A5 "
          "PAPER SIZE: 70 GSN "

          "NOTES: QUANTITIY REQUIRED FOR CUSTOMIZED NOTE BOOKS ",
    },

    "Notebook 2": {
      "name": "Notebook 2",
      "mrp": 58.0,
      "discount": 24,
      "image": "assets/image/note book2.jpg",
      "description": "CUSTOMIZED NOTE BOOKS"
          " YOUR SCHOOL NAME AND LOGO"
          " PAGES:200"
          " SIZE: A5"
          "PAPER SIZE: 70 GSM"
          " NOTE: QUANTITIY REQUIRED FOR CUSTOMIZED NOTE BOOK",
    },
    "Notebook 3": {
      "name": "Notebook 3",
      "mrp": 58.0,
      "discount": 24,
      "image": "assets/image/notebook3.jpg"
          "",
      "description": "CUSTOMIZED NOTE BOOKS"
      " YOUR SCHOOL NAME AND LOGO"
      " PAGES: 200"
      "  PAPER SIZE: 70GSM"
      " NOTE: QUANTITIY REQUIRED FOR CUSTOMIZED NOTE BOOKS",
    },



    /// ================= PROGRESS CARD =================
    "Progress Card 1": {
      "name": "Progress Card 1",
      "mrp": 35.0,
      "discount": 0,
      "image": "assets/image/ProgressCard1.jpeg",
      "description": "Student progress card"
                     "Note: Quantity restrictions ",
    },


    "Progress Card 2": {
      "name": "Progress Card 2",
      "mrp": 45.0,
      "discount": 22,
      "image": "assets/image/ProgressCard2.jpeg",
      "description": "Results"
       "Qty 100",
    },


    "Progress Card 3": {
      "name": "Progress Card 3",
      "mrp": 45.0,
      "discount": 22,
      "image": "assets/image/ProgressCard3.jpeg",
      "description": "progress card"
          " Qty 100",
    },

    "Progress Card 4": {
      "name": "Progress Card 4",
      "mrp": 45.0,
      "discount": 22,
      "image": "assets/image/ProgressCard4.jpeg",
      "description": "progress card"
                     "Qty 100",
    },

    /// ================= UNIFORM =================
    "Uniform 1": {
      "name": "Uniform 1",// school uniform
      "mrp": 480.0,
      "discount": 42,
      "image": "assets/image/uniform1.jpg",
      "description": "School uniform "
          " WITH YOUR SCHOOL NAME AND LOGO"
          "UNIFORM SIZE: 18-20-22-24"
          "CLOTHE COMPANY: MAFTLAL AND PODAR"
          "  HIGH QUALITY"

          " NOTE: QUANTITY RESTRICTIONS"
          "NOTE: PRICE DEPENDS ON SIZES"

          "NOTE: NO DESIGN CHARGES REQUIRED"
          "NOTE: QUANTITY RESTRICTIONS",
    },

    "Uniform 2": {
      "name": "Uniform 2", // yellow uniform single
      "mrp": 680.0,
      "discount": 29,
      "image": "assets/image/uniform4.jpg",
      "description": "Premium school uniform"
                     "Yellow"
                     "Maftlal Brand Only",
    },

    "Uniform 3": {
      "name": "Uniform 2",
      "mrp": 649.0,
      "discount": 31,
      "image": "assets/image/uniform3.jpg",
      "description": "Boys & Girls Uniform"
      " Quality Product"
      " Min Qty. 100"
      "Boys: 449/-"
      "Girls: 499/-",
},

    "Uniform 4": {
      "name": "Uniform 2",
      "mrp": 679.0,
      "discount": 34,
      "image": "assets/image/uniform4.jpg",
      "description": "Boys & Girls Uniform"
      " Quality Product"
      "Min Qty. 100"
      "Boys: 449/-"
      " Girls: 499/-",
},

    "Uniform 5": {
      "name": "Uniform 2",
      "mrp": 549.0,
      "discount": 27,
      "image": "assets/image/uniform1.jpg",
      "description": "Boys & Girls Uniform"
                     "Quality Product"
                     "Min Qty. 100"
                     "Boys: 449/-"
                     "Girls: 499/-",
},
  };

}