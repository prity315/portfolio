const dayjs = require('dayjs');
const csv = require('csv-parser');
const createCsvWriter = require('csv-writer').createObjectCsvWriter;
const fs = require('fs');
const path = require('path');
const fetch = require('node-fetch');
const APIGATEWAY_URL =
    'https://5d1ru58ok5.execute-api.eu-central-1.amazonaws.com/dev'; //dev env

// const APIGATEWAY_URL =
//     'https://dgtxtopkc6.execute-api.eu-central-1.amazonaws.com/sctest'; //test env

// const APIGATEWAY_URL = "https://p5t9hj997b.execute-api.eu-central-1.amazonaws.com/sclocaldev"; //localdev env

var demographicItems = [];
var items = [];
var workspace_id;
var evaluation_id;
var dataCollection_id;
var startTime;
const DC_URL = 'test19/oct10'; //Edit the route to import responses

let targetFolder = path.basename('./', '.csv');
if (!fs.existsSync(targetFolder)) {
    fs.mkdirSync(targetFolder);
}

const csvWriter = createCsvWriter({
    path: targetFolder + '/FailedResponses.csv',
    // header: ['3dfdee4f-711c-414f-a9db-d7455d2d3bac','9d6b8b16-b591-4f3d-a777-40b3e0343c14','722fb984-1c2a-4b72-a5ab-f1589f1f4d8d','53b7f47a-d19b-414c-ad68-b425e9303045','615f4ef8-29a5-4766-acd8-c9102ae92bd5','7372ccb9-c942-462d-ba57-c88dc8c998ee','6262f95e-7b41-4acb-9e9b-51a75862d6aa','31efeb3d-65ce-4243-8375-733d467252d4','647f9776-3439-4a6f-adaf-52613ecf8982','495bf127-a0c7-4d4f-bba0-ea6492df400e','4de9a3ea-bd84-4f60-a724-79ba69aa5756','000dc53f-3a56-420e-8956-e3af0364739b','766c8a4a-47d9-4b88-8c14-cf451b4eebb2','3359da8d-0e36-4a4a-85e6-c354b1f092db','72f22040-7eb7-4211-8ff0-c6d4b8c8d6a4','31441cc6-2420-4c7f-858e-91f1ed128e25','c8816bd8-7f01-4d3a-bd71-9e43055dd8b0','9a72fbd8-4bf8-4a93-b227-b13b96387652','e2a7d794-3b5c-42eb-800e-88322946b461','924e2dcc-fc8f-407d-8e93-76c164621141','d68924fc-f71a-4cf5-85eb-3472074c123e','19c85aca-c6f8-4ff7-b249-b23846d97871','66a25fc6-3f96-4de2-8fbf-0e3698bbaea0','db7b30d8-e88a-4381-ad14-891c058d5478','0cd57d4a-0cc1-44cd-9489-15f96bcf4aa2','f47466c9-7e4d-4bd1-b62c-9d1d3bf903d8','5763083a-a57b-4db8-b413-cb526146b0bf','58423bf9-b4d5-4e5b-8737-ab8f7fec5675','c1782941-fc92-4494-9de0-6f8228440f62','d14a4bc7-db68-4590-99c7-ba992360ec36','105310bf-83ab-4aa8-a547-833efb5c4113','57db5da6-d21b-4f14-a7e6-759f61fcccef','81de2011-db29-4ef8-bd54-ebbf34867ba9','08d32658-286f-45e2-8e0f-3b4fc97ab210','9de5b5eb-6e52-4806-bef5-367d30f1402d','4ee07e2c-509d-47b8-b89d-a89f819b46e8','ffe805c2-b38d-4260-8541-1323506eab88','7c286b24-ae76-43ca-b100-ce22780f41e3','37886499-cd97-4eb4-abd6-d94854250565','95ee88eb-1282-464a-9669-33e1e6cff34b','4e037572-418f-456c-b208-f52ca015c306','498b7dab-216e-4c9f-9a66-f7e44610a3d2','1427529b-cf18-41d8-9fa9-e4541e055d3b','a15b0ff6-abcc-4289-86ef-8fd29d93f4f0','03f07d67-97f4-4e00-b6db-ead779416beb','92def2b0-4c18-4d94-ab4d-c8df6fd02cb4','c3ad3c90-78e4-4ca1-a7a3-fe47a2a6dc19','43709c60-e559-447d-a434-159e5f5bc784','a1672d71-5401-4c15-b681-5535668fb02e','81520c59-a613-420d-bfe8-143342512b05','0865b04d-3db1-42f2-aa47-97bcb61451de','a3304621-f0d9-4ffd-945f-58e069ef79d7','83643356-568b-4df0-8a65-9633caea9026','ed0bdf76-b93b-45bb-aaac-bc7a93b726d7','7f8cf038-08fd-4779-902c-437da204d9a4','56650ace-ee38-4f3d-a92e-98d4e3ef6acc','87adff2e-35a1-4c66-a6e7-f30805663696','44608ec5-5563-426d-9279-a459f2691dae','02448105-d7de-433d-a3e1-1cd7ae7c3188','1a5d7eff-aeac-4cc5-a8f2-6c69ac02d8e1','5cb8572a-5e91-4179-b627-6801c88dae0d','9f6dcae8-97fe-45ff-bb6c-6965e01d72fe','8b09abb0-5265-452f-92bd-49c2d6dd8f5c','2c0ef465-f387-41f1-a6e4-755da7ebbafc','61d1b180-a9a2-4506-8846-b63c1e058a2a','c05832c0-3a15-4214-bf0d-f2cfa69b37e9','d2893842-5fc1-4ea8-87e1-220281ae035d','2c0144d3-a67e-4d89-b597-8346bca6400a','68e25ff4-d73d-4895-b860-ea04ed3bb748','22de3ab9-4e62-43ba-84fb-9c505e534c13','fc59a829-cc9e-47b8-9d09-7e0b6727c6d8','26769ebf-c0cf-4d99-b06d-66fd1583969a','99ba6ae2-e2f9-431e-80a8-e5e5320ce5ff','90ecfb82-7f6b-4788-abfc-95c84a455527','926e3b42-73e0-43d0-b8f9-8547bda669a6','1ef21172-959b-41f8-8ca1-c4c946fda073','80295ee5-a407-43c3-b348-4bf225511409','cb9651e7-7741-44a9-baa1-fc11284c2c46','31bd96a6-6007-4f57-98e6-a03935523bad','ab385751-1b71-4dd2-9c30-82405cd2c276','753649f2-aefb-435b-8ed2-ecd9683ca8b8','bc42ab37-fe1b-4c28-90e6-343e9385e38e','821c776a-0fa1-4537-b32e-2140bc4f5d95','ed62ffc9-a2e1-4e9b-b40b-a673709a9c7e','startTime','endTime','duration','id'] //CRM header
    // header: ['53b7f47a-d19b-414c-ad68-b425e9303045','615f4ef8-29a5-4766-acd8-c9102ae92bd5','722fb984-1c2a-4b72-a5ab-f1589f1f4d8d','9d6b8b16-b591-4f3d-a777-40b3e0343c14','3dfdee4f-711c-414f-a9db-d7455d2d3bac','7372ccb9-c942-462d-ba57-c88dc8c998ee','6262f95e-7b41-4acb-9e9b-51a75862d6aa','unused1','unused2','unused3','98db53fb-492a-4c9e-9308-c48d19353bf9','6c4085aa-ed6d-4d0e-9959-a3fb79ee4c88','01afa125-c7c2-4a94-acad-c3068cb0413a','c2b13045-d5c2-445f-b443-cdcab71bcffc','239b221f-e62c-484f-8351-d7311a8105df','c65b33dd-f60e-40d1-b742-c5a8b64de6d5','906e91ed-ff55-4f18-8578-006ccf405660','551eb162-218f-44d9-872f-3a9cadca4d8f','ef4bf2f3-246d-4dfb-ab66-6e89d22cd8ef','22cac3d1-dcb1-4c34-8755-cca2945010a7','5004ac5e-57fe-4c1b-8e83-a986c7a8fdf6','2965bd6e-76ba-4a33-82ad-6af374ce4025','b1ca8a22-d95d-44cc-9d9e-d8d907c87ba6','37b70f43-87a3-4c0c-80dd-b34562ba9dc5','48132aad-b89d-4aea-89df-84bc50e1fe7a','ac267953-a760-452d-9fff-803defefe40d','d924e440-d793-41dd-ac2d-4bcd78fe45d1','3dc05ea5-2042-43f5-a438-a8a777562f10','792ab82b-747c-44d8-9b01-9af20682aa7e','3e5432d4-5fc2-467b-8f7d-6d1415f1c4d1','4e1035f4-3e52-4157-8e7d-c5d8956eba09','19f413b1-8eab-4fdd-ac0d-9390e040bf67','e2fefb47-c93c-4ec2-a189-673d7268e445','21cd6f8c-c136-45e2-a3d4-60c4b5e880be','85124193-f1d7-426b-b43f-8b35aa4fe616','4dc80e53-75cd-42aa-b513-ab2dcdfd98e5','d26bec0a-bd35-4a17-8407-a0987e680ff3','dca28f17-02bc-4078-94bc-e2952a276c63','539518d0-c088-4653-befb-c9ed9ee16caa','3a2e404a-0108-4d63-b78e-24a6069bef19','f12c6327-534f-4b88-ab54-8f0a4d1583e3','4274ec89-6bdb-48ad-bf27-27f1fc6a9ff9','85be5572-72f6-4996-9974-09ed003f9265','09ea0fe8-873f-478f-9cf7-02015e3a94a7','41f2e57d-e330-4906-81dc-6e165e2b3352','ad646864-22ad-43fd-935e-972ce368e217','ec880f5e-5a11-4d1c-98e3-cf1b7b2955d0','ba1e7e93-0ac9-429e-acf2-b557debb0048','635cdcd0-b065-4207-b98e-e80bafe99c2a','fe799560-bba3-4738-b01e-748c86d68b84','f0ee0933-1896-4329-b0e3-22a38ea83850','a9a13d89-6b28-4dcb-ad95-b46f8ac5e727','2a8c0338-c462-4cc3-93f4-e0baf0171c26','f3f94230-6de7-448b-9a9b-80a66d7e1717','9c177989-ba6e-404f-95bf-96c113aabdbe','eacc416b-db48-420e-a3da-3f99ba8684fd','fc02302e-f34f-4070-a4cd-ed238b08dc5a','a0d592b4-80b8-4070-8d83-4aa07c41d8b3','ff1eda0c-6a85-414b-9cc5-027620ea4cad','9d1efcfd-2a4f-4170-82db-766400d1648a','0dcb2070-b2ad-4b5b-8dde-c32c6b47ada4','c1fae4b3-0c35-4068-b2a2-4e8bbb36782a','11d25d50-0e79-4cde-aab2-bd06f3878d02','26a0df05-f2c9-4aa7-be19-b98334b6f421','1018e8eb-1d24-42a1-b7e6-25f1eb8f196f','8ce09682-1a16-4a52-8914-8356b45e5f01','3085db5b-6e5d-4141-9b87-f59af5fef6cd','ef3d9caa-c000-4b73-99fd-dc1f6a2b3a79','2eeaa4c7-d4e6-469d-95f7-349d69ec55c6','808d3528-c83d-4d6b-8997-19f96bb6fa4f','06dcca01-7678-4252-9fce-78c093a0dfa0','c9113283-e0e4-4331-aaa0-123ff098052c','3743272d-f431-47af-9ef1-d05064c3c049','ae065e62-715c-48ed-94f7-07086b19f6c9','47ab2eea-f803-43b1-a177-c7bb00cf173e','8bb29f9f-3cb2-43a9-8589-a52e810cecb9','5fd75fde-4c78-42ca-ace9-58e9c59b538b','4a7909bf-1de2-48a7-922e-a3aa63b32d98','ff833323-6efe-4d91-8c24-1dcb49ae7c29','4491e50d-0428-4552-a33b-88a8987a8637','495535c7-185c-40d0-9684-d48597f99daa','79040f81-f33f-4903-9abd-b84a9f602660','919c8d3a-97e8-4261-bc6e-a32590c55ba7','a4e0d4e1-e903-4373-90f7-248ff6388c18','c2d522a2-d48a-4180-a69a-6918eab2b767','7647bb71-96d9-4e51-b7bf-7b2934c46b91','15e49b16-1403-44d6-9937-9e5286ee282e','84390d9a-f932-4860-aee9-c3ea8594c84c','477e3ca4-dacd-4f09-b913-065ff72805d3','67d597ef-beaa-4e22-8ae7-46fcdd8d990b','3adf42f5-8842-485d-86ba-de1b5007a0ad','b8588443-4522-42a9-9a95-6d6f20342b99','a36bcfc5-914f-4882-b911-529ed1557b99','1486a6fb-3435-4dde-a028-5cadd9fe87c4','b5ef7332-088e-41d2-b352-58b933f5be05','1741338b-7bb8-42bb-adc8-65058eab58a9','30df9953-1e70-4a1b-8f4f-df00e45446ed','b4325333-3b5c-49f6-8c49-229a8a8a52a4','295113be-3a84-4867-9ef5-a42803a570d7','070af6e2-4e13-47b9-b67d-31602fdcdd65','2f27ea76-7f5f-4304-9fbe-97c8f30cdf56','6f7c366c-9ad6-44ee-b8ab-fa9709a0a8d2','496066ba-7523-406a-9ae2-6128c9e3f0e2','fd2cd438-eb49-4e38-9ba1-c9134adccd50','ad35580c-cd16-455d-b7ad-6dbf9f558d76','46eada89-d5e8-4940-884b-966b2fcf954d','c83abfe5-0136-4277-b6f7-6753d38142dd','82801a44-ed75-4c7f-97f8-d19eb8cbcbc8','83829be2-f5e8-4eaf-a3a6-4ac88ec9961f','29e861b3-69b7-42c5-9981-59cd93687b62','c986b3ec-d7d5-4322-bfcf-e74997c2478e','3f976c45-d92f-4787-a580-15a912baf32f','d8f16f73-150e-473e-b52f-2f68d57a6cae','ec016bad-80da-4ad2-8494-5f206afd2d00','c2f57786-837b-4e3d-b566-92dd24006fea','f61802aa-883a-43a3-b15c-4aeb7bcc96eb','e2118ef1-9196-49b4-9a80-98774cb78eac','6697a6d4-00a1-4e74-a36e-52e5ee2b02ad','c6b20d5a-6850-4fa1-8578-0fa7456e20f1','id','duration','Start Date','End Date'] //m-365(tandem2.csv) header
    // header: ['3dfdee4f-711c-414f-a9db-d7455d2d3bac','9d6b8b16-b591-4f3d-a777-40b3e0343c14','53b7f47a-d19b-414c-ad68-b425e9303045','615f4ef8-29a5-4766-acd8-c9102ae92bd5','722fb984-1c2a-4b72-a5ab-f1589f1f4d8d','7372ccb9-c942-462d-ba57-c88dc8c998ee','6262f95e-7b41-4acb-9e9b-51a75862d6aa','98db53fb-492a-4c9e-9308-c48d19353bf9','6c4085aa-ed6d-4d0e-9959-a3fb79ee4c88','01afa125-c7c2-4a94-acad-c3068cb0413a','c2b13045-d5c2-445f-b443-cdcab71bcffc','239b221f-e62c-484f-8351-d7311a8105df','c65b33dd-f60e-40d1-b742-c5a8b64de6d5','906e91ed-ff55-4f18-8578-006ccf405660','551eb162-218f-44d9-872f-3a9cadca4d8f','ef4bf2f3-246d-4dfb-ab66-6e89d22cd8ef','22cac3d1-dcb1-4c34-8755-cca2945010a7','5004ac5e-57fe-4c1b-8e83-a986c7a8fdf6','2965bd6e-76ba-4a33-82ad-6af374ce4025','b1ca8a22-d95d-44cc-9d9e-d8d907c87ba6','37b70f43-87a3-4c0c-80dd-b34562ba9dc5','48132aad-b89d-4aea-89df-84bc50e1fe7a','ac267953-a760-452d-9fff-803defefe40d','d924e440-d793-41dd-ac2d-4bcd78fe45d1','3dc05ea5-2042-43f5-a438-a8a777562f10','792ab82b-747c-44d8-9b01-9af20682aa7e','3e5432d4-5fc2-467b-8f7d-6d1415f1c4d1','4e1035f4-3e52-4157-8e7d-c5d8956eba09','19f413b1-8eab-4fdd-ac0d-9390e040bf67','e2fefb47-c93c-4ec2-a189-673d7268e445','21cd6f8c-c136-45e2-a3d4-60c4b5e880be','85124193-f1d7-426b-b43f-8b35aa4fe616','4dc80e53-75cd-42aa-b513-ab2dcdfd98e5','d26bec0a-bd35-4a17-8407-a0987e680ff3','dca28f17-02bc-4078-94bc-e2952a276c63','539518d0-c088-4653-befb-c9ed9ee16caa','3a2e404a-0108-4d63-b78e-24a6069bef19','f12c6327-534f-4b88-ab54-8f0a4d1583e3','4274ec89-6bdb-48ad-bf27-27f1fc6a9ff9','85be5572-72f6-4996-9974-09ed003f9265','09ea0fe8-873f-478f-9cf7-02015e3a94a7','41f2e57d-e330-4906-81dc-6e165e2b3352','ad646864-22ad-43fd-935e-972ce368e217','ec880f5e-5a11-4d1c-98e3-cf1b7b2955d0','ba1e7e93-0ac9-429e-acf2-b557debb0048','635cdcd0-b065-4207-b98e-e80bafe99c2a','fe799560-bba3-4738-b01e-748c86d68b84','f0ee0933-1896-4329-b0e3-22a38ea83850','a9a13d89-6b28-4dcb-ad95-b46f8ac5e727','2a8c0338-c462-4cc3-93f4-e0baf0171c26','f3f94230-6de7-448b-9a9b-80a66d7e1717','9c177989-ba6e-404f-95bf-96c113aabdbe','eacc416b-db48-420e-a3da-3f99ba8684fd','fc02302e-f34f-4070-a4cd-ed238b08dc5a','a0d592b4-80b8-4070-8d83-4aa07c41d8b3','ff1eda0c-6a85-414b-9cc5-027620ea4cad','9d1efcfd-2a4f-4170-82db-766400d1648a','0dcb2070-b2ad-4b5b-8dde-c32c6b47ada4','c1fae4b3-0c35-4068-b2a2-4e8bbb36782a','11d25d50-0e79-4cde-aab2-bd06f3878d02','26a0df05-f2c9-4aa7-be19-b98334b6f421','1018e8eb-1d24-42a1-b7e6-25f1eb8f196f','8ce09682-1a16-4a52-8914-8356b45e5f01','3085db5b-6e5d-4141-9b87-f59af5fef6cd','ef3d9caa-c000-4b73-99fd-dc1f6a2b3a79','2eeaa4c7-d4e6-469d-95f7-349d69ec55c6','808d3528-c83d-4d6b-8997-19f96bb6fa4f','06dcca01-7678-4252-9fce-78c093a0dfa0','c9113283-e0e4-4331-aaa0-123ff098052c','3743272d-f431-47af-9ef1-d05064c3c049','ae065e62-715c-48ed-94f7-07086b19f6c9','47ab2eea-f803-43b1-a177-c7bb00cf173e','8bb29f9f-3cb2-43a9-8589-a52e810cecb9','5fd75fde-4c78-42ca-ace9-58e9c59b538b','4a7909bf-1de2-48a7-922e-a3aa63b32d98','ff833323-6efe-4d91-8c24-1dcb49ae7c29','4491e50d-0428-4552-a33b-88a8987a8637','495535c7-185c-40d0-9684-d48597f99daa','79040f81-f33f-4903-9abd-b84a9f602660','919c8d3a-97e8-4261-bc6e-a32590c55ba7','a4e0d4e1-e903-4373-90f7-248ff6388c18','c2d522a2-d48a-4180-a69a-6918eab2b767','7647bb71-96d9-4e51-b7bf-7b2934c46b91','15e49b16-1403-44d6-9937-9e5286ee282e','84390d9a-f932-4860-aee9-c3ea8594c84c','477e3ca4-dacd-4f09-b913-065ff72805d3','67d597ef-beaa-4e22-8ae7-46fcdd8d990b','3adf42f5-8842-485d-86ba-de1b5007a0ad','b8588443-4522-42a9-9a95-6d6f20342b99','a36bcfc5-914f-4882-b911-529ed1557b99','1486a6fb-3435-4dde-a028-5cadd9fe87c4','b5ef7332-088e-41d2-b352-58b933f5be05','1741338b-7bb8-42bb-adc8-65058eab58a9','30df9953-1e70-4a1b-8f4f-df00e45446ed','b4325333-3b5c-49f6-8c49-229a8a8a52a4','295113be-3a84-4867-9ef5-a42803a570d7','070af6e2-4e13-47b9-b67d-31602fdcdd65','2f27ea76-7f5f-4304-9fbe-97c8f30cdf56','6f7c366c-9ad6-44ee-b8ab-fa9709a0a8d2','496066ba-7523-406a-9ae2-6128c9e3f0e2','fd2cd438-eb49-4e38-9ba1-c9134adccd50','ad35580c-cd16-455d-b7ad-6dbf9f558d76','46eada89-d5e8-4940-884b-966b2fcf954d','c83abfe5-0136-4277-b6f7-6753d38142dd','82801a44-ed75-4c7f-97f8-d19eb8cbcbc8','83829be2-f5e8-4eaf-a3a6-4ac88ec9961f','29e861b3-69b7-42c5-9981-59cd93687b62','c986b3ec-d7d5-4322-bfcf-e74997c2478e','3f976c45-d92f-4787-a580-15a912baf32f','d8f16f73-150e-473e-b52f-2f68d57a6cae','ec016bad-80da-4ad2-8494-5f206afd2d00','c2f57786-837b-4e3d-b566-92dd24006fea','f61802aa-883a-43a3-b15c-4aeb7bcc96eb','e2118ef1-9196-49b4-9a80-98774cb78eac','6697a6d4-00a1-4e74-a36e-52e5ee2b02ad','c6b20d5a-6850-4fa1-8578-0fa7456e20f1','duration','startTime','endTime','id'] //demo-m365.csv header
    // header: ['3dfdee4f-711c-414f-a9db-d7455d2d3bac','9d6b8b16-b591-4f3d-a777-40b3e0343c14','722fb984-1c2a-4b72-a5ab-f1589f1f4d8d','53b7f47a-d19b-414c-ad68-b425e9303045','615f4ef8-29a5-4766-acd8-c9102ae92bd5','7372ccb9-c942-462d-ba57-c88dc8c998ee','6262f95e-7b41-4acb-9e9b-51a75862d6aa','f4dbbcf7-20d0-4bde-9e5e-e0e5566eb6e9','761cc763-f2a0-434f-b23d-94e3519d4f90','d907a72f-7f94-4b00-9333-5afa5796ae95','a7a57134-3be8-4bd5-bee9-31c2807e9699','88cdc205-90b2-4dd0-b7c4-2fcd972dc3d5','8180bb12-4ad0-4d36-85dd-e0c150001736','8149d17c-f0ae-4f9f-b402-43cfa414941c','21f8e6ad-a18c-41f0-bcb3-27a63003a475','215005ea-8f97-4b17-8d32-c63c7f910147','0e2ab008-30bd-483e-a571-8c3ca95405b2','e035fdf6-aa09-4290-8b36-68cf1c6e0353','640388c7-2413-40ff-a143-f587d856d5a3','5171c2a9-b82f-49b5-8956-89e0fccc5cec','21986c0d-50e3-471b-a927-68a65478d5b3','697c7ff9-ac75-45e7-9e96-550bfe59e4e4','4f20243d-05a9-499e-853f-184393acdde9','56610197-6bdf-48fb-98c3-fd05f7866a6f','6503cb45-6f22-411d-b56d-4a30a2a84d44','0de87535-52ef-49e8-aaa0-aa914980b9ea','ae92c381-a08c-48b5-a4e2-a828b3d62b5c','8a5b1e9f-f355-49de-beb3-05b0ffca34e2','18928bae-3666-4a2d-8d47-3b9b2127a7fa','2001d5eb-e685-4f78-8e2a-ec99b938b629','362221ed-7386-4657-afc0-72d6e5d48b36','bb06d4e5-49ab-4a52-bc55-84725bd87461','116e360e-0522-46e3-97e1-47fbb52147a6','b7e6b15b-70f8-45ad-95d3-9a7a1d7801a1','0cec9be7-b5aa-4eeb-946c-62fdd9c17d9c','9982fde6-ddb9-42b9-8212-0560530461ce','ebc67eee-7637-4482-a8b8-083ac70d40c8','4f37ecd6-c2ad-418f-96a6-cf4c3a84e949','a3beb797-adba-402f-a36f-1ff516da52f4','0ab0a7f0-292e-4487-b047-e06674b3f9bb','91692714-b982-473c-974f-b57bcc08debd','cce51c28-3ecf-4d70-8f5b-053f3975cfbc','42874c74-621e-4106-8e82-5347763231d5','1a846347-1b69-4ab7-b328-a3936ba81271','bac0e802-9d24-4b67-bebc-eb405b4c48b1','07302ac8-973a-46fa-bb7b-b01a90504268','af850a1a-a7dd-4071-8404-76d49f5c4297','5cda807e-d8d3-43ca-8853-14da9d97c41d','be2ba178-a15b-4d12-ad98-f16961753a50','8918f9dc-f12b-45d0-bbc8-054a0fab0f2a','c754cf52-977e-4ce9-a862-1c45cb4eeff8','ea64754a-05c4-421b-a5ce-b6117ffe1d15','fa6acb21-8c39-4b27-bb0c-c1ad46c80bc5','34bc9265-5309-4f74-b341-e8d64404f7b2','0f8d49c2-907b-4156-99c1-09048c82174c','cdc386dd-cba7-4a88-aa7e-a9c50bb7a439','0f609285-89d6-4c08-aac5-4f607f9cf3b7','30ad493e-7dac-44a6-819f-537420e27721','e86612e8-b2e4-4970-bf3c-5e4b207169e6','e4164a88-7583-48b1-82ec-7cf9bdf87fec','bb09049d-d6e4-4f4a-8797-34f0276aaa7b','18571cec-3e28-437b-b353-666191908fa9','c771fd5c-af12-41f3-9933-d9f6e3b67329','dbd6f36c-096a-49e0-8432-3d57f7b91455','e9f28bcf-c7b5-4629-9477-5c09cc73010d','a38c5089-b154-4b83-98f3-083e03d903c5','7360787c-4f3f-4b7a-99a0-8204f6be9528','0395ddf1-03fd-409b-9ec7-c1708891b448','b9a112cd-6a18-4a11-a9cb-4b6fe7aaa0fb','71aa6a20-dd9d-45a3-91b7-653c8d71abda','56e34197-e46c-488e-9104-a3afa1b9c460','f1950c4c-5b12-4a5a-997c-f92289e025bc','63b2763a-7615-451a-b189-f0e33bd6d196','fab50d60-7455-44b5-b80e-f9d4e6aa181a','2359265c-0a32-4403-a7eb-5688e61c7790','7d01747b-6565-4e93-8ba3-5e57a4160c3e','126c8b43-451a-4081-86a6-565277bba95f','e9de41ab-e0e8-4331-9a8f-46e44ab4d541','a3ab2733-1826-46e9-bd6b-b854d8e320ab','e02f9653-9d6d-45ee-897c-0e34d6626585','f502904d-7987-48b7-beea-cb1d8dd8e855','a9eda45f-82e8-4e7e-836f-6a3b3658e4e2','280bfc3b-7c63-4297-9fb4-92829e5d4fb5','2d8a3de3-b7f6-46d5-a2c1-c41862d7187d','duration','startTime','endTime','id'] // demo-dynamics.csv
    header: ['3dfdee4f-711c-414f-a9db-d7455d2d3bac','9d6b8b16-b591-4f3d-a777-40b3e0343c14','722fb984-1c2a-4b72-a5ab-f1589f1f4d8d','53b7f47a-d19b-414c-ad68-b425e9303045','615f4ef8-29a5-4766-acd8-c9102ae92bd5','7372ccb9-c942-462d-ba57-c88dc8c998ee','6262f95e-7b41-4acb-9e9b-51a75862d6aa','8a7085b0-9289-4da8-9e65-d5f0923b246d','5dd932c6-c6f9-4821-b20c-108ec7cd60b8','ee3e10f3-e244-40d4-b2d8-55c057aba70f','23661a62-bacc-44c7-8163-7c6380c1a843','353c12f3-0e1e-4352-99dc-a42a4eed8cb4','ccd1bc36-d8ea-4fe6-bfcf-9013aa08bf03','c07563cf-a84b-4f5a-b9d2-230776c4de78','61ec9f2b-71cc-4dde-bf29-cef336cec16b','dae126f1-d441-4d37-a8ca-9a7919c40ff4','6021df0a-9e4b-496b-bada-536a2c18c1ef','18c7041e-f41e-42ff-8068-7ce0eddad770','741d2fc4-5164-4df8-b815-a033d5ca8223','b1785ab9-8693-40ab-a05b-ddec7a28cb19','e3d17a34-48e2-46a3-9e31-c0df1e33cf15','89d6ce76-7fa0-40b2-bd2e-96f575502bb5','c51dbc32-1746-410a-9c64-20b5e85df7a6','b2f1f0d7-0e20-4a73-909b-fd8929805e96','9144267c-cadb-46b1-8019-b0dcd5df92ba','18015ba3-7937-42bb-8575-77bcd09b9d72','ab62eabc-6f62-4672-9c54-37527feb11de','608fd1aa-668f-4bb2-b547-7ed601594b73','de6f2d87-e2b8-4a2a-bedb-3da09ac7210f','e5c31f42-7997-4ee2-b8a8-83cd7a7c031a','ff96a504-426b-493d-b687-a427ce85b6d1','83b0cb20-d61b-4c69-8f85-d4cc1a190926','af3e7ae2-0307-4865-9ac0-58ea026df380','179e15e9-d7d9-4e69-88c2-01f684ad158f','b6f826f7-2b48-4f65-b0df-05626a5e8d4d','4884a5a9-3c94-418d-8ad8-3c2b7609d9c5','5287c5a6-7138-46e3-97ad-1071bcea6266','3303e17d-c17f-48b9-ab29-45319ef29767','5185e824-2fe2-41f9-9b54-101228b964a6','6c48abc3-2286-4fc6-a391-1cf9b6777500','596ce57b-30e2-477d-b474-c1a647969554','7229a0fc-97e2-4a02-b7f4-9449b143cd1f','145b6025-93a6-468c-a201-041d0fac71d5','ed4dade7-167c-4aa8-b1ca-cdf231f5bc9f','69999ea1-484f-46d3-afd0-14e3cc74e517','118c0b2b-69df-4304-b715-632a0afb1dac','cd1fab61-4772-4a5d-a7b1-27a9fc8a0983','865aa38c-f68a-4055-beb7-fa0ba5be1c94','75aabe02-371b-475e-8d11-8417d6d3bdf9','56e8e5dd-8ea9-40ee-b105-0bb23ade2233','352f8ef1-c0ea-4289-b074-e7d2ae257f8f','b4527676-3978-46a3-8bb5-4976c426385b','b3952d44-aaed-4303-b5ed-09794d86bfad','05d98888-b833-4921-acf0-20facfc8c20e','1d5b5e94-7821-45d3-89bb-5cd84113d591','621d73b9-5bd5-4a9e-ae99-611d299a78cb','6e3fbb83-b17c-4921-b46b-9ea553d864d5','2369f4b4-2f01-4391-9d88-8f0e62a75244','786e7692-b8ec-46a9-bbed-8f78691f7731','fc87eda0-eca0-461d-88b9-f385c616ed3a','6f6c5636-dcac-4c3f-beba-3d71276b2bb4','29385cae-6931-4b7d-b88b-05e200b7d872','491c9cdc-ff5d-4a2a-9979-1fa38e9aa038','e2f6615d-6fce-4f35-b1c5-2420fecdcb7c','1ca6ca19-b3fb-4d18-9f9a-2048bdbf5264','4fe41b99-ceb2-464c-b784-703d07655a7b','431614fc-5b9a-4abe-b1e3-f0580ccafc27','17846c89-48df-4f8e-bda6-5622593b5f1c','1ef965bc-00d0-400f-9545-185d36e64586','f85a8f24-7dd8-413a-a70f-8a0fffd295b5','75a4816f-cb22-40f5-9495-bc254d0a2a05','d02be518-7849-47a1-9092-e0a28f051ef3','30b81366-d533-461e-8ea3-66cfb8cd9aaa','bd534066-94d1-4869-9dd3-fbe01a5487f8','b3257e00-bd0a-4c12-932d-9af2b3e0247d','85673b3a-c8d8-42d0-b8e0-b8d69ce57720','38dd831f-4d6f-4b6f-89eb-ecd0c3ae5cde','66b635b0-1954-4b8a-bbb0-544711915f37','30760d40-f5ba-4070-aa93-34d958c83488','f7373da5-494a-4e8e-bcfa-bd8e42edfb84','067f1044-23e9-4014-bb63-878bd22ff1ba','720fb4a5-2fcb-41f7-b01d-daedc29e9f53','41783d05-5045-474f-840f-14a904dc0faa','1eb79e6e-0d20-4d2c-9250-d896d425fac1','duration','startTime','endTime','id'] //demo-salesforce.csv
});

