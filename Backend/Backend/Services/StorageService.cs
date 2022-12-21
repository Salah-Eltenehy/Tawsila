using Azure.Storage.Blobs;
using Azure.Storage.Sas;
using Backend.Models.Settings;
using Microsoft.Extensions.Options;

namespace Backend.Services;

public interface IStorageService
{
    Task<string> UploadStream(string containerName, Stream stream, string extension);
    Task<string[]> UploadStreams(string containerName, Stream[] stream, string extension);
    string GetBlobUrl(string containerName, string fileName);
    string[] GetBlobsUrls(string containerName, string[] fileNames);
    
}

public class StorageService : IStorageService
{
    private readonly StorageSettings _storageSettings;

    public StorageService(IOptions<StorageSettings> storageSettings)
    {
        _storageSettings = storageSettings.Value;
    }

    public async Task<string> UploadStream(string containerName, Stream stream, string extension)
    {
        BlobServiceClient blobServiceClient = new(_storageSettings.ConnectionString);
        BlobContainerClient containerClient = blobServiceClient.GetBlobContainerClient(containerName);
        string fileName = Guid.NewGuid().ToString() + extension;
        BlobClient blobClient = containerClient.GetBlobClient(fileName);
        await blobClient.UploadAsync(stream);

        return fileName;
    }

    public async Task<string[]> UploadStreams(string containerName, Stream[] stream, string extension)
    {
        string[] fileNames = new string[stream.Length];
        BlobServiceClient blobServiceClient = new(_storageSettings.ConnectionString);
        BlobContainerClient containerClient = blobServiceClient.GetBlobContainerClient(containerName);
        for (int i = 0; i < stream.Length; i++)
        {
            string fileName = Guid.NewGuid().ToString() + extension;
            BlobClient blobClient = containerClient.GetBlobClient(fileName);
            await blobClient.UploadAsync(stream[i]);
            fileNames[i] = fileName;
        }

        return fileNames;
    }

    public string GetBlobUrl(string containerName, string fileName)
    {
        BlobServiceClient blobServiceClient = new(_storageSettings.ConnectionString);
        BlobContainerClient containerClient = blobServiceClient.GetBlobContainerClient(containerName);
        BlobClient blobClient = containerClient.GetBlobClient(fileName);
        BlobSasBuilder blobSasBuilder = new()
        {
            StartsOn = DateTime.UtcNow.Subtract(TimeSpan.FromMinutes(5)),
            ExpiresOn = DateTime.UtcNow.Add(TimeSpan.FromMinutes(60)),
            BlobContainerName = containerName,
            BlobName = fileName,
        };
        blobSasBuilder.SetPermissions(BlobSasPermissions.Read);
        string url = blobClient.GenerateSasUri(blobSasBuilder).ToString();

        return url;
    }

    public string[] GetBlobsUrls(string containerName, string[] fileNames)
    {
        string[] urls = new string[fileNames.Length];
        BlobServiceClient blobServiceClient = new(_storageSettings.ConnectionString);
        BlobContainerClient containerClient = blobServiceClient.GetBlobContainerClient(containerName);
        for (int i = 0; i < fileNames.Length; i++)
        {
            BlobClient blobClient = containerClient.GetBlobClient(fileNames[i]);
            BlobSasBuilder blobSasBuilder = new()
            {
                StartsOn = DateTime.UtcNow.Subtract(TimeSpan.FromMinutes(5)),
                ExpiresOn = DateTime.UtcNow.Add(TimeSpan.FromMinutes(60)),
                BlobContainerName = containerName,
                BlobName = fileNames[i],
            };
            blobSasBuilder.SetPermissions(BlobSasPermissions.Read);
            urls[i] = blobClient.GenerateSasUri(blobSasBuilder).ToString();
        }

        return urls;
    }
}
