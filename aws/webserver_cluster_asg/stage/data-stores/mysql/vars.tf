# Variable if choose to manage password outside of TF.
# Notice no default, db password or any sensitive data should not be stored in plain text.
# Will have to pass in arg by env variable;
#  export TF_VAR_db_password="(<YOUR_DB_PASSWORD>)"
# ***intentional space in beginning of export....to not store the password on disk in Bash History.
variable "db_password" {
    description = "The password for the database"
    type        = string
}


variable "db_name" {
    description = "The name for the database"
    type        = string
    default     = "example_mysql_db"
}
