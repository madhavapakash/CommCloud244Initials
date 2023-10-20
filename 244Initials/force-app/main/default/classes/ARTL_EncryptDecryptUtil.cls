public without sharing class ARTL_EncryptDecryptUtil {
    public static string encryptString(string str){
        System.debug('DEBUGG encryptString '+ str);
        Blob key = Blob.valueOf(System.Label.ARTL_EncryptionKey); //Need to finalise key and put it into custom label
        string encodedCipherText = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(str)));
        string encryptedString = encodingUtil.URLEncode(encodedCipherText,'UTF-8');
        return encryptedString;
    }
    
    public static string decryptString(string encryptedStr){
        Blob key = Blob.valueOf(System.Label.ARTL_EncryptionKey);
        Blob blobData = EncodingUtil.base64Decode(encryptedStr);    
        Blob decryptedBlob = Crypto.decryptWithManagedIV('AES128', key, blobData);    
        string decryptedString = decryptedBlob.toString();
        return decryptedString;
    }
}