# Admin Dashboard - Frontend-Only Implementation Plan
**Version**: 1.0
**Date**: 2025-10-29
**Scope**: UI/UX Implementation Only (No Backend Integration)
**Current Completion**: 45%
**Target Completion**: 100% Frontend
**Estimated Timeline**: 6-8 weeks

---

## Overview

This plan focuses exclusively on **frontend implementation** - completing all screens, forms, interactions, and UI components using **mock data**. Backend integration will be handled separately in the future.

### What This Plan Covers ✅
- All missing screens and detail views
- Forms with validation (client-side)
- UI components (charts, editors, tables)
- User interactions and workflows
- Mock data generation
- Export functionality (CSV/Excel/PDF with local packages)
- Animations and transitions
- Responsive design

### What This Plan DOESN'T Cover ❌
- Firebase integration
- API calls and endpoints
- Authentication backend
- Database operations
- Cloud storage
- Server-side validation
- Production deployment

---

## Table of Contents
1. [Current Frontend Status](#current-frontend-status)
2. [Implementation Phases](#implementation-phases)
3. [Detailed Task Breakdown](#detailed-task-breakdown)
4. [Dependencies Required](#dependencies-required)
5. [Testing Strategy](#testing-strategy)
6. [Timeline & Milestones](#timeline--milestones)

---

## Current Frontend Status

### Completion by Module

| Module | UI Scaffold | Detail Screens | Forms | Interactions | Widgets | Overall |
|--------|-------------|----------------|-------|--------------|---------|---------|
| **Authentication** | 100% | - | 100% | 80% | 100% | **90%** |
| **Dashboard** | 100% | - | - | 70% | 90% | **85%** |
| **User Management** | 100% | 0% | 0% | 40% | 80% | **45%** |
| **Content Mgmt** | 90% | 50% | 30% | 60% | 70% | **60%** |
| **Finance** | 85% | 0% | 20% | 50% | 80% | **47%** |
| **Analytics** | 30% | - | - | 20% | 40% | **30%** |
| **Communications** | 25% | 0% | 0% | 10% | 40% | **19%** |
| **Support** | 30% | 0% | 0% | 20% | 50% | **25%** |
| **System Admin** | 60% | 30% | 10% | 40% | 70% | **42%** |

**Overall Frontend Completion: 45%**

---

## Implementation Phases

### Phase 1: User Management Complete (Week 1-2)
**Priority**: HIGH | **Effort**: 60 hours

Complete all user management screens with detail views, forms, and interactions.

**Deliverables**:
- [ ] 5 user detail screens (student, institution, parent, counselor, recommender)
- [ ] User create/edit forms with validation
- [ ] Bulk operations UI
- [ ] Advanced search and filter widgets
- [ ] Export functionality (CSV/Excel/PDF)
- [ ] User activity timeline widget
- [ ] Verification workflow UI

---

### Phase 2: Content Management System (Week 3-4)
**Priority**: HIGH | **Effort**: 70 hours

Build complete content management interface with editing capabilities.

**Deliverables**:
- [ ] Rich text editor integration (flutter_quill)
- [ ] Media library screen with upload UI
- [ ] Content editor with preview
- [ ] Approval workflow UI
- [ ] Version history viewer
- [ ] Content templates
- [ ] Learning path designer UI
- [ ] Translation management interface

---

### Phase 3: Financial Management (Week 5)
**Priority**: HIGH | **Effort**: 30 hours

Complete financial screens and reporting.

**Deliverables**:
- [ ] Transaction detail screen
- [ ] Settlement management UI
- [ ] Fraud detection dashboard
- [ ] Financial reports with charts
- [ ] Fee configuration interface
- [ ] Payment reconciliation UI
- [ ] Revenue analytics dashboard

---

### Phase 4: Analytics & Reporting (Week 6)
**Priority**: MEDIUM | **Effort**: 40 hours

Build analytics dashboards and custom reporting.

**Deliverables**:
- [ ] Interactive charts (fl_chart integration)
- [ ] Custom dashboard builder UI
- [ ] Report designer interface
- [ ] Data visualization widgets
- [ ] KPI cards and metrics
- [ ] Chart customization options
- [ ] Export reports functionality

---

### Phase 5: Communications Hub (Week 7)
**Priority**: MEDIUM | **Effort**: 35 hours

Complete communication tools interface.

**Deliverables**:
- [ ] Email campaign creator
- [ ] SMS campaign interface
- [ ] Push notification composer
- [ ] Template management screen
- [ ] Campaign scheduler
- [ ] Recipient targeting UI
- [ ] Communication analytics

---

### Phase 6: Support System (Week 7)
**Priority**: MEDIUM | **Effort**: 30 hours

Build support and ticketing system.

**Deliverables**:
- [ ] Ticket detail screen
- [ ] Ticket management interface
- [ ] Live chat UI mockup
- [ ] Knowledge base editor
- [ ] Canned responses manager
- [ ] Support analytics dashboard
- [ ] User impersonation UI

---

### Phase 7: System Administration (Week 8)
**Priority**: MEDIUM | **Effort**: 25 hours

Complete system admin interfaces.

**Deliverables**:
- [ ] Admin account management UI
- [ ] Feature flags interface
- [ ] Infrastructure monitoring dashboard
- [ ] Backup/restore UI
- [ ] API key management screen
- [ ] System settings expanded
- [ ] Security audit viewer

---

### Phase 8: Polish & Refinement (Week 8)
**Priority**: MEDIUM | **Effort**: 20 hours

Polish all screens and add finishing touches.

**Deliverables**:
- [ ] Animations and transitions
- [ ] Loading states for all screens
- [ ] Empty states refinement
- [ ] Error states
- [ ] Tooltips and help text
- [ ] Keyboard navigation improvements
- [ ] Responsive design verification
- [ ] Dark mode refinement

---

## Detailed Task Breakdown

### Phase 1: User Management Complete (60 hours)

#### 1.1 Student Detail Screen (8 hours)

**File**: `lib/features/admin/users/presentation/student_detail_screen.dart`

```dart
class StudentDetailScreen extends ConsumerWidget {
  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock student data
    final student = _getMockStudent(studentId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Row(
        children: [
          // Left sidebar - Profile card
          SizedBox(
            width: 300,
            child: _ProfileCard(student),
          ),

          // Main content - Tabs
          Expanded(
            child: DefaultTabController(
              length: 6,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Overview'),
                      Tab(text: 'Academic'),
                      Tab(text: 'Applications'),
                      Tab(text: 'Documents'),
                      Tab(text: 'Payments'),
                      Tab(text: 'Activity'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _OverviewTab(student),
                        _AcademicTab(student),
                        _ApplicationsTab(student),
                        _DocumentsTab(student),
                        _PaymentsTab(student),
                        _ActivityTab(student),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

**Components to Create**:
- Profile card with avatar, name, email, status badge
- Quick stats cards (courses, applications, progress)
- 6 tab views with mock data
- Action buttons (edit, suspend, delete, message)
- Activity timeline widget

**Mock Data Needed**:
- Student profile with all fields
- Course enrollment data
- Application history
- Document list
- Payment transactions
- Activity log entries

---

#### 1.2 Institution Detail Screen (8 hours)

**File**: `lib/features/admin/users/presentation/institution_detail_screen.dart`

**Sections**:
1. Institution header (logo, name, verification badge)
2. Quick stats (programs: 24, applicants: 156, acceptance rate: 68%)
3. Tabs:
   - Overview: Institution info, contact, address
   - Programs: Data table of all programs
   - Applicants: Current applicants list
   - Statistics: Charts (enrollment trends, demographics)
   - Documents: Verification documents
   - Activity: Timeline

**Actions**:
- Edit institution
- Verify/Unverify institution
- Approve/Reject programs
- Change status
- Send message

---

#### 1.3 Parent Detail Screen (6 hours)

**File**: `lib/features/admin/users/presentation/parent_detail_screen.dart`

**Sections**:
1. Parent header with avatar and info
2. Quick stats (children: 2, total payments: $4,500)
3. Tabs:
   - Overview: Personal info
   - Children: Linked students (cards with quick info)
   - Payments: Payment history table
   - Messages: Communication history
   - Activity: Timeline

**Actions**:
- Edit parent profile
- Link/Unlink children
- View payment details
- Send message

---

#### 1.4 Counselor Detail Screen (7 hours)

**File**: `lib/features/admin/users/presentation/counselor_detail_screen.dart`

**Sections**:
1. Counselor header (avatar, name, specialization, rating)
2. Quick stats (active students: 45, sessions: 234, rating: 4.8)
3. Tabs:
   - Overview: Professional info, credentials
   - Students: Current student list with search
   - Sessions: Session history table
   - Schedule: Calendar view (use table_calendar package)
   - Reviews: Student feedback cards
   - Activity: Timeline

**Actions**:
- Edit profile
- Verify credentials
- View session details
- Change status

---

#### 1.5 Recommender Detail Screen (6 hours)

**File**: `lib/features/admin/users/presentation/recommender_detail_screen.dart`

**Sections**:
1. Recommender header (avatar, name, title, organization)
2. Quick stats (recommendations: 89, completion rate: 94%)
3. Tabs:
   - Overview: Professional info
   - Recommendations: All letters with status
   - Requests: Pending requests table
   - Statistics: Performance charts
   - Activity: Timeline

**Actions**:
- Edit profile
- View recommendation details
- Send message
- Change status

---

#### 1.6 User Forms (15 hours)

**Create Reusable Form Component**

**File**: `lib/features/admin/users/presentation/widgets/user_form.dart`

```dart
class UserForm extends ConsumerStatefulWidget {
  final UserRole userRole;
  final UserModel? existingUser; // null for create, populated for edit

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends ConsumerState<UserForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  // ... more controllers

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Avatar upload
          _AvatarUploader(),

          // Basic info section
          _buildSection('Basic Information', [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Full Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Valid email is required';
                }
                return null;
              },
            ),
            // ... more fields
          ]),

          // Role-specific fields
          if (widget.userRole == UserRole.institution)
            _buildInstitutionFields(),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(widget.existingUser == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Mock submission - show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User saved successfully!')),
      );
      Navigator.pop(context);
    }
  }
}
```

**Create/Edit Screens**:
- `create_user_screen.dart` - Wizard-style form for complex users
- `edit_user_screen.dart` - Pre-filled form for editing

**Validation Rules**:
- Email format validation
- Phone number validation
- Required fields
- URL validation (for institution websites)
- File size limits (for avatars)

---

#### 1.7 Bulk Operations (5 hours)

**File**: `lib/features/admin/users/presentation/widgets/bulk_actions_bar.dart`

```dart
class BulkActionsBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onActivate;
  final VoidCallback onDeactivate;
  final VoidCallback onDelete;
  final VoidCallback onExport;
  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Text(
            '$selectedCount selected',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 24),

          // Bulk actions
          IconButton(
            icon: Icon(Icons.check_circle),
            tooltip: 'Activate',
            onPressed: onActivate,
          ),
          IconButton(
            icon: Icon(Icons.block),
            tooltip: 'Deactivate',
            onPressed: onDeactivate,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () => _showDeleteConfirmation(context),
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            tooltip: 'Export',
            onPressed: onExport,
          ),

          Spacer(),

          TextButton(
            onPressed: onClearSelection,
            child: Text('Clear Selection'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Users'),
        content: Text('Are you sure you want to delete $selectedCount users? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
```

**Features**:
- Multi-select checkboxes in data tables
- Bulk action dropdown
- Confirmation dialogs
- Progress indicators
- Success/error notifications

**Update all list screens** to add:
- Checkbox column
- Select all/none
- Selection state management
- BulkActionsBar when items selected

---

#### 1.8 Advanced Search & Filters (6 hours)

**File**: `lib/features/admin/shared/widgets/advanced_search_dialog.dart`

```dart
class AdvancedSearchDialog extends StatefulWidget {
  final UserRole? userRole;

  @override
  _AdvancedSearchDialogState createState() => _AdvancedSearchDialogState();
}

class _AdvancedSearchDialogState extends State<AdvancedSearchDialog> {
  final _searchController = TextEditingController();
  String? _selectedStatus;
  DateTimeRange? _dateRange;
  String? _selectedRegion;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Search',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 24),

            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Filters
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedStatus,
                    items: ['Active', 'Inactive', 'Pending', 'Suspended']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedStatus = value),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Region',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedRegion,
                    items: ['East Africa', 'West Africa', 'Southern Africa', 'North Africa']
                        .map((region) => DropdownMenuItem(
                              value: region,
                              child: Text(region),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedRegion = value),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Date range
            OutlinedButton.icon(
              icon: Icon(Icons.calendar_today),
              label: Text(_dateRange == null
                  ? 'Select Date Range'
                  : '${_dateRange!.start.toString().split(' ')[0]} - ${_dateRange!.end.toString().split(' ')[0]}'),
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (range != null) {
                  setState(() => _dateRange = range);
                }
              },
            ),

            SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _clearFilters,
                  child: Text('Clear All'),
                ),
                SizedBox(width: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Apply filters (mock)
                    Navigator.pop(context, {
                      'search': _searchController.text,
                      'status': _selectedStatus,
                      'region': _selectedRegion,
                      'dateRange': _dateRange,
                    });
                  },
                  child: Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = null;
      _selectedRegion = null;
      _dateRange = null;
    });
  }
}
```

**Filter Chips Widget**:

**File**: `lib/features/admin/shared/widgets/filter_chips.dart`

```dart
class FilterChips extends StatelessWidget {
  final Map<String, dynamic> filters;
  final Function(String key) onRemove;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...filters.entries.map((entry) {
          return Chip(
            label: Text('${entry.key}: ${entry.value}'),
            deleteIcon: Icon(Icons.close, size: 18),
            onDeleted: () => onRemove(entry.key),
          );
        }).toList(),

