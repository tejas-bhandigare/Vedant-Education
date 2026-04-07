class ProductData {

  static final Map<String, Map<String, dynamic>> products = {

    /// ================= BAGS =================
    "bag1": {
      "name": "Bag 1",
      "mrp": 450.0,
      "discount": 27,
      "image": "assets/image/Bag1.jpg",
      "description": "Durable school bag for students",
    },

    "bag2": {
      "name": "Bag 2",
      "mrp": 500.0,
      "discount": 27,
      "image": "assets/image/Bag2.jpg",
      "description": "Premium quality school bag",
    },

    "bag3": {
      "name": "Kids School Bag",
      "mrp": 850.0,
      "discount": 27,
      "image": "assets/image/Bag3.jpg",
      "description": "Comfortable kids school bag with adjustable straps."
    },

    "bag4": {
      "name": "Junior School Bag",
      "mrp": 900.0,
      "discount": 27,
      "image": "assets/image/Bag4.jpeg",
      "description": "Stylish junior school bag with strong zip and pockets."
    },

    "bag5": {
      "name": "Senior School Bag",
      "mrp": 1050.0,
      "discount": 27,
      "image": "assets/image/Bag4.jpeg",
      "description": "Large capacity senior school bag for books."
    },

    "bag6": {
      "name": "Waterproof School Bag",
      "mrp": 1100.0,
      "discount": 27,
      "image": "assets/image/Bag4.jpeg",
      "description": "Waterproof school bag to protect books."
    },

    "bag7": {
      "name": "Lightweight School Bag",
      "mrp": 950.0,
      "discount": 27,
      "image": "assets/image/Bag4.jpeg",
      "description": "Lightweight bag for daily school use."
    },

    "bag8": {
      "name": "Multi Pocket Bag",
      "mrp": 1200.0,
      "discount": 27,
      "image": "assets/image/Bag4.jpeg",
      "description": "Multi pocket bag for organizing books."
    },

    "bag9": {
      "name": "Premium School Bag",
      "mrp": 1350.0,
      "discount": 27,
      "image": "assets/image/Bag4.jpeg",
      "description": "Premium quality strong school bag."
    },


    /// ================= PLAY GROUP BOOKS =================


    "PlayGroup Merged Books": {
      "name": "PlayGroup Merged Books",
      "mrp": 749.0,
      "discount": 27,
      "image": "assets/image/PlayGroup.jpeg",
      "description": "Complete PlayGroup merged books set",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/playgroup_merged/Play_group_book1.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/playgroup_merged/Play_group_book2.pdf"},
      ],


    },

    "PlayGroup Subject Wise": {
      "name": "PlayGroup Subject Wise",
      "mrp": 599.0,
      "discount": 27,
      "image": "assets/image/PlayGroup.jpeg",
      "description": "PlayGroup subject wise books set",
      "pdfs": [
        {"label": "English",  "asset": "assets/pdfs/playgroup_subject/PG English 1.8.1.pdf"},
        {"label": "Maths",    "asset": "assets/pdfs/playgroup_subject/PG Maths 1.8.1.pdf"},
        {"label": "EVS",      "asset": "assets/pdfs/playgroup_subject/PG EVS 1.8.1.pdf"},
      ],
    },

    /// ================= NURSERY =================


    "Nursery Merged Books": {
      "name": "Nursery Merged Books",
      "mrp": 799.0,
      "discount": 27,
      "image": "assets/image/Nursery.jpeg",
      "description": "Complete Nursery merged books",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/nursery_merged/book1.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/nursery_merged/book2.pdf"},
      ],
    },

    "Nursery Subject Wise": {
      "name": "Nursery Subject Wise",
      "mrp": 649.0,
      "discount": 27,
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
      "mrp": 899.0,
      "discount": 27,
      "image": "assets/image/JuniorKgEnglish.jpeg",
      "description": "Complete Junior KG merged books",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/junior_merged/book1.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/junior_merged/book2.pdf"},
      ],
    },

    "Junior Subject Wise": {
      "name": "Junior Subject Wise",
      "mrp": 699.0,
      "discount": 27,
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
      "mrp": 199.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "English cursive writing level 1",
    },

    "English Cursive Level 2": {
      "name": "English Cursive Level 2",
      "mrp": 249.0,
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
      "mrp": 50.0,
      "discount": 27,
      "image": "assets/image/Certification1.jpeg",
      "description": "School certificate",
    },

    "Certificate 2": {
      "name": "Certificate 2",
      "mrp": 50.0,
      "discount": 27,
      "image": "assets/image/Certification2.jpeg",
      "description": "Student achievement certificate",
    },

    "Certificate 3": {
      "name": "Certificate 3",
      "mrp": 70.0,
      "discount": 27,
      "image": "assets/image/Certification3.jpeg",
      "description": "Participation certificate",
    },

    "Certificate 4": {
      "name": "Certificate 4",
      "mrp": 80.0,
      "discount": 27,
      "image": "assets/image/Certification4.jpeg",
      "description": "Completion certificate",
    },

    "Certificate 5": {
      "name": "Certificate 4",
      "mrp": 80.0,
      "discount": 27,
      "image": "assets/image/Certification5.jpeg",
      "description": "Completion certificate",
    },

    "Certificate 6": {
      "name": "Certificate 4",
      "mrp": 80.0,
      "discount": 27,
      "image": "assets/image/Certification6.jpeg",
      "description": "Completion certificate",
    },

    /// ================= ID CARD =================
    "Id Card 1": {
      "name": "Id Card 1",
      "mrp": 100.0,
      "discount": 27,
      "image": "assets/image/IdCard1.jpeg",
      "description": "School ID card",
    },

    "Id Card 2": {
      "name": "Id Card 2",
      "mrp": 100.0,
      "discount": 27,
      "image": "assets/image/IdCard2.jpeg",
      "description": "Student ID card",
    },

    /// ================= MEDALS =================
    "Gold Silver Bronze": {
      "name": "Medals Set",
      "mrp": 150.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "Gold, Silver, Bronze medals",
    },

    /// ================= NOTEBOOK =================
    "Notebook 1": {
      "name": "Notebook 1",
      "mrp": 120.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "Student notebook",
    },

    "Notebook 2": {
      "name": "Notebook 2",
      "mrp": 140.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "High quality notebook",
    },

    "Notebook 3": {
      "name": "Notebook 3",
      "mrp": 160.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "High quality thick notebook",
    },


    /// ================= PROGRESS CARD =================
    "Progress Card 1": {
      "name": "Progress Card 1",
      "mrp": 80.0,
      "discount": 27,
      "image": "assets/image/ProgressCard1.jpeg",
      "description": "Student progress card",
    },

    "Progress Card 2": {
      "name": "Progress Card 2",
      "mrp": 80.0,
      "discount": 27,
      "image": "assets/image/ProgressCard2.jpeg",
      "description": "School progress card",
    },

    "Progress Card 3": {
      "name": "Progress Card 3",
      "mrp": 80.0,
      "discount": 27,
      "image": "assets/image/ProgressCard3.jpeg",
      "description": "Student yearly progress card",
    },

    "Progress Card 4": {
      "name": "Progress Card 4",
      "mrp": 80.0,
      "discount": 27,
      "image": "assets/image/ProgressCard4.jpeg",
      "description": "Detailed academic progress card",
    },

    /// ================= UNIFORM =================
    "Uniform 1": {
      "name": "Uniform 1",
      "mrp": 499.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "School uniform set",
    },

    "Uniform 2": {
      "name": "Uniform 2",
      "mrp": 549.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "Premium school uniform",
    },

  };

}