async function getDataCollection() {
    console.log('APIGATEWAY_URL: ', APIGATEWAY_URL);
    let requestOptions = {
        method: 'POST',
        body: JSON.stringify({ route: DC_URL }),
        redirect: 'follow',
    };
    try {
        const response = await fetch(
            `${APIGATEWAY_URL}/datacollection`,
            requestOptions
        );
        const dc = await response.json();
        if (dc) {
            console.log('REST API Pty : /datacollection: ', dc);

            demographicItems = dc.demographicItems;
            items = dc.orderedItems;
            workspace_id = dc.workspace_id;
            evaluation_id = dc.evaluation_id;
            dataCollection_id = dc.datacollection_id;
        }
        startTime = new Date();
    } catch (error) {
        console.log('Error fetching dataCollection...', error);
    }
}

/**
 * Parse duration to float
 */
function parseDurationToFloat(duration) {
    let matches = duration.match(/^([0-9]+):([0-9]+):([0-9]+)$/);

    return (
        parseInt(matches[1]) * 60 +
        parseInt(matches[2]) +
        parseInt(matches[3]) / 60
    );
}

function formatResponse(data) {
    let itemArray = [];
    let demographicItemsArray = [];

    items.forEach((item) => {
        // Adding items with values from csv
        itemArray.push({
            id: item.id,
            option: data[item.id],
            designation: item.designation,
        });
    });

    demographicItems.forEach((dgi) => {
        demographicItemsArray.push({
            id: dgi.id,
            option: data[dgi.id],
        });
    });

    const formattedData = {
        demographicItems: demographicItemsArray,
        items: itemArray,
        route: DC_URL,
        workspace_id,
        evaluation_id,
        dataCollection_id,
        startTime: dayjs(startTime).format(),
        endTime: dayjs(new Date()).format(),
        durationInFloat: parseDurationToFloat(data['duration']),
    };
    return formattedData;
}