        ActionChip(
          label: Text('Clear All'),
          onPressed: onClearAll,
        ),
      ],
    );
  }
}
```

---

#### 1.9 Export Functionality (5 hours)

**File**: `lib/core/services/export_service.dart`

```dart
class ExportService {
  // Export to CSV
  static Future<void> exportToCsv(
    List<Map<String, dynamic>> data,
    String filename,
  ) async {
    if (data.isEmpty) return;

    // Get headers from first row
    final headers = data.first.keys.toList();

    // Build CSV string
    final csvData = [
      headers.join(','), // Header row
      ...data.map((row) =>
        headers.map((header) => _escapeCsvValue(row[header])).join(',')
      ),
    ].join('\n');

    // Download file (web) or save (mobile)
    if (kIsWeb) {
      _downloadFile(csvData, '$filename.csv', 'text/csv');
    } else {
      await _saveFile(csvData, '$filename.csv');
    }
  }

  // Export to Excel
  static Future<void> exportToExcel(
    List<Map<String, dynamic>> data,
    String filename,
  ) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    if (data.isEmpty) return;

    // Add headers
    final headers = data.first.keys.toList();
    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = headers[i];
    }

    // Add data rows
    for (var rowIndex = 0; rowIndex < data.length; rowIndex++) {
      final row = data[rowIndex];
      for (var colIndex = 0; colIndex < headers.length; colIndex++) {
        sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: colIndex,
          rowIndex: rowIndex + 1,
        )).value = row[headers[colIndex]];
      }
    }

    // Save file
    final bytes = excel.encode();
    if (kIsWeb) {
      _downloadFile(bytes!, '$filename.xlsx',
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    } else {
      await _saveFile(bytes!, '$filename.xlsx');
    }
  }

  // Export to PDF
  static Future<void> exportToPdf(
    List<Map<String, dynamic>> data,
    String title,
    String filename,
  ) async {
    final pdf = pw.Document();

    if (data.isEmpty) return;

    final headers = data.first.keys.toList();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(title, style: pw.TextStyle(fontSize: 24)),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: headers,
                data: data.map((row) =>
                  headers.map((header) => row[header].toString()).toList()
                ).toList(),
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    if (kIsWeb) {
      _downloadFile(bytes, '$filename.pdf', 'application/pdf');
    } else {
      await _saveFile(bytes, '$filename.pdf');
    }
  }

  // Helper methods
  static String _escapeCsvValue(dynamic value) {
    final str = value.toString();
    if (str.contains(',') || str.contains('"') || str.contains('\n')) {
      return '"${str.replaceAll('"', '""')}"';
    }
    return str;
  }

  static void _downloadFile(dynamic data, String filename, String mimeType) {
    // Web download
    final bytes = data is String ? utf8.encode(data) : data;
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  static Future<void> _saveFile(dynamic data, String filename) async {
    // Mobile save
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    if (data is String) {
      await file.writeAsString(data);
    } else {
      await file.writeAsBytes(data);
    }

    // Show success message
    // Note: You'll need to pass context or use a global key for SnackBar
    print('File saved to: ${file.path}');
  }
}
```

**Export Dialog**:

**File**: `lib/features/admin/shared/widgets/export_dialog.dart`

```dart
class ExportDialog extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String defaultFilename;

  @override
  _ExportDialogState createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  String _format = 'csv';
  final _filenameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filenameController.text = widget.defaultFilename;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Export Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _filenameController,
            decoration: InputDecoration(
              labelText: 'Filename',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _format,
            decoration: InputDecoration(
              labelText: 'Format',
              border: OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(value: 'csv', child: Text('CSV')),
              DropdownMenuItem(value: 'excel', child: Text('Excel (XLSX)')),
              DropdownMenuItem(value: 'pdf', child: Text('PDF')),
            ],
            onChanged: (value) => setState(() => _format = value!),
          ),
          SizedBox(height: 16),
          Text(
            '${widget.data.length} records will be exported',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);

            // Show loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Exporting...')),
            );

            // Export
            try {
              switch (_format) {
                case 'csv':
                  await ExportService.exportToCsv(
                    widget.data,
                    _filenameController.text,
                  );
                  break;
                case 'excel':
                  await ExportService.exportToExcel(
                    widget.data,
                    _filenameController.text,
                  );
                  break;
                case 'pdf':
                  await ExportService.exportToPdf(
                    widget.data,
                    'User Data',
                    _filenameController.text,
                  );
                  break;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Export successful!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Export failed: $e')),
              );
            }
          },
          child: Text('Export'),
        ),
      ],
    );
  }
}
```

---

### Phase 2: Content Management System (70 hours)

#### 2.1 Rich Text Editor (16 hours)

**File**: `lib/features/admin/content/presentation/widgets/rich_text_editor.dart`

```dart
class RichTextEditor extends StatefulWidget {
  final String? initialContent;
  final Function(String content) onContentChanged;

