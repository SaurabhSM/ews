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
    /// Represents information for a managed folder.
    /// </summary>
 class ManagedFolderInformation extends ComplexProperty
    {
        /* private */ bool? canDelete;
        /* private */ bool? canRenameOrMove;
        /* private */ bool? mustDisplayComment;
        /* private */ bool? hasQuota;
        /* private */ bool? isManagedFoldersRoot;
        /* private */ String managedFolderId;
        /* private */ String comment;
        /* private */ int? storageQuota;
        /* private */ int? folderSize;
        /* private */ String homePage;

        /// <summary>
        /// Initializes a new instance of the <see cref="ManagedFolderInformation"/> class.
        /// </summary>
        ManagedFolderInformation()
            : super()
        {
        }

        /// <summary>
        /// Tries to read element from XML.
        /// </summary>
        /// <param name="reader">The reader.</param>
        /// <returns>True if element was read.</returns>
@override
        bool TryReadElementFromXml(EwsServiceXmlReader reader)
        {
            switch (reader.LocalName)
            {
                case XmlElementNames.CanDelete:
                    this.canDelete = reader.ReadValue<bool>();
                    return true;
                case XmlElementNames.CanRenameOrMove:
                    this.canRenameOrMove = reader.ReadValue<bool>();
                    return true;
                case XmlElementNames.MustDisplayComment:
                    this.mustDisplayComment = reader.ReadValue<bool>();
                    return true;
                case XmlElementNames.HasQuota:
                    this.hasQuota = reader.ReadValue<bool>();
                    return true;
                case XmlElementNames.IsManagedFoldersRoot:
                    this.isManagedFoldersRoot = reader.ReadValue<bool>();
                    return true;
                case XmlElementNames.ManagedFolderId:
                    this.managedFolderId = reader.ReadValue();
                    return true;
                case XmlElementNames.Comment:
                    reader.TryReadValue(ref this.comment);
                    return true;
                case XmlElementNames.StorageQuota:
                    this.storageQuota = reader.ReadValue<int>();
                    return true;
                case XmlElementNames.FolderSize:
                    this.folderSize = reader.ReadValue<int>();
                    return true;
                case XmlElementNames.HomePage:
                    reader.TryReadValue(ref this.homePage);
                    return true;
                default:
                    return false;
            }
        }

        /// <summary>
        /// Gets a value indicating whether the user can delete objects in the folder.
        /// </summary>
 bool? CanDelete
        {
            get { return this.canDelete; }
        }

        /// <summary>
        /// Gets a value indicating whether the user can rename or move objects in the folder.
        /// </summary>
 bool? CanRenameOrMove
        {
            get { return this.canRenameOrMove; }
        }

        /// <summary>
        /// Gets a value indicating whether the client application must display the Comment property to the user.
        /// </summary>
 bool? MustDisplayComment
        {
            get { return this.mustDisplayComment; }
        }

        /// <summary>
        /// Gets a value indicating whether the folder has a quota.
        /// </summary>
 bool? HasQuota
        {
            get { return this.hasQuota; }
        }

        /// <summary>
        /// Gets a value indicating whether the folder is the root of the managed folder hierarchy.
        /// </summary>
 bool? IsManagedFoldersRoot
        {
            get { return this.isManagedFoldersRoot; }
        }

        /// <summary>
        /// Gets the Managed Folder Id of the folder.
        /// </summary>
 String ManagedFolderId
        {
            get { return this.managedFolderId; }
        }

        /// <summary>
        /// Gets the comment associated with the folder.
        /// </summary>
 String Comment
        {
            get { return this.comment; }
        }

        /// <summary>
        /// Gets the storage quota of the folder.
        /// </summary>
 int? StorageQuota
        {
            get { return this.storageQuota; }
        }

        /// <summary>
        /// Gets the size of the folder.
        /// </summary>
 int? FolderSize
        {
            get { return this.folderSize; }
        }

        /// <summary>
        /// Gets the home page associated with the folder.
        /// </summary>
 String HomePage
        {
            get { return this.homePage; }
        }
    }
