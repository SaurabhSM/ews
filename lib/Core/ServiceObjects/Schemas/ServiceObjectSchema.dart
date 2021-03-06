/*
 * Exchange Web Services Managed API
 *
 * Copyright (c) Microsoft Corporation
 * All rights reserved.
 *
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation files (the "Software"), to deal in the Software
 * without restriction, including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
 * to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

import 'dart:collection';

import 'package:ews/ComplexProperties/ExtendedPropertyCollection.dart';
import 'package:ews/Core/LazyMember.dart';
import 'package:ews/Core/ServiceObjects/Schemas/AppointmentSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/CalendarResponseObjectSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/CancelMeetingMessageSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/ContactGroupSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/ContactSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/ConversationSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/EmailMessageSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/FolderSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/ItemSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/MeetingCancellationSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/MeetingMessageSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/MeetingRequestSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/MeetingResponseSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/PersonaSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/PostItemSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/PostReplySchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/ResponseMessageSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/ResponseObjectSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/SearchFolderSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/TaskSchema.dart';
import 'package:ews/Core/XmlElementNames.dart';
import 'package:ews/Enumerations/ExchangeVersion.dart';
import 'package:ews/Enumerations/PropertyDefinitionFlags.dart';
import 'package:ews/PropertyDefinitions/ComplexPropertyDefinition.dart';
import 'package:ews/PropertyDefinitions/IndexedPropertyDefinition.dart';
import 'package:ews/PropertyDefinitions/PropertyDefinition.dart';
import 'package:ews/PropertyDefinitions/PropertyDefinitionBase.dart';
import 'package:ews/misc/OutParam.dart';

/// <summary>
/// Delegate that takes a property definition and matching static field info.
/// </summary>
/// <param name="propertyDefinition">Property definition.</param>
/// <param name="fieldInfo">Field info.</param>
typedef void PropertyFieldInfoDelegate(PropertyDefinition, FieldInfo);

//typedef LazyMember<Map<String, PropertyDefinitionBase>> = LazyMember<Map<String, PropertyDefinitionBase>>;
//typedef SchemaTypeList = LazyMember<System.Collections.Generic.List<System.Type>>;

/// <summary>
/// Represents the base class for all item and folder schemas.
/// </summary>
abstract class ServiceObjectSchema
    with IterableMixin<PropertyDefinition>
    implements Iterable<PropertyDefinition> {
  static Object _lockObject = new Object();

  /// <summary>
  /// List of all schema types.
  /// </summary>
  /// <remarks>
  /// If you add a new ServiceObject subclass that has an associated schema, add the schema type
  /// to the list below.
  /// </remarks>
  static LazyMember<List<Type>> _allSchemaTypes = LazyMember<List<Type>>(() {
    return [
      AppointmentSchema,
      CalendarResponseObjectSchema,
      CancelMeetingMessageSchema,
      ContactGroupSchema,
      ContactSchema,
      ConversationSchema,
      EmailMessageSchema,
      FolderSchema,
      ItemSchema,
      MeetingMessageSchema,
      MeetingRequestSchema,
      MeetingCancellationSchema,
      MeetingResponseSchema,
      PersonaSchema,
      PostItemSchema,
      PostReplySchema,
      ResponseMessageSchema,
      ResponseObjectSchema,
      ServiceObjectSchema,
      SearchFolderSchema,
      TaskSchema
    ];
  });

  /// <summary>
  /// Dictionary of all property definitions.
  /// </summary>
  static LazyMember<Map<String, PropertyDefinitionBase>> _allSchemaProperties =
      new LazyMember<Map<String, PropertyDefinitionBase>>(() {
    Map<String, PropertyDefinitionBase> propDefDictionary =
        new Map<String, PropertyDefinitionBase>();
    for (Type type in ServiceObjectSchema._allSchemaTypes.Member) {
      ServiceObjectSchema.AddSchemaPropertiesToDictionary(
          type, propDefDictionary);
    }
    return propDefDictionary;
  });

  /// <summary>
  /// Call delegate for each public static PropertyDefinition field in type.
  /// </summary>
  /// <param name="type">The type.</param>
  /// <param name="propFieldDelegate">The property field delegate.</param>
//        static void ForeachPublicStaticPropertyFieldInType(Type type, PropertyFieldInfoDelegate propFieldDelegate)
//        {
//            FieldInfo[] fieldInfos = type.GetFields(BindingFlags.Static | BindingFlags.Public | BindingFlags.DeclaredOnly);
//
//            for (FieldInfo fieldInfo in fieldInfos)
//            {
//                if (fieldInfo.FieldType == typeof(PropertyDefinition) || fieldInfo.FieldType.IsSubclassOf(typeof(PropertyDefinition)))
//                {
//                    PropertyDefinition propertyDefinition = (PropertyDefinition)fieldInfo.GetValue(null);
//                    propFieldDelegate(propertyDefinition, fieldInfo);
//                }
//            }
//        }

  /// <summary>
  /// Adds schema properties to dictionary.
  /// </summary>
  /// <param name="type">Schema type.</param>
  /// <param name="propDefDictionary">The property definition dictionary.</param>
  static void AddSchemaPropertiesToDictionary(
      Type type, Map<String, PropertyDefinitionBase> propDefDictionary) {
//            ServiceObjectSchema.ForeachPublicStaticPropertyFieldInType(
//                type,
//                (propertyDefinition, fieldInfo) {
//                    // Some property definitions descend from ServiceObjectPropertyDefinition but don't have
//                    // a Uri, like ExtendedProperties. Ignore them.
//                    if (propertyDefinition.Uri != null && propertyDefinition.Uri.isNotEmpty))
//                    {
//                        PropertyDefinitionBase existingPropertyDefinition;
//                        if (propDefDictionary.TryGetValue(propertyDefinition.Uri, out existingPropertyDefinition))
//                        {
//                            EwsUtilities.Assert(
//                                existingPropertyDefinition == propertyDefinition,
//                                "Schema.allSchemaProperties.delegate",
//                                string.Format("There are at least two distinct property definitions with the following URI: {0}", propertyDefinition.Uri));
//                        }
//                        else
//                        {
//                            propDefDictionary.Add(propertyDefinition.Uri, propertyDefinition);
//
//                            // The following is a "generic hack" to register properties that are not public and
//                            // thus not returned by the above GetFields call. It is currently solely used to register
//                            // the MeetingTimeZone property.
//                            List<PropertyDefinition> associatedInternalProperties = propertyDefinition.GetAssociatedInternalProperties();
//
//                            for (PropertyDefinition associatedInternalProperty in associatedInternalProperties)
//                            {
//                                propDefDictionary.Add(associatedInternalProperty.Uri, associatedInternalProperty);
//                            }
//                        }
//                    }
//                });
  }

  /// <summary>
  /// Adds the schema property names to dictionary.
  /// </summary>
  /// <param name="type">The type.</param>
  /// <param name="propertyNameDictionary">The property name dictionary.</param>
  static void _AddSchemaPropertyNamesToDictionary(
      Type type, Map<PropertyDefinition, String> propertyNameDictionary) {
//            ServiceObjectSchema.ForeachPublicStaticPropertyFieldInType(
//                type,
//                delegate(PropertyDefinition propertyDefinition, FieldInfo fieldInfo)
//                { propertyNameDictionary.Add(propertyDefinition, fieldInfo.Name); });
  }

  /// <summary>
  /// Initializes a new instance of the <see cref="ServiceObjectSchema"/> class.
  /// </summary>
  ServiceObjectSchema() {
    this.RegisterProperties();
  }

  /// <summary>
  /// Finds the property definition.
  /// </summary>
  /// <param name="uri">The URI.</param>
  /// <returns>Property definition.</returns>
  static PropertyDefinitionBase FindPropertyDefinition(String uri) {
    return ServiceObjectSchema._allSchemaProperties.Member[uri];
  }

  /// <summary>
  /// Initialize schema property names.
  /// </summary>
  static void InitializeSchemaPropertyNames() {
    lock(lockObject) {
      for (Type type in ServiceObjectSchema._allSchemaTypes.Member) {
//                    ServiceObjectSchema.ForeachPublicStaticPropertyFieldInType(
//                        type,
//                        delegate(PropertyDefinition propDef, FieldInfo fieldInfo) { propDef.Name = fieldInfo.Name; });
      }
    }
  }

  /// <summary>
  /// Defines the ExtendedProperties property.
  /// </summary>
  static PropertyDefinition ExtendedProperties =
      ComplexPropertyDefinition<ExtendedPropertyCollection>.withFlags(
          XmlElementNames.ExtendedProperty,
          [
            PropertyDefinitionFlags.AutoInstantiateOnRead,
            PropertyDefinitionFlags.ReuseInstance,
            PropertyDefinitionFlags.CanSet,
            PropertyDefinitionFlags.CanUpdate
          ],
          ExchangeVersion.Exchange2007_SP1, () {
    return new ExtendedPropertyCollection();
  });

  Map<String, PropertyDefinition> _properties =
      new Map<String, PropertyDefinition>();

  List<PropertyDefinition> _visibleProperties = new List<PropertyDefinition>();

  List<PropertyDefinition> _firstClassProperties =
      new List<PropertyDefinition>();

  List<PropertyDefinition> _firstClassSummaryProperties =
      new List<PropertyDefinition>();

  List<IndexedPropertyDefinition> _indexedProperties =
      new List<IndexedPropertyDefinition>();

  /// <summary>
  /// Registers a schema property.
  /// </summary>
  /// <param name="property">The property to register.</param>
  /// <param name="isInternal">Indicates whether the property is or should be visible to developers.</param>
  void _RegisterPropertyWithInternal(
      PropertyDefinition property, bool isInternal) {
    this._properties[property.XmlElementName] = property;

    if (!isInternal) {
      this._visibleProperties.add(property);
    }

    // If this property does not have to be requested explicitly, add
    // it to the list of firstClassProperties.
    if (!property.HasFlagWithoutExchangeVersion(
        PropertyDefinitionFlags.MustBeExplicitlyLoaded)) {
      this._firstClassProperties.add(property);
    }

    // If this property can be found, add it to the list of firstClassSummaryProperties
    if (property.HasFlagWithoutExchangeVersion(
        PropertyDefinitionFlags.CanFind)) {
      this._firstClassSummaryProperties.add(property);
    }
  }

  /// <summary>
  /// Registers a schema property that will be visible to developers.
  /// </summary>
  /// <param name="property">The property to register.</param>
  void RegisterProperty(PropertyDefinition property) {
    this._RegisterPropertyWithInternal(property, false);
  }

  /// <summary>
  /// Registers an schema property.
  /// </summary>
  /// <param name="property">The property to register.</param>
  void RegisterInternalProperty(PropertyDefinition property) {
    this._RegisterPropertyWithInternal(property, true);
  }

  /// <summary>
  /// Registers an indexed property.
  /// </summary>
  /// <param name="indexedProperty">The indexed property to register.</param>
  void RegisterIndexedProperty(IndexedPropertyDefinition indexedProperty) {
    this._indexedProperties.add(indexedProperty);
  }

  /// <summary>
  /// Registers properties.
  /// </summary>
  void RegisterProperties() {}

  /// <summary>
  /// Gets the list of first class properties for this service object type.
  /// </summary>
  List<PropertyDefinition> get FirstClassProperties =>
      this._firstClassProperties;

  /// <summary>
  /// Gets the list of first class summary properties for this service object type.
  /// </summary>
  List<PropertyDefinition> get FirstClassSummaryProperties =>
      this._firstClassSummaryProperties;

  /// <summary>
  /// Gets the list of indexed properties for this service object type.
  /// </summary>
  List<IndexedPropertyDefinition> get IndexedProperties =>
      this._indexedProperties;

  /// <summary>
  /// Tries to get property definition.
  /// </summary>
  /// <param name="xmlElementName">Name of the XML element.</param>
  /// <param name="propertyDefinition">The property definition.</param>
  /// <returns>True if property definition exists.</returns>
  bool TryGetPropertyDefinition(String xmlElementName,
      OutParam<PropertyDefinition> propertyDefinitionOutParam) {
    if (this._properties.containsKey(xmlElementName)) {
      propertyDefinitionOutParam.param = this._properties[xmlElementName];
      return true;
    } else {
      return false;
    }
  }

  /// <summary>
  /// Obtains an enumerator for the properties of the schema.
  /// </summary>
  /// <returns>An IEnumerator instance.</returns>
  Iterator<PropertyDefinition> get iterator => this._visibleProperties.iterator;
// Iterable<PropertyDefinition> GetEnumerator()
//        {
//            return this.visibleProperties.GetEnumerator();
//        }

  /// <summary>
  /// Obtains an enumerator for the properties of the schema.
  /// </summary>
  /// <returns>An IEnumerator instance.</returns>
//        System.Collections.IEnumerator System.Collections.Iterable.GetEnumerator()
//        {
//            return this.visibleProperties.GetEnumerator();
//        }
}
