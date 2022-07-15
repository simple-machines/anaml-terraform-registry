resource "anaml-operations_user" "test_user" {
  name       = "Test User"
  email      = "anamltestuser@simplemachines.com.au"
  given_name = "Test"
  surname    = "User"
  password   = "hunter23"
  roles      = ["author"]
}

resource "anaml-operations_user" "genevieve_steele" {
  name       = "Genevieve Steele"
  email      = "genevieve_steele@example.com"
  given_name = "Genevieve"
  surname    = "Steele"
  password   = "hunter23"
  roles      = ["author"]
}

resource "anaml-operations_user" "sonny_bowman" {
  name       = "Sonny Bowman"
  email      = "sonny_bowman@example.com"
  given_name = "Sonny"
  surname    = "Bowman"
  password   = "hunter23"
  roles      = ["super_user"]
}

resource "anaml-operations_user" "shawn_bloodworth" {
  name       = "Shawn Bloodworth"
  email      = "shawn_bloodworth@example.com"
  given_name = "Shawn"
  surname    = "Bloodworth"
  password   = "hunter23"
  roles      = ["author", "admin_system"]
}

resource "anaml-operations_user" "gideon_york" {
  name       = "Gideon York"
  email      = "gideon_york@example.com"
  given_name = "Gideon"
  surname    = "York"
  password   = "hunter23"
  roles      = []
}

resource "anaml-operations_user" "jacob_carlisle" {
  name       = "Jacob Carlisle"
  email      = "jacob_carlisle@example.com"
  given_name = "Jacob"
  surname    = "Carlisle"
  password   = "hunter23"
  roles      = ["author"]
}

resource "anaml-operations_user" "freddie_strong" {
  name       = "Freddie Strong"
  email      = "freddie_strong@example.com"
  given_name = "Freddie"
  surname    = "Strong"
  password   = "hunter23"
  roles      = ["author"]
}
