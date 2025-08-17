import 'dart:io';

// ANSI color codes for UI
const String reset = '\x1B[0m';
const String green = '\x1B[32m';
const String red = '\x1B[31m';
const String yellow = '\x1B[33m';
const String cyan = '\x1B[36m';
const String bold = '\x1B[1m';

// Role class
class Role {
  String title;
  String description;
  Role(this.title, this.description);
}

// TeamMember class
class TeamMember {
  String name;
  List<Role> roles = [];
  TeamMember(this.name);

  void addRole(Role role) {
    roles.add(role);
  }

  void displayRoles() {
    if (roles.isEmpty) {
      print("  $yellow No roles assigned.$reset");
    } else {
      for (var role in roles) {
        print("  $cyan- ${role.title}:$reset ${role.description}");
      }
    }
  }
}

// Generic StorageBox
class StorageBox<T> {
  T? data;
  void store(T item) {
    data = item;
  }

  T? retrieve() {
    return data;
  }
}

// Global variables
List<TeamMember> teamMembers = [];
List<Role> roles = [
  Role('UI Design', 'Designs the user interface and user experience.'),
  Role(
    'API Development',
    'Develops and maintains the application programming interface.',
  ),
  Role('Database Setup', 'Sets up and manages the database.'),
  Role('System Development', 'Implements core system functionalities.'),
  Role('Testing', 'Tests the system for bugs and issues.'),
];
var lastAssigned = StorageBox<String>();

void main() {
  print("\n$cyan╔════════════════════════════════════════════════════════╗");
  print(
    "            ${bold}Welcome to Team Role Assignment$reset$cyan          ",
  );

  print("╚════════════════════════════════════════════════════════╝$reset");
  inputTeamMembers();
  showMenu();
}

void inputTeamMembers() {
  teamMembers.clear();
  int? size;
  while (size == null || size < 3 || size > 5) {
    stdout.write("$cyan Enter the number of team members (3 to 5): $reset");
    String? input = stdin.readLineSync();
    if (input != null && int.tryParse(input) != null) {
      size = int.parse(input);
    } else {
      print("$red Invalid input. Please enter a number between 3 and 5.$reset");
    }
  }
  for (int i = 1; i <= size; i++) {
    while (true) {
      stdout.write("$yellow Enter name for team member #$i: $reset");
      String? name = stdin.readLineSync();
      if (name != null && name.trim().isNotEmpty) {
        teamMembers.add(TeamMember(name.trim()));
        break;
      } else {
        print("$red Invalid name. Please try again.$reset");
      }
    }
  }
}

void viewTeamMembers() {
  print("\n$bold$yellow Team Members:$reset");
  for (var member in teamMembers) {
    print("  $green${member.name}$reset");
  }
}

void viewRoles() {
  print("\n$bold$yellow Roles:$reset");
  for (int i = 0; i < roles.length; i++) {
    print("  $cyan${i + 1}. ${roles[i].title}$reset - ${roles[i].description}");
  }
}

void assignRoles() {
  // Clear previous assignments
  for (var member in teamMembers) {
    member.roles.clear();
  }
  for (int i = 0; i < roles.length; i++) {
    var member = teamMembers[i % teamMembers.length];
    member.addRole(roles[i]);
  }
  print("$green Roles have been assigned in round-robin fashion!$reset");
}

void viewAssignments() {
  print("\n$bold$yellow Assigned Roles:$reset");
  for (var member in teamMembers) {
    print("$green${member.name}:$reset");
    member.displayRoles();
  }
}

void viewStorageBox() {
  print("\n$bold$yellow Last Assignment Stored:$reset");
  // Find the last role assigned and the member who got it
  if (teamMembers.isEmpty || roles.isEmpty) {
    print("$yellow No assignments available.$reset");
    return;
  }
  // Find the last role assigned (last in roles list)
  Role lastRole = roles.last;
  // Find which member got the last role (round-robin logic)
  TeamMember lastMember = teamMembers[(roles.length - 1) % teamMembers.length];
  String assignment = "${lastMember.name} was assigned with '${lastRole.title}'";
  lastAssigned.store(assignment);

  if (lastAssigned.data != null) {
    print("$green${lastAssigned.data}$reset");
  } else {
    print("$yellow No last assignment stored.$reset");
  }
}

void showMenu() {
  while (true) {
    print("\n$bold$cyan=== Scrum Logic Menu ===$reset");
    print("  1. View Team Members");
    print("  2. View Roles");
    print("  3. Assign Roles");
    print("  4. View Role Assignments");
    print("  5. View Last Role Assigned");
    print("  6. Exit");
    stdout.write("$yellow Select an option (1-6): $reset");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        viewTeamMembers();
        break;
      case '2':
        viewRoles();
        break;
      case '3':
        assignRoles();
        break;
      case '4':
        viewAssignments();
        break;
      case '5':
        viewStorageBox();
        break;
      case '6':
        print("$red Exiting...$reset");
        return;
      default:
        print("$red Invalid option. Please try again.$reset");
    }
  }
}
