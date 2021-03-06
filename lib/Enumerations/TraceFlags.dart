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

/// <summary>
/// Defines flags to control tracing details.
/// </summary>
//    [Flags]
enum TraceFlags {
  /// <summary>
  /// No tracing.
  /// </summary>
//  None,

  /// <summary>
  /// Trace EWS request messages.
  /// </summary>
  EwsRequest,

  /// <summary>
  /// Trace EWS response messages.
  /// </summary>
  EwsResponse,

  /// <summary>
  /// Trace EWS response HTTP headers.
  /// </summary>
  EwsResponseHttpHeaders,

  /// <summary>
  /// Trace Autodiscover request messages.
  /// </summary>
  AutodiscoverRequest,

  /// <summary>
  /// Trace Autodiscover response messages.
  /// </summary>
  AutodiscoverResponse,

  /// <summary>
  /// Trace Autodiscover response HTTP headers.
  /// </summary>
  AutodiscoverResponseHttpHeaders,

  /// <summary>
  /// Trace Autodiscover configuration logic.
  /// </summary>
  AutodiscoverConfiguration,

  /// <summary>
  /// Trace messages used in debugging the Exchange Web Services Managed API
  /// </summary>
  DebugMessage,

  /// <summary>
  /// Trace EWS request HTTP headers.
  /// </summary>
  EwsRequestHttpHeaders,

  /// <summary>
  /// Trace Autodiscover request HTTP headers.
  /// </summary>
  AutodiscoverRequestHttpHeaders,

  /// <summary>
  /// Trace EWS timezone related logic.
  /// </summary>
  EwsTimeZones

  /// <summary>
  /// All trace types enabled.
  /// </summary>
//        All = Int64.MaxValue,
}
