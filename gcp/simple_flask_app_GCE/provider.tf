// Configure the Google Cloud provider
provider "google" {
  credentials = file("CREDENTIALS_FILE.json")
  project     = "flask-app-310119"
  region      = "us-central1"
}