const importDemoResponseFromCSV = async () => {
    var count = 0;
    var failedResponseCount = 0;
    try {
        await getDataCollection();
        console.log('workspace_id: ', workspace_id);
        fs.createReadStream('../../data/responses/demo-salesforce.csv')
            .pipe(csv())
            .on('data', (data) => {

                const formatedData = formatResponse(data);
                // console.log("formatedData: ", formatedData);
                fetch(`${APIGATEWAY_URL}/responses`, {
                    method: 'POST',
                    body: JSON.stringify(formatedData),
                    redirect: 'follow',
                })
                    .then((response) => {
                        response.json().then((item) => {
                            if (item === 'Response Saved') {
                                count++;
                                console.log(item, count);
                            } else {
                                ++failedResponseCount;
                                console.log(
                                    'failedResponseCount: ',
                                    failedResponseCount
                                );
                                // console.log('failedResponse data: ', data);
                                csvWriter
                                    .writeRecords([data])
                                    .then(() =>
                                        console.log(
                                            'The CSV file was written successfully'
                                        )
                                    );
                            }
                        });
                    })
                    .catch((error) => {
                        console.log('Error saving response: ', error);
                        ++failedResponseCount;
                        csvWriter
                            .writeRecords([data])
                            .then(() =>
                                console.log(
                                    'The CSV file was written successfully'
                                )
                            );
                    });
            })
            .on('end', () => {
                console.log('Done');
            });
    } catch (error) {
        console.log('Error getting DC result....', error);
    }
};

importDemoResponseFromCSV();
