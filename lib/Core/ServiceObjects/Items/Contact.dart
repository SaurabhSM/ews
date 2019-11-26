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

import 'dart:typed_data';

import 'package:ews/Attributes/ServiceObjectDefinitionAttribute.dart';
import 'package:ews/ComplexProperties/CompleteName.dart' as complex;
import 'package:ews/ComplexProperties/EmailAddress.dart';
import 'package:ews/ComplexProperties/EmailAddressCollection.dart';
import 'package:ews/ComplexProperties/EmailAddressDictionary.dart';
import 'package:ews/ComplexProperties/FileAttachment.dart';
import 'package:ews/ComplexProperties/ImAddressDictionary.dart';
import 'package:ews/ComplexProperties/ItemAttachment.dart';
import 'package:ews/ComplexProperties/ItemId.dart';
import 'package:ews/ComplexProperties/PhoneNumberDictionary.dart';
import 'package:ews/ComplexProperties/PhysicalAddressDictionary.dart';
import 'package:ews/ComplexProperties/StringList.dart';
import 'package:ews/Core/EwsUtilities.dart';
import 'package:ews/Core/ExchangeService.dart';
import 'package:ews/Core/PropertySet.dart';
import 'package:ews/Core/ServiceObjects/Items/Item.dart';
import 'package:ews/Core/ServiceObjects/Schemas/ContactSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/ItemSchema.dart';
import 'package:ews/Core/ServiceObjects/Schemas/ServiceObjectSchema.dart'
    as core;
import 'package:ews/Core/XmlElementNames.dart';
import 'package:ews/Enumerations/ContactSource.dart' as enumerations;
import 'package:ews/Enumerations/ExchangeVersion.dart';
import 'package:ews/Enumerations/FileAsMapping.dart' as enumerations;
import 'package:ews/Exceptions/PropertyException.dart';
import 'package:ews/misc/OutParam.dart';

/// <summary>
/// Represents a contact. Properties available on contacts are defined in the ContactSchema class.
/// </summary>
//    [Attachable]
//    [ServiceObjectDefinition(XmlElementNames.Contact)]
class Contact extends Item {
  /* private */
  static const String ContactPictureName = "ContactPicture.jpg";

  /// <summary>
  /// Initializes an unsaved local instance of <see cref="Contact"/>. To bind to an existing contact, use Contact.Bind() instead.
  /// </summary>
  /// <param name="service">The ExchangeService object to which the contact will be bound.</param>
  Contact(ExchangeService service) : super(service) {}

  /// <summary>
  /// Initializes a new instance of the <see cref="Contact"/> class.
  /// </summary>
  /// <param name="parentAttachment">The parent attachment.</param>
  Contact.withAttachment(ItemAttachment parentAttachment)
      : super.withAttachment(parentAttachment) {}

  /// <summary>
  /// Binds to an existing contact and loads the specified set of properties.
  /// Calling this method results in a call to EWS.
  /// </summary>
  /// <param name="service">The service to use to bind to the contact.</param>
  /// <param name="id">The Id of the contact to bind to.</param>
  /// <param name="propertySet">The set of properties to load.</param>
  /// <returns>A Contact instance representing the contact corresponding to the specified Id.</returns>
  static Future<Contact> BindWithItemIdAndPropertySet(
      ExchangeService service, ItemId id, PropertySet propertySet) {
    return service.BindToItemGeneric<Contact>(id, propertySet);
  }

  /// <summary>
  /// Binds to an existing contact and loads its first class properties.
  /// Calling this method results in a call to EWS.
  /// </summary>
  /// <param name="service">The service to use to bind to the contact.</param>
  /// <param name="id">The Id of the contact to bind to.</param>
  /// <returns>A Contact instance representing the contact corresponding to the specified Id.</returns>
  static Future<Contact> BindWithItemId(ExchangeService service, ItemId id) {
    return Contact.BindWithItemIdAndPropertySet(
        service, id, PropertySet.FirstClassProperties);
  }

