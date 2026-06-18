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
      "mrp": 1649.0,
      "discount": 55,
      "image": "assets/image/PlayGroup.jpeg",
      "description": "Complete PlayGroup merged books set",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/playgroup_merged/Play_group_book1.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/playgroup_merged/Play_group_book2.pdf"},
        {"label": "Book 3", "asset": "assets/pdfs/playgroup_merged/Play_group_book1.pdf"},// missing pdf Playgorup book 3
        {"label": "Book 4", "asset": "assets/pdfs/playgroup_merged/Play_group_book2.pdf"},// mkssing pdf playgoup book 4
      ],
    },

    "PlayGroup Subject Wise": {
      "name": "PlayGroup Subject Wise",
      "mrp": 1649.0,
      "discount": 55,
      "image": "assets/image/PlayGroup.jpeg",
      "description": "PlayGroup subject wise books set\n"
          "English \n"
          "Maths\n"
          "EVS\n"
          "Art & Craft , Rhymes\n",
      "pdfs": [
        {"label": "English",  "asset": "assets/pdfs/playgroup_subject/PG English 1.8.1.pdf"},
        {"label": "Maths",    "asset": "assets/pdfs/playgroup_subject/PG Maths 1.8.1.pdf"},
        {"label": "EVS",      "asset": "assets/pdfs/playgroup_subject/PG EVS 1.8.1.pdf"},
        {"label": "Rhymes & Stories ", "asset": "assets/pdfs/playgroup_subject/PG EVS 1.8.1.pdf"},// missing pdf
      ],
    },


    /// ================= NURSERY =================

    "Nursery Merged Books": {
      "name": "Nursery Merged Books",
      "mrp": 1749.0,
      "discount": 51,
      "image": "assets/image/Nursery.jpeg",
      "description": "Book No.1\n"
          "Book No.2\n"
          "Book No.3\n"
          "Book No.4\n"
          "Book No.5\n"
          "Note : Maths 1-50 Number Also Available if Required\n",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/nursery_merged/Nursery Book 1.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/nursery_merged/Nursery Book 2.pdf"},
        {"label": "Book 3", "asset": "assets/pdfs/nursery_merged/Nursery Book 3.pdf"},
        {"label": "Book 4", "asset": "assets/pdfs/nursery_merged/Nursery Book 4.pdf"},
        {"label": "Book 5", "asset": "assets/pdfs/nursery_merged/Nursery Book 5.pdf"},


      ],
    },

    // ── Nursery Subject Wise sub-products (4 items) ──


    /// All pdf missing Nursory Subject WISE


    "Nursery Subjectwise Books": {
      "name": "Nursery Subjectwise Books",
      "mrp": 1749.0,
      "discount": 54,
      "image": "assets/image/Nursery.jpeg",
      "description": "English- LTI PATTERN\n "
                     "OR\n"
                     "English - ABCD Pattern\n"
                     "Mathematics\n"
                      "EVS\n"
                      "Art & Craft Without Hindi Content 1.8.1\n"
                      "Art & Craft ,Rhymes & Drawing Books\n"
                      "Notes : Maths 1-50 Number Also Available if Required\n",

      "pdfs": [
        {"label": "Maths",  "asset": "assets/pdfs/nursery_subject/nursery_subjectwise_Book_LTI_Pattern/Nursery MATHS 1.6.1.pdf"},
        {"label": "EVS",    "asset": "assets/pdfs/nursery_subject/nursery_subjectwise_Book_LTI_Pattern/Nursery EVS Book 1.7.1.pdf"},
        {"label": "Art & Craft ,Rhymes , Story",      "asset": "assets/pdfs/nursery_subject/nursery_subjectwise_Book_LTI_Pattern/Nursery Art And Craft, Story, Rhymes, Drawing Book 1.7.1.pdf"},
        {"label": "English LTI",  "asset": "assets/pdfs/nursery_subject/nursery_subjectwise_Book_LTI_Pattern/Nursery English LTI 1.8.1.pdf"},
        {"label": "English ABCD Pattern",    "asset": "assets/pdfs/nursery_subject/nursery_subjectwise_Book_LTI_Pattern/Nursery English ABCD 1.8.1.pdf"},
        {"label": "Art & Craft Without Hindi Content 1.8.1",      "asset": "assets/pdfs/nursery_subject/evs.pdf"},///misiing pdf
      ],
    },

    "Nursery Hindi Reading Book": {
      "name": "हिंदी",
      "mrp": 299.0,
      "discount": 50,
      "image": "assets/image/Nursery.jpeg",
      "description": "Reading Book",
      "pdfs": [
        {"label": "Hindi Reading", "asset": "assets/pdfs/nursery_subject/hindi/Nursery Hindi Book 1.6.1.pdf"},
      ],
    },

    "Nursery Hindi L-1": {
      "name": "Nursery Hindi L-1",
      "mrp": 311.0,
      "discount": 52,
      "image": "assets/image/nursoryhindil1.jpeg",
      "description": "Writing Book",
      "pdfs": [
        {"label": "Hindi Writing", "asset": "assets/pdfs/nursery_subject/nursery_hindi L1/Jr. KG Book Hindi 1.6.1 Level 1.pdf"},
      ],
    },

    "Nursery Drawing Book": {
      "name": "Drawing Book (Optional)",
      "mrp": 329.0,
      "discount": 55,
      "image": "assets/image/sakshi.png",
      "description": "Optional - No Quantity Restriction\n"
                     "You can Use it for any class\n",
      "pdfs": [
        {"label": "Nursery Drawing Book", "asset": "assets/pdfs/nursery_subject/Drawing_Book(Optional)/Nursery Drawing Book 1.7.1.pdf"},
      ],
    },


    /// ================= JUNIOR =================

    "Junior Merged Books": {
      "name": "Junior Merged Books",
      "mrp": 1949.0,
      "discount": 54,
      "image": "assets/image/JuniorKgEnglish.jpeg",
      "description": "Book No. 1\n"
                     "Book No. 2\n"
                     "Book No. 3\n"
                     "Book No. 4\n"
                     "Book No. 5\n"
                     "OR\n"
                     "Note : Extra Content if required \n"
                     "Level 2\n"
                     "Book Also Available\n"
                     "क से ज्ञ  तक \n"
                     "Number 51 -100\n",
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
      "mrp": 1949.0,
      "discount": 54,
      "image": "assets/image/JuniorKgEnglish.jpeg",
      "description":
      "English\n"
      "हिंदी 1.6.1\n"
      "OR\n"
      "हिंदी 1.6.2\n"
      "Maths\n"
      "EVS\n"
      "OR\n"
      "EVS 1.8.1\n"
      "Art & Craft,Poems & Stories\n"
      "Art & Craft Without Hindi Content 1.8.1\n"
      ,
      "pdfs": [
        {"label": "English",  "asset": "assets/pdfs/junior_subject/Jr KG Book English 1.7.1.pdf"},
        {"label": "Maths 1.6.2",    "asset": "assets/pdfs/junior_subject/Jr. KG Book MATHS 1.6.2.pdf"},
        {"label": "EVS",      "asset": "assets/pdfs/junior_subject/Jr. KG  EVS 1.7.1.pdf"},
        {"label": "Hindi 1.6.1",    "asset": "assets/pdfs/junior_subject/Jr. KG Book Hindi 1.6.1 Level 1.pdf"},
        {"label": " Art & Craft,Story & Rhymes",      "asset": "assets/pdfs/junior_subject/Jr. KG Book Story & Activities 1.7.1.pdf"},//missing pdf
        {"label": " Art & Craft Without Hindi Content 1.8.1",      "asset": "assets/pdfs/junior_subject/Jr. KG Book Story & Activities 1.7.1.pdf"},//missing pdf
        {"label": "Maths 1.7.2",    "asset": "assets/pdfs/junior_subject/Jr. KG Book MATHS 1.6.2.pdf"}, ///missing pdf
        {"label": "Hindi 1.6.2",    "asset": "assets/pdfs/junior_subject/Jr. KG Book Hindi 1.6.2 Level 2.pdf"},///missing pdf
        {"label": "EVS 1.8.1",      "asset": "assets/pdfs/junior_subject/Jr. KG  EVS 1.7.1.pdf"},///missing pdf
      ],
    },

    "Marathi Level 1 Book": {
      "name": "Marathi Level 1 Book",
      "mrp": 399.0,
      "discount": 55,     
      "image": "assets/image/marathijrl1.jpeg",
      "description": "Level 1",
      "pdfs": [
        {"label": "Marathi L1", "asset": "assets/pdfs/junior_subject/Marathi Book 1.8.1 Level-1.pdf"},
      ],
    },


    /// all pdf mising
    "Junior Kg Merge अ से ज्ञ": {
      "name": "Junior Kg Merge अ से ज्ञ",
      "mrp": 1949.0,
      "discount": 54,
      "image": "assets/image/MarathiL1.jpeg",
      "description":
          "Level 2 Books\n"
          "Book No.1\n"
          "Book No.2\n"
          "Book No.3\n"
          "Book No.4\n"
          "Book No.5\n"

      ,
      "pdfs": [
        {"label": "Book No.1", "asset": "assets/pdfs/junior_subject/Marathi Book 1.8.1 Level-1.pdf"},///missing pdf
        {"label": "Book No.2", "asset": "assets/pdfs/junior_subject/Marathi Book 1.8.1 Level-1.pdf"},///missing pdf
        {"label": "Book No.3", "asset": "assets/pdfs/junior_subject/Marathi Book 1.8.1 Level-1.pdf"},///missing pdf
        {"label": "Book No.4", "asset": "assets/pdfs/junior_subject/Marathi Book 1.8.1 Level-1.pdf"},///missing pdf
        {"label": "Book No.5", "asset": "assets/pdfs/junior_subject/Marathi Book 1.8.1 Level-1.pdf"},///missing pdf
      ],
    },




    /// ================= SENIOR =================

    // ── Senior Subject Wise sub-products (3 items) ──

    "Senior Kg Subjectwise": {
      "name": "Senior Kg Subjectwise",
      "mrp": 1999.0,
      "discount": 53,
      "image": "assets/image/seniorkgsubjectwise.jpeg",
      "description": "English 1.7.1\n"
      "OR\n"
      "English 1.8.1\n"
      "हिंदी 1.6.1\n"
      "Or\n"
      "हिंदी मात्रा 1.6.2\n"
      "Maths\n"
      "EVS\n"
      "Art & Craft,Poems & Stories\n"
      "Or\n"
      "Art & Craft without Hindi Content 1.8.1\n",
      "pdfs": [
        {"label": "Math 1.6.2",  "asset": "assets/pdfs/senior_subject/Sr. KG Book MATHS 1.6.2.pdf"},
        {"label": "English 1.7.1",  "asset": "assets/pdfs/senior_subject/English 1.7.1.pdf"},
        {"label": "हिंदी 1.6.1", "asset": "assets/pdfs/senior_subject/HINDI 1.6.1.pdf"},
        {"label": "EVS GK",      "asset": "assets/pdfs/senior_subject/EVS GK.pdf"},

        {"label": "Art & Craft ,Stories and Rhymes 1.6.2",  "asset": "assets/pdfs/senior_subject/Sr. KG Book MATHS 1.6.2.pdf"},/// missing pdfs
        {"label": "हिंदी मात्रा 1.6.2",  "asset": "assets/pdfs/senior_subject/Sr. KG Book MATHS 1.6.2.pdf"},///missing
        {"label": "English 1.8.1",  "asset": "assets/pdfs/senior_subject/Sr. KG Book MATHS 1.6.2.pdf"},///mising pdf
        {"label": "Art and Craft Without Hindi Content 1.8.1",  "asset": "assets/pdfs/senior_subject/Sr. KG Book MATHS 1.6.2.pdf"},/// missing pdf

      ],
    },

    "Marathi Level 2 Book": {
      "name": "Marathi Level 2 Book",
      "mrp": 399.0,
      "discount": 53,
      "image": "assets/image/MarathiL2.jpeg",
      "description": "Level 2",
      "pdfs": [
        {"label": "Marathi L2", "asset": "assets/pdfs/senior_subject/Marathi Book 1.8.1 Level-2.pdf"},
      ],
    },

    "Marathi Level 3 Book": {
      "name": "Marathi Level 3 Book",
      "mrp": 399.0,
      "discount": 53,
      "image": "assets/image/MarathiL3.jpeg",
      "description": "Marathi Matra Book",
      "pdfs": [
        {"label": "Marathi L3", "asset": "assets/pdfs/senior_subject/Marathi Book 1.8.1 Level-3.pdf"},
      ],
    },

    // ── Senior Merged Books sub-products (2 items) ──

    "Senior Kg Merge Books": {
      "name": "Senior Kg Merge Books",
      "mrp": 1999.0,
      "discount": 53,
      "image": "assets/image/seniorkgmergebook5.jpeg",
      "description": "Book No. 1\n"
          "Book No. 2\n"
          "Book No. 3\n"
          "Book No. 4\n"
          "Book No. 5\n",
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
      "mrp": 1999.0,
      "discount": 53,
      "image": "assets/image/seniorkglevel2.jpeg",
      "description":
              "Book No. 1\n"
              "Book No. 2\n"
              "Book No. 3\n"
              "Book No. 4\n"
              "Book No. 5\n"
      ,
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/senior_merged/level2/Sr. KG Book 1 1.8.2.pdf"},
        {"label": "Book 2", "asset": "assets/pdfs/senior_merged/level2/Sr. KG Book 2 1.8.2.pdf"},
        {"label": "Book 3", "asset": "assets/pdfs/senior_merged/level2/Sr. KG Book 3 1.8.2.pdf"},
        {"label": "Book 4", "asset": "assets/pdfs/senior_merged/level2/Sr. KG Book 4 1.8.2.pdf"},
        {"label": "Book 5", "asset": "assets/pdfs/senior_merged/level2/Sr. KG Book 5 1.8.2.pdf"},
      ],
    },



    /// ================= ENGLISH CURSIVE =================


    "English Cursive Level 1": {
      "name": "English Cursive Level 1",
      "mrp": 299.0,
      "discount": 54,
      "image": "assets/image/englishlevel1.jpeg",
      "description": "English cursive writing level 1",
      "pdfs": [
        {"label": "Cursive L1", "asset": "assets/pdfs/english_cursive_levels/English Cursive Book Level 1.pdf"},
      ],
    },


    "English Cursive Level 2": {
      "name": "English Cursive Level 2",
      "mrp": 299.0,
      "discount": 54,
      "image": "assets/image/englishcursivelevel2.jpeg",
      "description": "English cursive writing level 2",
      "pdfs": [
        {"label": "Cursive L2", "asset": "assets/pdfs/english_cursive_levels/English Cursive Book Level 2.pdf"},
      ],
    },



    /// ================= ગુજરાતી =================


    "ગુજરાતી Nursery Book": {
      "name": "ગુજરાતી Nursery Book",
      "mrp": 279.0,
      "discount": 39,
      "image": "assets/image/gujratinursiory.jpeg",
      "description": "No Quantity Restrictions",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/gujarati/Gujrati Junior Kg Book.pdf"},
      ],
    },

    "ગુજરાતી Junior Kg Book": {
      "name": "ગુજરાતી Junior Kg Book",
      "mrp": 289.0,
      "discount": 38,
      "image": "assets/image/gujratijr.jpeg",
      "description": "No Quantity Restrictions",
      "pdfs": [
        {"label": "Book 1", "asset": "assets/pdfs/gujarati/Nursery Gujarati Book.pdf"},
      ],
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




