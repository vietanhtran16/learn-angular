resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.user_pool_name}"
}

resource "aws_cognito_identity_provider" "google_provider" {
  user_pool_id  = "${aws_cognito_user_pool.user_pool.id}"
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "email"
    client_id        = "97383913215-882plu1flh2hiecnat0onphi0bs952mp.apps.googleusercontent.com"
    client_secret    = "UefT2k4EQA0vVOOWzjuOJQo-"
  }
}