  /// <summary>
  /// method to return the schema associated with this type of object.
  /// </summary>
  /// <returns>The schema associated with this type of object.</returns>
  @override
  core.ServiceObjectSchema GetSchema() {
    return ContactSchema.Instance;
  }

  /// <summary>
  /// Gets the minimum required server version.
  /// </summary>
  /// <returns>Earliest Exchange version in which this service object type is supported.</returns>
  @override
  ExchangeVersion GetMinimumRequiredServerVersion() {
    return ExchangeVersion.Exchange2007_SP1;
  }

  /// <summary>

  /// </summary>
  /// <param name="content">The bytes making up the picture.</param>
  void SetContactPicture(Uint8List content) {
    EwsUtilities.ValidateMethodVersion(
        this.Service, ExchangeVersion.Exchange2010, "SetContactPicture");

    InternalRemoveContactPicture();
    FileAttachment fileAttachment =
        Attachments.AddFileAttachmentWithContent(ContactPictureName, content);
    fileAttachment.IsContactPhoto = true;
  }

  /// <summary>

  /// </summary>
  /// <param name="contentStream">The stream containing the picture.</param>
// void SetContactPicture(Stream contentStream)
//        {
//            EwsUtilities.ValidateMethodVersion(this.Service, ExchangeVersion.Exchange2010, "SetContactPicture");
//
//            InternalRemoveContactPicture();
//            FileAttachment fileAttachment = Attachments.AddFileAttachment(ContactPictureName, contentStream);
//            fileAttachment.IsContactPhoto = true;
//        }

  /// <summary>

  /// </summary>
  /// <param name="fileName">The name of the file that contains the picture.</param>
// void SetContactPicture(String fileName)
//        {
//            EwsUtilities.ValidateMethodVersion(this.Service, ExchangeVersion.Exchange2010, "SetContactPicture");
//
//            InternalRemoveContactPicture();
//            FileAttachment fileAttachment = Attachments.AddFileAttachment(Path.GetFileName(fileName), fileName);
//            fileAttachment.IsContactPhoto = true;
//        }

  /// <summary>
  /// Retrieves the file attachment that holds the contact's picture.
  /// </summary>
  /// <returns>The file attachment that holds the contact's picture.</returns>
  FileAttachment GetContactPictureAttachment() {
    EwsUtilities.ValidateMethodVersion(this.Service,
        ExchangeVersion.Exchange2010, "GetContactPictureAttachment");

    if (!this.PropertyBag.IsPropertyLoaded(ItemSchema.Attachments)) {
      throw new PropertyException("Strings.AttachmentCollectionNotLoaded");
    }

    for (FileAttachment fileAttachment in this.Attachments) {
      if (fileAttachment.IsContactPhoto) {
        return fileAttachment;
      }
    }
    return null;
  }

  /// <summary>
  /// Removes the picture from local attachment collection.
  /// </summary>
  /* private */
  void InternalRemoveContactPicture() {
    // Iterates in reverse order to remove file attachments that have IsContactPhoto set to true.
    for (int index = this.Attachments.Count - 1; index >= 0; index--) {
      FileAttachment fileAttachment = this.Attachments[index] as FileAttachment;
      if (fileAttachment != null) {
        if (fileAttachment.IsContactPhoto) {
          this.Attachments.Remove(fileAttachment);
        }
      }
    }
  }

  /// <summary>
  /// Removes the contact's picture.
  /// </summary>
  void RemoveContactPicture() {
    EwsUtilities.ValidateMethodVersion(
        this.Service, ExchangeVersion.Exchange2010, "RemoveContactPicture");

    if (!this.PropertyBag.IsPropertyLoaded(ItemSchema.Attachments)) {
      throw new PropertyException("Strings.AttachmentCollectionNotLoaded");
    }

    InternalRemoveContactPicture();
  }