  @override
  _RichTextEditorState createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  late QuillController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize with existing content or empty
    final document = widget.initialContent != null
        ? Document.fromJson(jsonDecode(widget.initialContent!))
        : Document();

    _controller = QuillController(
      document: document,
      selection: TextSelection.collapsed(offset: 0),
    );

    // Listen to changes
    _controller.addListener(() {
      widget.onContentChanged(
        jsonEncode(_controller.document.toDelta().toJson()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
              controller: _controller,
              showAlignmentButtons: true,
              showBackgroundColorButton: true,
              showCenterAlignment: true,
              showCodeBlock: true,
              showColorButton: true,
              showFontFamily: false,
              showFontSize: true,
              showHeaderStyle: true,
              showIndent: true,
              showInlineCode: true,
              showJustifyAlignment: true,
              showLeftAlignment: true,
              showLink: true,
              showListBullets: true,
              showListCheck: true,
              showListNumbers: true,
              showQuote: true,
              showRedo: true,
              showRightAlignment: true,
              showStrikeThrough: true,
              showUndo: true,
            ),
          ),
        ),

        // Editor
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _controller,
                readOnly: false,
                placeholder: 'Start writing...',
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

**Custom Toolbar Buttons**:
- Image upload button
- Video embed button
- Table insertion
- Code block with syntax highlighting

---

#### 2.2 Content Editor Screen (12 hours)

**File**: `lib/features/admin/content/presentation/content_editor_screen.dart`

```dart
class ContentEditorScreen extends ConsumerStatefulWidget {
  final String? contentId; // null for new content

  @override
  _ContentEditorScreenState createState() => _ContentEditorScreenState();
}

class _ContentEditorScreenState extends ConsumerState<ContentEditorScreen> {
  final _titleController = TextEditingController();
  String _contentBody = '';
  String _selectedType = 'course';
  String _selectedCategory = 'technology';
  bool _isPublished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contentId == null ? 'Create Content' : 'Edit Content'),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.visibility),
            label: Text('Preview'),
            onPressed: _showPreview,
          ),
          SizedBox(width: 16),
          TextButton(
            onPressed: _saveDraft,
            child: Text('Save Draft'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: _publish,
            child: Text(_isPublished ? 'Update' : 'Publish'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Main editor
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextField(
                    controller: _titleController,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Content Title',
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Rich text editor
                  Container(
                    height: 600,
                    child: RichTextEditor(
                      onContentChanged: (content) {
                        setState(() => _contentBody = content);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right sidebar - Settings
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                left: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('Content Type', [
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: ['course', 'lesson', 'resource', 'assessment']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedType = value!),
                    ),
                  ]),

                  _buildSection('Category', [
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: ['technology', 'business', 'science', 'arts']
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedCategory = value!),
                    ),
                  ]),

                  _buildSection('Featured Image', [
                    _ImageUploader(),
                  ]),

                  _buildSection('Tags', [
                    _TagsInput(),
                  ]),

                  _buildSection('Visibility', [
                    SwitchListTile(
                      title: Text('Published'),
                      value: _isPublished,
                      onChanged: (value) => setState(() => _isPublished = value),
                    ),
                  ]),

                  _buildSection('SEO', [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Meta Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        ...children,
        SizedBox(height: 24),
      ],
    );
  }

  void _saveDraft() {
    // Mock save
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Draft saved')),
    );
  }

  void _publish() {
    // Mock publish
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Content published!')),
    );
  }

  void _showPreview() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 800,
          height: 600,
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Preview', style: TextStyle(fontSize: 24)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _titleController.text,
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 24),
                      // Render Quill content
                      Text('Content preview would be rendered here'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

#### 2.3 Media Library (14 hours)

**File**: `lib/features/admin/content/presentation/media_library_screen.dart`

```dart
class MediaLibraryScreen extends ConsumerStatefulWidget {
  @override
  _MediaLibraryScreenState createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends ConsumerState<MediaLibraryScreen> {
  String _viewMode = 'grid'; // 'grid' or 'list'
  String _filterType = 'all'; // 'all', 'images', 'videos', 'documents'
  List<MediaFile> _selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    final mediaFiles = _getMockMediaFiles();

    return Scaffold(
      appBar: AppBar(
        title: Text('Media Library'),
        actions: [
          // View mode toggle
          IconButton(
            icon: Icon(_viewMode == 'grid' ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == 'grid' ? 'list' : 'grid';
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Toolbar
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                // Upload button
                ElevatedButton.icon(
                  icon: Icon(Icons.upload_file),
                  label: Text('Upload'),
                  onPressed: _showUploadDialog,
                ),
                SizedBox(width: 16),

                // Filter chips
                FilterChip(
                  label: Text('All'),
                  selected: _filterType == 'all',
                  onSelected: (selected) {
                    setState(() => _filterType = 'all');
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Images'),
                  selected: _filterType == 'images',
                  onSelected: (selected) {
                    setState(() => _filterType = 'images');
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Videos'),
                  selected: _filterType == 'videos',
                  onSelected: (selected) {
                    setState(() => _filterType = 'videos');
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Documents'),
                  selected: _filterType == 'documents',
                  onSelected: (selected) {
                    setState(() => _filterType = 'documents');
                  },
                ),

                Spacer(),

                // Search
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search media...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bulk actions bar (if items selected)
          if (_selectedFiles.isNotEmpty)
            _BulkActionsBar(
              selectedCount: _selectedFiles.length,
              onDelete: () => setState(() => _selectedFiles.clear()),
              onClearSelection: () => setState(() => _selectedFiles.clear()),
            ),

          // Media grid/list
          Expanded(
            child: _viewMode == 'grid'
                ? _buildGridView(mediaFiles)
                : _buildListView(mediaFiles),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<MediaFile> files) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        final isSelected = _selectedFiles.contains(file);

        return GestureDetector(
          onTap: () => _showFileDetails(file),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Thumbnail
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                        child: file.type == 'image'
                            ? Image.network(file.url, fit: BoxFit.cover)
                            : Center(
                                child: Icon(
                                  _getFileIcon(file.type),
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                    // Info
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            file.size,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Selection checkbox
              Positioned(
                top: 8,
                left: 8,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (selected) {
                    setState(() {
                      if (selected!) {
                        _selectedFiles.add(file);
                      } else {
                        _selectedFiles.remove(file);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView(List<MediaFile> files) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        final isSelected = _selectedFiles.contains(file);

        return ListTile(
          leading: Checkbox(
            value: isSelected,
            onChanged: (selected) {
              setState(() {
                if (selected!) {
                  _selectedFiles.add(file);
                } else {
                  _selectedFiles.remove(file);
                }
              });
            },
          ),
          title: Text(file.name),
          subtitle: Text('${file.size} • Uploaded ${file.uploadedAt}'),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => _showFileOptions(file),
          ),
          onTap: () => _showFileDetails(file),
        );
      },
    );
  }

  void _showUploadDialog() {
    // Mock upload dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload Files'),
        content: Container(
          width: 400,
          height: 300,
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Drag and drop files here'),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          // Mock file picker
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.any,
                          );
                          if (result != null) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${result.files.length} files uploaded')),
                            );
                          }
                        },
                        child: Text('Browse Files'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFileDetails(MediaFile file) {
    // Show file details dialog
  }

  void _showFileOptions(MediaFile file) {
    // Show options menu
  }

  IconData _getFileIcon(String type) {
    switch (type) {
      case 'video':
        return Icons.video_file;
      case 'document':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  List<MediaFile> _getMockMediaFiles() {
    return [
      MediaFile(
        id: '1',
        name: 'course-thumbnail.jpg',
        type: 'image',
        url: 'https://via.placeholder.com/300',
        size: '2.4 MB',
        uploadedAt: '2 hours ago',
      ),
      // ... more mock files
    ];
  }
}

class MediaFile {
  final String id;
  final String name;
  final String type;
  final String url;
  final String size;
  final String uploadedAt;

  MediaFile({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.size,
    required this.uploadedAt,
  });
}
```

---

#### 2.4 Approval Workflow UI (10 hours)

Add to existing `content_management_screen.dart`:
- Approval status badges
- Reviewer assignment dropdown
- Approve/Reject buttons with comment dialog
- Workflow history timeline
- Bulk approval actions

---

#### 2.5 Version History (10 hours)

**File**: `lib/features/admin/content/presentation/version_history_screen.dart`

```dart
class VersionHistoryScreen extends StatelessWidget {
  final String contentId;

  @override
  Widget build(BuildContext context) {
    final versions = _getMockVersions();

    return Scaffold(
      appBar: AppBar(
        title: Text('Version History'),
      ),
      body: Row(
        children: [
          // Version list
          SizedBox(
            width: 300,
            child: ListView.builder(
              itemCount: versions.length,
              itemBuilder: (context, index) {
                final version = versions[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('v${version.number}'),
                  ),
                  title: Text('Version ${version.number}'),
                  subtitle: Text(
                    '${version.author} • ${version.createdAt}',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: version.isCurrent
                      ? Chip(label: Text('Current'))
                      : null,
                  selected: index == 0,
                  onTap: () {
                    // Show version details
                  },
                );
              },
            ),
          ),

          VerticalDivider(),

          // Version details
          Expanded(
            child: Column(
              children: [
                // Version header
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Version ${versions[0].number}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'By ${versions[0].author} on ${versions[0].createdAt}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.restore),
                        label: Text('Restore This Version'),
                        onPressed: () => _showRestoreConfirmation(context),
                      ),
                    ],
                  ),
                ),

                // Version content preview
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Changes in this version:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        _ChangeItem(
                          type: 'added',
                          content: 'Added new section on African history',
                        ),
                        _ChangeItem(
                          type: 'modified',
                          content: 'Updated course objectives',
                        ),
                        _ChangeItem(
                          type: 'removed',
                          content: 'Removed outdated reference materials',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRestoreConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restore Version'),
        content: Text(
          'Are you sure you want to restore this version? '
          'The current version will be saved in history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Version restored')),
              );
            },
            child: Text('Restore'),
          ),
        ],
      ),
    );
  }

  List<ContentVersion> _getMockVersions() {
    return [
      ContentVersion(
        number: 5,
        author: 'John Admin',
        createdAt: '2 hours ago',
        isCurrent: true,
      ),
      ContentVersion(
        number: 4,
        author: 'Jane Editor',
        createdAt: '1 day ago',
        isCurrent: false,
      ),
      // ... more versions
    ];
  }
}

class _ChangeItem extends StatelessWidget {
  final String type; // 'added', 'modified', 'removed'
  final String content;

  const _ChangeItem({required this.type, required this.content});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (type) {
      case 'added':
        color = Colors.green;
        icon = Icons.add_circle;
        break;
      case 'removed':
        color = Colors.red;
        icon = Icons.remove_circle;
        break;
      default:
        color = Colors.orange;
        icon = Icons.edit;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 12),
          Expanded(child: Text(content)),
        ],
      ),
    );
  }
}

class ContentVersion {
  final int number;
  final String author;
  final String createdAt;
  final bool isCurrent;

  ContentVersion({
    required this.number,
    required this.author,
    required this.createdAt,
    required this.isCurrent,
  });
}
```

---

#### 2.6 Learning Path Designer (8 hours)

**File**: `lib/features/admin/content/presentation/learning_path_designer_screen.dart`

Create a simple drag-and-drop interface for designing learning paths:
- Node-based path builder (simplified)
- Prerequisites connections
- Path visualization
- Save/load path configurations

---

### Phase 3-8: Remaining Modules

[Due to length constraints, I'll provide a summary for the remaining phases]

**Phase 3: Finance (30 hours)**
- Transaction detail screen with full payment info
- Settlement management UI with payout scheduling
- Fraud detection dashboard with charts
- Financial reports with date range filters
- Fee configuration interface

**Phase 4: Analytics (40 hours)**
- fl_chart integration for all chart types
- Custom dashboard builder (simplified drag-and-drop)
- Report designer with filters
- Data visualization widgets library
- Export charts functionality

**Phase 5: Communications (35 hours)**
- Email campaign creator with template selection
- SMS campaign interface
- Push notification composer
- Template management CRUD
- Campaign analytics dashboard

**Phase 6: Support (30 hours)**
- Ticket detail screen with response composer
- Live chat UI mockup (no real-time)
- Knowledge base editor (similar to content editor)
- Canned responses manager
- Support analytics

**Phase 7: System Admin (25 hours)**
- Admin account management UI
- Feature flags toggle interface
- Infrastructure monitoring dashboard (mock metrics)
- Backup/restore UI
- API key management screen

**Phase 8: Polish (20 hours)**
- Add loading states to all screens
- Refine empty states
- Add tooltips
- Improve animations
- Test responsive design
- Dark mode refinement

---

## Dependencies Required

```yaml
# pubspec.yaml additions

dependencies:
  # Rich Text Editor
  flutter_quill: ^9.0.0

  # Forms & Validation
  flutter_form_builder: ^9.1.0
  form_builder_validators: ^9.0.0

  # File Handling
  file_picker: ^8.0.0  # already included
  image_picker: ^1.0.5

  # Export
  excel: ^4.0.0
  pdf: ^3.10.0
  csv: ^6.0.0
  printing: ^5.11.0

  # Charts (already included)
  fl_chart: ^0.68.0

  # Calendar
  table_calendar: ^3.0.9

  # Utils
  intl: ^0.20.2  # already included
  uuid: ^4.3.0  # already included
  timeago: ^3.7.1  # already included

  # For web downloads
  universal_html: ^2.2.4

  # Path provider (for mobile file saving)
  path_provider: ^2.1.1
```

---

## Testing Strategy

### Widget Tests (20 hours)
- Test all new screens render correctly
- Test form validation
- Test user interactions (button clicks, navigation)
- Test export functionality
- Test chart rendering

### Integration Tests (10 hours)
- Test complete workflows (create user → view details → edit)
- Test navigation between screens
- Test search and filter combinations

---

## Timeline & Milestones

### Week-by-Week Breakdown

**Week 1**: User Management (Part 1)
- Mon-Tue: Student & Institution detail screens
- Wed-Thu: Parent & Counselor detail screens
- Fri: Recommender detail screen

**Week 2**: User Management (Part 2)
- Mon-Tue: User forms (create/edit)
- Wed: Bulk operations
- Thu: Advanced search & filters
- Fri: Export functionality

**Week 3**: Content Management (Part 1)
- Mon-Tue: Rich text editor integration
- Wed-Thu: Content editor screen
- Fri: Testing

**Week 4**: Content Management (Part 2)
- Mon-Tue: Media library
- Wed: Approval workflow
- Thu: Version history
- Fri: Learning path designer (simplified)

**Week 5**: Finance
- Mon: Transaction details
- Tue: Settlement UI
- Wed: Fraud detection
- Thu: Financial reports
- Fri: Fee configuration

**Week 6**: Analytics
- Mon-Tue: Chart integration
- Wed: Dashboard builder
- Thu: Report designer
- Fri: Testing

**Week 7**: Communications & Support
- Mon-Tue: Email/SMS/Push campaigns
- Wed: Template management
- Thu: Ticket management
- Fri: Knowledge base

**Week 8**: System Admin & Polish
- Mon: Admin account management
- Tue: Feature flags & monitoring
- Wed-Thu: Polish all screens
- Fri: Final testing

---

## Success Criteria

### Frontend Completion Checklist

- [ ] All detail screens implemented (5 user types)
- [ ] All forms with validation working
- [ ] Rich text editor integrated
- [ ] Media library functional (with mock upload)
- [ ] Export works (CSV/Excel/PDF)
- [ ] Charts display correctly
- [ ] All workflows have proper UI
- [ ] Loading/empty/error states everywhere
- [ ] Responsive design verified
- [ ] Dark mode works properly
- [ ] No console errors
- [ ] All navigation works
- [ ] All mock data realistic

### Quality Standards

- Clean code with proper comments
- Consistent UI/UX across all screens
- Reusable components
- Proper error handling
- Smooth animations
- Fast rendering (no jank)
- Accessible (keyboard navigation, screen readers)

---

## Next Steps

1. **Review this plan** and adjust timeline if needed
2. **Start with Phase 1** (User Management)
3. **Create mock data generators** for testing
4. **Set up daily progress tracking**
5. **Test each feature** before moving to next

---

**End of Document**

Last Updated: 2025-10-29
