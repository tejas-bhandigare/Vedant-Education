class ProductData {

  static final Map<String, Map<String, dynamic>> products = {

    /// ================= BAGS =================
    "bag1": {
      "name": "Bag 1",
      "mrp": 440.0,
      "discount": 27,
      "image": "assets/image/Bag1.jpg",
      "description": "Durable school bag for students",
    },

    "bag2": {
      "name": "Bag 2",
      "mrp": 440.0,
      "discount": 27,
      "image": "assets/image/Bag2.jpg",
      "description": "Premium quality school bag",
    },

    "bag3": {
      "name": "Kids School Bag",
      "mrp": 420.0,
      "discount": 33,
      "image": "assets/image/Bag3.jpg",
      "description": "Comfortable kids school bag with adjustable straps."
    },

    "bag4": {
      "name": "Junior School Bag",
      "mrp": 420.0,
      "discount": 33,
      "image": "assets/image/Bag4.jpeg",
      "description": "Stylish junior school bag with strong zip and pockets."
    },

    "bag5": {
      "name": "Senior School Bag",
      "mrp": 440.0,
      "discount": 27,
      "image": "assets/image/bag5.jpg",
      "description": "Large capacity senior school bag for books."
    },

    "bag6": {
      "name": "Waterproof School Bag",
      "mrp": 420.0,
      "discount": 33,
      "image": "assets/image/bag6.jpg",
      "description": "Waterproof school bag to protect books."
    },

    "bag7": {
      "name": "Lightweight School Bag",
      "mrp": 420.0,
      "discount": 33,
      "image": "assets/image/bag7.jpg",
      "description": "Lightweight bag for daily school use."
    },

    "bag8": {
      "name": "Multi Pocket Bag",
      "mrp": 449.0,
      "discount": 38,
      "image": "assets/image/bag8.jpg",
      "description": "Multi pocket bag for organizing books."
    },

    "bag9": {
      "name": "Premium School Bag",
      "mrp": 469.0,
      "discount": 24,
      "image": "assets/image/bag9.jpg",
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
      "mrp": 1749.0,
      "discount": 51,
      "image": "assets/image/Nursery.jpeg",
      "description": "Complete Nursery merged books",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/nursery_merged/Nursery Book 1.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/nursery_merged/Nursery Book 2.pdf"},
        {"label": "Book 3", "asset": "assets/pdfs/nursery_merged/Nursery Book 3.pdf"},
        {"label": "Book 4", "asset": "assets/pdfs/nursery_merged/Nursery Book 4.pdf"},
        {"label": "Book 5", "asset": "assets/pdfs/nursery_merged/Nursery Book 5.pdf"},


      ],
    },

    // ── Nursery Subject Wise sub-products (4 items) ──

    "Nursery Subjectwise Books": {
      "name": "Nursery Subjectwise Books",
      "mrp": 649.0,
      "discount": 27,
      "image": "assets/image/Nursery.jpeg",
      "description": "English- LTI PATTERN or...",
      "pdfs": [
        {"label": "English",  "asset": "assets/pdfs/nursery_subject/english.pdf"},
        {"label": "Maths",    "asset": "assets/pdfs/nursery_subject/maths.pdf"},
        {"label": "EVS",      "asset": "assets/pdfs/nursery_subject/evs.pdf"},
      ],
    },

    "Nursery Hindi Reading Book": {
      "name": "हिंदी",
      "mrp": 199.0,
      "discount": 27,
      "image": "assets/image/Nursery.jpeg",
      "description": "Reading Book",
      "pdfs": [
        {"label": "Hindi Reading", "asset": "assets/pdfs/nursery_subject/hindi_reading.pdf"},
      ],
    },

    "Nursery Hindi L-1": {
      "name": "Nursery Hindi L-1",
      "mrp": 199.0,
      "discount": 27,
      "image": "assets/image/nursoryhindil1.jpeg",
      "description": "Writing Book",
      "pdfs": [
        {"label": "Hindi Writing", "asset": "assets/pdfs/nursery_subject/hindi_writing.pdf"},
      ],
    },

    "Nursery Drawing Book": {
      "name": "Drawing Book (Optional)",
      "mrp": 149.0,
      "discount": 27,
      "image": "assets/image/sakshi.png",
      "description": "Optional - No Quantity Restriction",
    },


    /// ================= JUNIOR =================

    "Junior Merged Books": {
      "name": "Junior Merged Books",
      "mrp": 899.0,
      "discount": 27,
      "image": "assets/image/JuniorKgEnglish.jpeg",
      "description": "Complete Junior KG merged books",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/junior_merged/Jr. KG Book 1-1.8.1.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/junior_merged/Jr. KG Book 2-1.8.1.pdf"},
        {"label": "Book 3", "asset": "assets/pdfs/junior_merged/Jr. KG Book 3-1.8.1.pdf"},
        {"label": "Book 4", "asset": "assets/pdfs/junior_merged/Jr. KG Book 4-1.8.1.pdf"},
        {"label": "Book 5", "asset": "assets/pdfs/junior_merged/Jr. KG Book 5-1.8.1.pdf"},

      ],
    },

    // ── Junior Subject Wise sub-products (2 items) ──

    "Junior Kg Subject wise": {
      "name": "Junior Kg Subject wise",
      "mrp": 699.0,
      "discount": 27,
      "image": "assets/image/JuniorKgEnglish.jpeg",
      "description": "English\nहिंदी 1.6.1...",
      "pdfs": [
        {"label": "English",  "asset": "assets/pdfs/junior_subject/Jr KG Book English 1.7.1.pdf"},
        {"label": "Maths",    "asset": "assets/pdfs/junior_subject/Jr. KG Book MATHS 1.6.2.pdf"},
        {"label": "EVS",      "asset": "assets/pdfs/junior_subject/Jr. KG  EVS 1.7.1.pdf"},
        {"label": "Hindi",    "asset": "assets/pdfs/junior_subject/Jr. KG Book Hindi 1.6.1 Level 1.pdf"},
        {"label": "Story & Activities",      "asset": "assets/pdfs/junior_subject/Jr. KG Book Story & Activities 1.7.1.pdf"},

      ],
    },

    "Marathi Level 1 Book": {
      "name": "Marathi Level 1 Book",
      "mrp": 399.0,
      "discount": 55,
      "image": "assets/image/MarathiL1.jpeg",
      "description": "Level 1",
      "pdfs": [
        {"label": "Marathi L1", "asset": "assets/pdfs/junior_subject/Marathi Book 1.8.1 Level-1.pdf"},
      ],
    },






    /// ================= SENIOR =================

    // ── Senior Subject Wise sub-products (3 items) ──

    "Senior Kg Subjectwise": {
      "name": "Senior Kg Subjectwise",
      "mrp": 749.0,
      "discount": 27,
      "image": "assets/image/seniorkgsubjectwise.jpeg",
      "description": "English 1.7.1 OR...",
      "pdfs": [
        {"label": "Maths 1.6.2",  "asset": "assets/pdfs/senior_subject/English 1.7.1.pdf"},
        {"label": "Hindi 1.6.1",    "asset": "assets/pdfs/senior_subject/HINDI 1.6.1.pdf"},
        {"label": "EVS GK",      "asset": "assets/pdfs/senior_subject/EVS GK.pdf"},
        {"label": "Math 1.6.2",  "asset": "assets/pdfs/senior_subject/Sr. KG Book MATHS 1.6.2.pdf"},

      ],
    },

    "Marathi Level 2 Book": {
      "name": "Marathi Level 2 Book",
      "mrp": 249.0,
      "discount": 27,
      "image": "assets/image/MarathiL2.jpeg",
      "description": "Level 2",
      "pdfs": [
        {"label": "Marathi L2", "asset": "assets/pdfs/senior_subject/Marathi Book 1.8.1 Level-2.pdf"},
      ],
    },

    "Marathi Level 3 Book": {
      "name": "Marathi Level 3 Book",
      "mrp": 249.0,
      "discount": 27,
      "image": "assets/image/MarathiL3.jpeg",
      "description": "Marathi Matra Book",
      "pdfs": [
        {"label": "Marathi L3", "asset": "assets/pdfs/senior_subject/Marathi Book 1.8.1 Level-3.pdf"},
      ],
    },

    // ── Senior Merged Books sub-products (2 items) ──

    "Senior Kg Merge Books": {
      "name": "Senior Kg Merge Books",
      "mrp": 949.0,
      "discount": 27,
      "image": "assets/image/seniorkgmergebook5.jpeg",
      "description": "Book No. 1\nBook No. ...",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/senior_merged/Sr. KG Book 1 1.8.2.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/senior_merged/Sr. KG Book 2 1.8.2.pdf"},
        {"label": "Book 3", "asset": "assets/pdfs/senior_merged/Sr. KG Book 3 1.8.2.pdf"},
        {"label": "Book 4", "asset": "assets/pdfs/senior_merged/Sr. KG Book 4 1.8.2.pdf"},
        {"label": "Book 5", "asset": "assets/pdfs/senior_merged/Sr. KG Book 5 1.8.2.pdf"}
      ],
    },

    "Senior Kg Level 2": {
      "name": "Senior Kg Level 2",
      "mrp": 949.0,
      "discount": 27,
      "image": "assets/image/seniorkglevel2.jpeg",
      "description": "Book No. 1\nBook No....",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/senior_merged/level2/Sr. KG Book 1 1.8.2.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/senior_merged/level2/Sr. KG Book 2 1.8.2.pdf"},
        {"label": "Book 3", "asset": "assets/pdfs/senior_merged/level2/Sr. KG Book 3 1.8.2.pdf"},
        {"label": "Book 4", "asset": "assets/pdfs/senior_merged/level2/Sr. KG Book 4 1.8.2.pdf"},
        {"label": "Book 5", "asset": "assets/pdfs/senior_merged/level2/Sr. KG Book 5 1.8.2.pdf"},
      ],
    },

    // "Senior KG Worksheet": {
    //   "name": "Senior KG Worksheet",
    //   "mrp": 299.0,
    //   "discount": 27,
    //   "image": "assets/image/sakshi.png",
    //   "description": "Senior KG worksheets",
    //   "pdfs": [
    //     {"label": "Worksheet 1", "asset": "assets/pdfs/senior_worksheet/worksheet1.pdf"},
    //     {"label": "Worksheet 2", "asset": "assets/pdfs/senior_worksheet/worksheet2.pdf"},
    //   ],
    // },


    /// ================= ENGLISH CURSIVE =================


    "English Cursive Level 1": {
      "name": "English Cursive Level 1",
      "mrp": 199.0,
      "discount": 27,
      "image": "assets/image/englishlevel1.jpeg",
      "description": "English cursive writing level 1",
      "pdfs": [
        {"label": "Cursive L1", "asset": "assets/pdfs/english_cursive_levels/English Cursive Book Level 1.pdf"},
      ],
    },
    // "English Cursive Level 1": {
    //   "name": "English Cursive Level 1",
    //   "mrp": 199.0,
    //   "discount": 27,
    //   "image": "assets/image/englishlevel1.jpeg",
    //   "description": "English cursive writing level 1",
    // },


    "English Cursive Level 2": {
      "name": "English Cursive Level 2",
      "mrp": 249.0,
      "discount": 27,
      "image": "assets/image/englishcursivelevel2.jpeg",
      "description": "English cursive writing level 2",
      "pdfs": [
        {"label": "Cursive L2", "asset": "assets/pdfs/english_cursive_levels/English Cursive Book Level 2.pdf"},
      ],
    },
    // "English Cursive Level 2": {
    //   "name": "English Cursive Level 2",
    //   "mrp": 249.0,
    //   "discount": 27,
    //   "image": "assets/image/englishcursivelevel2.jpeg",
    //   "description": "English cursive writing level 2",
    // },


    /// ================= ગુજરાતી =================


    "ગુજરાતી Nursery Book": {
      "name": "ગુજરાતી Nursery Book",
      "mrp": 199.0,
      "discount": 27,
      "image": "assets/image/gujratinursiory.jpeg",
      "description": "Marathi Nursery language book",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/gujarati/Gujrati Junior Kg Book.pdf"},
      ],
    },

    "ગુજરાતી Junior Kg Book": {
      "name": "ગુજરાતી Junior Kg Book",
      "mrp": 249.0,
      "discount": 27,
      "image": "assets/image/gujratijr.jpeg",
      "description": "Marathi Junior KG book",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/gujarati/Nursery Gujarati Book.pdf"},
      ],
    },

    // "ગુજરાતી Nursery Book": {
    //   "name": "ગુજરાતી Nursery Book",
    //   "mrp": 199.0,
    //   "discount": 27,
    //   "image": "assets/image/gujratinursiory.jpeg",
    //   "description": "Marathi Nursery language book",
    // },
    //
    // "ગુજરાતી Junior Kg Book": {
    //   "name": "ગુજરાતી Junior Kg Book",
    //   "mrp": 249.0,
    //   "discount": 27,
    //   "image": "assets/image/gujratijr.jpeg",
    //   "description": "Marathi Junior KG book",
    // },


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
      "name": "Certificate 5",
      "mrp": 80.0,
      "discount": 27,
      "image": "assets/image/Certification5.jpeg",
      "description": "Completion certificate",
    },

    "Certificate 6": {
      "name": "Certificate 6",
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
      "image": "assets/image/medals.jpg",
      "description": "Gold, Silver, Bronze medals",
    },


    /// ================= NOTEBOOK =================
    "Notebook 1": {
      "name": "Notebook 1",
      "mrp": 120.0,
      "discount": 27,
      "image": "assets/image/notebook 1.jpg",
      "description": "Student notebook",
    },

    "Notebook 2": {
      "name": "Notebook 2",
      "mrp": 140.0,
      "discount": 27,
      "image": "assets/image/note book2.jpg",
      "description": "High quality notebook",
    },

    "Notebook 3": {
      "name": "Notebook 3",
      "mrp": 160.0,
      "discount": 27,
      "image": "assets/image/notebook3.jpg",
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
      "image": "assets/image/uniform1.jpg",
      "description": "School uniform set",
    },

    "Uniform 2": {
      "name": "Uniform 2",
      "mrp": 549.0,
      "discount": 27,
      "image": "assets/image/uniform4.jpg",
      "description": "Premium school uniform",
    },

    "Uniform 3": {
      "name": "Uniform 3",
      "mrp": 549.0,
      "discount": 27,
      "image": "assets/image/uniform3.jpg",
      "description": "Premium school uniform",
    },

    "Uniform 4": {
      "name": "Uniform 4",
      "mrp": 549.0,
      "discount": 27,
      "image": "assets/image/uniform4.jpg",
      "description": "Premium school uniform",
    },

    "Uniform 5": {
      "name": "Uniform 5",
      "mrp": 549.0,
      "discount": 27,
      "image": "assets/image/uniform1.jpg",
      "description": "Premium school uniform",
    },
  };

}