  /// <summary>
  /// Validates this instance.
  /// </summary>
  @override
  void Validate() {
    super.Validate();

    OutParam<Object> fileAsMappingOutParam = new OutParam();
    if (this
        .TryGetProperty(ContactSchema.FileAsMapping, fileAsMappingOutParam)) {
      // FileAsMapping is extended by 5 new values in 2010 mode. Validate that they are used according the version.
      EwsUtilities.ValidateEnumVersionValue(fileAsMappingOutParam, this.Service.RequestedServerVersion);
    }
  }

  /// <summary>
  /// Gets or set the name under which this contact is filed as. FileAs can be manually set or
  /// can be automatically calculated based on the value of the FileAsMapping property.
  /// </summary>
  String get FileAs => this.PropertyBag[ContactSchema.FileAs];

  set FileAs(String value) => this.PropertyBag[ContactSchema.FileAs] = value;

  /// <summary>
  /// Gets or sets a value indicating how the FileAs property should be automatically calculated.
  /// </summary>
  enumerations.FileAsMapping get FileAsMapping =>
      this.PropertyBag[ContactSchema.FileAsMapping];

  set FileAsMapping(enumerations.FileAsMapping value) =>
      this.PropertyBag[ContactSchema.FileAsMapping] = value;

  /// <summary>
  /// Gets or sets the display name of the contact.
  /// </summary>
  String get DisplayName => this.PropertyBag[ContactSchema.DisplayName];

  set DisplayName(String value) =>
      this.PropertyBag[ContactSchema.DisplayName] = value;

  /// <summary>
  /// Gets or sets the given name of the contact.
  /// </summary>
  String get GivenName => this.PropertyBag[ContactSchema.GivenName];

  set GivenName(String value) =>
      this.PropertyBag[ContactSchema.GivenName] = value;

  /// <summary>
  /// Gets or sets the initials of the contact.
  /// </summary>
  String get Initials => this.PropertyBag[ContactSchema.Initials];

  set Initials(String value) =>
      this.PropertyBag[ContactSchema.Initials] = value;

  /// <summary>
  /// Gets or sets the initials of the contact.
  /// </summary>
  String get MiddleName => this.PropertyBag[ContactSchema.MiddleName];

  set MiddleName(String value) =>
      this.PropertyBag[ContactSchema.MiddleName] = value;

  /// <summary>
  /// Gets or sets the middle name of the contact.
  /// </summary>
  String get NickName => this.PropertyBag[ContactSchema.NickName];

  set NickName(String value) =>
      this.PropertyBag[ContactSchema.NickName] = value;

  /// <summary>
  /// Gets the complete name of the contact.
  /// </summary>
  complex.CompleteName get CompleteName =>
      this.PropertyBag[ContactSchema.CompleteName];

  /// <summary>
  /// Gets or sets the compnay name of the contact.
  /// </summary>
  String get CompanyName => this.PropertyBag[ContactSchema.CompanyName];

  set CompanyName(String value) =>
      this.PropertyBag[ContactSchema.CompanyName] = value;

  /// <summary>
  /// Gets an indexed list of e-mail addresses for the contact. For example, to set the first e-mail address,
  /// use the following syntax: EmailAddresses[EmailAddressKey.EmailAddress1] = "john.doe@contoso.com"
  /// </summary>
  EmailAddressDictionary get EmailAddresses =>
      this.PropertyBag[ContactSchema.EmailAddresses];

  /// <summary>
  /// Gets an indexed list of physical addresses for the contact. For example, to set the business address,
  /// use the following syntax: PhysicalAddresses[PhysicalAddressKey.Business] = new PhysicalAddressEntry()
  /// </summary>
  PhysicalAddressDictionary get PhysicalAddresses =>
      this.PropertyBag[ContactSchema.PhysicalAddresses];

  /// <summary>
  /// Gets an indexed list of phone numbers for the contact. For example, to set the home phone number,
  /// use the following syntax: PhoneNumbers[PhoneNumberKey.HomePhone] = "phone number"
  /// </summary>
  PhoneNumberDictionary get PhoneNumbers =>
      this.PropertyBag[ContactSchema.PhoneNumbers];

