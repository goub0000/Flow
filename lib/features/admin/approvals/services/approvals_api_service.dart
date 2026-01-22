import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/approval_models.dart';

/// Service for communicating with Approvals API
/// Handles admin approval workflow operations
class ApprovalsApiService {
  // API base URL - Railway production deployment
  static const String baseUrl =
      'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final String? _accessToken;

  ApprovalsApiService({
    http.Client? client,
    String? accessToken,
  })  : _client = client ?? http.Client(),
        _accessToken = accessToken;

  /// Build headers with authentication
  Map<String, String> _buildHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  /// Handle API response errors
  void _handleError(http.Response response, String operation) {
    if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please log in again');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden: You do not have permission for this action');
    } else if (response.statusCode == 404) {
      throw Exception('Resource not found');
    } else {
      final body = jsonDecode(response.body);
      final detail = body['detail'] ?? 'Unknown error';
      throw Exception('$operation failed: $detail');
    }
  }

  // ==================== CRUD Operations ====================

  /// Create a new approval request (using enum-based model)
  Future<ApprovalRequest> createRequest(CreateApprovalRequest data) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/admin/approvals'),
        headers: _buildHeaders(),
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequest.fromJson(json);
      } else {
        _handleError(response, 'Create approval request');
        throw Exception('Failed to create approval request');
      }
    } catch (e) {
      throw Exception('Error creating approval request: $e');
    }
  }

  /// Create a new approval request (using string-based model for flexibility)
  Future<ApprovalRequest> createRequestFromStrings(ApprovalRequestCreate data) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/admin/approvals'),
        headers: _buildHeaders(),
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequest.fromJson(json);
      } else {
        _handleError(response, 'Create approval request');
        throw Exception('Failed to create approval request');
      }
    } catch (e) {
      throw Exception('Error creating approval request: $e');
    }
  }

  /// List approval requests with filters
  Future<ApprovalRequestListResponse> listRequests({
    int page = 1,
    int pageSize = 20,
    List<ApprovalStatus>? status,
    List<ApprovalRequestType>? requestType,
    List<ApprovalActionType>? actionType,
    List<ApprovalPriority>? priority,
    String? initiatedBy,
    String? regionalScope,
    int? currentApprovalLevel,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status.map((s) => s.name).join(',');
      }
      if (requestType != null && requestType.isNotEmpty) {
        queryParams['request_type'] = requestType.map((t) => t.name).join(',');
      }
      if (actionType != null && actionType.isNotEmpty) {
        queryParams['action_type'] = actionType.map((a) => a.name).join(',');
      }
      if (priority != null && priority.isNotEmpty) {
        queryParams['priority'] = priority.map((p) => p.name).join(',');
      }
      if (initiatedBy != null) queryParams['initiated_by'] = initiatedBy;
      if (regionalScope != null) queryParams['regional_scope'] = regionalScope;
      if (currentApprovalLevel != null) {
        queryParams['current_approval_level'] = currentApprovalLevel.toString();
      }
      if (fromDate != null) queryParams['from_date'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['to_date'] = toDate.toIso8601String();
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse('$baseUrl/admin/approvals')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequestListResponse.fromJson(json);
      } else {
        _handleError(response, 'List approval requests');
        throw Exception('Failed to list approval requests');
      }
    } catch (e) {
      throw Exception('Error listing approval requests: $e');
    }
  }

  /// Get approval request by ID
  Future<ApprovalRequest> getRequest(
    String requestId, {
    bool includeActions = true,
    bool includeComments = true,
  }) async {
    try {
      final queryParams = <String, String>{
        'include_actions': includeActions.toString(),
        'include_comments': includeComments.toString(),
      };

      final uri = Uri.parse('$baseUrl/admin/approvals/$requestId')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequest.fromJson(json);
      } else {
        _handleError(response, 'Get approval request');
        throw Exception('Failed to get approval request');
      }
    } catch (e) {
      throw Exception('Error getting approval request: $e');
    }
  }

  /// Update approval request
  Future<ApprovalRequest> updateRequest(
    String requestId,
    UpdateApprovalRequest data,
  ) async {
    try {
      final response = await _client.patch(
        Uri.parse('$baseUrl/admin/approvals/$requestId'),
        headers: _buildHeaders(),
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequest.fromJson(json);
      } else {
        _handleError(response, 'Update approval request');
        throw Exception('Failed to update approval request');
      }
    } catch (e) {
      throw Exception('Error updating approval request: $e');
    }
  }

  /// Withdraw approval request
  Future<ApprovalRequest> withdrawRequest(
    String requestId, {
    String? reason,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (reason != null) queryParams['reason'] = reason;

      final uri = Uri.parse('$baseUrl/admin/approvals/$requestId/withdraw')
          .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await _client.post(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequest.fromJson(json);
      } else {
        _handleError(response, 'Withdraw approval request');
        throw Exception('Failed to withdraw approval request');
      }
    } catch (e) {
      throw Exception('Error withdrawing approval request: $e');
    }
  }

  // ==================== Review Actions ====================

  /// Approve a request
  Future<ApprovalRequest> approveRequest(
    String requestId,
    ApproveRequestData data,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/admin/approvals/$requestId/approve'),
        headers: _buildHeaders(),
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequest.fromJson(json);
      } else {
        _handleError(response, 'Approve request');
        throw Exception('Failed to approve request');
      }
    } catch (e) {
      throw Exception('Error approving request: $e');
    }
  }

  /// Deny a request
  Future<ApprovalRequest> denyRequest(
    String requestId,
    DenyRequestData data,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/admin/approvals/$requestId/deny'),
        headers: _buildHeaders(),
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequest.fromJson(json);
      } else {
        _handleError(response, 'Deny request');
        throw Exception('Failed to deny request');
      }
    } catch (e) {
      throw Exception('Error denying request: $e');
    }
  }

  /// Request additional information
  Future<ApprovalRequest> requestInfo(
    String requestId,
    RequestInfoData data,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/admin/approvals/$requestId/request-info'),
        headers: _buildHeaders(),
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequest.fromJson(json);
      } else {
        _handleError(response, 'Request info');
        throw Exception('Failed to request info');
      }
    } catch (e) {
      throw Exception('Error requesting info: $e');
    }
  }

  /// Respond to info request
  Future<ApprovalRequest> respondToInfo(
    String requestId,
    RespondInfoData data,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/admin/approvals/$requestId/respond-info'),
        headers: _buildHeaders(),
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequest.fromJson(json);
      } else {
        _handleError(response, 'Respond to info');
        throw Exception('Failed to respond to info');
      }
    } catch (e) {
      throw Exception('Error responding to info: $e');
    }
  }

  /// Delegate request
  Future<ApprovalRequest> delegateRequest(
    String requestId,
    DelegateRequestData data,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/admin/approvals/$requestId/delegate'),
        headers: _buildHeaders(),
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequest.fromJson(json);
      } else {
        _handleError(response, 'Delegate request');
        throw Exception('Failed to delegate request');
      }
    } catch (e) {
      throw Exception('Error delegating request: $e');
    }
  }

  /// Escalate request
  Future<ApprovalRequest> escalateRequest(
    String requestId,
    EscalateRequestData data,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/admin/approvals/$requestId/escalate'),
        headers: _buildHeaders(),
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequest.fromJson(json);
      } else {
        _handleError(response, 'Escalate request');
        throw Exception('Failed to escalate request');
      }
    } catch (e) {
      throw Exception('Error escalating request: $e');
    }
  }

  // ==================== Comments ====================

  /// Add comment to request
  Future<ApprovalComment> addComment(
    String requestId,
    CreateCommentData data,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/admin/approvals/$requestId/comments'),
        headers: _buildHeaders(),
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalComment.fromJson(json);
      } else {
        _handleError(response, 'Add comment');
        throw Exception('Failed to add comment');
      }
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  /// Get comments for request
  Future<List<ApprovalComment>> getComments(String requestId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/admin/approvals/$requestId/comments'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        return json
            .map((c) => ApprovalComment.fromJson(c as Map<String, dynamic>))
            .toList();
      } else {
        _handleError(response, 'Get comments');
        throw Exception('Failed to get comments');
      }
    } catch (e) {
      throw Exception('Error getting comments: $e');
    }
  }

  /// Delete comment
  Future<void> deleteComment(String requestId, String commentId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/admin/approvals/$requestId/comments/$commentId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode != 200) {
        _handleError(response, 'Delete comment');
        throw Exception('Failed to delete comment');
      }
    } catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }

  // ==================== Dashboard ====================

  /// Get approval statistics
  Future<ApprovalStatistics> getStatistics({String? regionalScope}) async {
    try {
      final queryParams = <String, String>{};
      if (regionalScope != null) queryParams['regional_scope'] = regionalScope;

      final uri = Uri.parse('$baseUrl/admin/approvals/stats')
          .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalStatistics.fromJson(json);
      } else {
        _handleError(response, 'Get statistics');
        throw Exception('Failed to get statistics');
      }
    } catch (e) {
      throw Exception('Error getting statistics: $e');
    }
  }

  /// Get pending actions for current admin
  Future<MyPendingActionsResponse> getMyPendingActions() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/admin/approvals/my-pending'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return MyPendingActionsResponse.fromJson(json);
      } else {
        _handleError(response, 'Get pending actions');
        throw Exception('Failed to get pending actions');
      }
    } catch (e) {
      throw Exception('Error getting pending actions: $e');
    }
  }

  /// Get requests submitted by current admin
  Future<ApprovalRequestListResponse> getMyRequests({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final uri = Uri.parse('$baseUrl/admin/approvals/my-requests')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalRequestListResponse.fromJson(json);
      } else {
        _handleError(response, 'Get my requests');
        throw Exception('Failed to get my requests');
      }
    } catch (e) {
      throw Exception('Error getting my requests: $e');
    }
  }

  // ==================== Configuration ====================

  /// Get approval configurations
  Future<List<ApprovalConfig>> getConfigs() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/admin/approvals/config'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final configs = json['configs'] as List;
        return configs
            .map((c) => ApprovalConfig.fromJson(c as Map<String, dynamic>))
            .toList();
      } else {
        _handleError(response, 'Get configs');
        throw Exception('Failed to get configs');
      }
    } catch (e) {
      throw Exception('Error getting configs: $e');
    }
  }

  // ==================== Audit ====================

  /// Get audit log for a request
  Future<ApprovalAuditLogResponse> getRequestAuditLog(
    String requestId, {
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final uri = Uri.parse('$baseUrl/admin/approvals/$requestId/audit')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalAuditLogResponse.fromJson(json);
      } else {
        _handleError(response, 'Get audit log');
        throw Exception('Failed to get audit log');
      }
    } catch (e) {
      throw Exception('Error getting audit log: $e');
    }
  }

  /// Get system-wide audit log
  Future<ApprovalAuditLogResponse> getSystemAuditLog({
    int page = 1,
    int pageSize = 50,
    DateTime? fromDate,
    DateTime? toDate,
    String? eventType,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (fromDate != null) queryParams['from_date'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['to_date'] = toDate.toIso8601String();
      if (eventType != null) queryParams['event_type'] = eventType;

      final uri = Uri.parse('$baseUrl/admin/approvals/audit')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApprovalAuditLogResponse.fromJson(json);
      } else {
        _handleError(response, 'Get system audit log');
        throw Exception('Failed to get system audit log');
      }
    } catch (e) {
      throw Exception('Error getting system audit log: $e');
    }
  }

  /// Dispose of resources
  void dispose() {
    _client.close();
  }
}
