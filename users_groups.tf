#USERS AND THEIR ACCESS KEYS
resource "aws_iam_user" "sysadmin1" {
  name = "system_administrator_1"
}

resource "aws_iam_access_key" "sysadmin-1" {
  user = aws_iam_user.sysadmin1.name
}

resource "aws_iam_user" "sysadmin2" {
  name = "system_administrator_2"
}

resource "aws_iam_access_key" "sysadmin-2" {
  user = aws_iam_user.sysadmin2.name
}

resource "aws_iam_user" "dbadmin1" {
  name = "database_administrator_1"
}

resource "aws_iam_access_key" "dbadmin-1" {
  user = aws_iam_user.dbsadmin1.name
}

resource "aws_iam_user" "dbadmin2" {
  name = "database_administrator_2"
}

resource "aws_iam_access_key" "dbadmin-2" {
  user = aws_iam_user.dbadmin2.name
}

resource "aws_iam_user" "monitoruser1" {
  name = "monitoring_user_1"
}

resource "aws_iam_access_key" "monitor-1" {
  user = aws_iam_user.monitoruser1.name
}

resource "aws_iam_user" "monitoruser2" {
  name = "monitoring_user_2"
}

resource "aws_iam_access_key" "monitor-2" {
  user = aws_iam_user.monitoruser2.name
}

resource "aws_iam_user" "monitoruser3" {
  name = "monitoring_user_3"
}

resource "aws_iam_access_key" "monitor-3" {
  user = aws_iam_user.monitoruser3.name
}

resource "aws_iam_user" "monitoruser4" {
  name = "monitoring_user_4"
}

resource "aws_iam_access_key" "monitor-4" {
  user = aws_iam_user.monitoruser4.name
}

#GROUPS/USERS_MEMBERSHIP

resource "aws_iam_group" "SysAdmin" {
  name = "system_admins"
}

resource "aws_iam_group" "DBAdmin" {
  name = "database_admins"
}

resource "aws_iam_group" "Monitor" {
  name = "monitoring_group"
}

resource "aws_iam_group_membership" "sysadmin_membership" {
  name = "membership_for_sysadmin_group"

  users = [
    aws_iam_user.sysadmin1.name,
    aws_iam_user.sysadmin2.name,
  ]

  group = aws_iam_group.SysAdmin.name
}

resource "aws_iam_group_membership" "dbadmin_membership" {

  name = "membership_for_dbadmin_group"

  users = [
    aws_iam_user.dbadmin1.name,
    aws_iam_user.dbadmin2.name,
  ]

  group = aws_iam_group.DBAdmin.name
}

resource "aws_iam_group_membership" "monitor_users_membership" {
  name = "membership_for_monitor_group"

  users = [
    aws_iam_user.monitoruser1.name,
    aws_iam_user.monitoruser2.name,
    aws_iam_user.monitoruser3.name,
    aws_iam_user.monitoruser4.name,
  ]

  group = aws_iam_group.Monitor.name
}

#PASSWD_POLICY

resource "aws_iam_account_password_policy" "passwd_policy" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  password_reuse_prevention      = 3
  max_password_age               = 90
  allow_users_to_change_password = true


}

#PROGRAMMATIC/CONSOLE ACCESS

# resource "aws_iam_user_login_profile" "console_access" { #console access
#   for_each = var.create_login_profiles

#   user    = aws_iam_user.sysadmin1.name
#   pgp_key = var.pgp_key
# }

resource "aws_iam_user_login_profile" "sys1_console_access" {
  user    = aws_iam_user.sysadmin1.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_login_profile" "sys2_console_access" {
  user    = aws_iam_user.sysadmin2.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_login_profile" "dbsys1_console_access" {
  user    = aws_iam_user.dbadmin1.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_login_profile" "dbsys2_console_access" {
  user    = aws_iam_user.dbadmin2.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_login_profile" "monitor1_console_access" {
  user    = aws_iam_user.monitoruser1.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_login_profile" "monitor2_console_access" {
  user    = aws_iam_user.monitoruser2.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_login_profile" "monitor3_console_access" {
  user    = aws_iam_user.monitoruser3.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_login_profile" "monitor4_console_access" {
  user    = aws_iam_user.monitoruser4.name
  pgp_key = var.pgp_key
}
