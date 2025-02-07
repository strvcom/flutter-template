import 'package:project_setup/configuration.dart';
import 'package:project_setup/core/util/files.dart';
import 'package:project_setup/core/util/print.dart';
import 'package:project_setup/core/util/util.dart';

// Define lists of directories and files to exclude
Future<void> appRename() async {
  printBoldCyan('Rebranding the App...');

  // Title: Step 1 - Recursively go trough all directories and replace application name string
  if (Configuration.renameOldAppName != Configuration.renameNewAppName) {
    printBoldYellow('Replacing App Name');
    await findAndReplaceTextInDirectory(
      directoryPath: getProjectRootDirectoryPath(),
      searchString: Configuration.renameOldAppName,
      replaceString: Configuration.renameNewAppName,
      excludedDirs: ['build', 'project_setup', '.git'],
      includedFiles: Configuration.renameAppNameIncludedFiles,
    );
  }

  // Title: Step 2 - Recursively go trough all directories and replace package name string
  if (Configuration.renameOldPackageName != Configuration.renameNewPackageName) {
    printBoldYellow('Replacing Package Name');
    await findAndReplaceTextInDirectory(
      directoryPath: getProjectRootDirectoryPath(),
      searchString: Configuration.renameOldPackageName,
      replaceString: Configuration.renameNewPackageName,
      excludedDirs: ['build', 'project_setup', '.git'],
      includedFiles: Configuration.renamePackageNameIncludedFiles,
    );

    printBoldYellow('Renaming Android Directories');
    await findAndReplaceDirectoryPath(
      directoryPath: getProjectRootDirectoryPath() + '/android',
      oldStructure: Configuration.renameOldPackageName.replaceAll('.', '/'),
      newStructure: Configuration.renameNewPackageName.replaceAll('.', '/'),
      excludedDirs: ['build', 'project_setup', '.git'],
    );
  }

  // Finish
  printBoldGreen('✅ App rebranding successful!');
}
