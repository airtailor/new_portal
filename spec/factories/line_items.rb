items = [
  "Pants",
  "Shirt",
  "Million",
  "Dress",
  "Coat / Jacket",
  "Cardigan",
  "Skirt",
  "Vest",
  "Suit Jacket",
  "Sweater",
  "Tie Slimming Service",
  "Necktie",
  #"Air Tailor Welcome Kit",
  "Million Dollar Collar — Air Tailor provides MDC"
]

# consider sample items
alterations = [
  "Sleeves Taken In",
  "Replace Jacket Zipper",
  "Line Jacket Sleeves With Fabric",
  "Replace Lining In Coat",
  "Reenforce Patch On Coat",
  "Shorten Length",
  "Sides Taken In",
  "Add Button",
  "Reshape Collar",
  "Minimize Hood",
  "Shorten Sleeve Length – From Shoulder",
  "Sides Let Out",
  "Add Hook for Cardigan",
  "Shorten Skirt Length",
  "Let Out Skirt Length",
  "Take In Waist",
  "Let Out Waist",
  "Shorten Jacket Length",
  "Shorten Sleeve Length – From Wrist",
  "Jacket Sides Taken In",
  "Jacket Sleeves Let Out",
  "Replace Lining In Jacket",
  "Replace Buttons (Please Include Buttons)",
  "Repair Pocket",
  "Remove Shoulder Pads",
  "Take Shoulders In",
  "Slim Jacket Sleeves",
  "Reshape Shoulder Pads",
  "Remove Vents From Jacket",
  "Add Double Vents To Jacket",
  "2 Inches (5.08 cm)",
  "2.25 Inches (5.72 cm)",
  "2.5 Inches (6.35 cm)",
  "2.75 Inches (6.99 cm)",
  "3 Inches (7.62 cm)",
  "3.25 Inches (8.26 cm)",
  "3.5 Inches (8.89 cm)",
  "2 Inches (5.08 cm) 4+",
  "2 Inches (5.08 cm) 8+",
  "2 Inches (5.08 cm) 12+",
  "2 Inches (5.08 cm) 16+",
  "2.25 Inches (5.72 cm) 4+",
  "2.25 Inches (5.72 cm) 8+",
  "2.25 Inches (5.72 cm) 12+",
  "2.25 Inches (5.72 cm) 16+",
  "2.5 Inches (6.35 cm) 4+",
  "2.5 Inches (6.35 cm) 8+",
  "2.5 Inches (6.35 cm) 12+",
  "2.5 Inches (6.35 cm) 16+",
  "2.75 Inches (6.99 cm) 4+",
  "2.75 Inches (6.99 cm) 8+",
  "2.75 Inches (6.99 cm) 12+",
  "2.75 Inches (6.99 cm) 16+",
  "3 Inches (7.62 cm) 4+",
  "3 Inches (7.62 cm) 8+",
  "3 Inches (7.62 cm) 12+",
  "3 Inches (7.62 cm) 16+",
  "3.25 Inches (8.26 cm) 4+",
  "3.25 Inches (8.26 cm) 8+",
  "3.25 Inches (8.26 cm) 12+",
  "3.25 Inches (8.26 cm) 16+",
  "3.5 Inches (8.89 cm) 4+",
  "3.5 Inches (8.89 cm) 8+",
  "3.5 Inches (8.89 cm) 12+",
  "3.5 Inches (8.89 cm) 16+",
  "Take in side seams",
  "Vest",
  "Repair Hole",
  "Shorten Tie Length",
  "Repair Worn Tip",
  "Narrow to 2\"",
  "Narrow to 2.25\"",
  "Narrow to 2.5\"",
  "Narrow to 3\"",
  "Narrow to 3.25\"",
  "Narrow to 3.5\"",
  "Repair",
  "Shorten Bow Tie",
  "Seat / Waistband Taken In — Jeans",
  "Seat / Waistband Taken In — Pants",
  "Seat / Waistband Taken In – Shorts",
  "Slim Pants Legs (Taper)",
  "Pants Into Shorts",
  "Shorten Pant Length - Regular Hem",
  "Shorten Pant Length - Blind Stitch Hem",
  "Shorten Pant Length - Original Hem",
  "Shorten Pant Length - Cuffed Hem",
  "Add Suspender Buttons",
  "Replace Zipper",
  "Add Seam Tape to Pants",
  "Let Out Waistband — Pants",
  "Repair Hem",
  "Put Patch On",
  "Seat Taken In — Pants",
  "Add Side Slits To Pants",
  "Let Out Pant Length",
  "Remove Belt Loops",
  "Add Rubber Grip To Inside Waist",
  "Shirt Sleeves Length Taken Up — With Cuff",
  "Shirt Sleeves Length Taken Up — Without Cuff",
  "Shirt Sleeves Taken In",
  "Shirt Sides Taken In",
  "Long Into Short Sleeve Shirt",
  "Add Pocket To T-shirt (Please Include Fabric)",
  "Shorten Shirt Length",
  "Shirt Shoulders Taken In",
  "Stiffen Collar With MDC",
  "Add Elbow Patches To Shirt",
  "Fix Shirt Hem",
  "Shorten T-Shirt Length",
  "Line T-Shirt Sleeves With Fabric",
  "Add Patch To T-Shirt",
  "Sew Tie On",
  "Secure Button",
  "Add/Replace All Buttons",
  "Shirt Cuff for Links (both sides)",
  "Fix Camisole Straps",
  "Stiffen Collar With MDC (customer provides)",
  "Move Sleeve Button",
  "Take Shirt Up From Shoulders",
  "Turn Collar into Button-down",
  "Add Darts to Back of Shirt"
]

FactoryBot.define do
  factory :line_item, class: Hash do
     id { Faker::Number.number(10) }
     variant_id { Faker::Number.number(11) }

     sequence(:title) do |n|
      item = items.sample
      "#{item} ##{n}"
     end

     quantity { 1 }
     price { Faker::Commerce.price }
     grams { Faker::Number.number(4) }
     variant_title { "#{title.split(" ")[0]} #{alterations.sample}" }
     skip_create
     initialize_with { attributes }
  end

  factory :line_item_with_random_quantity, class: Hash, parent: :line_item do
     quantity { Faker::Number.number(1) }
     skip_create
     initialize_with { attributes }
  end
end