  /// <summary>
  /// Gets or sets the contact's assistant name.
  /// </summary>
  String get AssistantName => this.PropertyBag[ContactSchema.AssistantName];

  set AssistantName(String value) =>
      this.PropertyBag[ContactSchema.AssistantName] = value;

  /// <summary>
  /// Gets or sets the birthday of the contact.
  /// </summary>
  DateTime get Birthday => this.PropertyBag[ContactSchema.Birthday];

  set Birthday(DateTime value) =>
      this.PropertyBag[ContactSchema.Birthday] = value;

  /// <summary>
  /// Gets or sets the business home page of the contact.
  /// </summary>
  String get BusinessHomePage =>
      this.PropertyBag[ContactSchema.BusinessHomePage];

  set BusinessHomePage(String value) =>
      this.PropertyBag[ContactSchema.BusinessHomePage] = value;

  /// <summary>
  /// Gets or sets a list of children for the contact.
  /// </summary>
  StringList get Children => this.PropertyBag[ContactSchema.Children];

  set Children(StringList value) =>
      this.PropertyBag[ContactSchema.Children] = value;

  /// <summary>
  /// Gets or sets a list of companies for the contact.
  /// </summary>
  StringList get Companies => this.PropertyBag[ContactSchema.Companies];

  set Companies(StringList value) =>
      this.PropertyBag[ContactSchema.Companies] = value;

  /// <summary>
  /// Gets the source of the contact.
  /// </summary>
  enumerations.ContactSource get ContactSource =>
      this.PropertyBag[ContactSchema.ContactSource];

  /// <summary>
  /// Gets or sets the department of the contact.
  /// </summary>
  String get Department => this.PropertyBag[ContactSchema.Department];

  set Department(String value) =>
      this.PropertyBag[ContactSchema.Department] = value;

  /// <summary>
  /// Gets or sets the generation of the contact.
  /// </summary>
  String get Generation => this.PropertyBag[ContactSchema.Generation];

  set Generation(String value) =>
      this.PropertyBag[ContactSchema.Generation] = value;

  /// <summary>
  /// Gets an indexed list of Instant Messaging addresses for the contact. For example, to set the first
  /// IM address, use the following syntax: ImAddresses[ImAddressKey.ImAddress1] = "john.doe@contoso.com"
  /// </summary>
  ImAddressDictionary get ImAddresses =>
      this.PropertyBag[ContactSchema.ImAddresses];

  /// <summary>
  /// Gets or sets the contact's job title.
  /// </summary>
  String get JobTitle => this.PropertyBag[ContactSchema.JobTitle];

  set JobTitle(String value) =>
      this.PropertyBag[ContactSchema.JobTitle] = value;

  /// <summary>
  /// Gets or sets the name of the contact's manager.
  /// </summary>
  String get Manager => this.PropertyBag[ContactSchema.Manager];

  set Manager(String value) => this.PropertyBag[ContactSchema.Manager] = value;

  /// <summary>
  /// Gets or sets the mileage for the contact.
  /// </summary>
  String get Mileage => this.PropertyBag[ContactSchema.Mileage];

  set Mileage(String value) => this.PropertyBag[ContactSchema.Mileage] = value;

  /// <summary>
  /// Gets or sets the location of the contact's office.
  /// </summary>
  String get OfficeLocation => this.PropertyBag[ContactSchema.OfficeLocation];

  set OfficeLocation(String value) =>
      this.PropertyBag[ContactSchema.OfficeLocation] = value;

  /// <summary>
  /// Gets or sets the index of the contact's postal address. When set, PostalAddressIndex refers to
  /// an entry in the PhysicalAddresses indexed list.
  /// </summary>
//        PhysicalAddressIndex? get PostalAddressIndex => this.PropertyBag[ContactSchema.PostalAddressIndex];
//        set PostalAddressIndex(PhysicalAddressIndex? value) => this.PropertyBag[ContactSchema.PostalAddressIndex] = value;

