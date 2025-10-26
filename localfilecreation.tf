resource "local_file" "file" {
  filename = "file.txt"
  content = "Hi Rushikesh, this file is created using terraform"
}