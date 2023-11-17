alias SpaceGoods.Repo
alias SpaceGoods.Products.Product
alias SpaceGoods.ImageProcessor

products = [
  %{
    name: "Orion Exploration Suit",
    description: "Designed for lunar exploration missions, offers mobility and protection.",
    price: "25000.00",
    rating: 4.7,
    category: "Space Suits",
    image_url: "/images/orion_exploration_suit.jpg"
  },
  %{
    name: "Martian EVA Suit",
    description: "Engineered for Mars exploration, equipped with advanced life support.",
    price: "35000.00",
    rating: 4.9,
    category: "Space Suits",
    image_url: "/images/martian_eva_suit.jpg"
  },
  %{
    name: "Astronaut Training Suit",
    description: "Perfect for astronaut training sessions, durable and comfortable.",
    price: "15000.00",
    rating: 4.5,
    category: "Space Suits",
    image_url: "/images/astronaut_training_suit.jpg"
  },
  %{
    name: "Lunar Lunch Pack",
    description: "A variety of nutritious and delicious meals prepared for lunar missions.",
    price: "100.00",
    rating: 4.3,
    category: "Space Food",
    image_url: "/images/lunar_lunch_pack.jpg"
  },
  %{
    name: "Martian Meal Kit",
    description: "Specially formulated meals for Mars missions, rich in essential nutrients.",
    price: "120.00",
    rating: 4.6,
    category: "Space Food",
    image_url: "/images/martian_meal_kit.jpg"
  },
  %{
    name: "Astro Snack Box",
    description: "A selection of tasty and healthy snacks for astronauts on the go.",
    price: "50.00",
    rating: 4.2,
    category: "Space Food",
    image_url: "/images/astro_snack_box.jpg"
  },
  %{
    name: "Lunar Boots",
    description: "Highly durable boots designed for walking on the lunar surface.",
    price: "2000.00",
    rating: 4.8,
    category: "Space Gear",
    image_url: "/images/lunar_boots.jpg"
  },
  %{
    name: "Martian Helmet",
    description: "Advanced helmet with integrated communication and HUD for Mars exploration.",
    price: "5000.00",
    rating: 5.0,
    category: "Space Gear",
    image_url: "/images/martian_helmet.jpg"
  },
  %{
    name: "Zero-G Gloves",
    description:
      "Gloves designed for optimal dexterity and protection in zero gravity environments.",
    price: "1500.00",
    rating: 4.7,
    category: "Space Gear",
    image_url: "/images/zero_g_gloves.jpg"
  },
  %{
    name: "Lunar Rover",
    description: "A versatile rover designed for transportation and exploration on the Moon.",
    price: "75000.00",
    rating: 4.9,
    category: "Space Tech",
    image_url: "/images/lunar_rover.jpg"
  },
  %{
    name: "Martian Drone",
    description: "A high-tech drone for aerial exploration and surveying of Mars.",
    price: "30000.00",
    rating: 4.8,
    category: "Space Tech",
    image_url: "/images/martian_drone.jpg"
  },
  %{
    name: "Satellite Kit",
    description: "A DIY kit for building and launching your own satellite.",
    price: "40400.00",
    rating: 4.6,
    category: "Space Tech",
    image_url: "/images/satellite_kit.jpg"
  },
  %{
    name: "Lunar Landscape Poster",
    description: "A high-quality poster featuring the stunning landscapes of the Moon.",
    price: "30.00",
    rating: 4.5,
    category: "Space Decor",
    image_url: "/images/lunar_landscape_poster.jpg"
  },
  %{
    name: "Martian Surface Canvas",
    description: "A beautiful canvas print showcasing the red landscapes of Mars.",
    price: "60.00",
    rating: 4.7,
    category: "Space Decor",
    image_url: "/images/martian_surface_canvas.jpg"
  },
  %{
    name: "Galaxy Wall Mural",
    description: "Transform your room with this breathtaking galaxy wall mural.",
    price: "120.00",
    rating: 4.9,
    category: "Space Decor",
    image_url: "/images/galaxy_wall_mural.jpg"
  },
  %{
    name: "Moon Exploration Guide",
    description: "A comprehensive guide to exploring the Moon, featuring maps and tips.",
    price: "25.00",
    rating: 4.6,
    category: "Space Literature",
    image_url: "/images/moon_exploration_guide.jpg"
  },
  %{
    name: "Mars Colonization Handbook",
    description: "A handbook detailing the essentials of colonizing Mars.",
    price: "35.00",
    rating: 4.8,
    category: "Space Literature",
    image_url: "/images/mars_colonization_handbook.jpg"
  },
  %{
    name: "Galactic Encyclopedia",
    description: "An encyclopedia covering the wonders of our galaxy.",
    price: "50.00",
    rating: 5.0,
    category: "Space Literature",
    image_url: "/images/galactic_encyclopedia.jpg"
  },
  %{
    name: "Rocket Science Handbook",
    description: "A comprehensive handbook on rocket science and space engineering.",
    price: "40.00",
    rating: 4.9,
    category: "Space Literature",
    image_url: "/images/rocket_science_handbook.jpg"
  },
  %{
    name: "Space Suit Replica",
    description: "A detailed replica of a space suit, great for display or costume.",
    price: "700.00",
    rating: 4.8,
    category: "Space Suits",
    image_url: "/images/space_suit_replica.jpg"
  },
  %{
    name: "Meteorite Fragment",
    description: "A fragment of a meteorite, a unique and rare collectible.",
    price: "300.00",
    rating: 5.0,
    category: "Space Decor",
    image_url: "/images/meteorite_fragment.jpg"
  },
  %{
    name: "Alien Life Encyclopedia",
    description: "An encyclopedia exploring the possibilities of extraterrestrial life.",
    price: "55.00",
    rating: 4.6,
    category: "Space Literature",
    image_url: "/images/alien_life_encyclopedia.jpg"
  },
  %{
    name: "Space Exploration VR Kit",
    description: "A virtual reality kit for experiencing space exploration.",
    price: "250.00",
    rating: 4.7,
    category: "Space Tech",
    image_url: "/images/space_exploration_vr_kit.jpg"
  },
  %{
    name: "Galactic Map Poster",
    description: "A detailed map of our galaxy, perfect for education and decoration.",
    price: "35.00",
    rating: 4.9,
    category: "Space Decor",
    image_url: "/images/galactic_map_poster.jpg"
  },
  %{
    name: "Interstellar Travel Guide",
    description: "A speculative guide on interstellar travel and exploration.",
    price: "40.00",
    rating: 4.8,
    category: "Space Literature",
    image_url: "/images/interstellar_travel_guide.jpg"
  },
  %{
    name: "Space Station Model",
    description: "A detailed model of an international space station.",
    price: "110.00",
    rating: 4.9,
    category: "Space Decor",
    image_url: "/images/space_station_model.jpg"
  }
]

Enum.each(products, fn product ->
  # Resize the image before inserting the product
  image_name = product.image_url |> String.split("/") |> List.last()
  ImageProcessor.resize_image(image_name)
end)

Enum.each(products, fn product ->
  %Product{}
  |> Product.changeset(product)
  |> Repo.insert!()
end)