  /// <summary>
  /// Gets or sets the contact's profession.
  /// </summary>
  String get Profession => this.PropertyBag[ContactSchema.Profession];

  set Profession(String value) =>
      this.PropertyBag[ContactSchema.Profession] = value;

  /// <summary>
  /// Gets or sets the name of the contact's spouse.
  /// </summary>
  String get SpouseName => this.PropertyBag[ContactSchema.SpouseName];

  set SpouseName(String value) =>
      this.PropertyBag[ContactSchema.SpouseName] = value;

  /// <summary>
  /// Gets or sets the surname of the contact.
  /// </summary>
  String get Surname => this.PropertyBag[ContactSchema.Surname];

  set Surname(String value) => this.PropertyBag[ContactSchema.Surname] = value;

  /// <summary>
  /// Gets or sets the date of the contact's wedding anniversary.
  /// </summary>
  DateTime get WeddingAnniversary =>
      this.PropertyBag[ContactSchema.WeddingAnniversary];

  set WeddingAnniversary(DateTime value) =>
      this.PropertyBag[ContactSchema.WeddingAnniversary] = value;

  /// <summary>
  /// Gets a value indicating whether this contact has a picture associated with it.
  /// </summary>
  bool get HasPicture => this.PropertyBag[ContactSchema.HasPicture];

  /// <summary>
  /// Gets the full phonetic name from the directory
  /// </summary>
  String get PhoneticFullName =>
      this.PropertyBag[ContactSchema.PhoneticFullName];

  /// <summary>
  /// Gets the phonetic first name from the directory
  /// </summary>
  String get PhoneticFirstName =>
      this.PropertyBag[ContactSchema.PhoneticFirstName];

  /// <summary>
  /// Gets the phonetic last name from the directory
  /// </summary>
  String get PhoneticLastName =>
      this.PropertyBag[ContactSchema.PhoneticLastName];

  /// <summary>
  /// Gets the Alias from the directory
  /// </summary>
  String get Alias => this.PropertyBag[ContactSchema.Alias];

  /// <summary>
  /// Get the Notes from the directory
  /// </summary>
  String get Notes => this.PropertyBag[ContactSchema.Notes];

  /// <summary>
  /// Gets the Photo from the directory
  /// </summary>
// Uint8List get DirectoryPhoto => this.PropertyBag[ContactSchema.Photo];

  /// <summary>
  /// Gets the User SMIME certificate from the directory
  /// </summary>
// Uint8List[] UserSMIMECertificate
//        {
//            get
//            {
//                ByteArrayArray array = (ByteArrayArray)this.PropertyBag[ContactSchema.UserSMIMECertificate];
//                return array.Content;
//            }
//        }

  /// <summary>
  /// Gets the MSExchange certificate from the directory
  /// </summary>
// Uint8List[] get MSExchangeCertificate
//
//            {
//                ByteArrayArray array = (ByteArrayArray)this.PropertyBag[ContactSchema.MSExchangeCertificate];
//                return array.Content;
//            }

  /// <summary>
  /// Gets the DirectoryID as Guid or DN string
  /// </summary>
  String get DirectoryId => this.PropertyBag[ContactSchema.DirectoryId];

  /// <summary>
  /// Gets the manager mailbox information
  /// </summary>
  EmailAddress get ManagerMailbox =>
      this.PropertyBag[ContactSchema.ManagerMailbox];

  /// <summary>
  /// Get the direct reports mailbox information
  /// </summary>
  EmailAddressCollection get DirectReports =>
      this.PropertyBag[ContactSchema.DirectReports];

  @override
  ServiceObjectDefinitionAttribute getServiceObjectDefinitionAttribute() {
    return ServiceObjectDefinitionAttribute(XmlElementNames.Contact);
  }
}
