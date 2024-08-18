

/*
void _showEditBinDialog(TrashBin bin) {
  TextEditingController nameController = TextEditingController(text: bin.name);
  String updatedCategory = bin.category;
  String updatedGroup = bin.groupName;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.color3, // Background color set to color3
        title: const Text(
          'Edit Bin',
          style: TextStyle(color: AppColors.color1), // Title color set to color1
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Bin Name',
                labelStyle: TextStyle(color: AppColors.color1), // Label color
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.color1), // Line color
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.color1), // Focused line color
                ),
              ),
              style: const TextStyle(color: AppColors.color4), // Text color
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: updatedCategory,
              onChanged: (value) {
                setState(() {
                  updatedCategory = value!;
                });
              },
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    category,
                    style: const TextStyle(color: AppColors.color4), // Dropdown item text color
                  ),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: AppColors.color1), // Label color
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.color1), // Line color
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.color1), // Focused line color
                ),
              ),
              dropdownColor: AppColors.color3, // Dropdown background color
              iconEnabledColor: AppColors.color1, // Dropdown arrow color
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: updatedGroup,
              onChanged: (value) {
                setState(() {
                  updatedGroup = value!;
                });
              },
              items: _groups.map((group) {
                return DropdownMenuItem(
                  value: group.name,
                  child: Text(
                    group.name,
                    style: const TextStyle(color: AppColors.color4), // Dropdown item text color
                  ),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Group',
                labelStyle: TextStyle(color: AppColors.color1), // Label color
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.color1), // Line color
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.color1), // Focused line color
                ),
              ),
              dropdownColor: AppColors.color3, // Dropdown background color
              iconEnabledColor: AppColors.color1, // Dropdown arrow color
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.color1, // Button background color
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.color2), // Button text color
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                bin.name = nameController.text;
                bin.category = updatedCategory;
                bin.groupName = updatedGroup;
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenColor, // Button background color
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: AppColors.color2), // Button text color
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteBin(bin);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Red background for the delete button
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.color2), // Button text color
            ),
          ),
        ],
      );
    },
  );
}

----------------------------

void _deleteBin(TrashBin bin) {
    setState(() {
      _trashBins.remove(bin);
      _groups
          .firstWhere((group) => group.name == bin.groupName)
          .trashBins
          .remove(bin);
    });
  }

  void _editBin(TrashBin bin) {
    _showEditBinDialog(bin);
  }
  */