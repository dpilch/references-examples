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


/** This is an auto generated class representing the RelatedOne type in your schema. */
class RelatedOne extends amplify_core.Model {
  static const classType = const _RelatedOneModelType();
  final String id;
  final Primary? _primary;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  RelatedOneModelIdentifier get modelIdentifier {
      return RelatedOneModelIdentifier(
        id: id
      );
  }
  
  Primary? get primary {
    return _primary;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const RelatedOne._internal({required this.id, primary, createdAt, updatedAt}): _primary = primary, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory RelatedOne({String? id, Primary? primary}) {
    return RelatedOne._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      primary: primary);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelatedOne &&
      id == other.id &&
      _primary == other._primary;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("RelatedOne {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("primary=" + (_primary != null ? _primary!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  RelatedOne copyWith({Primary? primary}) {
    return RelatedOne._internal(
      id: id,
      primary: primary ?? this.primary);
  }
  
  RelatedOne copyWithModelFieldValues({
    ModelFieldValue<Primary?>? primary
  }) {
    return RelatedOne._internal(
      id: id,
      primary: primary == null ? this.primary : primary.value
    );
  }
  
  RelatedOne.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _primary = json['primary']?['serializedData'] != null
        ? Primary.fromJson(new Map<String, dynamic>.from(json['primary']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'primary': _primary?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'primary': _primary,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<RelatedOneModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<RelatedOneModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final PRIMARY = amplify_core.QueryField(
    fieldName: "primary",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Primary'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "RelatedOne";
    modelSchemaDefinition.pluralName = "RelatedOnes";
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["id"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: RelatedOne.PRIMARY,
      isRequired: false,
      targetNames: ['primaryId'],
      ofModelName: 'Primary'
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

class _RelatedOneModelType extends amplify_core.ModelType<RelatedOne> {
  const _RelatedOneModelType();
  
  @override
  RelatedOne fromJson(Map<String, dynamic> jsonData) {
    return RelatedOne.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'RelatedOne';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [RelatedOne] in your schema.
 */
class RelatedOneModelIdentifier implements amplify_core.ModelIdentifier<RelatedOne> {
  final String id;

  /** Create an instance of RelatedOneModelIdentifier using [id] the primary key. */
  const RelatedOneModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'RelatedOneModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is RelatedOneModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}