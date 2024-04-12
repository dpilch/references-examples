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
  final String id;
  final List<RelatedMany>? _relatedMany;
  final RelatedOne? _relatedOne;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  PrimaryModelIdentifier get modelIdentifier {
      return PrimaryModelIdentifier(
        id: id
      );
  }
  
  List<RelatedMany>? get relatedMany {
    return _relatedMany;
  }
  
  RelatedOne? get relatedOne {
    return _relatedOne;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Primary._internal({required this.id, relatedMany, relatedOne, createdAt, updatedAt}): _relatedMany = relatedMany, _relatedOne = relatedOne, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Primary({String? id, List<RelatedMany>? relatedMany, RelatedOne? relatedOne}) {
    return Primary._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      relatedMany: relatedMany != null ? List<RelatedMany>.unmodifiable(relatedMany) : relatedMany,
      relatedOne: relatedOne);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Primary &&
      id == other.id &&
      DeepCollectionEquality().equals(_relatedMany, other._relatedMany) &&
      _relatedOne == other._relatedOne;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Primary {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Primary copyWith({List<RelatedMany>? relatedMany, RelatedOne? relatedOne}) {
    return Primary._internal(
      id: id,
      relatedMany: relatedMany ?? this.relatedMany,
      relatedOne: relatedOne ?? this.relatedOne);
  }
  
  Primary copyWithModelFieldValues({
    ModelFieldValue<List<RelatedMany>?>? relatedMany,
    ModelFieldValue<RelatedOne?>? relatedOne
  }) {
    return Primary._internal(
      id: id,
      relatedMany: relatedMany == null ? this.relatedMany : relatedMany.value,
      relatedOne: relatedOne == null ? this.relatedOne : relatedOne.value
    );
  }
  
  Primary.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _relatedMany = json['relatedMany'] is List
        ? (json['relatedMany'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => RelatedMany.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _relatedOne = json['relatedOne']?['serializedData'] != null
        ? RelatedOne.fromJson(new Map<String, dynamic>.from(json['relatedOne']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'relatedMany': _relatedMany?.map((RelatedMany? e) => e?.toJson()).toList(), 'relatedOne': _relatedOne?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'relatedMany': _relatedMany,
    'relatedOne': _relatedOne,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<PrimaryModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<PrimaryModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final RELATEDMANY = amplify_core.QueryField(
    fieldName: "relatedMany",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'RelatedMany'));
  static final RELATEDONE = amplify_core.QueryField(
    fieldName: "relatedOne",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'RelatedOne'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Primary";
    modelSchemaDefinition.pluralName = "Primaries";
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["id"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Primary.RELATEDMANY,
      isRequired: false,
      ofModelName: 'RelatedMany',
      associatedKey: RelatedMany.PRIMARYID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: Primary.RELATEDONE,
      isRequired: false,
      ofModelName: 'RelatedOne',
      associatedKey: RelatedOne.PRIMARYID
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
  final String id;

  /** Create an instance of PrimaryModelIdentifier using [id] the primary key. */
  const PrimaryModelIdentifier({
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
  String toString() => 'PrimaryModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is PrimaryModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}