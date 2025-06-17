import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'dart:io';

// TODO: This screen will eventually need to load existing user data.
// For now, it mirrors the structure of ProfileCreationScreen for editing.

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  final List<String> _genderOptions = ['Man', 'Woman', 'Non-binary', 'Other', 'Prefer not to say'];
  String? _interestedInGender;
  final List<String> _interestedInGenderOptions = ['Men', 'Women', 'Everyone'];

  // REMOVE: RangeValues? _preferredAgeRange;
  // REMOVE: final double _minAge = 18;
  // REMOVE: final double _maxAge = 65;

  // ADD: New state variables for age offsets
  RangeValues _preferredAgeOffsets = const RangeValues(-2, 2); // Default offsets
  final double _minOffset = -10; // Min offset (e.g., 10 years younger)
  final double _maxOffset = 10;  // Max offset (e.g., 10 years older)

  // TODO: Load existing user data in initState
  @override
  void initState() {
    super.initState();
    // Simulate loading existing data
    _nameController.text = "Current User Name"; // Placeholder
    _selectedDate = DateTime.now().subtract(const Duration(days: 20 * 365)); // Placeholder
    _selectedGender = _genderOptions[0]; // Placeholder
    _interestedInGender = _interestedInGenderOptions[0]; // Placeholder
    // REMOVE: _preferredAgeRange = const RangeValues(20, 30);
    // ADD: Initialize _preferredAgeOffsets (e.g., from saved user preferences if available)
    // For now, using default. In a real app, load this from user data.
    _preferredAgeOffsets = const RangeValues(-2, 2); 
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ADD: Helper function to calculate age
  int? _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return null;
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 17 * 365 + 1)),
      helpText: 'Select your Date of Birth',
       builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                  onPrimary: Colors.white,
                  onSurface: Theme.of(context).colorScheme.onSurface,
                ), dialogTheme: DialogThemeData(backgroundColor: Theme.of(context).scaffoldBackgroundColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      if (DateTime.now().difference(_selectedDate!).inDays < (17 * 365.25).floor()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be at least 17 years old.')),
        );
        setState(() {
          _selectedDate = null;
        });
      }
    }
  }

  Future<void> _pickImages() async {
    if (_images.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can upload a maximum of 5 photos.')),
      );
      return;
    }
    final List<XFile> pickedFiles = await _picker.pickMultiImage(limit: 5 - _images.length);
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _reorderImage(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final XFile item = _images.removeAt(oldIndex);
      _images.insert(newIndex, item);
    });
  }

  void _saveProfileChanges() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your date of birth.')),
        );
        return;
      }
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender.')),
        );
        return;
      }
      if (_interestedInGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select who you are interested in.')),
        );
        return;
      }
      if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload at least one photo.')),
        );
        return;
      }

      print('Profile changes saved:');
      print('Name: ${_nameController.text}');
      print('DOB: $_selectedDate');
      print('Gender: $_selectedGender');
      print('Interested In: $_interestedInGender');

      // UPDATE: Print logic for age preference
      final int? currentUserAge = _calculateAge(_selectedDate);
      if (currentUserAge != null) {
        final int lowerAgeBound = currentUserAge + _preferredAgeOffsets.start.round();
        final int upperAgeBound = currentUserAge + _preferredAgeOffsets.end.round();
        // Ensure minimum age of 17 for partners
        final int effectiveLowerAge = (lowerAgeBound < 17) ? 17 : lowerAgeBound;
        final int effectiveUpperAge = (upperAgeBound < 17) ? 17 : upperAgeBound;

        print('Preferred Age Offsets: Start: ${_preferredAgeOffsets.start.round()} yrs, End: ${_preferredAgeOffsets.end.round()} yrs');
        print('Calculated Preferred Age Range: $effectiveLowerAge - $effectiveUpperAge');
      } else {
        print('Preferred Age Offsets: Start: ${_preferredAgeOffsets.start.round()} yrs, End: ${_preferredAgeOffsets.end.round()} yrs (User DOB not set)');
      }
      print('Photos: ${_images.map((e) => e.path).toList()}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully (mock)!')),
      );
      Navigator.of(context).pop(); // Go back to settings screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile & Preferences'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfileChanges,
            tooltip: 'Save Changes',
          )
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Name
              Text("What's Your Name?", style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  prefixIcon: Icon(Icons.person, color: theme.colorScheme.primary),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20), // Adjusted spacing

              // Date of Birth
              Text("When's Your Birthday?", style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("(Must be 17+)", style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: Icon(Icons.calendar_today, color: theme.colorScheme.onPrimary),
                label: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : DateFormat.yMMMMd().format(_selectedDate!), // Formatted date
                  style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                onPressed: () => _pickDate(context),
              ),
              const SizedBox(height: 20), // Adjusted spacing

              // Gender
              Text("Your Gender Identity", style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Gender',
                  prefixIcon: Icon(Icons.wc, color: theme.colorScheme.primary),
                ),
                dropdownColor: theme.scaffoldBackgroundColor,
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: _genderOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: theme.colorScheme.onSurface)),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Please select your gender' : null,
              ),
              const SizedBox(height: 20), // Adjusted spacing

              // Interested In Gender
              Text("Who Are You Interested In?", style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Interested In',
                  prefixIcon: Icon(Icons.people_alt_outlined, color: theme.colorScheme.primary),
                ),
                dropdownColor: theme.scaffoldBackgroundColor,
                value: _interestedInGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _interestedInGender = newValue;
                  });
                },
                items: _interestedInGenderOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: theme.colorScheme.onSurface)),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Please select your preference' : null,
              ),
              const SizedBox(height: 20), // Adjusted spacing

              // Preferred Age Difference
              Text("Preferred Age Difference", style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ?? Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  color: theme.inputDecorationTheme.fillColor,
                ),
                child: Builder( // Use Builder to ensure context for ScaffoldMessenger
                  builder: (context) {
                    final int? currentUserAge = _calculateAge(_selectedDate);
                    String preferenceDisplayText;
                    String effectiveRangeDisplayText = "";

                    if (currentUserAge == null) {
                      preferenceDisplayText = "Select your Date of Birth to set age preferences.";
                    } else {
                      int startOffsetVal = _preferredAgeOffsets.start.round();
                      int endOffsetVal = _preferredAgeOffsets.end.round();

                      String formatOffset(int offset) {
                        if (offset == 0) return "your age";
                        return "${offset.abs()} years ${offset < 0 ? 'younger' : 'older'}";
                      }

                      if (startOffsetVal == endOffsetVal) {
                        preferenceDisplayText = formatOffset(startOffsetVal);
                        if (startOffsetVal == 0) preferenceDisplayText = "Around your age";
                      } else {
                        preferenceDisplayText = "From ${formatOffset(startOffsetVal)} to ${formatOffset(endOffsetVal)}";
                      }
                      
                      int lowerAgeBound = currentUserAge + startOffsetVal;
                      int upperAgeBound = currentUserAge + endOffsetVal;

                      int displayLowerAge = lowerAgeBound < 17 ? 17 : lowerAgeBound;
                      int displayUpperAge = upperAgeBound < 17 ? 17 : upperAgeBound;
                      
                      if (displayLowerAge > displayUpperAge) { // Ensure correct order for display
                          final temp = displayLowerAge;
                          displayLowerAge = displayUpperAge;
                          displayUpperAge = temp;
                      }
                      if (displayUpperAge < displayLowerAge) displayUpperAge = displayLowerAge;

                      effectiveRangeDisplayText = "Effective age range: $displayLowerAge - $displayUpperAge years old";
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          preferenceDisplayText,
                          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
                        ),
                        if (currentUserAge != null && effectiveRangeDisplayText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              effectiveRangeDisplayText,
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                            ),
                          ),
                        RangeSlider(
                          values: _preferredAgeOffsets,
                          min: _minOffset,
                          max: _maxOffset,
                          divisions: (_maxOffset - _minOffset).round(),
                          labels: RangeLabels(
                            "${_preferredAgeOffsets.start.round() > 0 ? '+' : ''}${_preferredAgeOffsets.start.round()} yrs",
                            "${_preferredAgeOffsets.end.round() > 0 ? '+' : ''}${_preferredAgeOffsets.end.round()} yrs",
                          ),
                          activeColor: theme.colorScheme.primary,
                          inactiveColor: theme.colorScheme.primary.withOpacity(0.3),
                          onChanged: (RangeValues values) {
                            if (_calculateAge(_selectedDate) == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select your Date of Birth to set age preferences.')),
                              );
                              return;
                            }
                            setState(() {
                              _preferredAgeOffsets = RangeValues(
                                values.start.clamp(_minOffset, _maxOffset),
                                values.end.clamp(_minOffset, _maxOffset)
                              );
                            });
                          },
                        ),
                      ],
                    );
                  }
                ),
              ),
              const SizedBox(height: 24),

              // Photo Upload
              Text("Show Your Best Self", style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("(Min 1, Max 5 photos)", style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[850]?.withOpacity(0.5),
                ),
                child: Column(
                  children: [
                    if (_images.isEmpty)
                      GestureDetector(
                        onTap: _pickImages,
                        child: SizedBox(
                          height: 120,
                          // ADDED decoration for tap area
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: theme.colorScheme.primary.withOpacity(0.6), width: 1.5)
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined, size: 40, color: theme.colorScheme.primary),
                                  const SizedBox(height: 8),
                                  Text("Tap to add photos", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_images.isNotEmpty)
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Card(
                            key: ValueKey(_images[index].path),
                            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
                            color: theme.cardColor.withOpacity(0.7),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), // Added shape
                            child: ListTile(
                              leading: ClipRRect( // Rounded corners for image preview
                                borderRadius: BorderRadius.circular(4.0),
                                child: kIsWeb
                                    ? Image.network(_images[index].path, width: 50, height: 50, fit: BoxFit.cover)
                                    : Image.file(File(_images[index].path), width: 50, height: 50, fit: BoxFit.cover),
                              ),
                              title: Text('Photo \\${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ReorderableDragStartListener( // Explicit drag handle
                                    index: index,
                                    child: const Icon(Icons.drag_handle, color: Colors.white70),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                                    onPressed: () => _removeImage(index),
                                    tooltip: 'Remove Photo',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        onReorder: _reorderImage,
                      ),
                    if (_images.isNotEmpty && _images.length < 5)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextButton.icon(
                          icon: Icon(Icons.add_photo_alternate_outlined, color: theme.colorScheme.secondary),
                          label: Text('Add More (\${_images.length}/5)', style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.w500)),
                          onPressed: _pickImages,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_outlined),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _saveProfileChanges,
              ),
               const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
