/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Primary type in your schema. */
class Primary extends amplify_core.Model {
  static const classType = const _PrimaryModelType();
  final String? _tenantId;
  final String? _instanceId;
  final String? _recordId;
  final String? _content;
  final List<Related>? _related;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => modelIdentifier.serializeAsString();
  
  PrimaryModelIdentifier get modelIdentifier {
    try {
      return PrimaryModelIdentifier(
        tenantId: _tenantId!,
        instanceId: _instanceId!,
        recordId: _recordId!
      );
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get tenantId {
    try {
      return _tenantId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get instanceId {
    try {
      return _instanceId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get recordId {
    try {
      return _recordId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get content {
    return _content;
  }
  
  List<Related>? get related {
    return _related;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Primary._internal({required tenantId, required instanceId, required recordId, content, related, createdAt, updatedAt}): _tenantId = tenantId, _instanceId = instanceId, _recordId = recordId, _content = content, _related = related, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Primary({required String tenantId, required String instanceId, required String recordId, String? content, List<Related>? related}) {
    return Primary._internal(
      tenantId: tenantId,
      instanceId: instanceId,
      recordId: recordId,
      content: content,
      related: related != null ? List<Related>.unmodifiable(related) : related);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Primary &&
      _tenantId == other._tenantId &&
      _instanceId == other._instanceId &&
      _recordId == other._recordId &&
      _content == other._content &&
      DeepCollectionEquality().equals(_related, other._related);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Primary {");
    buffer.write("tenantId=" + "$_tenantId" + ", ");
    buffer.write("instanceId=" + "$_instanceId" + ", ");
    buffer.write("recordId=" + "$_recordId" + ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Primary copyWith({String? content, List<Related>? related}) {
    return Primary._internal(
      tenantId: tenantId,
      instanceId: instanceId,
      recordId: recordId,
      content: content ?? this.content,
      related: related ?? this.related);
  }
  
  Primary copyWithModelFieldValues({
    ModelFieldValue<String?>? content,
    ModelFieldValue<List<Related>>? related
  }) {
    return Primary._internal(
      tenantId: tenantId,
      instanceId: instanceId,
      recordId: recordId,
      content: content == null ? this.content : content.value,
      related: related == null ? this.related : related.value
    );
  }
  
  Primary.fromJson(Map<String, dynamic> json)  
    : _tenantId = json['tenantId'],
      _instanceId = json['instanceId'],
      _recordId = json['recordId'],
      _content = json['content'],
      _related = json['related'] is List
        ? (json['related'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Related.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'tenantId': _tenantId, 'instanceId': _instanceId, 'recordId': _recordId, 'content': _content, 'related': _related?.map((Related? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'tenantId': _tenantId,
    'instanceId': _instanceId,
    'recordId': _recordId,
    'content': _content,
    'related': _related,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<PrimaryModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<PrimaryModelIdentifier>();
  static final TENANTID = amplify_core.QueryField(fieldName: "tenantId");
  static final INSTANCEID = amplify_core.QueryField(fieldName: "instanceId");
  static final RECORDID = amplify_core.QueryField(fieldName: "recordId");
  static final CONTENT = amplify_core.QueryField(fieldName: "content");
  static final RELATED = amplify_core.QueryField(
    fieldName: "related",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Related'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Primary";
    modelSchemaDefinition.pluralName = "Primaries";
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["tenantId", "instanceId", "recordId"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Primary.TENANTID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Primary.INSTANCEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Primary.RECORDID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Primary.CONTENT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Primary.RELATED,
      isRequired: true,
      ofModelName: 'Related',
      associatedKey: Related.PRIMARYTENANTID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _PrimaryModelType extends amplify_core.ModelType<Primary> {
  const _PrimaryModelType();
  
  @override
  Primary fromJson(Map<String, dynamic> jsonData) {
    return Primary.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Primary';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Primary] in your schema.
 */
class PrimaryModelIdentifier implements amplify_core.ModelIdentifier<Primary> {
  final String tenantId;
  final String instanceId;
  final String recordId;

  /**
   * Create an instance of PrimaryModelIdentifier using [tenantId] the primary key.
   * And [instanceId], [recordId] the sort keys.
   */
  const PrimaryModelIdentifier({
    required this.tenantId,
    required this.instanceId,
    required this.recordId});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'tenantId': tenantId,
    'instanceId': instanceId,
    'recordId': recordId
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'PrimaryModelIdentifier(tenantId: $tenantId, instanceId: $instanceId, recordId: $recordId)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is PrimaryModelIdentifier &&
      tenantId == other.tenantId &&
      instanceId == other.instanceId &&
      recordId == other.recordId;
  }
  
  @override
  int get hashCode =>
    tenantId.hashCode ^
    instanceId.hashCode ^
    recordId.hashCode;
}