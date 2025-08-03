import 'dart:io';

//alignment and colors of UI
const String reset = '\x1B[0m';
const String green = '\x1B[32m';
const String red = '\x1B[31m';
const String yellow = '\x1B[33m';
const String cyan = '\x1B[36m';
const String bold = '\x1B[1m';

Map<String, String> roles = {
  '1': 'UI Design',
  '2': 'API Development',
  '3': 'Database Setup',
  '4': 'System Development',
  '5': 'Testing',
};

void main() {
  print("\n$cyan╔════════════════════════════════════════════════════════╗");
  print(
    "            ${bold}Welcome to Team Role Assignment$reset$cyan          ",
  );

  print("╚════════════════════════════════════════════════════════╝$reset");
  int teamSize = getTeamSize();
  List<String> teamMembers = getTeamMembers(teamSize);
  Map<String, List<String>> assignments = assignRoles(teamMembers);
  showMenu(teamMembers, assignments);
}

List<String> getTeamMembers(int teamSize) {
  List<String> members = [];
  for (int i = 1; i <= teamSize; i++) {
    stdout.write("$yellow Enter name for team member #$i: $reset");
    String? name = stdin.readLineSync();
    if (name != null && name.trim().isNotEmpty) {
      members.add(name.trim());
    } else {
      print("$red Invalid name. Please try again.$reset");
      i--;
    }
  }
  return members;
}

int getTeamSize() {
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
  return size;
}

// Assign roles to team members in round-robin fashion using roles map keys
Map<String, List<String>> assignRoles(List<String> teamMembers) {
  Map<String, List<String>> assignments = {};
  List<String> roleKeys = roles.keys.toList();
  for (int i = 0; i < teamMembers.length; i++) {
    assignments[teamMembers[i]] = [];
  }
  for (int i = 0; i < roleKeys.length; i++) {
    String member = teamMembers[i % teamMembers.length];
    String role = roles[roleKeys[i]]!;
    assignments[member]?.add(role);
  }
  return assignments;
}

void showMenu(List<String> teamMembers, Map<String, List<String>> assignments) {
  while (true) {
    print("\n$bold$cyan Menu:$reset");
    print("  1. View Team Members");
    print("  2. View Roles");
    print("  3. Assign Roles");
    print("  4. View Role Assignments");
    print("  5. Exit");
    stdout.write("$yellow Select an option (1-5): $reset");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print("\n$bold$yellow Team Members:$reset");
        for (var member in teamMembers) {
          print("  $green$member$reset");
        }
        break;
      case '2':
        print("\n$bold$yellow Roles:$reset");
        roles.forEach((key, value) {
          print("  $cyan$key. $value$reset");
        });
        break;
      case '3':
        assignments = assignRoles(teamMembers);
        var newAssignments = assignRoles(teamMembers);
        assignments.addAll(newAssignments);
        print("$green Roles have been reassigned!$reset");
        break;
      case '4':
        viewAssignedRoles(teamMembers, assignments);
        break;
      case '5':
        print("$red Exiting...$reset");
        return;
      default:
        print("$red Invalid option. Please try again.$reset");
    }
  }
}

// View assigned roles with descriptions
void viewAssignedRoles(
  List<String> teamMembers,
  Map<String, List<String>> assignments,
) {
  print("\n$bold$yellow Assigned Roles:$reset");
  for (var member in teamMembers) {
    print("$green$member:$reset");
    for (var role in assignments[member] ?? []) {
      String desc = '';
      if (role == 'UI Design') {
        desc = 'Designs the user interface and user experience.';
      } else if (role == 'API Development') {
        desc = 'Develops and maintains the application programming interface.';
      } else if (role == 'Database Setup') {
        desc = 'Sets up and manages the database.';
      } else if (role == 'System Development') {
        desc = 'Implements core system functionalities.';
      } else if (role == 'Testing') {
        desc = 'Tests the system for bugs and issues.';
      }
      print("  $cyan- $role:$reset $desc");
    }
  }
}
