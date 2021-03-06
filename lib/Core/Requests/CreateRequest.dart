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

import 'package:ews/ComplexProperties/FolderId.dart';
import 'package:ews/Core/EwsServiceXmlWriter.dart';
import 'package:ews/Core/EwsUtilities.dart';
import 'package:ews/Core/ExchangeService.dart';
import 'package:ews/Core/Requests/MultiResponseServiceRequest.dart';
import 'package:ews/Core/Responses/ServiceResponse.dart';
import 'package:ews/Core/ServiceObjects/ServiceObject.dart';
import 'package:ews/Enumerations/ServiceErrorHandling.dart';
import 'package:ews/Enumerations/XmlNamespace.dart';

/// <summary>
/// Represents an Create request.
/// </summary>
/// <typeparam name="TServiceObject">The type of the service object.</typeparam>
/// <typeparam name="TResponse">The type of the response.</typeparam>
abstract class CreateRequest<TServiceObject extends ServiceObject,
        TResponse extends ServiceResponse>
    extends MultiResponseServiceRequest<
        TResponse> //        where TServiceObject : ServiceObject
//        where TResponse : ServiceResponse
{
  FolderId _parentFolderId;

  Iterable<TServiceObject> _objects;

  /// <summary>
  /// Initializes a new instance of the <see cref="CreateRequest&lt;TServiceObject, TResponse&gt;"/> class.
  /// </summary>
  /// <param name="service">The service.</param>
  /// <param name="errorHandlingMode"> Indicates how errors should be handled.</param>
  CreateRequest(ExchangeService service, ServiceErrorHandling errorHandlingMode)
      : super(service, errorHandlingMode) {}

  /// <summary>
  /// Validate request.
  /// </summary>
  @override
  void Validate() {
    super.Validate();
    if (this.ParentFolderId != null) {
      this
          .ParentFolderId
          .ValidateExchangeVersion(this.Service.RequestedServerVersion);
    }
  }

  /// <summary>
  /// Gets the expected response message count.
  /// </summary>
  /// <returns>Number of responses expected.</returns>
  @override
  int GetExpectedResponseMessageCount() {
    return EwsUtilities.GetEnumeratedObjectCount(this._objects);
  }

  /// <summary>
  /// Gets the name of the parent folder XML element.
  /// </summary>
  /// <returns>XML element name.</returns>
  String GetParentFolderXmlElementName();

  /// <summary>
  /// Gets the name of the object collection XML element.
  /// </summary>
  /// <returns>XML element name.</returns>
  String GetObjectCollectionXmlElementName();

  /// <summary>
  /// Writes XML elements.
  /// </summary>
  /// <param name="writer">The writer.</param>
  @override
  void WriteElementsToXml(EwsServiceXmlWriter writer) {
    if (this.ParentFolderId != null) {
      writer.WriteStartElement(
          XmlNamespace.Messages, this.GetParentFolderXmlElementName());
      this.ParentFolderId.WriteToXmlElemenetName(writer);
      writer.WriteEndElement();
    }

    writer.WriteStartElement(
        XmlNamespace.Messages, this.GetObjectCollectionXmlElementName());
    for (ServiceObject obj in this._objects) {
      obj.WriteToXml(writer);
    }
    writer.WriteEndElement();
  }

  /// <summary>
  /// Gets or sets the service objects.
  /// </summary>
  /// <value>The objects.</value>
  Iterable<TServiceObject> get Objects => this._objects;

  set Objects(Iterable<TServiceObject> value) {
    this._objects = value;
  }

  /// <summary>
  /// Gets or sets the parent folder id.
  /// </summary>
  /// <value>The parent folder id.</value>
  FolderId get ParentFolderId => this._parentFolderId;

  set ParentFolderId(FolderId value) {
    this._parentFolderId = value;
  }
}
